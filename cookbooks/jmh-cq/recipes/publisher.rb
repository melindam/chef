# Definition provided from this cookbook

# Publishers in a load balanced environment need to be able to
# pull out of the load balance pool. Adding the load balancer draining, if needed for the environment
lb_databag = EncryptedDataBagItem.load(node['cq']['lb']['databag'][0],node['cq']['lb']['databag'][1])
lb_environments = lb_databag.to_hash.keys()

load_balancer_enabled = lb_environments.include?(node['jmh_server']['environment'])

dispatcher_ip = '127.0.0.1'
if load_balancer_enabled
  node['cq']['dispatcher_publisher_hash'].keys().each() do |c_env|
    if node['roles'].include?(c_env)
      node.default['cq']['dispatcher_role'] = node['cq']['dispatcher_publisher_hash'][c_env]
    end
  end
  unless node['roles'].include?(node['cq']['dispatcher_role'])
    Chef::Log.debug( "the dispatcher role search is =roles:#{node['cq']['dispatcher_role']} AND chef_environment:#{node.environment}")
    search(:node, "roles:#{node['cq']['dispatcher_role']} AND chef_environment:#{node.environment}") do |n|
      dispatcher_ip = n['ipaddress']
    end
  end
end

Chef::Log.debug("dispatcher ip is: #{dispatcher_ip}")

node['cq']['maintenance_time']['publisher_weekday_rolehash'].each() do |rolekey,weekday|
  if node['roles'].include?(rolekey)
    node.default['cq']['maintenance_time']['publisher_weekday'] = weekday
  end
end

jmh_cq_instance 'publisher' do
  disable_tar_compaction node['cq']['author']['disable_tar_compaction']
  load_balancer_enabled load_balancer_enabled
  load_balancer_pools node['cq']['lb']['pools'] if load_balancer_enabled
  load_balancer_pool_ip "#{dispatcher_ip}:443" if load_balancer_enabled
  action :install
end

template File.join(node['cq']['bin_dir'],'update_lb_pool_rb.sh') do
  cookbook 'jmh-bamboo'
  source 'update_lb_pool_rb.erb'
  owner 'root'
  group 'root'
  mode 0700
  variables(
      environment_creds: (load_balancer_enabled) ? {"#{node['jmh_server']['environment']}": lb_databag[node['jmh_server']['environment']].to_hash()} : nil
  )
  action ( lb_environments.include?(node['jmh_server']['environment'])) ? :create : :delete
end
