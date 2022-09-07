#
# Cookbook Name:: jmh-events
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'jmh-events::db'
include_recipe 'jmh-events::client'
