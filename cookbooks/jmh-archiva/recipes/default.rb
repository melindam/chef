#
# Cookbook Name:: jmh-archiva
# Recipe:: default
#
# Copyright 2013, John Muir Health
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'iptables'
include_recipe 'ark'

# Install Mysql Database
include_recipe 'jmh-archiva::install_db'

jmh_java_install 'java_archiva' do
  version node['jmh_archiva']['java_version']
  action :install
end

# Service defined for restarts when changes are made
service 'archiva' do
  service_name 'archiva'
  action :nothing
end

user node['jmh_archiva']['user'] do
  action :create
  shell '/bin/bash'
  manage_home true
end

ruby_block "Remove password expire for #{node['jmh_archiva']['user']}" do
  block do
     %x(chage -M #{node['jmh_server']['users']['password_expire_days']} #{node['jmh_archiva']['user']})
  end
end

# Allow rundeck to
rundeck_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'rundeck')

directory File.join('home', node['jmh_archiva']['user'], '.ssh') do
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['user']
  mode 0700
end

file File.join('home', node['jmh_archiva']['user'], '.ssh', 'authorized_keys') do
  content rundeck_key_bag['public_key']
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['user']
  mode 0600
end

ark 'archiva' do
  # url node['jmh_archiva']['binary_archives'] + '/apache-archiva-' + node['jmh_archiva']['version'] + '-bin.tar.gz'
  url node['jmh_archiva']['binary_archives']
  version node['jmh_archiva']['version']
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  action :install
  not_if { ::File.exist?(node['jmh_archiva']['install_dir']) }
end

# Install mysql connector
mysql_connector_j File.join(node['jmh_archiva']['install_dir'], 'lib') do
  action :create
end

execute 'change owner mysql-connector*jar' do
  command "chown #{node['jmh_archiva']['user']}:#{node['jmh_archiva']['group']} mysql-connector*.jar"
  cwd File.join(node['jmh_archiva']['install_dir'], 'lib')
end

directory node['jmh_archiva']['scratch_dir'] do
  owner 'root'
  group 'root'
  mode 0755
end

# Will restart archiva when jetty file is editted
template File.join(node['jmh_archiva']['install_dir'], 'conf/jetty.xml') do
  source 'jetty.erb'
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0644
  variables(
    :db_driver => node['jmh_archiva']['mysql']['dbdriver'],
    :db_host => node['jmh_archiva']['mysql']['host'],
    :db_userdb_name => node['jmh_archiva']['mysql']['dbname'],
    :db_user => node['jmh_archiva']['mysql']['username'],
    :db_password => node['jmh_archiva']['mysql']['password'],
    :jetty_port => node['jmh_archiva']['jetty']['port']
  )
  notifies :restart, 'service[archiva]', :delayed
end

template File.join(node['jmh_archiva']['install_dir'], 'contexts/archiva.xml') do
  source 'archiva_context_xml.erb'
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0644
  notifies :restart, 'service[archiva]', :delayed
end

repo_databag = data_bag_item('archiva', 'repositories')

template 'Update Archiva File' do
  path File.join(node['jmh_archiva']['install_dir'], 'conf/archiva.chef')
  source 'archiva.erb'
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0644
  variables(
     :snapshot_remote_repos => repo_databag['remote_repositories']['snapshots'],
     :internal_remote_repos => repo_databag['remote_repositories']['internal']
  )
  action :nothing
end

template File.join(node['jmh_archiva']['install_dir'], 'conf/archiva.chef') do
  source 'archiva.erb'
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0644
  variables(
     :snapshot_remote_repos => repo_databag['remote_repositories']['snapshots'],
     :internal_remote_repos => repo_databag['remote_repositories']['internal']
  )
  notifies :create, 'template[Update Archiva File]', :immediately
  notifies :restart, 'service[archiva]', :delayed
end

template File.join(node['jmh_archiva']['install_dir'], 'conf/wrapper.conf') do
  source 'wrapper.erb'
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0644
  variables(
    :jmx_port => node['jmh_archiva']['jmx']['port'],
    :java_home => JmhJavaUtil.get_java_home(node['jmh_archiva']['java_version'], node),
    :mysql_jar => "mysql-connector-java-#{node['mysql_connector']['j']['version']}-bin.jar"
  )
  notifies :restart, 'service[archiva]', :delayed
end

template File.join(node['jmh_archiva']['install_dir'], 'conf/security.properties') do
  source 'security_properties.erb'
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0644
  variables(
    :server_name => node['jmh_archiva']['ebizrepo']['apache_config']['server_name']
  )
  notifies :restart, 'service[archiva]', :delayed
end

iptables_rule 'iptables_archiva'

include_recipe 'jmh-archiva::install_repository' if node['jmh_archiva']['install_repositories'] == true

if node['jmh_archiva']['install_apache_app_download'] || node['recipes'].include?('jmh-archiva::app_download')
  include_recipe 'jmh-archiva::app_download'
else
  include_recipe 'jmh-archiva::apache'
end

#  Create the init file for root to call
template '/etc/init.d/archiva' do
  source 'init.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables(
    systemd: JmhServerHelpers.rhel7?(node)
  )
end

systemd_service 'archiva' do
  unit_description "Apache Archiva"
  after %w( network.target syslog.target mysql.service )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    working_directory "#{node['jmh_archiva']['install_dir']}/bin"
    exec_start "#{node['jmh_archiva']['install_dir']}/bin/archiva start"
    exec_stop "#{node['jmh_archiva']['install_dir']}/bin/archiva stop"
    pid_file "#{node['jmh_archiva']['install_dir']}/logs/archiva.pid"
    user node['jmh_archiva']['user']
    group node['jmh_archiva']['group']
    type 'forking'
  end
  only_if { JmhServerHelpers.rhel7?(node) } # systemd
end


directory "/home/archiva/bin" do
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0755
  action :create
end

template "/home/archiva/bin/repo_clean.rb" do
  source 'repo_clean_rb.erb'
  owner node['jmh_archiva']['user']
  group node['jmh_archiva']['group']
  mode 0744
  action :create
end

service 'archiva' do
  action [:enable, :start]
end
