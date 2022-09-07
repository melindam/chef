include_recipe 'jmh-crowd'

user node['jmh_crowd']['run_as'] do
  action :create
  manage_home true
  shell '/bin/false'
end

directory node['jmh_crowd']['install']['dir'] do
  user node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  mode 0755
  action :create
end

r_path = File.join(
  node['jmh_crowd']['base_url'],
  "#{node['jmh_crowd']['names'][node['jmh_crowd']['flavor']]}-#{node['jmh_crowd']['version']}#{node['jmh_crowd']['extensions'][node['jmh_crowd']['flavor']]}"
)
l_path = File.join(node['jmh_crowd']['scratch_dir'], File.basename(r_path))

remote_file l_path do
  source r_path
  action :create_if_missing
end

node.normal['jmh_crowd']['install']['current'] = File.join(
  node['jmh_crowd']['install']['dir'],
  File.basename(l_path).sub(node['jmh_crowd']['extensions'][node['jmh_crowd']['flavor']], '')
)

execute 'install crowd' do
  command "tar -xzf #{l_path}"
  cwd node['jmh_crowd']['install']['dir']
  not_if do
    File.directory?(node['jmh_crowd']['install']['current'])
  end
  notifies :restart, 'service[crowd]', :delayed
end

execute 'update crowd permissions' do
  command "chown -R #{node['jmh_crowd']['run_as']}.#{node['jmh_crowd']['run_as']} #{node['jmh_crowd']['install']['current']}"
  action :run
end

systemd_service 'crowd' do
  unit_description 'Atlassian Crowd'
  after %w( network.target syslog.target )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    exec_start "#{node['jmh_crowd']['install']['current']}/apache-tomcat/bin/catalina.sh start"
    exec_stop "#{node['jmh_crowd']['install']['current']}/apache-tomcat/bin/catalina.sh stop"
    pid_file "#{node['jmh_crowd']['install']['current']}/apache-tomcat/bin/tomcat.pid"
    user node['jmh_crowd']['run_as']
    group node['jmh_crowd']['run_as']
    type 'forking'
  end
end

crowd_databag = Chef::EncryptedDataBagItem.load(node['jmh_crowd']['databag']['name'], node['jmh_crowd']['databag']['databag_item'])

template File.join(node['jmh_crowd']['install']['current'], 'client/conf/crowd.properties')  do
  source 'crowd_properties.erb'
  mode 0655
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  variables(
    :app_password =>  if node['jmh_crowd']['application']['password']
                        node['jmh_crowd']['application']['password']
                      else
                        crowd_databag[node['jmh_crowd']['databag']['password_field']]
                      end,
    :crowd_url => node['jmh_crowd']['url'],
    :crowd_app_url => node['jmh_crowd']['application']['url']
  )
  notifies :restart, 'service[crowd]', :delayed
end

# if the cfg file exists, take the variables we want from it
# if the cfg does not exist,
#  If you have the license and server id, then create it from the variables
#  else do nothing

#  For updating the config file when it changes
if File.exist?(File.join(node['jmh_crowd']['install']['current'], 'shared/crowd.cfg.xml'))
  crowd_config_file = File.join(node['jmh_crowd']['install']['current'], 'shared/crowd.cfg.xml')

  node['jmh_crowd']['config']['setup_variables_list'].each do |crowd_var|
    node.normal['jmh_crowd']['config']['setup_variables'][crowd_var] = ParseCrowdXml.parse_config(crowd_var, crowd_config_file)
  end
  %w(crowd.server.id license).each do |crowd_prop|
    node.normal['jmh_crowd']['config'][crowd_prop] = ParseCrowdXml.parse_config_property(crowd_prop, crowd_config_file)
  end
elsif node['jmh_crowd']['config']['license']
  Chef::Log.warn("**Upgrade of Crowd in Progress")

  execute "Backup crowd Database before upgrade" do
    command node['jmh_db']['backup']['backup_script']
    action :run
  end
else
  Chef::Log.warn("**New Install of Crowd in Progress")
end

# The Crowd cfg file gets modified by the application at boot all the time and that hoses
#   up the template resource.  So we only update the crowd cfg file when we make changes
#   to our own copy of the file 'crowd.cfg.xml-chef'
template File.join(node['jmh_crowd']['install']['current'], 'shared/crowd.cfg.xml-chef')  do
  source 'crowd_cfg_xml.erb'
  mode 0600
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  variables(
    :crowd_config_properties => node['jmh_crowd']['config']['setup_variables'],
    :max_pool_size => 30,
    :server_id => node['jmh_crowd']['config']['crowd.server.id'],
    :license => node['jmh_crowd']['config']['license'],
    :password => node['jmh_crowd']['mysql']['password']
  )
  action :create
  only_if { node['jmh_crowd']['config']['license']  }
  notifies :create, 'remote_file[Update Crowd Config File]', :immediately
  notifies :restart, 'service[crowd]', :delayed
end

remote_file 'Update Crowd Config File' do
  path File.join(node['jmh_crowd']['install']['current'], 'shared','crowd.cfg.xml')
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  mode 0655
  source "file://#{node['jmh_crowd']['install']['current']}/shared/crowd.cfg.xml-chef"
  action :nothing
end

# If ssl is enabled, put the certs on the system, else make sure they are removed
directory node['jmh_crowd']['ssl']['cert_folder'] do
  recursive true
  mode 0700
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  action :create
  only_if { node['jmh_crowd']['enable_ssl'] }
end

cookbook_file File.join(node['jmh_crowd']['ssl']['cert_folder'], node['jmh_crowd']['ssl']['keystore']) do
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  mode 0600
  source 'keystore'
  action :create
  only_if { node['jmh_crowd']['enable_ssl'] }
  notifies :restart, 'service[crowd]', :delayed
end

# Remove keystore if ssl is turned off
file File.join(node['jmh_crowd']['ssl']['cert_folder'], node['jmh_crowd']['ssl']['keystore']) do
  action :delete
  not_if { node['jmh_crowd']['enable_ssl'] }
  notifies :restart, 'service[crowd]', :delayed
end

jmh_crowd_install_certificate 'Crowd - Install crowd cert in jre' do
  java_home JmhJavaUtil.get_java_home(node['jmh_crowd']['java']['version'], node)
  action :create
  only_if { node['jmh_crowd']['enable_ssl'] }
end

template File.join(node['jmh_crowd']['install']['current'], 'apache-tomcat/conf', 'server.xml')  do
  source 'server_xml.erb'
  mode 0600
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  variables(
    :port => node['jmh_crowd']['port'],
    :ssl_port => node['jmh_crowd']['ssl_port'],
    :enable_ssl => node['jmh_crowd']['enable_ssl'],
    :keystore_file => File.join(node['jmh_crowd']['ssl']['cert_folder'], node['jmh_crowd']['ssl']['keystore']),
    :keystorepass => node['jmh_crowd']['ssl']['keystorepass'] ? node['jmh_crowd']['ssl']['keystorepass'] : crowd_databag['keystore_password']
  )
  notifies :restart, 'service[crowd]', :delayed
end

template File.join(node['jmh_crowd']['install']['current'], 'apache-tomcat/bin', 'setenv.sh')  do
  source 'setenv_sh.erb'
  mode 0755
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  notifies :restart, 'service[crowd]', :delayed
  variables(
    java_opts: node['jmh_crowd']['java_opts'],
    pid_file: File.join(node['jmh_crowd']['install']['current'],'/apache-tomcat/bin/tomcat.pid')
  )
end

template File.join(node['jmh_crowd']['install']['current'], 'apache-tomcat/bin', 'catalina.sh')  do
  source 'catalina_sh.erb'
  mode 0755
  owner node['jmh_crowd']['run_as']
  group node['jmh_crowd']['run_as']
  notifies :restart, 'service[crowd]', :delayed
  variables(
    :java_home => JmhJavaUtil.get_java_home(node['jmh_crowd']['java']['version'], node),
    :pid_file => "#{node['jmh_crowd']['install']['current']}/apache-tomcat/bin/tomcat.pid"
  )
end

file File.join(node['jmh_crowd']['install']['current'], 'crowd-webapp/WEB-INF/classes/crowd-init.properties') do
  content "crowd.home=#{node['jmh_crowd']['install']['current']}\n"
  mode 0644
  action :create
  notifies :restart, 'service[crowd]', :delayed
end

# Stub the service for install notifications
service 'crowd' do
  action [:enable, :start]
end

include_recipe 'jmh-crowd::datastore'
