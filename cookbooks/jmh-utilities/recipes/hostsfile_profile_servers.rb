# Find profile server based on search of jmh-myjmh::profile recipe

profile_ip = '127.0.0.1'

if Chef::Config[:solo]
  Chef::Log.info('This recipe does not support solo search')
else
  # including alias for profile server to allow tomcat instances to communicate over SSL
  search(:node, node['jmh_utilities']['profile']['search_query']) do |n|
    if node.chef_environment == n.environment
      profile_ip = (n['ipaddress'] == node['ipaddress']) ? '127.0.0.1' : n['ipaddress']
      break
    end
  end
end

hostsfile_entry profile_ip do
  hostname node['jmh_utilities']['profile']['internal_domain']
  comment 'profile server for tomcat'
  action :append
end
