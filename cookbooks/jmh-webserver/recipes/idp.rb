node.default['jmh_webserver']['listen'] = [node['jmh_webserver']['idp']['http']['port'],
                                      node['jmh_webserver']['idp']['https']['port']]

include_recipe 'jmh-webserver'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'
include_recipe 'apache2::mod_proxy_connect'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_remoteip' unless node['jmh_webserver']['apache']['legacy_apache']

apache_configs = Array.new
node['jmh_webserver']['idp']['app_proxies'].each_key do |attribute_app_proxy|
  apache_configs.push(node['jmh_webserver']['idp']['app_proxies'][attribute_app_proxy])
end
%w(jmherror).each do |databag_app_proxy|
  apache_configs.push(data_bag_item('apache_redirects', databag_app_proxy))
end


%w(http https).each do |protocol|
  params = node['jmh_webserver']['idp']['apache']
  params = params.merge(node['jmh_webserver']['idp'][protocol])
  params['includes'] = apache_configs.map do |conf|
                         File.join(node['apache']['dir'], 'conf', "#{conf['id']}.conf")
                       end
  Chef::Log.debug("Params for setup are: #{params}")
  jmh_webserver "#{node['jmh_webserver']['idp']['apache_name']} for #{protocol}" do
    name node['jmh_webserver']['idp']['apache_name']
    apache_config params
    doc_root node['jmh_webserver']['idp']['apache']['docroot']
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
  elsif item['target_recipe']
    if node['recipes'].include?(item['target_recipe'].gsub('\\', ''))
      remote_node['ipaddress'] = 'localhost'
      found = true
    else
      search(:node, "recipes:#{item['target_recipe']}") do |n|
        if n.environment == node.environment
          if n['ipaddress'] == node['ipaddress']
            remote_node['ipaddress'] = 'localhost'
          elsif n['cloud'] && !node['cloud']
            remote_node['ipaddress'] = n['cloud']['public_hostname']
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
  end

  # Create the configuration file with the contents of the data bag
  template "#{conf['id']} template for idp" do
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
        #directives: item['directives']
        #maintenance_mode: maintenance_mode,
        #maintenance_page: maintenance_page
      )
    else
      # Addition needed for domain redirects to also ignore server aliases
      source 'web_app.conf.erb'
      variables(
        params: Mash.new(WebserverUtil.crawl_for_envs(item['config'], node['jmh_webserver']['idp']['domain_maps']))
      )
    end
    notifies :restart, 'service[apache2]', :delayed
  end

end

include_recipe 'jmh-webserver::jmherror'
