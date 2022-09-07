node.default['jmh_webserver']['listen'] = [node['jmh_idev']['jmhweb']['http']['port'], node['jmh_idev']['jmhweb']['https']['port']]

include_recipe 'jmh-webserver'
include_recipe 'jmh-webserver::php_dependencies'

include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_connect'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'

apache_configs = Array.new

apache_configs.push(data_bag_item('apache_redirects', 'jmherror'))

node['jmh_idev']['jmhweb']['app_proxies'].each_key do |attribute_app_proxy|
  apache_configs.push(node['jmh_idev']['jmhweb']['app_proxies'][attribute_app_proxy])
end

%w(http https).each do |protocol|
  params = node['jmh_idev']['jmhweb']['apache']
  params = params.merge(node['jmh_idev']['jmhweb'][protocol])
  params['includes'] = apache_configs.map do |conf|
    File.join(node['apache']['dir'], 'conf', "#{conf['id']}.conf")
  end

  Chef::Log.info("Params for setup are: #{params}")
  jmh_webserver "#{node['jmh_idev']['jmhweb']['apache_name']} for #{protocol}" do
    name node['jmh_idev']['jmhweb']['apache_name']
    apache_config params
    doc_root node['jmh_idev']['jmhweb']['apache']['docroot']
  end
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
  elsif item['target_ipaddress']
    remote_node['ipaddress'] = item['target_ipaddress']
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
  template "#{conf['id']} " do
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
          proxies: item['proxies'].to_hash
      )
    else
      # Addition needed for domain redirects to also ignore server aliases
      source 'web_app.conf.erb'
      variables(
          params: Mash.new(WebserverUtil.crawl_for_envs(item['config'], node['jmh_idev']['jmhweb']['domain_maps']))
      )
    end
    notifies :restart, 'service[apache2]', :delayed
  end
end


template '/var/www/html/index.html' do
  source 'index.html.erb'
  variables(
       env_name: %w(prod stage).include?(node['jmh_server']['environment']) ? "" : "DEVELOPMENT "
      )
end
