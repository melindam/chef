include_recipe 'jmh-rundeck::default'

directory File.join(node['rundeck']['datadir'],'projects') do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  mode '0755'
end

projects_databag = Chef::DataBagItem.load(node['jmh_rundeck']['project_data_bag'], 'projects')

server_hash = {}

projects_databag['projects'].each do |project|
  project['resources'].each do |res|
    current_resource_name = res['name']
    current_resource = { 'ipaddress' => 'localhost' }
    Chef::Log.debug("The Resource is #{current_resource_name}")
    next if server_hash[current_resource_name]
    if Chef::Config[:solo]
      Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
    else
      search(:node, "name:#{current_resource_name}") do |n|
        current_resource['ipaddress'] = case
                                        when n['ipaddress'] == node['ipaddress']
                                          '127.0.0.1'
                                        when n['cloud']
                                          n['cloud']['public_hostname']
                                        else
                                          n['ipaddress']
                                        end
        current_resource['osarch'] = n['kernel']['machine']
        current_resource['osname'] = n['kernel']['name']
        current_resource['osversion'] = n['kernel']['release']
        break
      end
      server_hash[current_resource_name] = current_resource
    end
  end
end

Chef::Log.debug("The Server Hash looks like #{server_hash}")

projects_databag['projects'].each do |rd_project|
  jmh_rundeck_project_builder rd_project['name'] do
    servers server_hash
    project_resources rd_project['resources']
    description rd_project['description']
    ssh_keypath rd_project['ssh_keypath'] if rd_project['ssh_keypath']
    action :create
  end
end
