include_recipe 'java'
include_recipe 'jmh-tcserver::user'
include_recipe 'ssh_known_hosts'

package 'git'

directory node['jmh_tcserver']['install_dir'] do
  action :create
  owner node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
end

git node['jmh_tcserver']['install_dir'] do
  repository node['jmh_tcserver']['repository']
  revision node['jmh_tcserver']['revision']
  user node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
  action :sync
end

template '/etc/init.d/tcserver' do
  source 'all.init.erb'
  mode 0755
  variables(
    :user => node['jmh_tcserver']['user'],
    :tcserver_home => node['jmh_tcserver']['install_dir']
  )
end

# Ensure required directories exist within app instances
%w(logs temp).each do |r_dir|
  node['jmh_tcserver']['available_apps'].each do |app|
    directory File.join(node['jmh_tcserver']['install_dir'], app, r_dir) do
      owner node['jmh_tcserver']['user']
      group node['jmh_tcserver']['group']
    end
  end
end

