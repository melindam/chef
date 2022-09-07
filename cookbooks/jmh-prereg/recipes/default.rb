#
# Cookbook Name:: jmh-prereg
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'jmh-prereg::db'
include_recipe 'jmh-prereg::client'