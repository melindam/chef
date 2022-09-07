# DEPRECATED #
#
catalina_properties = ['# JMH echo Properties']
catalina_properties.push("# dropped off by chef")

node.default['jmh_idev']['appserver']['echo']['catalina_properties'] = catalina_properties

jmh_tomcat node['jmh_idev']['appserver']['echo']['name'] do
  enable_http node['jmh_idev']['appserver']['echo']['enable_http']
  enable_ssl node['jmh_idev']['appserver']['echo']['enable_ssl']
  java_version node['jmh_idev']['appserver']['echo']['java_version']
  port node['jmh_idev']['appserver']['echo']['port']
  shutdown_port node['jmh_idev']['appserver']['echo']['shutdown_port']
  jmx_port node['jmh_idev']['appserver']['echo']['jmx_port']
  ajp_port node['jmh_idev']['appserver']['echo']['ajp_port']
  iptables node['jmh_idev']['appserver']['echo']['iptables']
  version node['jmh_idev']['appserver']['echo']['version']
  rollout_array node['jmh_idev']['appserver']['echo']['rollout_array']
  catalina_properties node['jmh_idev']['appserver']['echo']['catalina_properties']
  action :create
end
