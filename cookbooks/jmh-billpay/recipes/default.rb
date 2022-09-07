#
# Cookbook Name:: jmh-billpay
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'jmh-billpay::db'
include_recipe 'jmh-billpay::client'
include_recipe 'jmh-billpay::scripts'
include_recipe 'jmh-billpay::ftp_server'
