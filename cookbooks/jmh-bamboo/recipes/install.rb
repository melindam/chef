include_recipe 'jmh-bamboo'

directory node['jmh_bamboo']['install']['dir'] do
  action :create
end

r_path = if node['jmh_bamboo']['use_local_download']
           File.join(node['jmh_bamboo']['base_local_url'],
                     "#{node['jmh_bamboo']['names'][node['jmh_bamboo']['flavor']]}-" \
                     "#{node['jmh_bamboo']['version']}#{node['jmh_bamboo']['extensions'][node['jmh_bamboo']['flavor']]}")
         else
           File.join(node['jmh_bamboo']['base_url'],
                     "#{node['jmh_bamboo']['names'][node['jmh_bamboo']['flavor']]}-" \
                     "#{node['jmh_bamboo']['version']}#{node['jmh_bamboo']['extensions'][node['jmh_bamboo']['flavor']]}")
         end
l_path = File.join(node['jmh_bamboo']['scratch_dir'], File.basename(r_path))

Chef::Log.info("Rpath: #{r_path}")

remote_file l_path do
  source r_path
  action :create_if_missing
end

node.default['jmh_bamboo']['install']['current'] = File.join(
  node['jmh_bamboo']['install']['dir'],
  File.basename(l_path).sub(node['jmh_bamboo']['extensions'][node['jmh_bamboo']['flavor']], '')
)
include_recipe 'jmh-bamboo::user'
include_recipe 'jmh-bamboo::dependencies'

execute 'update_bamboo_permissions' do
  command "chown -R #{node['jmh_bamboo']['run_as']}.#{node['jmh_bamboo']['run_as']} #{node['jmh_bamboo']['install']['current']}"
  action :nothing
end

execute 'install bamboo' do
  command "tar -xzf #{l_path}"
  cwd node['jmh_bamboo']['install']['dir']
  not_if do
    File.directory?(node['jmh_bamboo']['install']['current'])
  end
  notifies :restart, 'service[bamboo]', :delayed
  notifies :run, 'execute[update_bamboo_permissions]', :immediately
end

include_recipe 'jmh-bamboo::mysql'

file File.join(node['jmh_bamboo']['install']['current'], 'atlassian-bamboo/WEB-INF/classes/bamboo-init.properties') do
  content "bamboo.home=#{node['jmh_bamboo']['install']['current']}\n"
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0644
end

template '/etc/init.d/bamboo' do
  source 'bamboo_init_d.erb'
  variables(
    :start_script => "#{node['jmh_bamboo']['install']['current']}/bin/start-bamboo.sh",
    :stop_script => "#{node['jmh_bamboo']['install']['current']}/bin/stop-bamboo.sh",
    :user => node['jmh_bamboo']['run_as'],
    :el => node['platform_family'] == 'rhel'
  )
  mode 0755
  action :create
  notifies :restart, 'service[bamboo]', :delayed
end

systemd_service 'bamboo' do
  unit_description 'Atlassian Bamboo'
  after %w( network.target syslog.target )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    exec_start "#{node['jmh_bamboo']['install']['current']}/bin/start-bamboo.sh"
    exec_stop "#{node['jmh_bamboo']['install']['current']}/bin/stop-bamboo.sh"
    user node['jmh_bamboo']['run_as']
    group node['jmh_bamboo']['run_as']
    type 'forking'
  end
end

if File.exist?(File.join(node['jmh_bamboo']['install']['current'], 'bamboo.cfg.xml'))
  bamboo_config_file = File.join(node['jmh_bamboo']['install']['current'], 'bamboo.cfg.xml')

  node['jmh_bamboo']['config']['setup_variables_list'].each do |bamboo_var|
    node.normal['jmh_bamboo']['config']['setup_variables'][bamboo_var] = ParseBambooXml.parse_config(bamboo_var, bamboo_config_file)
  end
  %w(serverId serverKey license.string).each do |bamboo_prop|
    node.normal['jmh_bamboo']['config'][bamboo_prop] = ParseBambooXml.parse_config_property(bamboo_prop, bamboo_config_file)
  end
elsif node['jmh_bamboo']['config']['license.string']
  Chef::Log.warn("**Upgrade of Bamboo in Progress")

  # TODO Stop service

  execute "Backup Bamboo Database before upgrade" do
    command node['jmh_db']['backup']['backup_script']
    action :run
  end
else
  Chef::Log.warn("**New Install of Bamboo in Progress")
end

template File.join(node['jmh_bamboo']['install']['current'], 'bamboo.cfg.xml-chef')  do
  source 'bamboo_cfg_xml.erb'
  mode 0600
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  variables(
    :bamboo_config_properties => node['jmh_bamboo']['config']['setup_variables'],
    :bamboo_build_number => node['jmh_bamboo']['build_number'][node['jmh_bamboo']['version']],
    :max_pool_size => 30,
    :server_id => node['jmh_bamboo']['config']['serverId'],
    :license => node['jmh_bamboo']['config']['license.string'],
    :server_key => node['jmh_bamboo']['config']['serverKey'],
    :password => node['jmh_bamboo']['mysql']['password'],
    :user => node['jmh_bamboo']['mysql']['username'],
    :database =>  node['jmh_bamboo']['mysql']['dbname'],
    :server_name => node['jmh_bamboo']['server_name']
  )
  action :create
  only_if { node['jmh_bamboo']['config']['license.string']  }
  notifies :create, 'remote_file[Update Bamboo Config File]', :immediately
  notifies :restart, 'service[bamboo]', :delayed
end

remote_file 'Update Bamboo Config File' do
  path File.join(node['jmh_bamboo']['install']['current'], 'bamboo.cfg.xml')
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0655
  source "file://#{node['jmh_bamboo']['install']['current']}/bamboo.cfg.xml-chef"
  action :nothing
end


template File.join(node['jmh_bamboo']['install']['current'], 'conf/server.xml') do
  source 'server_xml.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  action :create
  notifies :restart, 'service[bamboo]', :delayed
  variables(
      server_name: node['jmh_bamboo']['server_name'],
      server_port: node['jmh_bamboo']['server_port']
  )
end

template File.join(node['jmh_bamboo']['install']['current'], 'bin/catalina.sh') do
  source 'catalina_sh.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  action :create
  variables(
    :java_home => JmhJavaUtil.get_java_home(node['jmh_bamboo']['java']['server_version'], node),
    :pid_file => "#{node['jmh_bamboo']['install']['current']}/bin/bamboo.pid"
  )
  notifies :restart, 'service[bamboo]', :delayed
end

template File.join(node['jmh_bamboo']['install']['current'], 'bin/setenv.sh') do
  source 'setenv_sh.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  action :create
  notifies :restart, 'service[bamboo]', :delayed
end

%w(xml-data index).each do |rootdirs|
  directory File.join(node['jmh_bamboo']['install']['current'], rootdirs) do
    owner node['jmh_bamboo']['run_as']
    group node['jmh_bamboo']['run_as']
    mode 0755
    action :create
  end
end

%w(configuration builds build-dir).each do |xmldir|
  directory File.join(node['jmh_bamboo']['install']['current'], 'xml-data', xmldir) do
    recursive true
    owner node['jmh_bamboo']['run_as']
    group node['jmh_bamboo']['run_as']
    mode 0755
    action :create
  end
end

# Setup Crowd Authentication
crowd_env = node['jmh_server']['global']['crowd_chef_environment'] ? node['jmh_server']['global']['crowd_chef_environment'] : node.chef_environment
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  node.default['jmh_bamboo']['crowd_server_url'] = '127.0.0.1'
else
  unless node['jmh_bamboo']['crowd_server_url']
    search(:node, "roles:#{node['jmh_bamboo']['crowd_role']} AND chef_environment:#{crowd_env}") do |n|
      ip = n['ipaddress']
      port = n['jmh_crowd']['port']
      node.default['jmh_bamboo']['crowd_server_url'] = "http\://#{ip}\\:#{port}/crowd"
    end
  end
end

if node['jmh_bamboo']['crowd_server_url'].nil?
  node.default['jmh_bamboo']['crowd_authentication'] = false
  node.default['jmh_bamboo']['crowd_server_url'] = 'http://localhost:8095/crowd'
end

mybaseurl = node['jmh_bamboo']['mybase_bamboo_url']
admin_file = File.join(node['jmh_bamboo']['install']['current'], 'xml-data/configuration/administration.xml')
if File.exist?(admin_file)
  xml_edit 'Fix Bamboo Context in Admin file' do
    path admin_file
    target '/AdministrationConfiguration/myBaseUrl'
    fragment "<myBaseUrl>#{mybaseurl}</myBaseUrl>"
    notifies :restart, 'service[bamboo]', :delayed
    not_if { File.readlines(admin_file).grep(/#{mybaseurl}/).size > 0 }
    action :replace
  end
end

template File.join(node['jmh_bamboo']['install']['current'], 'xml-data/configuration/crowd.properties') do
  source 'crowd_properties.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  action :create
  notifies :restart, 'service[bamboo]', :delayed
  variables(
    :crowd_url => node['jmh_bamboo']['crowd_server_url']
  )
end

template File.join(node['jmh_bamboo']['install']['current'], 'xml-data/configuration/atlassian-user.xml') do
  source 'atlassian_user_xml.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  action :create
  notifies :restart, 'service[bamboo]', :delayed
  variables(
    :use_crowd => node['jmh_bamboo']['crowd_authentication']
  )
end

service 'bamboo' do
  action [:enable, :start]
end

include_recipe 'jmh-bamboo::lighthouse'
include_recipe 'jmh-bamboo::testcafe'
include_recipe 'jmh-bamboo::mongodb'