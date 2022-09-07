node.default['jmh_webserver']['listen'] = [80]
include_recipe 'jmh-webserver'
include_recipe 'jmh-operations::ebiz_web_server'

directory File.join(node['jmh_operations']['web_server']['apache_config80']['docroot'], 'reporting') do
  user node['apache']['user']
  group node['jmh_server']['backup']['group']
  action :create
end

directory File.join(node['jmh_operations']['web_server']['apache_config80']['docroot'], 'reporting', 'event_manager') do
  user node['apache']['user']
  group node['jmh_server']['backup']['group']
  mode 0770
  action :create
end

ops_bag = Chef::EncryptedDataBagItem.load('operations', 'secure')
crowd_apache_password = ops_bag['crowd_prod_apache_password']

prod_crowd_ip = '127.0.0.1'
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, 'roles:jmh-crowd') do |n|
    if n.environment == node['jmh_operations']['prod_environment']
      prod_crowd_ip = n['ipaddress']
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for crowd")
    end
  end
end

template File.join(node['apache']['dir'], 'conf-available', 'reporting.conf') do
  source 'reporting_apache_conf.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0600
  variables(
    :location => 'reporting',
    :authname => 'Secure Ebiz Invite',
    :authtype => 'Basic',
    :crowdappname => 'apache-ebiz-tools',
    :crowdapppassword => crowd_apache_password,
    :crowdurl => "http://#{prod_crowd_ip}:8095/crowd/",
    :require => node['jmh_webserver']['apache']['legacy_apache'] ? 'group EVENT_REGISTRATION_REPORT' : 'crowd-group EVENT_REGISTRATION_REPORT'
  )
  notifies :restart, 'service[apache2]', :delayed
end

apache_config 'reporting'

apache_conf 'mime7z' do
  cookbook 'jmh-webserver'
  notifies :restart, 'service[apache2]', :delayed
end

