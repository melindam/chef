#
# Cookbook Name:: jmh-tomcat
# Recipe:: default
#

include_recipe 'jmh-tomcat::tomcat_native'

include_recipe 'jmh-tomcat::user'

directory node['jmh_tomcat']['target'] do
  recursive true
  mode '0755'
  action :create
end

directory '/root/bin for jmh-tomcat' do
  path '/root/bin'
  owner 'root'
  group 'root'
  mode 0700
  action :create
end

template '/root/bin/tomcat-all.sh' do
  source 'tomcat_all.erb'
  owner 'root'
  group 'root'
  mode 0700
  action :create
end
