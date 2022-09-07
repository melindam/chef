  # Add entries into /etc/hosts for found dispatcher nodes
# Roll through any entry by IP address and add other values

if Chef::Config[:solo]
  Chef::Log.info('This recipe does not support solo search')
##  If we have defined the web stuff within the enviroment, use them instead
# See README for more info
elsif node['jmh_utilities']['hostsfile']['www_servers']
  node['jmh_utilities']['hostsfile']['www_servers'].each do |h_entry|
    hostsfile_entry h_entry['ipaddress'] do
      hostname h_entry['hostname'] if h_entry['aliases']
      aliases h_entry['aliases'] if h_entry['aliases']
      unique h_entry['unique'] if h_entry['aliases']
      action h_entry['action']
    end
  end
else
## Else we go find the frontend using a search
  www_ip = '127.0.0.1'
  www_name = node['jmh_server']['global']['apache']['www']['server_name']
  idp_name = node['jmh_server']['global']['apache']['idp']['server_name']
  api_name = node['jmh_server']['global']['apache']['api']['server_name']

  unless node['recipes'].include?(node['jmh_utilities']['hostsfile']['local_recipe_check'])
    search(:node, node['jmh_utilities']['hostsfile']['front_end_search']) do |n|
      next unless n.environment == node.environment
      www_ip = n['ipaddress']
    end
  end

  # If localhost, do not remove the other entries
  hostsfile_entry www_ip do
    hostname www_name
    aliases [idp_name, api_name]
    unique www_ip == '127.0.0.1' ? false : true
    action www_ip == '127.0.0.1' ? :append : :create
  end
end

