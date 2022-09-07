#
# Cookbook Name:: jmh-operations
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.
include_recipe 'jmh-server::jmhbackup'

rsa_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'jmhbackup')

file File.join('home', node['jmh_operations']['backup']['user'], '.ssh', 'id_rsa') do
  user node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0600'
  content rsa_key_bag['ssh_private_key']
end

directory "/home/#{node['jmh_operations']['backup']['user']}/bin" do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

[node['jmh_operations']['backup_root'], node['jmh_operations']['encryption_backup_root']].each do |backup_dirs|
  directory backup_dirs do
    recursive true
    action :create
  end
end
