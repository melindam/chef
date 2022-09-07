## Backup pingfed
pingfed_server_list = []

unless Chef::Config[:solo]
  search(:node, 'recipes:jmh-pingfed\:\:pingfederate') do |n|
    node_hash = {}
    node_hash['name'] = n.name
    node_hash['ipaddress'] = case 
                             when n['cloud'] && node['jmh_server']['jmh_local_server']
                               n['cloud']['public_hostname']
                             when n['firehost'] && node['jmh_server']['jmh_local_server']
                               n['firehost']['nat_ip']
                             else
                               n['ipaddress']
                             end      
    node_hash['environment'] = n.environment
    pingfed_server_list.push(node_hash)
    Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to ping backup list")
  end
else
  pingfed_server_list.push('name' => 'test', 'ipaddress' => '127.0.0.1')
end

directory node['jmh_operations']['pingfed']['backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

pingfed_server_list.each do |n|
  directory "#{node['jmh_operations']['pingfed']['backup_dir']}/#{n['name']}" do
    owner node['jmh_operations']['backup']['user']
    group node['jmh_operations']['backup']['user']
    mode '0700'
  end
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_pingfederate.sh') do
  source 'archive_rsync_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :user => node['jmh_operations']['backup']['user'],
    :backup_dir => node['jmh_operations']['pingfed']['backup_dir'],
    :remote_dir => node['jmh_operations']['pingfed']['remote_dir'],
    :dev_search_filter => '*.zip',
    :server_list => pingfed_server_list,
    :dev_environments => node['jmh_operations']['archivedb']['dev_backup_environments']
  )
end