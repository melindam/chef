#
# Cookbook Name:: can-mycanopy
# Recipe:: default
#
# Copyright (c) 2016 John Muir Health, All Rights Reserved.

include_recipe 'apache2'

include_recipe 'jmh-server::jmhbackup'

template File.join('/home', node['can_mycanopy']['client']['user'], 'bin', 'deploy_canopy_client.sh') do
  source 'deploy_canopy_client_sh.erb'
  owner node['can_mycanopy']['client']['user']
  group node['can_mycanopy']['client']['user']
  mode 0755
  variables(
    :content_dir => node['can_mycanopy']['client']['docroot'],
    :app_name => node['can_mycanopy']['client']['app_name'],
    :home_dir => File.join('/home', node['can_mycanopy']['client']['user']),
    :misc_dir => node['can_mycanopy']['client']['misc_dir']
  )
end

directory File.join(node['can_mycanopy']['client']['docroot'], node['can_mycanopy']['client']['app_name']) do
  owner node['can_mycanopy']['client']['user']
  group node['can_mycanopy']['client']['user']
  mode 0755
  action :create
end

directory node['can_mycanopy']['client']['misc_dir'] do
  owner node['can_mycanopy']['client']['user']
  group node['can_mycanopy']['client']['user']
  mode 0755
  action :create
end

template File.join(node['can_mycanopy']['client']['misc_dir'], 'environment.js') do
  source 'environment_js.erb'
  owner node['can_mycanopy']['client']['user']
  group node['can_mycanopy']['client']['user']
  mode 0644
  variables(
    :production_mode => node['can_mycanopy']['client']['production_mode'],
    :url_api => node['can_mycanopy']['client']['url_api'],
    :url_sapi => node['can_mycanopy']['client']['url_sapi'],
    :url_idp => node['can_mycanopy']['client']['url_idp'],
    :url_idp_logout => node['can_mycanopy']['client']['url_idp_logout'],
    :url_idp_return_uri => node['can_mycanopy']['client']['url_idp_return_uri'],
    :disable_login => node['can_mycanopy']['client']['disable_login'],
    :cookie_domain => node['can_mycanopy']['client']['cookie_domain'],
    :cookie_name => node['can_mycanopy']['client']['cookie_name'],
    :cookie_expiration => node['can_mycanopy']['client']['cookie_expiration'],
    :mock_api => node['can_mycanopy']['client']['mock_api'],
    :federations => node['can_mycanopy']['client']['federations']
  )
  action :create
end

# Copy over environment file
## Why Lazy? It will get the content at compile time, and it will not get any new changes
ruby_block 'Copy Environment File' do
  block do
    ::FileUtils.copy_file(File.join(node['can_mycanopy']['client']['misc_dir'], 'environment.js'),
                          File.join(node['can_mycanopy']['client']['docroot'], node['can_mycanopy']['client']['app_name'], 'app', 'environment.js'))
  end
  action :run
  only_if { ::File.exist?(File.join(node['can_mycanopy']['client']['docroot'], node['can_mycanopy']['client']['app_name'], 'app', 'environment.js')) }
end
# file "Copy Environment File" do
# path File.join(node['can_mycanopy']['client']['docroot'], node['can_mycanopy']['client']['app_name'], 'app','environment.js')
# owner node['can_mycanopy']['client']['user']
# group node['can_mycanopy']['client']['user']
# mode 0644
# lazy { content ::File.open(File.join(node['can_mycanopy']['client']['misc_dir'], 'environment.js')).read }
# action :create
# only_if { ::File.exists?(File.join(node['can_mycanopy']['client']['docroot'], node['can_mycanopy']['client']['app_name'], 'app','environment.js')) }
# end
