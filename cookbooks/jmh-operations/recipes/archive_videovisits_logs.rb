include_recipe 'jmh-operations::default'

package 'rsync' do
  action :install
end

directory node['jmh_operations']['videovisits']['backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

videovisits_servers = []

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, node['jmh_operations']['videovisits']['api_search_query']) do |n|
    if node['jmh_operations']['videovisits']['backup_environment'] == n.environment
      server_list = {}
      server_list['name'] = n.name
      server_list['ipaddress'] = n['ipaddress']
      videovisits_servers.push(server_list)
      
      directory File.join(node['jmh_operations']['videovisits']['backup_dir'], "#{n.name}") do
        owner node['jmh_operations']['backup']['user']
        group node['jmh_operations']['backup']['user']
        mode '0700'
      end
      Chef::Log.info("Found #{n.name} with IP #{n['ipaddress']}")
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for videovisits server for #{n.environment}")
    end
  end
end



template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_videovisits_logs.sh') do
  source 'archive_videovisits_logs.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :user => node['jmh_operations']['backup']['user'],
    :backup_dir => node['jmh_operations']['videovisits']['backup_dir'],
    :server_list => videovisits_servers
  )
end
