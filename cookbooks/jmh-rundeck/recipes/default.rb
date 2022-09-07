#
# Cookbook Name:: jmh-rundeck
# Recipe:: AppServers
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['rundeck']['rdbms']['dbpassword'] = random_password unless node['rundeck']['rdbms']['dbpassword']

jmh_java_install 'java_rundeck' do
  version node['jmh_rundeck']['java_version']
  action :install
end

jmh_db_database node['rundeck']['rdbms']['dbname'] do
  database node['rundeck']['rdbms']['dbname']
  ssl node['jmh_rundeck']['db']['ssl']
  action :create
end

jmh_db_user 'rundeck_user' do
  database node['rundeck']['rdbms']['dbname']
  username node['rundeck']['rdbms']['dbuser']
  password node['rundeck']['rdbms']['dbpassword']
  privileges node['rundeck']['rdbms']['privileges']
  connect_over_ssl node['jmh_rundeck']['db']['connect_over_ssl']
end

user node['rundeck']['user'] do
  comment 'Rundeck User'
  home node['rundeck']['user_home']
  system true
  shell '/bin/bash'
end

directory node['rundeck']['user_home'] do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  recursive true
  mode '0700'
end


yum_repository 'rundeck' do
  description 'Rundeck - Release'
  url node['rundeck']['rpm']['repo']['url']
  gpgkey node['rundeck']['rpm']['repo']['gpgkey']
  gpgcheck node['rundeck']['rpm']['repo']['gpgcheck']
  action :add
end

template '/etc/sysconfig/rundeckd' do
  source 'sysconfig.erb'
  action :create
  variables(
    java_home: JmhJavaUtil.get_java_home(node['jmh_rundeck']['java_version'],node),
    custom_java_opts: node['rundeck']['custom_jvm_properties']
  )
  notifies :restart, 'service[rundeckd]', :delayed
end

yum_package 'rundeck' do
  version node['rundeck']['rpm']['version'].split('-')[1, 2].join('-')
  action :install
end

template "#{node['rundeck']['configdir']}/rundeck-config.properties" do
  source 'rundeck-config.properties.erb'
  owner node['rundeck']['user']
  group node['rundeck']['group']
  variables(
      rdbms: node['rundeck']['rdbms'],
      domain_name: node['rundeck']['hostname']
  )
  #TODO removed restart because config is getting update for some odd reason
  # notifies :restart, 'service[rundeckd]', :delayed
end

template "#{node['rundeck']['configdir']}/realm.properties" do
  owner node['rundeck']['user']
  group node['rundeck']['group']
  source 'realm.properties.erb'
  variables(
      rundeck_users: data_bag_item(node['rundeck']['rundeck_databag'],node['rundeck']['rundeck_databag_users'])['users']
  )
  notifies :restart, 'service[rundeckd]', :delayed
end

include_recipe 'iptables'
iptables_rule 'rundeck'

ssh_databag = Chef::EncryptedDataBagItem.load('credentials', 'rundeck')

file File.join(node['rundeck']['basedir'], '/.ssh/id_rsa') do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode '0600'
  content ssh_databag['private_key']
end

file File.join(node['rundeck']['basedir'], '/.ssh/id_rsa.pub') do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode '0600'
  content ssh_databag['public_key']
end

file File.join(node['rundeck']['user_home'], '/.ssh/id_rsa') do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode '0600'
  content ssh_databag['private_key']
end

file File.join(node['rundeck']['user_home'], '/.ssh/id_rsa.pub') do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode '0600'
  content ssh_databag['public_key']
end

template File.join(node['rundeck']['configdir'], 'devuser.aclpolicy') do
  source 'devuser.aclpolicy.erb'
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode '0600'
end

include_recipe 'jmh-rundeck::projects'

service 'rundeckd' do
  provider Chef::Provider::Service::Systemd
  action [:start, :enable]
end

node.default['jmh_webserver']['listen'] = [node['jmh_rundeck']['http']['port']]
include_recipe "jmh-webserver"
jmh_webserver node['jmh_rundeck']['apache_name']  do
  doc_root node['jmh_rundeck']['http']['docroot']
  apache_config node['jmh_rundeck']['http']
end

directory '/var/www/html/logs' do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode '0755'
end

include_recipe 'jmh-rundeck::options_web_server'
include_recipe 'jmh-rundeck::remote_db_connections'
include_recipe 'jmh-utilities::hostsfile_internal'
include_recipe 'jmh-utilities::hostsfile_www_servers'


