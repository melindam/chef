include_recipe 'jmh-operations::default'

billpay_server = {}

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, 'recipes:jmh-billpay\:\:client') do |n|
    if node['jmh_operations']['billpay']['backup_environment'] == n.environment
      billpay_server['name'] = n.name
      billpay_server['ipaddress'] = n['ipaddress']
      # billpay_server['nat_ip'] = n['ipaddress']
      Chef::Log.info("Found #{n.name} with IP #{billpay_server['ipaddress']}")
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for billpay server for #{n.environment}")
    end
  end
end

directory node['jmh_operations']['billpay']['backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_billpay_files.sh') do
  source 'archive_billpay_files_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :user => node['jmh_operations']['backup']['user'],
    :backup_dir => node['jmh_operations']['billpay']['backup_dir'],
    :server => billpay_server['ipaddress']
  )
end
