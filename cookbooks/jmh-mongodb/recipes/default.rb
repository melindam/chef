#
# Cookbook:: jmh-mongodb
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

if node['mongodb']['admin']['password'].nil?
  node.normal['mongodb']['admin']['password'] = random_password
end

# both passwords have to be the same for authentication to work and setup other users
node.default['mongodb']['authentication']['password'] = node['mongodb']['admin']['password']

# this recipe takes care of the "upgrade" of minor versions
# upgrades to major version e.g 2.5 => 3.1 may need some re-work
include_recipe 'sc-mongodb::default'
include_recipe 'sc-mongodb::user_management'

# creates iptables for ports
iptables_rule "mongodb" do
  cookbook 'jmh-mongodb'
  source 'mongodb_iptables.erb'
  variables node['jmh_mongodb']['iptables_list']
  enable node['jmh_mongodb']['iptables_list']['portlist'].length != 0 ? true : false
end

include_recipe 'jmh-mongodb::backup'
