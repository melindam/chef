# to download prod ECHO file, and upload to all dev environment servers with FAD client

dev_servers = ''
search(:node, node['jmh_operations']['fad']['client_query']) do |n|
  if n.environment == node['jmh_operations']['prod_environment']
    Chef::Log.info("Skipping #{n['ipaddress']} for FAD Development server name")
  else
    dev_fad_node = n['ipaddress']
    dev_servers << ' ' + dev_fad_node
    Chef::Log.info("Adding #{n['ipaddress']} to FAD script")
  end
end

prod_server = 'localhost'
search(:node, node['jmh_operations']['fad']['client_query']) do |n|
  if n.environment == node['jmh_operations']['prod_environment']
    if n['ipaddress'] == node['ipaddress']
      prod_server = '127.0.0.1'
    else
      prod_server = n['ipaddress']
    end
    break
  else
    Chef::Log.info("Skipping #{n['ipaddress']} for FAD prod server")
  end
end

template '/home/jmhbackup/bin/echo_import_dev.sh' do
  source 'echo_import_dev.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode 0700
  variables(
      :dev_servers => dev_servers,
      :prod_server => prod_server
  )
end