#
# Cookbook Name:: jmh-myjmh
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'jmh-myjmh::db'
include_recipe 'jmh-myjmh::scripts'
include_recipe 'jmh-myjmh::profile-client'
include_recipe 'jmh-myjmh::profile_api'
