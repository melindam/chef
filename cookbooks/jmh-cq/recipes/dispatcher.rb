# Create Domain Map -  what is this for ['dispatcher']['domain_maps']['server_name']
node.normal['cq']['dispatcher']['domain_maps']['server_name'] = node['cq']['dispatcher']['www']['server_name']
node.normal['cq']['dispatcher']['domain_maps']['api_server_name'] = node['jmh_server']['global']['apache']['api']['server_name']
node.normal['cq']['dispatcher']['domain_maps']['idp_server_name'] = node['jmh_server']['global']['apache']['idp']['server_name']
node.normal['cq']['dispatcher']['domain_maps']['supportportal_server_name'] = node['jmh_server']['global']['apache']['supportportal']['server_name']
node.normal['cq']['dispatcher']['domain_maps']['prc_server_name'] = node['jmh_server']['global']['apache']['prc']['server_name']

node.normal['jmh_server']['ssh']['sshd_config']['permit_root_login'] = 'forced-commands-only'

pub_nodes = Mash.new

# publisher are not defined, use them.  Else, search for them
if node['cq']['dispatcher']['publisher_list']
  node['cq']['dispatcher']['publisher_list'].each do |p_node|
    pub_nodes[p_node['name']] = Mash.new(
      :hostname => p_node['ipaddress'],
      :port => p_node['port'] || 4503
    )
  end
else
  # Discover existing publisher instances and configure them into the
  # dispatcher configuration
  found_pubs = Array.new
  search(:node, "roles:#{node['cq']['dispatcher']['publisher_role']} AND chef_environment:#{node.environment}") do |n|
    found_pubs.push(n)
  end
  if found_pubs.empty?
    cmd = Mixlib::ShellOut.new('ps ax | grep httpd | grep -v grep')
    cmd.run_command
    if cmd.stdout.empty?
      Chef::Application.fatal!('HTTPD running but no nodes found with role:' \
                               "#{node['cq']['dispatcher']['publisher_role']}.  Stopping dispatcher install")
    else
      pub_nodes['localhost'] = Mash.new(:hostname => '127.0.0.1', :port => 4503)
    end
  else
    found_pubs.each do |p_node|
      p_port = p_node['cq'] && p_node['cq']['publisher'] ? p_node['cq']['publisher']['port'] : 4503

      pub_nodes[p_node.name] = Mash.new(
        :hostname => p_node['ipaddress'],
        :port => p_port
      )
    end
  end
end

node.default['cq']['dispatcher']['any']['farms']['website']['renders'] = pub_nodes

# Find author roles
found_authors = Array.new
search(:node, "roles:#{node['cq']['dispatcher']['author_role']} AND chef_environment:#{node.environment}") do |n|
  found_authors.push(n)
end

author_nodes = Mash.new
author_nodes['initial_deny'] = Mash.new(
  #:hostname => '*.*.*.*',
  :glob => '*.*.*.*',
  :type => 'deny'

)

found_authors.each do |p_node|
  author_nodes[p_node.name] = Mash.new(
    #:hostname => p_node['ipaddress'],
    :glob => p_node['ipaddress'],
    #:port => p_node['cq']['author']['port'],
    :type => 'allow'
  )
end

node.default['cq']['dispatcher']['any']['farms']['website']['cache']['allowedClients'] = author_nodes

# Include required apache configurations - mod_deflate is included by default in apache2  ::default
node.default['jmh_webserver']['listen'] = [80, 443]

include_recipe 'jmh-webserver'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_connect'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'
include_recipe 'jmh-webserver::openidc'


template 'apache2-conf-charset-UTF8' do
  path "#{node['apache']['dir']}/conf-available/charset-UTF8.conf"
  cookbook 'jmh-webserver'
  source 'charset.conf.erb'
  owner 'root'
  group node['apache']['root_group']
  mode 00644
  backup false
  notifies :restart, 'service[apache2]', :delayed
end
apache_config 'charset-UTF8'

if node['jmh_webserver']['apache']['legacy_apache']
  remote_file File.join(node['apache']['lib_dir'], 'modules', 'mod_remoteip.so') do
    source node['jmh_apps']['apache']['mod_remoteip']['src_url']
    mode 0777
    action :create
    notifies :restart, 'service[apache2]', :delayed
    only_if { node['jmh_webserver']['apache']['legacy_apache'] }
  end

  apache_module 'remoteip' do
    enable node['cq']['dispatcher']['enable_remoteip'] ? node['cq']['dispatcher']['enable_remoteip'] : true
    cookbook 'jmh-webserver'
    conf node['cq']['dispatcher']['enable_remoteip'] ? node['cq']['dispatcher']['enable_remoteip'] : true
    notifies :restart, 'service[apache2]', :delayed
  end
else
  include_recipe 'apache2::mod_remoteip'
  apache_conf 'remoteip' do
    cookbook 'jmh-webserver'
    source 'mods/remoteip.conf.erb'
    notifies :restart, 'service[apache2]', :delayed
  end

end

apache_conf 'proxy_log' do
  cookbook 'jmh-webserver'
  source 'mods/proxy_log_format_conf.erb'
  notifies :restart, 'service[apache2]', :delayed
end

# Ensure our default directory exists
directory node['cq']['dispatcher']['document_root'] do
  owner node['apache']['user']
  group node['apache']['group']
  mode '0755'
  action :create
end


# Create Robots file
template File.join(node['cq']['dispatcher']['document_root'], node['cq']['dispatcher']['robots']['file']) do
  source 'robots.erb'
  user 'root'
  group 'root'
  mode '0655'
  action :create
  variables(
    :show_site_map => node['cq']['dispatcher']['robots']['show_site_map'],
    :server_root => node['cq']['dispatcher']['www']['server_name'],
    :sitemap_urls => node['cq']['dispatcher']['robots']['site_maps']
  )
end

include_recipe 'jmh-webserver::jmherror'

# Downloads remote file unless we have a checksum stored and the
# remote checksum matches
jmh_utilities_s3_download File.join(node['apache']['libexec_dir'], 'mod_dispatcher.so') do
  remote_path node['cq']['dispatcher']['apache_mod_s3_key']
  bucket node['cq']['aws']['s3_bucket']
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create directory and file for the dispatcher.any configuration file

any_path = File.join(node['apache']['dir'], node['cq']['dispatcher']['config']['dispatcher_config'])

directory File.dirname(any_path) do
  recursive true
end

template File.join(node['apache']['dir'],'/conf/dispatcher.any') do
  source 'cq.dispatcher.any.erb'
  action :create
  mode 0644
  notifies :restart, 'service[apache2]', :delayed
end

# Definition provided via the apache2 cookbook for loading in a
# defined module plus a configuration file. (configuration file is in
# the templates/default directory in this cookbook)

apache_module 'dispatcher' do
  enable true
  conf true
end

# Get MyChart proxy context
epic_config = JmhEpic.get_epic_config(node)

mychart_redirect = []
if epic_config['mychart']['sso_context']
  node.default['cq']['app_proxies']['mychartsso_proxies']['proxies'] = {"/#{epic_config['mychart']['sso_context']}": "/#{epic_config['mychart']['sso_context']}"}
  mychart_redirect.push("/mychart/?$ /#{epic_config['mychart']['sso_context']} [PT,L]")
  mychart_redirect.push("/mychart/(billing/guestpay.*) /#{epic_config['mychart']['sso_context']}/$1 [PT,L]")
  mychart_redirect.push("/mychartscheduling$ /#{epic_config['mychart']['sso_context']}/scheduling [PT,L]")
end

include_recipe "jmh-webserver::customphonebook"

# Add the application proxies to the ignore content https
ignore_array = Array.new(node['cq']['dispatcher']['www_configs']['cq_ignore_content_https'])
node['cq']['app_proxies'].each_key do |cproxy|
  node['cq']['app_proxies'][cproxy]['proxies'].each_key do |ccontext|
    ignore_array.push("%{REQUEST_URI} !^#{ccontext}.*$")
  end
end

cond_rewrites = node['cq']['dispatcher']['additional_cond_rewrites'].to_hash
cond_rewrites["^/(.*)$ #{node['cq']['dispatcher']['www']['content_home']}/$1 [PT,L]"] = ignore_array
node.default['cq']['dispatcher']['https']['cond_rewrites'] = cond_rewrites


dispatcher_configs = Array.new
# Data bag driven apache configurations for dispatcher
node['cq']['dispatcher']['app_proxies'].each do |databag_app_proxy|
  dispatcher_configs.push(data_bag_item('apache_redirects', databag_app_proxy))
end
# Variable driven apache configurations for dispatcher
node['cq']['app_proxies'].each_key do |attribute_app_proxy|
  dispatcher_configs.push(node['cq']['app_proxies'][attribute_app_proxy])
end

# Used to collect crons so we do not try to run the chef-client more than once
maintenance_crons = []

dispatcher_configs.each do |conf|
  Chef::Log.info "Fetching data bag for apache redirects: #{conf}"

  # item = data_bag_item('apache_redirects', conf)
  item = conf
  Chef::Log.debug("The item is #{item.to_s}")

  # If the data bag item defines a target role, find the node so the
  # configurations can point to it
  remote_node = { 'ipaddress' => '127.0.0.1' }
  found = false
  if Chef::Config[:solo]
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  elsif item['target_ipaddress']
    remote_node = {'ipaddress' => item['target_ipaddress'] }
    found = true
  elsif item['target_recipe']
    if node['recipes'].include?(item['target_recipe'].gsub('\\',''))
      remote_node['ipaddress'] = '127.0.0.1'
      found = true
    else
      search(:node, "recipes:#{item['target_recipe']}") do |n|
        if n.environment == node.environment
          if n['ipaddress'] == node['ipaddress']
            remote_node['ipaddress'] = 'localhost'
          elsif node['test_run']
            remote_node['ipaddress'] =  n['cloud']['public_hostname']
          else
            remote_node['ipaddress'] = n['ipaddress']
          end
          found = true
          break
        else
          Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for profile server")
        end
      end
    end
  end

  if item['target_role'] && !found && !Chef::Config[:solo]
    search(:node, "roles:#{item['target_role']} AND chef_environment:#{node.environment}") do |n|
      remote_node['ipaddress'] = n['ipaddress']
      break
    end
  end

  # If no node is found, point to self until the remote node can be found
  # remote_node ||= node

  if item['id'] == 'domain_redirects'
    server_names = ["%{HTTP_HOST} !(#{node['cq']['dispatcher']['www']['server_name']})",
                    "%{HTTP_HOST} !(#{node['jmh_server']['global']['apache']['supportportal']['server_name']})",
                    '%{HTTP_HOST} !(localhost)',
                    "%{HTTP_HOST} !(#{node['ipaddress']})"]

    if node['cq']['dispatcher']['www']['server_aliases']
       node['cq']['dispatcher']['www']['server_aliases'].each do |server_alias|
        server_names.push("%{HTTP_HOST} !(#{server_alias})")
      end
    end
    final_cond_rewrite = { '(.*) https://%{SERVER_NAME}$1 [R=301]' => server_names }
    item['config']['cond_final_rewrites'] = final_cond_rewrite
  end

  ## MAINTENANCE MODE##
  maintenance_page = item['maintenance_page'] ? item['maintenance_page'] : node['cq']['dispatcher']['default_proxy_maintenance_page']
  ## 1. Check for a general maintenance for the environment
  maintenance_mode = item['maintenance']
  ## 2. If the now general maintenance, check the maintenance windows
  if maintenance_mode == false && item['maintenance_windows']
    item['maintenance_windows'].each_key do |window|
      Chef::Log.info("Now looking into maintenance window for: #{window}")
      start_date = DateTime.strptime(item['maintenance_windows'][window]['start'], '%Y-%m-%d %H:%M:%S %Z')
      stop_date = DateTime.strptime(item['maintenance_windows'][window]['stop'], '%Y-%m-%d %H:%M:%S %Z')
      now = DateTime.now

      Chef::Log.info("Now is #{now}")
      Chef::Log.info("Start is #{start_date}")
      Chef::Log.info("Stop is #{stop_date}")
      # Run Maintenance
      maintenance_mode = true if now >= start_date && now < stop_date
      # For adding and removing crons to start the maintenance windows
      # if more than 5 days since the stop date, remove the crons
      unless maintenance_crons.include?(window)
        Chef::Log.info('Adding a cron')
        maintenance_crons.push(window)
        if now > (stop_date + 5)
          cron "#{window}-start" do
            action :delete
          end
          cron "#{window}-stop" do
            action :delete
          end
        else
          cron "#{window}-start" do
            minute start_date.min
            hour start_date.hour
            day start_date.day
            month start_date.month
            command "echo 'Starting Maintenance' | mail -s 'Starting Maintenance' #{node['cq']['check_page']['email']}; " \
                    '/usr/bin/chef-client &> /var/log/chef_cron.log'
            action :create
          end
          cron "#{window}-stop" do
            minute stop_date.min
            hour stop_date.hour
            day stop_date.day
            month stop_date.month
            command "echo 'Stopping Maintenance' | mail -s 'Stopping Maintenance' #{node['cq']['check_page']['email']}; " \
                    '/usr/bin/chef-client &> /var/log/chef_cron.log'
            action :create
          end
        end
      end
    end
  end

  if node['jmh_webserver']['jmherror']['force_maintenance']
    maintenance_mode = true
    Chef::Log.warn("Force Maintenance is Set to True")
  end
  Chef::Log.info("Maintenance Mode is #{maintenance_mode}")

  # Create the configuration file with the contents of the data bag
  template File.join(node['apache']['dir'], 'conf', "#{item['id']}.conf") do
    cookbook 'jmh-webserver'
    mode 0644
    if item['proxies']
      source 'proxies.conf.erb'
      variables(
        :remote_address => remote_node['ipaddress'],
        :remote_port => item['port'] || 80,
        :proto => item['proto'] || 'http',
        :proxies => item['proxies'].to_hash,
        :directives => item['directives'],
        :locations => item['locations'],
        :maintenance_mode => maintenance_mode,
        :maintenance_page => maintenance_page
      )
    else
      # Addition needed for domain redirects to also ignore server aliases
      source 'web_app.conf.erb'
      variables(
        :params => Mash.new(CQ.crawl_for_envs(item['config'], node['cq']['dispatcher']['domain_maps']))
      )
    end
    notifies :restart, 'service[apache2]', :delayed
  end
end

modules_conf_names = node['cq']['dispatcher']['modules']
# Create apache modules conf files same as .erb files
modules_conf_names.each do |modconf|
  template File.join(node['apache']['dir'], 'conf-available', "#{modconf}.conf") do
    cookbook 'jmh-webserver'
    mode 0644
    owner 'root'
    group 'root'
    source "apache/#{modconf}.conf.erb"
    notifies :restart, 'service[apache2]', :delayed
  end
  apache_config modconf
end

node.default['cq']['dispatcher']['common_http']['includes'] = (dispatcher_configs).map do |conf_name|
                                                                 File.join(node['apache']['dir'], 'conf', "#{conf_name['id']}.conf")
                                                               end
node.default['cq']['dispatcher']['http']['cond_rewrites'] = { '^/(.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]': node['cq']['dispatcher']['ssl_redirect_rewrite'],
                               "^/(.*)$ #{node['cq']['dispatcher']['www']['content_home']}/$1 [R=301,L]": node['cq']['dispatcher']['www_configs']['cq_ignore_content_http']}
http_mash = node['cq']['dispatcher']['common_http'].merge(node['cq']['dispatcher']['http'])

jmh_webserver 'aem dispatcher http' do
  name '1www'
  doc_root node['cq']['dispatcher']['common_http']['docroot']
  cookbook node['cq']['dispatcher']['common_http']['cookbook']
  apache_config http_mash
end

include_recipe 'jmh-cq::dispatcher-ssl'

# Add in the loaded ssl files
node['cq']['dispatcher']['ssl']['apache']['www'].each do |name, path|
  node.default['cq']['dispatcher']['https']["ssl_#{name}_file"] = path
end

https_mash = node['cq']['dispatcher']['common_http'].merge(node['cq']['dispatcher']['https'])
https_mash['rewrites'] = mychart_redirect + https_mash['rewrites']

jmh_webserver 'aem dispatcher https' do
  name '1www'
  doc_root node['cq']['dispatcher']['common_http']['docroot']
  cookbook node['cq']['dispatcher']['common_http']['cookbook']
  apache_config https_mash
end

include_recipe 'jmh-cq::dispatcher-prc'

directory '/root/.ssh' do
  mode 0700
end

#  Remove Cache
# TODO: Lets get cqadmin to be able to run this and get it out of root
bamboo_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'bamboo')
rundeck_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'rundeck')

authorized_keys_file_content = "command=\"/root/bin/removeCache.sh\", " + bamboo_key_bag['ssh_public_key'] + "\n" +
     "command=\"/root/bin/removeCache.sh\", " + rundeck_key_bag['public_key']

file File.join('root', '.ssh', 'authorized_keys') do
  content authorized_keys_file_content
  owner 'root'
  group 'root'
  mode 0600
end

directory '/root/bin' do
  mode 0700
end

template '/root/bin/removeCache.sh' do
  source 'remove_cache.erb'
  owner 'root'
  group 'root'
  mode 0700
  variables(
    :docroot => node['cq']['dispatcher']['document_root']
  )
end
