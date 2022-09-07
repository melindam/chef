#
# Cookbook Name:: jmh-mule
# Recipe:: default
#
# Tomcat user will be mulesoft user for security purposes
include_recipe 'jmh-tomcat::user'

directory node['jmh_mule']['target'] do
  recursive true
  owner node['jmh_mule']['user']
  group node['jmh_mule']['group']
  mode '0755'
  action :create
end

directory '/home/tomcat/deploy.mule' do
  recursive true
  owner node['jmh_mule']['user']
  group node['jmh_mule']['group']
  mode '0755'
  action :create
end

if node['recipes'].include?(node['jmh_mule']['ecryptfs_recipe'])
  directory node['jmh_mule']['ecryptfs_folder'] do
    owner node['jmh_mule']['user']
    group node['jmh_mule']['group']
    mode '0755'
    action :create
  end
end

directory '/root/bin' do
  owner 'root'
  group 'root'
  mode 0700
  action :create
end

