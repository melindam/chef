include_recipe 'jmh-operations::default'

archiva_server = {}

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, 'role:jmh-archiva') do |n|
    if node['jmh_operations']['archiva']['backup_environment'] == n.environment
      archiva_server['name'] = n.name
      archiva_server['ipaddress'] = n['ipaddress']
      # archiva_server['nat_ip'] = (n.firehost) ? n.firehost.nat_ip : nil
      Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to archiva backup list")
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for archiva backup")
    end
  end
end

directory node['jmh_operations']['archiva']['backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_archiva.sh') do
  source 'archive_archiva_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :user => node['jmh_operations']['backup']['user'],
    :backup_dir => File.join(node['jmh_operations']['archiva']['backup_dir'], 'repositories'),
    :server => archiva_server,
    :jmh_local => node['jmh_server']['jmh_local_server']
  )
end
