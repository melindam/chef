#
# Cookbook Name:: jmh-splunk
# Recipe:: server
#
#

node.default['splunk']['server']['url'] = node['jmh_splunk']['version_hash'][node['jmh_splunk']['version']]['server']
node.default['splunk']['upgrade']['server_url'] = node['jmh_splunk']['version_hash'][node['jmh_splunk']['version']]['server']
node.default['splunk']['is_server'] = true

include_recipe 'chef-splunk::upgrade' if node['jmh_splunk']['upgrade']

hostsfile_entry node['jmh_splunk']['keyserver']['ip'] do
  hostname node['jmh_splunk']['keyserver']['name']
  comment 'splunk keyserver'
  unique true
  action :create
end

include_recipe 'chef-splunk::user'
include_recipe 'chef-splunk::install_server'
include_recipe 'chef-splunk::service'

# Overriding the splunk::setup_auth because I am not a fan of chef-vault
# setup_auth is set to false, so we setup our own password
splunk_databag = Chef::EncryptedDataBagItem.load(node['jmh_splunk']['databag'],node['jmh_splunk']['databag_item'])
# TODO Remove the case and move it to the environment
node.default['jmh_splunk']['admin_password'] = case node['jmh_server']['environment']
                                               when 'prod'
                                                 splunk_databag['prod_password']
                                               else
                                                 splunk_databag['dev_password']
                                               end unless node['jmh_splunk']['admin_password']

# Only creates admin user first time, then seed file is removed
# If you have to reset the password, need to remove the .user-seed.conf
execute 'remove-passwd-file-first-run' do
  command 'rm -f #{splunk_dir}/etc/passwd'
  not_if { ::File.exist?("#{splunk_dir}/etc/system/local/.user-seed.conf") }
end

template 'user-seed.conf' do
  path "#{splunk_dir}/etc/system/local/user-seed.conf"
  cookbook 'chef-splunk'
  source 'user-seed-conf.erb'
  owner node['splunk']['user']['username']
  group node['splunk']['user']['username']
  mode '600'
  sensitive true
  variables user: 'admin', password: node['jmh_splunk']['admin_password']
  notifies :restart, 'service[splunk]', :immediately
  not_if { ::File.exist?("#{splunk_dir}/etc/system/local/.user-seed.conf") }
end

file '.user-seed.conf' do
  path "#{splunk_dir}/etc/system/local/.user-seed.conf"
  content "true\n"
  owner node['splunk']['user']['username']
  group node['splunk']['user']['username']
  mode '600'
end

include_recipe 'jmh-splunk::server_apache'

template File.join("#{splunk_dir}/etc/system/local",'alert_actions.conf') do
  source 'alert_actions.conf.erb'
  mode 0600
  variables(
    servername: node['jmh_splunk']['http']['config']['server_name']
  )
end

iptables_rule "splunk_server" do
  cookbook 'jmh-splunk'
  source 'iptables.erb'
  variables Hash['portlist' => {'8000' => 'ACCEPT', '9997' => 'ACCEPT'}]
  action :create
end