
Chef::Application.fatal!("MyChart Proxy cannot run on the same server as dispatcher!") if node['recipes'].include?('jmh-cq::dispatcher')

node.default['jmh_webserver']['listen'] = [node['jmh_webserver']['mychart']['https']['port']]

include_recipe 'jmh-webserver'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_connect'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_remoteip'


apache_conf 'proxy_log' do
  cookbook 'jmh-webserver'
  source 'mods/proxy_log_format_conf.erb'
  notifies :restart, 'service[apache2]', :delayed
end

apache_configs = Array.new
node['jmh_webserver']['default_app_proxies'].each do |databag_app_proxy|
  apache_configs.push(data_bag_item('apache_redirects', databag_app_proxy))
end

epic_config = JmhEpic.get_epic_config(node)

# Create the proxy by which epic environment we are using
mychart_proxy = Hash.new
mychart_proxy['id'] = 'mychart_proxies'
mychart_proxy['target_ip'] = epic_config['mychart']['ipaddress']
mychart_proxy['port'] = epic_config['mychart']['port']
mychart_proxy['proto'] = epic_config['mychart']['protocol']
mychart_proxy['proxies'] = {"/#{epic_config['mychart']['mcm_mychart_context']}": "/#{epic_config['mychart']['mcm_mychart_context']}",
                            "/#{epic_config['mychart']['mcm_context']}": "/#{epic_config['mychart']['mcm_context']}",
                            "/#{epic_config['mychart']['sso_context']}": "/#{epic_config['mychart']['sso_context']}"}

mychart_proxy['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']
apache_configs.push(mychart_proxy)

node.default['jmh_webserver']['mychart']['https']['includes'] = apache_configs.map do |conf|
                                                                  File.join(node['apache']['dir'], 'conf', "#{conf['id']}.conf")
                                                                end
jmh_webserver "#{node['jmh_webserver']['mychart']['apache_name']}" do
  name node['jmh_webserver']['mychart']['apache_name']
  apache_config node['jmh_webserver']['mychart']['https']
  doc_root node['jmh_webserver']['mychart']['https']['docroot']
end

apache_configs.each do |conf|
  Chef::Log.info "Fetching data bag for apache redirects: #{conf}"
  item = conf
  # If the data bag item defines a target role, find the node so the
  # configurations can point to it
  remote_node = {'ipaddress' => "127.0.0.1"}
  found = false
  if Chef::Config[:solo]
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  elsif item['target_ip']
    remote_node['ipaddress'] = item['target_ip']
  elsif item['target_recipe']
    search(:node, "recipes:#{item['target_recipe']}") do |n|
      if n.environment == node.environment
        if n['ipaddress'] == node['ipaddress']
          remote_node['ipaddress'] = 'localhost'
        else
          remote_node['ipaddress'] = n['ipaddress']
        end
        found = true
        break
      else
        Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for server")
      end
    end
  end

  # Create the configuration file with the contents of the data bag
  template "#{conf['id']} template for mychart" do
    path  File.join(node['apache']['dir'], 'conf', "#{conf['id']}.conf")
    cookbook 'jmh-webserver'
    source 'proxies.conf.erb'
    mode 0644
    if item['proxies']
      source 'proxies.conf.erb'
      variables(
        remote_address: remote_node['ipaddress'],
        remote_port: item['port'] || 80,
        proto: item['proto'] || 'http',
        proxies: item['proxies'].to_hash,
        directives: node['jmh_webserver']['mychart']['proxy_directives']
      )
    else
      # Addition needed for domain redirects to also ignore server aliases
      source 'web_app.conf.erb'
      variables(
        params: Mash.new(WebserverUtil.crawl_for_envs(item['config'], node['jmh_webserver']['mychart']['domain_maps']))
      )
    end
    notifies :restart, 'service[apache2]', :delayed
  end

end

include_recipe 'jmh-webserver::jmherror'

if node['recipes'].include?('jmh-encrypt::lukscrypt')

  encrypted_httpd_log_dir = ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'httpd')

  ruby_block 'Move Logs to Encryption Location' do
    block do
      FileUtils.mv( node['apache']['log_dir'], node['jmh_encrypt']['lukscrypt']['encrypted_directory'] )
    end
    not_if { ::File.symlink?(node['apache']['log_dir']) }
    notifies :create, 'link[Create Log Symlink]', :immediately
  end

  link 'Create Log Symlink' do
    target_file node['apache']['log_dir']
    to encrypted_httpd_log_dir
    link_type :symbolic
    action :nothing
    notifies :reload, "service[apache2]", :delayed
  end


end
