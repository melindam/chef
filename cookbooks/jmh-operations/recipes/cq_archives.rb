include_recipe 'jmh-operations::default'

jmh_java_install 'install backup java' do
  version node['jmh_operations']['cq']['java_version']
  action :install
end

cq_nodes = {}

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  cq_nodes = { 'publisher' => { 'name' => 'publisher', 'ipaddress' => '127.0.0.1', 'environment' => 'arprod', 'jmh_environment' => 'prod' },
               'author' => { 'name' => 'author', 'ipaddress' => '127.0.0.1', 'environment' => 'arprod', 'jmh_environment' => 'prod' } }
else
  node['jmh_operations']['cq']['server_backups']['servers'].each do |server|
    search(:node, server['search_query']) do |n|
      if node['jmh_operations']['cq']['server_backups']['environment'] == n.environment
        found_server = {}
        found_server['name'] = n.name
        found_server['ipaddress'] = n['ipaddress']
        cq_nodes[server['name']] = found_server
        Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to cq #{server['name']} backup list")
      else
        Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} cq backup list")
      end
    end
  end
end

directory node['jmh_operations']['cq']['backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0755'
end

# CQ Full Server Backups
directory File.join(node['jmh_operations']['cq']['backup_dir'], node['jmh_operations']['cq']['server_backups']['folder_name']) do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

node['jmh_operations']['cq']['server_backups']['servers'].each do |server|
  server_node = cq_nodes[server['name']]
  Chef::Log.debug "The server node is #{server_node}"
  template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', "get_cq_#{server['name']}_backup.sh") do
    source 'cq/backup_servers_sh.erb'
    owner node['jmh_operations']['backup']['user']
    group node['jmh_operations']['backup']['user']
    mode '0700'
    variables(
      :user => node['jmh_operations']['backup']['user'],
      :backup_dir => File.join(node['jmh_operations']['cq']['backup_dir'], node['jmh_operations']['cq']['server_backups']['folder_name']),
      :server_ip =>  server_node['ipaddress'],
      :backup_name => server['backup_name'],
      :java_version => JmhJavaUtil.get_java_home(node['jmh_operations']['cq']['java_version'], node),
      :sleep_time => '1200'
    )
  end
end

# CQ Production Packs
prodpacks_server = {}
search(:node, node['jmh_operations']['cq']['prod_packs']['search_query']) do |n|
  prodpacks_server['name'] = n.name
  prodpacks_server['ipaddress'] = n['ipaddress']
  Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to cq prod packs")
end

directory File.join(node['jmh_operations']['cq']['backup_dir'], node['jmh_operations']['cq']['prod_packs']['folder_name']) do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0755'
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'get_cq_prod_packs.sh') do
  source 'cq/prod_packs_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :user => node['jmh_operations']['backup']['user'],
    :ip_address =>  prodpacks_server['ipaddress'],
    :share_dir => node['cq']['share_directory'],
    :backup_dir => File.join(node['jmh_operations']['cq']['backup_dir'], node['jmh_operations']['cq']['prod_packs']['folder_name']),
    :java_home => JmhJavaUtil.get_java_home(node['jmh_operations']['cq']['java_version'], node),
  )
end