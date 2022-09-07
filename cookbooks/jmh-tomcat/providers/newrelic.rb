
action :create do
  appname = new_resource.appname ? new_resource.appname : new_resource.name

  Chef::Log.warn("The folder is #{new_resource.folder}")

  ark 'newrelic' do
    url "#{node['jmh_tomcat']['newrelic']['base_url']}/#{node['jmh_tomcat']['newrelic']['agent']}"
    path new_resource.folder
    owner new_resource.owner
    group new_resource.group
    action :put
    notifies :restart, "service[#{new_resource.service}]", :delayed
    not_if { ::File.exist?(::File.join(new_resource.folder, 'newrelic')) }
  end

  yml_file = ::File.join(new_resource.folder, 'newrelic', 'newrelic.yml')

  template yml_file do
    source 'newrelic_yml.erb'
    cookbook 'jmh-tomcat'
    owner new_resource.owner
    group new_resource.group
    mode '0644'
    variables(
      :app_name => appname,
      :license_key => node['jmh_tomcat']['newrelic']['license_key']
    )
    action :create
    notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{new_resource.service}]", :delayed
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  appname = new_resource.appname ? new_resource.appname : new_resource.name
  log "Removing newrelic for #{appname}"
  directory "#{new_resource.folder}/newrelic" do
    action :delete
    recursive true
    notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{new_resource.service}]", :delayed
  end
  new_resource.updated_by_last_action(true)
end
