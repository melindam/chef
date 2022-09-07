#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
# Cookbook Name:: zncrypt
# Recipe:: default
#
# Copyright 2012, Gazzang, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# All rights reserved - Do Not Redistribute
#
# check if the data bag exists, use a begin / rescue to handle the exception
passphrase = node[:zncrypt][:passphrase]
passphrase2 = node[:zncrypt][:passphrase2]
if passphrase.nil?
 # check if there is a masterkey_bag otherwise skip activation
 data_bag('masterkey_bag')
 # we also need a passhprase and second passphrase, we will generate a random one
 # JMH is not going to use a 2nd passphrase or a databag yet
 passphrase=data_bag_item('masterkey_bag', 'key1')['passphrase']
 passphrase2=data_bag_item('masterkey_bag', 'key1')['passphrase2']
end

#service "iptables" do
  #action :stop
#end

# ensures kernel and headers are synched
include_recipe "jmh-zncrypt::kernel-update"

# installs zncrypt
include_recipe "jmh-zncrypt::zncrypt"

# activates the zncrypt and stores the master key using the data bag 
include_recipe "jmh-zncrypt::activate"

# configures the directories using the configuration from the databag
include_recipe "jmh-zncrypt::config_acls"

# does extra steps that JMH wants to accomplish
include_recipe "jmh-zncrypt::cronjob"

#include_recipe "jmh-zncrypt::encrypt_mysql"

#service "iptables" do
 # action :start
#end

