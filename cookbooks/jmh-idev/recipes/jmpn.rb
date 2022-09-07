include_recipe 'jmh-idev::hostsfile_caprrdb'

catalina_properties = ['# JMH jmpn Properties']
catalina_properties.push("# nothing")
catalina_properties.push("# 2 nothing")

node.default['jmh_idev']['appserver']['jmpn']['catalina_properties'] = catalina_properties

jmh_tomcat node['jmh_idev']['appserver']['jmpn']['name'] do
  enable_http node['jmh_idev']['appserver']['jmpn']['enable_http']
  enable_ssl node['jmh_idev']['appserver']['jmpn']['enable_ssl']
  java_version node['jmh_idev']['appserver']['jmpn']['java_version']
  port node['jmh_idev']['appserver']['jmpn']['port']
  shutdown_port node['jmh_idev']['appserver']['jmpn']['shutdown_port']
  jmx_port node['jmh_idev']['appserver']['jmpn']['jmx_port']
  iptables node['jmh_idev']['appserver']['jmpn']['iptables']
  version node['jmh_idev']['appserver']['jmpn']['version']
  rollout_array node['jmh_idev']['appserver']['jmpn']['rollout_array']
  catalina_properties node['jmh_idev']['appserver']['jmpn']['catalina_properties']
  directories node['jmh_idev']['appserver']['jmpn']['directories']
  action :create
end
