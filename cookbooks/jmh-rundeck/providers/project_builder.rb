use_inline_resources

action :create do
  server_hash = new_resource.servers
  project_array = new_resource.project_resources
  project_name = new_resource.name

  directory ::File.join(node['rundeck']['datadir'], 'projects', project_name) do
    owner node['rundeck']['user']
    group node['rundeck']['user']
    recursive true
    mode '0700'
  end

  directory ::File.join(node['rundeck']['datadir'], 'projects', project_name, 'etc') do
    owner node['rundeck']['user']
    group node['rundeck']['user']
    mode '0700'
  end

  template ::File.join(node['rundeck']['datadir'], 'projects', project_name, 'etc', 'project.properties') do
    owner node['rundeck']['user']
    group node['rundeck']['user']
    source 'project_properties.erb'
    variables(
      :name => project_name,
      :description => new_resource.description,
      :ssh_keypath => new_resource.ssh_keypath
    )
    action :create
    notifies :restart, 'service[rundeckd]', :delayed
  end

  Chef::Log.debug("Project Array is #{project_array}")
  Chef::Log.debug("Server Hash  is #{server_hash}")

  template ::File.join(node['rundeck']['datadir'], 'projects', project_name, 'etc', 'resources.xml') do
    owner node['rundeck']['user']
    group node['rundeck']['user']
    source 'project_resources_xml.erb'
    variables(
      :resource_hash => server_hash,
      :project_array => project_array
    )
    action :create
    notifies :restart, 'service[rundeckd]', :delayed
  end
end
