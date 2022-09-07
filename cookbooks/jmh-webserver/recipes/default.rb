#
# Cookbook Name:: jmh-webserver
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#TODO This port stuff is chaos.  Need to fix it by setting a variable for each port so we can consolidate
# them all at compile time
if node['jmh_webserver']['listen']
  node.default['apache']['listen'] = node['jmh_webserver']['listen']
else
  node.default['apache']['listen'] = [80]
end

load_balancer_databag = Chef::EncryptedDataBagItem.load(node['jmh_server']['mail']['load_balancer_data_bag'][0],
                                                        node['jmh_server']['mail']['load_balancer_data_bag'][1])
remote_ip_proxies = Array.new
load_balancer_databag.to_h.each do |lbname, lbvalue|
  next if lbname == 'id'
  remote_ip_proxies.push(lbvalue['ip'])
end

node.default['jmh_webserver']['apache']['remote_ip_proxy_servers'] = remote_ip_proxies.concat(node['jmh_webserver']['apache']['vpn_ips'])

Chef::Log.warn("The apache ports are #{node['apache']['listen'].to_s}")
include_recipe 'apache2::default'

