#
# Cookbook Name:: jmh-broker
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
# ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'jmh-broker::activemq'

include_recipe 'jmh-broker::app'
