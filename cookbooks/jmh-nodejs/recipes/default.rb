#
# Cookbook:: jmh-nodejs
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.


# Install a default version of nodejs
jmh_nodejs_install "Default install for node version #{node['jmh_nodejs']['default_version']}" do
  action :install
end