node.default['jmh_webserver']['listen'] = [node['jmh_webserver']['jmhhr']['http']['port'],
                                           node['jmh_webserver']['jmhhr']['https']['port']]

include_recipe 'jmh-webserver'
include_recipe 'apache2::mod_expires'
include_recipe 'apache2::mod_status'
include_recipe 'apache2::mod_headers'

apache_configs = Array.new
%w(jmherror).each do |databag_app_proxy|
  apache_configs.push(data_bag_item('apache_redirects', databag_app_proxy))
end


%w(http https).each do |protocol|
  params = node['jmh_webserver']['jmhhr']['apache']
  params = params.merge(node['jmh_webserver']['jmhhr'][protocol])
  params['includes'] = apache_configs.map do |conf|
    File.join(node['apache']['dir'], 'conf', "#{conf['id']}.conf")
  end
  Chef::Log.debug("Params for setup are: #{params}")
  jmh_webserver "#{node['jmh_webserver']['jmhhr']['apache_name']} for #{protocol}" do
    name node['jmh_webserver']['jmhhr']['apache_name']
    apache_config params
    doc_root node['jmh_webserver']['jmhhr']['apache']['docroot']
  end
end

include_recipe 'jmh-webserver::jmherror'
