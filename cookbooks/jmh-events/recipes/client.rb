#
# Cookbook Name:: jmh-events
# Recipe:: client
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

if node['jmh_events']['client']['db']['password'].nil?
  node.normal['jmh_events']['client']['db']['password'] = secure_password
end

jmh_db_user 'events_client_user' do
  database node['jmh_events']['client']['database']
  username node['jmh_events']['client']['db']['username']
  password node['jmh_events']['client']['db']['password']
  parent_node_query node['jmh_events']['client']['db']['node_query'] unless node['recipes'].include?(node['jmh_events']['client']['db']['local_recipe'])
  privileges node['jmh_events']['client']['db']['privileges']
  connect_over_ssl node['recipes'].include?(node['jmh_events']['client']['db']['local_recipe']) ? false : true
end

Chef::Log.debug("Config is #{node['jmh_events']['client']['appserver']}")

include_recipe 'jmh-utilities::hostsfile_internal'
include_recipe 'jmh-utilities::hostsfile_crowd_servers'
include_recipe 'jmh-utilities::hostsfile_www_servers'

jmh_tomcat 'events' do
  name node['jmh_events']['client']['appserver']['name']
  version node['jmh_events']['client']['appserver']['version']
  java_version node['jmh_events']['client']['appserver']['java_version']
  max_heap_size node['jmh_events']['client']['appserver']['max_heap_size']
  max_permgen node['jmh_events']['client']['appserver']['max_permgen']
  catalina_opts node['jmh_events']['client']['appserver']['catalina_opts']
  port node['jmh_events']['client']['appserver']['port']
  thread_stack_size node['jmh_events']['client']['appserver']['thread_stack_size']
  shutdown_port node['jmh_events']['client']['appserver']['shutdown_port']
  jmx_port node['jmh_events']['client']['appserver']['jmx_port']
  ssl_port node['jmh_events']['client']['appserver']['ssl_port']
  jmx_port node['jmh_events']['client']['appserver']['jmx_port']
  iptables node['jmh_events']['client']['appserver']['iptables']
  directories node['jmh_events']['client']['appserver']['directories']
  exec_start_pre node['jmh_events']['client']['appserver']['exec_start_pre']
  relax_query_chars node['jmh_events']['client']['appserver']['relax_query_chars']
  action :create
end

jmh_crowd_install_certificate 'Install Crowd cert in jre' do
  java_home JmhJavaUtil.get_java_home(node['jmh_events']['client']['appserver']['java_version'], node)
  action :create
end

# TODO: include new recipe from jmh-cq to create eventmanageruser password in author instance
