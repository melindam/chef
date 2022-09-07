# Default recipe for building a jmh-server box
#
include_recipe "jmh-server::encrypted_data_bag"

chef_client_updater "Install #{node['jmh_server']['chef']['version']} and kill" do
  version node['jmh_server']['chef']['version']
  post_install_action 'kill'
end

file "/etc/hostname" do
  content node.name
  not_if { node['platform_family'] == 'windows' }
end

execute "set hostname with hostnamectl" do
  command "/usr/bin/hostnamectl set-hostname #{node.name}"
  action :run
  only_if {File.exists?('/usr/bin/hostnamectl')}
end

include_recipe 'os-hardening::default' unless node['platform_family'] == 'windows'
# Set linux permissions to permissive
include_recipe "selinux::permissive" unless node['platform_family'] == 'windows'

# Set Windows Permissions
include_recipe 'windows-hardening::password_policy' if node['platform_family'] == 'windows'
# include_recipe 'windows-hardening::security_policy' if node['platform_family'] == 'windows'
include_recipe 'windows-hardening::user_rights' if node['platform_family'] == 'windows'
include_recipe 'windows-hardening::audit' if node['platform_family'] == 'windows'
include_recipe 'windows-hardening::ie' if node['platform_family'] == 'windows'
include_recipe 'windows-hardening::rdp' if node['platform_family'] == 'windows'
include_recipe 'windows-hardening::access' if node['platform_family'] == 'windows'
include_recipe 'windows-hardening::privacy' if node['platform_family'] == 'windows'
include_recipe 'windows-hardening::powershell' if node['platform_family'] == 'windows'

package "which"  unless node['platform_family'] == 'windows'

include_recipe "jmh-server::yum"  unless node['platform_family'] == 'windows'

include_recipe "jmh-server::timezone"  unless node['platform_family'] == 'windows'

include_recipe "jmh-server::users"

include_recipe "chef-client::config"

if node['platform_family'] == 'windows'
  include_recipe "chef-client::task"
else
  include_recipe "jmh-server::chef_cron"
end

include_recipe "jmh-server::iptables" unless node['platform_family'] == 'windows'

include_recipe "jmh-server::mail" unless node['platform_family'] == 'windows'

include_recipe 'jmh-server::ssh' unless node['platform_family'] == 'windows'

package "vim-enhanced" do
  action :install
  not_if {node['platform_family'] == 'windows'}
end

# create hostname command prompt on systems if in the cloud
template '/etc/profile.d/jmh.sh' do
  source 'profile_jmh.sh.erb'
  owner 'root'
  group 'root'
  mode 0644
  not_if {node['platform_family'] == 'windows'}
end

include_recipe "ssh_known_hosts::default" unless node['platform_family'] == 'windows'

# Clean up /var/log/audit logs 
execute 'clean_audit_logs' do
  command 'find /var/log/audit/ -mtime +2 -exec rm -f {} \;'
  action :run
end
