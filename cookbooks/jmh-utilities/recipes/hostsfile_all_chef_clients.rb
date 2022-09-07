#
# Cookbook Name:: jmh-utilities
# Recipe:: hostsfile_all_chef_clients
#  Will add all of the chef nodes hosts entries
#  for use in jmh-local environment, otherwise it will create hosts entries for each 
#  AWS or Firehost/Armor environment that use the local IP for the environment
# if server in AWS then use local IP - cannot reach firehost,
# if server in Armor then use local IP - cannot reach AWS
    

search(:node, 'recipes:jmh-server\:\:default') do |n|
   serverip = case 
     when n['cloud'] && node['jmh_server']['jmh_local_server']
       n['cloud']['local_ipv4']
     when n['firehost'] && node['jmh_server']['jmh_local_server']
       n['firehost']['nat_ip']
     else
       n['ipaddress']
     end
  hostsfile_entry serverip do
    hostname n.name
    unique false
    action :append
  end
end
