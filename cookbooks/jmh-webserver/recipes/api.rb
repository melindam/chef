
node.default['jmh_webserver']['listen'] = [node['jmh_webserver']['api']['http']['port'],
                                      node['jmh_webserver']['api']['https']['port']]

include_recipe 'jmh-webserver'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_connect'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_remoteip' unless node['jmh_webserver']['apache']['legacy_apache']


epic_config = JmhEpic.get_epic_config(node)
node.default['jmh_webserver']['api']['app_proxies']['mychart']['proxies'] =
     {"/#{epic_config['mychart']['mcm_mychart_context']}": "/#{epic_config['mychart']['mcm_mychart_context']}",
     "/#{epic_config['mychart']['mcm_context']}": "/#{epic_config['mychart']['mcm_context']}"}



apache_configs = Array.new
node['jmh_webserver']['api']['app_proxies'].each_key do |attribute_app_proxy|
  apache_configs.push(node['jmh_webserver']['api']['app_proxies'][attribute_app_proxy])
end
%w(jmherror).each do |databag_app_proxy|
  apache_configs.push(data_bag_item('apache_redirects', databag_app_proxy))
end


%w(http https).each do |protocol|
  params = node['jmh_webserver']['api']['apache']
  params = params.merge(node['jmh_webserver']['api'][protocol])
  params['includes'] = apache_configs.map do |conf|
                         File.join(node['apache']['dir'], 'conf', "#{conf['id']}.conf")
                       end
  Chef::Log.debug("Params for setup are: #{params}")
  jmh_webserver "#{node['jmh_webserver']['api']['apache_name']} for #{protocol}" do
    name node['jmh_webserver']['api']['apache_name']
    apache_config params
    doc_root node['jmh_webserver']['api']['apache']['docroot']
  end
end

# Used to collect crons so we do not try to run the chef-client more than once
maintenance_crons = []
apache_configs.each do |conf|

  Chef::Log.info "Fetching data bag for apache redirects: #{conf}"

  item = conf

  # If the data bag item defines a target role, find the node so the
  # configurations can point to it
  remote_node = {'ipaddress' => "127.0.0.1"}
  if Chef::Config[:solo]
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  elsif item['target_ipaddress']
    remote_node = {'ipaddress' => item['target_ipaddress'] }
  elsif item['target_recipe']
    search(:node, "recipes:#{item['target_recipe']} AND chef_environment:#{node.environment}") do |n|
      if n['ipaddress'] == node['ipaddress']
        remote_node['ipaddress'] = 'localhost'
      elsif node['test_run']
        remote_node['ipaddress'] = n['cloud']['public_hostname']
      else
        remote_node['ipaddress'] = n['ipaddress']
      end
      break
    end
  end

  # ## MAINTENANCE MODE##
  maintenance_page = item['maintenance_page'] ? item['maintenance_page'] : node['jmh_webserver']['jmherror']['default_proxy_maintenance_page']
  ## 1. Check for a general maintenance for the environment
  maintenance_mode = item['maintenance']
  ## 2. If the now general maintenance, check the maintenance windows
  if maintenance_mode == false && item['maintenance_windows']
    item['maintenance_windows'].each_key do |window|
      Chef::Log.info("Now looking into maintenance window for: #{window}")
      start_date = DateTime.strptime(item['maintenance_windows'][window]['start'], '%Y-%m-%d %H:%M:%S %Z')
      stop_date = DateTime.strptime(item['maintenance_windows'][window]['stop'], '%Y-%m-%d %H:%M:%S %Z')
      now = DateTime.now

      Chef::Log.info("Now is #{now.to_s}")
      Chef::Log.info("Start is #{start_date.to_s}")
      Chef::Log.info("Stop is #{stop_date.to_s}")
      # Run Maintenance
      maintenance_mode = true if now >= start_date && now < stop_date
      # For adding and removing crons to start the maintenance windows
      # if more than 5 days since the stop date, remove the crons
      unless maintenance_crons.include?(window)
        Chef::Log.info("Adding a cron")
        maintenance_crons.push(window)
        if now > ( stop_date + 5)
          cron "api-#{window}-start" do
            action :delete
          end
          cron "api-#{window}-stop" do
            action :delete
          end
        else
          cron "api-#{window}-start" do
            minute start_date.min
            hour start_date.hour
            day  start_date.day
            month start_date.month
            command "echo 'Starting Maintenance' | mail -s 'Starting Maintenance' #{node['cq']['check_page']['email']}; " +
                    '/usr/bin/chef-client &> /var/log/chef_cron.log'
            action :create
          end
          cron "api-#{window}-stop" do
            minute stop_date.min
            hour stop_date.hour
            day  stop_date.day
            month stop_date.month
            command "echo 'Stopping Maintenance' | mail -s 'Stopping Maintenance' #{node['cq']['check_page']['email']}; " +
                    '/usr/bin/chef-client &> /var/log/chef_cron.log'
            action :create
          end
        end
      end
    end
  end

  Chef::Log.info("Maintenance Mode is #{maintenance_mode}")

  # Create the configuration file with the contents of the data bag
  template "#{conf['id']} template for api" do
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
        directives: item['directives'],
        maintenance_mode: maintenance_mode,
        maintenance_page: maintenance_page
      )
    else
      # Addition needed for domain redirects to also ignore server aliases
      source 'web_app.conf.erb'
      variables(
        params: Mash.new(WebserverUtil.crawl_for_envs(item['config'], node['jmh_webserver']['api']['domain_maps']))
      )
    end
    notifies :restart, 'service[apache2]', :delayed
  end

end

include_recipe 'jmh-webserver::jmherror'




