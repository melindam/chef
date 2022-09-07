Chef::Log.debug("Config is #{node['jmh_billpay']['client']['appserver']}")

gateway_props = Chef::EncryptedDataBagItem.load(node['jmh_billpay']['client']['gateway']['data_bag'], node['jmh_billpay']['client']['gateway']['data_bag_item'])
node.default['jmh_billpay']['client']['appserver']['catalina_properties'] = %w(prod stage).include?(node['jmh_server']['environment']) ? gateway_props['prod'] : gateway_props['dev']

jmh_tomcat node['jmh_billpay']['client']['appserver']['name'] do
  name node['jmh_billpay']['client']['appserver']['name']
  java_version node['jmh_billpay']['client']['appserver']['java_version']
  max_heap_size node['jmh_billpay']['client']['appserver']['max_heap_size']
  port node['jmh_billpay']['client']['appserver']['port']
  thread_stack_size node['jmh_billpay']['client']['appserver']['thread_stack_size']
  shutdown_port node['jmh_billpay']['client']['appserver']['shutdown_port']
  jmx_port node['jmh_billpay']['client']['appserver']['jmx_port']
  ssl_port node['jmh_billpay']['client']['appserver']['ssl_port']
  ajp_port node['jmh_billpay']['client']['appserver']['ajp_port']
  jmx_port node['jmh_billpay']['client']['appserver']['jmx_port']
  iptables node['jmh_billpay']['client']['appserver']['iptables']
  directories node['jmh_billpay']['client']['appserver']['directories']
  catalina_properties node['jmh_billpay']['client']['appserver']['catalina_properties']
  action :create
end

include_recipe 'jmh-utilities::hostsfile_ssh1'
