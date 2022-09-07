#
# Cookbook Name:: jmh-events
# Recipe:: db
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

jmh_db_database node['jmh_events']['client']['database'] do
  database node['jmh_events']['client']['database']
  action :create
end

jmh_db_mysql_local_user node['jmh_events']['client']['database'] do
  username node['jmh_events']['db']['developer_user']
  database node['jmh_events']['client']['database']
  password node['jmh_events']['db']['developer_password']
  host_connection '%'
  privileges [:all]
  action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
end

analytics_bag = data_bag_item('operations', 'analytics')

unless node['jmh_events']['analytics'] && node['jmh_events']['analytics']['db_password']
    node.normal['jmh_events']['analytics']['db_password'] = random_password
end

# Create analytics DB connection user
analytics_bag['db_users'].each do |db_user|
  jmh_db_mysql_local_user db_user['name'] do
    username db_user['name']
    password node['jmh_events']['analytics']['db_password']
    database node['jmh_events']['client']['database']
    privileges [:select]
    # host_connection db_user['hostname']
    host_connection %w(prod stage).include?(node['jmh_server']['environment']) ? db_user['hostname'] : node['jmh_network']
    action db_user['action']
  end
end