# Add canopyhealth.com entries into /etc/hosts via search

# Search for node which has pingfederate recipe
pingfederate_server = '127.0.0.1'
if Chef::Config[:solo]
  Chef::Log.warn('This recipe does not support solo search')
else
  search(:node, node['can_mycanopy']['pingfederate']['node_query']) do |n|
    if n.environment == node.environment
      pingfederate_server = (n['ipaddress'] == node['ipaddress']) ? '127.0.0.1' : n['ipaddress']
      break
    end
  end
end
hostsfile_entry pingfederate_server do
  hostname node['cam_mycanopy']['pingfederate']['server_name']
  comment 'PingFederate local entry'
  action :append
end

# Search for openldap node
openldap_server = '127.0.0.1'
if Chef::Config[:solo]
  Chef::Log.warn('This recipe does not support solo search')
else
  search(:node, node['can_mycanopy']['openldap']['node_query']) do |n|
    if n.environment == node.environment
      openldap_server = (n['ipaddress'] == node['ipaddress']) ? '127.0.0.1' : n['ipaddress']
      break
    end
  end
end
hostsfile_entry openldap_server do
  hostname node['cam_mycanopy']['openldap']['server_name']
  action :append
end

# for non-prod env, johnmuirhealth.com entry must be local call

include_recipe 'jmh-utilities::hostsfile_www_servers'
