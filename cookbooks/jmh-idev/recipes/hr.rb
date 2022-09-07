# decommissioned 2/2020

catalina_properties = ['# JMH hr Properties']
catalina_properties.push("# nothing")
catalina_properties.push("# 2 nothing")

node.default['jmh_idev']['appserver']['hr']['catalina_properties'] = catalina_properties

jmh_tomcat node['jmh_idev']['appserver']['hr']['name'] do
  enable_http node['jmh_idev']['appserver']['hr']['enable_http']
  enable_ssl node['jmh_idev']['appserver']['hr']['enable_ssl']
  java_version node['jmh_idev']['appserver']['hr']['java_version']
  port node['jmh_idev']['appserver']['hr']['port']
  shutdown_port node['jmh_idev']['appserver']['hr']['shutdown_port']
  jmx_port node['jmh_idev']['appserver']['hr']['jmx_port']
  ajp_port node['jmh_idev']['appserver']['hr']['ajp_port']
  iptables node['jmh_idev']['appserver']['hr']['iptables']
  version node['jmh_idev']['appserver']['hr']['version']
  rollout_array node['jmh_idev']['appserver']['hr']['rollout_array']
  catalina_properties node['jmh_idev']['appserver']['hr']['catalina_properties']
  action :create
end
