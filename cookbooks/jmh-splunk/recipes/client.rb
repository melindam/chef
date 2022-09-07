
node.default['splunk']['forwarder']['url'] = node['jmh_splunk']['version_hash'][node['jmh_splunk']['version']]['forwarder']
node.default['splunk']['upgrade']['forwarder_url'] = node['jmh_splunk']['version_hash'][node['jmh_splunk']['version']]['forwarder']

search_string = "#{node['jmh_splunk']['recipe']} AND chef_environment:#{node['jmh_splunk']['server_environment']}"

server_list = ""
unless node['splunk']['server_list']
  search(:node, search_string) do |n|
    if n['ipaddress'] == node['ipaddress']
      server_list = "127.0.0.1:#{n['splunk']['receiver_port']}"
    else
      server_list = "#{n['ipaddress']}:#{n['splunk']['receiver_port']}"
    end
  end
  node.default['splunk']['server_list'] = server_list
end

include_recipe 'chef-splunk::client'

include_recipe 'chef-splunk::upgrade' if node['jmh_splunk']['upgrade']

node.default['jmh_splunk']['inputs_conf']['host'] = node.name
Chef::Log.debug("The inputs_conf are: #{node['jmh_splunk']['inputs_conf']}")

template "#{splunk_dir}/etc/system/local/inputs.conf" do
  cookbook 'chef-splunk'
  source 'inputs.conf.erb'
  mode 0644
  owner splunk_runas_user
  group splunk_runas_user
  variables(
    inputs_conf: node['jmh_splunk']['inputs_conf']
  )
  notifies :restart, 'service[splunk]', :delayed
  not_if { node['jmh_splunk']['inputs_conf'].nil? }
end
