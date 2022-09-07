# Find crowd server based on search of jmh-crowd recipe

crowd_ip = '127.0.0.1'
# Some environments share a crowd server.  It is defined in the environment
crowd_env = node.chef_environment
if node['jmh_server']['global']['crowd_chef_environment']
   crowd_env = node['jmh_server']['global']['crowd_chef_environment']
   Chef::Log.warn("The Crowd server will used from environment: #{crowd_env}")
end

found = false
# including alias for crowd server to allow applications to communicate over SSL
search(:node, node['jmh_utilities']['crowd']['search_query']) do |n|
  next unless n.environment == crowd_env
  crowd_ip = case
             when n['ipaddress'] == node['ipaddress']
               '127.0.0.1'
             # this occurs when it is a local server and does not use the vpn
             when n['cloud'] && node['jmh_server']['no_awsvpn_traffic']
               n['cloud']['public_ipv4']
             else
               n['ipaddress']
             end
  found = true
  break
end

Chef::Application.fatal!("Crowd not found in #{crowd_env}") if !found

hostsfile_entry crowd_ip do
  hostname node['jmh_utilities']['crowd']['internal_domain']
  comment 'crowd server local to env'
  action :append
end
