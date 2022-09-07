Chef::Log.debug("Config is #{node['jmh_prereg']['client']['appserver']}")

prereg_properties = ['# Preregistration client properties']
prereg_properties.push('org.apache.catalina.startup.ContextConfig.jarsToSkip=org.eclipse.jdt.core-3.16.0.jar')

node.default['jmh_prereg']['client']['appserver']['catalina_properties'] = prereg_properties

jmh_tomcat 'preregistration' do
  name node['jmh_prereg']['client']['appserver']['name']
  java_version node['jmh_prereg']['client']['appserver']['java_version']
  max_heap_size node['jmh_prereg']['client']['appserver']['max_heap_size']
  thread_stack_size node['jmh_prereg']['client']['appserver']['thread_stack_size']
  catalina_opts node['jmh_prereg']['client']['appserver']['catalina_opts']
  port node['jmh_prereg']['client']['appserver']['port']
  jmx_port node['jmh_prereg']['client']['appserver']['jmx_port']
  ssl_port node['jmh_prereg']['client']['appserver']['ssl_port']
  jmx_port node['jmh_prereg']['client']['appserver']['jmx_port']
  shutdown_port node['jmh_prereg']['client']['appserver']['shutdown_port']
  iptables node['jmh_prereg']['client']['appserver']['iptables']
  directories node['jmh_prereg']['client']['appserver']['directories']
  catalina_properties node['jmh_prereg']['client']['appserver']['catalina_properties']
  exec_start_pre node['jmh_prereg']['client']['appserver']['exec_start_pre']
  version node['jmh_prereg']['client']['appserver']['version']
  mysql_j_version node['jmh_prereg']['client']['appserver']['mysql_j_version']
  exec_start_pre node['jmh_prereg']['client']['appserver']['exec_start_pre']
  action :create
end
