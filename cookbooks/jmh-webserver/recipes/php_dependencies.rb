# Include all the required dependencies for PHP and access to code

# Make sure the default php is not installed from centos repo
node['php']['remove_packages'].each do |php_package|
  package php_package do
    action :remove
    notifies :restart, 'service[apache2]', :delayed
  end
end

# Remove apache mods that are not needed
node['jmh_webserver']['apache_mod_removals'].each do |php_file|
  %w(mods-enabled mods-available).each do |mod_dir|
    file File.join(node['apache']['dir'],mod_dir, php_file) do
      action :delete
      notifies :restart, 'service[apache2]', :delayed
    end
  end
end

yum_package 'epel-release'

# Add repo for the latest versions of php
remote_file "#{Chef::Config[:file_cache_path]}/#{node['jmh_webserver']['php_prep']['yum_repo']['rpm']}" do
  source node['jmh_webserver']['php_prep']['yum_repo']['url']
  action :create
end
rpm_package node['jmh_webserver']['php_prep']['yum_repo']['name'] do
  source "#{Chef::Config[:file_cache_path]}/#{node['jmh_webserver']['php_prep']['yum_repo']['rpm']}"
  action :install
end

include_recipe 'xml'
include_recipe 'php'

apache_module 'php7' do
  enable true
  cookbook 'jmh-webserver'
  conf true
  module_path '/usr/lib64/httpd/modules/libphp7.so'
  notifies :restart, 'service[apache2]', :delayed
end
