include_recipe 'jmh-idev::hostsfile_caprrdb'

catalina_properties = ['# JMH sbo Properties']
catalina_properties.push("# nothing")
catalina_properties.push("# 2 nothing")

node.default['jmh_idev']['appserver']['sbo']['catalina_properties'] = catalina_properties

jmh_tomcat node['jmh_idev']['appserver']['sbo']['name'] do
  enable_http node['jmh_idev']['appserver']['sbo']['enable_http']
  enable_ssl node['jmh_idev']['appserver']['sbo']['enable_ssl']
  java_version node['jmh_idev']['appserver']['sbo']['java_version']
  port node['jmh_idev']['appserver']['sbo']['port']
  shutdown_port node['jmh_idev']['appserver']['sbo']['shutdown_port']
  jmx_port node['jmh_idev']['appserver']['sbo']['jmx_port']
  iptables node['jmh_idev']['appserver']['sbo']['iptables']
  version node['jmh_idev']['appserver']['sbo']['version']
  rollout_array node['jmh_idev']['appserver']['sbo']['rollout_array']
  catalina_properties node['jmh_idev']['appserver']['sbo']['catalina_properties']
  action :create
end
