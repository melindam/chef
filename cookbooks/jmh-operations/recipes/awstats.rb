include_recipe 'jmh-operations'
include_recipe 'jmh-webserver'
include_recipe 'jmh-operations::ebiz_web_server'
include_recipe 'apache2::mod_cgi'

user node['jmh_operations']['awstats']['user'] do
  shell '/bin/bash'
  manage_home true
  action :create
end

directory File.join('/home', node['jmh_operations']['awstats']['user'], '.ssh') do
  owner node['jmh_operations']['awstats']['user']
  group node['jmh_operations']['awstats']['user']
  mode '0755'
  action :create
end

rsa_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'awstats')
file File.join('/home', node['jmh_operations']['awstats']['user'], '.ssh', 'id_rsa') do
  content rsa_key_bag['ssh_private_key']
  owner node['jmh_operations']['awstats']['user']
  group node['jmh_operations']['awstats']['user']
  mode '0600'
  action :create
end

rundeck_pub_key_bag =  Chef::EncryptedDataBagItem.load('credentials', 'rundeck')
file File.join('/home', node['jmh_operations']['awstats']['user'], '.ssh', 'authorized_keys') do
  content rundeck_pub_key_bag['public_key']
  owner node['jmh_operations']['awstats']['user']
  group node['jmh_operations']['awstats']['user']
  mode '0644'
  action :create
end

directory node['jmh_operations']['awstats']['bin_dir'] do
  owner node['jmh_operations']['awstats']['user']
  group node['jmh_operations']['awstats']['user']
  mode '0700'
  action :create
end

directory node['jmh_operations']['awstats']['webserver_logs_dir'] do
  owner node['jmh_operations']['awstats']['user']
  group node['jmh_operations']['awstats']['user']
  mode '0755'
  action :create
end


node['jmh_operations']['awstats']['packages'].each do |packg|
  package packg
end

execute 'update_awstats_permissions' do
  command "chown -R #{node['jmh_operations']['awstats']['user']}:#{node['jmh_operations']['awstats']['user']} #{node['jmh_operations']['awstats']['base_dir']}"
  action :run
end

directory node['jmh_operations']['awstats']['data_dir'] do
  owner node['jmh_operations']['awstats']['user']
  group node['jmh_operations']['awstats']['user']
  mode '0755'
  action :create
end

awstats_servers_list = data_bag_item('operations', node['jmh_operations']['awstats']['servers_databag'])

awstats_servers_list['servers'].each do |awserver|
  # Adjust for just prod
  webserver_ips = []
  Chef::Log.info("Search is #{awserver['node_search']}")
  if Chef::Config[:solo]
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  else
    search(:node, awserver['node_search']) do |n|
      webserver_ips.push(n['ipaddress'])
    end
  end

  template File.join(node['jmh_operations']['awstats']['etcdir'], "awstats.#{awserver['name']}.conf") do
    source 'awstats/awstats_conf.erb'
    owner node['jmh_operations']['awstats']['user']
    group node['jmh_operations']['awstats']['user']
    mode '0644'
    variables(
      :server_name => awserver['name'],
      :logs => awserver['logs'],
      :logs_dir => File.join(node['jmh_operations']['awstats']['webserver_logs_dir'], awserver['name']),
      :alias_name => awserver['alias_name'],
      :skip_hosts => awserver['skip_hosts'],
      :ssl_path => awserver['ssl_path'],
      :tools_dir => node['jmh_operations']['awstats']['base_dir'] + '/tools'
    )
  end

  directory File.join(node['jmh_operations']['awstats']['webserver_logs_dir'], awserver['name']) do
    owner node['jmh_operations']['awstats']['user']
    group node['jmh_operations']['awstats']['user']
    mode '0755'
  end

  directory File.join(node['jmh_operations']['awstats']['webserver_logs_dir'], awserver['name'], 'done') do
    owner node['jmh_operations']['awstats']['user']
    group node['jmh_operations']['awstats']['user']
    mode '0755'
  end

  directory File.join(node['jmh_operations']['awstats']['data_dir'], awserver['name']) do
    owner node['jmh_operations']['awstats']['user']
    group node['jmh_operations']['awstats']['user']
    mode '0755'
  end

  template File.join(node['jmh_operations']['awstats']['bin_dir'], "process-awstats-#{awserver['name']}.sh") do
    source 'awstats/process_awstats_sh.erb'
    owner node['jmh_operations']['awstats']['user']
    group node['jmh_operations']['awstats']['user']
    mode 0755
    variables(
      :wwwroot => File.join(node['jmh_operations']['awstats']['base_dir'],'wwwroot'),
      :server_name => awserver['name'],
      :logs => awserver['logs'],
      :remote_user => 'jmhbackup',
      :ips => webserver_ips,
      :local_dir => node['jmh_operations']['awstats']['webserver_logs_dir']
    )
  end
end

template File.join(node['apache']['dir'], 'conf-available', 'awstats.conf') do
  source 'awstats/awstats_apache_conf.erb'
  mode '0644'
  variables(
    :wwwroot => File.join(node['jmh_operations']['awstats']['base_dir'],'wwwroot')
  )
  notifies :restart, 'service[apache2]', :delayed
end
apache_config 'awstats'
