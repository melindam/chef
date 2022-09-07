
# Cookbook Name:: can-mycanopy
# Recipe:: tomcat
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

catalina_properties = ['# Canopy Find a Doctor properties']
catalina_properties.push("canopyfad.jdbc.user=#{node['can_mycanopy']['fad']['db']['user']}")
catalina_properties.push("canopyfad.jdbc.password=#{node['can_mycanopy']['fad']['db']['password']}")

node.default['can_mycanopy']['tomcat']['appserver']['catalina_properties'] = catalina_properties

jmh_tomcat node['can_mycanopy']['tomcat']['appserver']['name'] do
  name node['can_mycanopy']['tomcat']['appserver']['name']
  catalina_properties node['can_mycanopy']['tomcat']['appserver']['catalina_properties']
  java_version node['can_mycanopy']['tomcat']['appserver']['java_version']
  max_heap_size node['can_mycanopy']['tomcat']['appserver']['max_heap_size']
  max_permgen node['can_mycanopy']['tomcat']['appserver']['max_permgen']
  port node['can_mycanopy']['tomcat']['appserver']['port']
  jmx_port node['can_mycanopy']['tomcat']['appserver']['jmx_port']
  ssl_port node['can_mycanopy']['tomcat']['appserver']['ssl_port']
  ajp_port node['can_mycanopy']['tomcat']['appserver']['ajp_port']
  shutdown_port node['can_mycanopy']['tomcat']['appserver']['shutdown_port']
  iptables node['can_mycanopy']['tomcat']['appserver']['iptables']
  rollout_array node['can_mycanopy']['tomcat']['appserver']['rollout_array']
  action :create
end
