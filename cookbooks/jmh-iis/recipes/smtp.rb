#
# Cookbook Name:: jmh-iis
# Recipe:: smtp
#
# Copyright (C) 2019 Melinda Moran
#
# All rights reserved - Do Not Redistribute
#

windows_feature "smtp-server" do
  action :install
  all true
  install_method :windows_feature_powershell
end