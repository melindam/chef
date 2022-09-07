include_recipe 'jmh-bamboo::user'
include_recipe 'jmh-bamboo::dependencies'
# include_recipe 'jmh-bamboo::project_dependencies'

bamboo_server_ip = '127.0.0.1'
if node['jmh_bamboo']['server_ip']
  bamboo_server_ip = node['jmh_bamboo']['server_ip']
else
  if Chef::Config[:solo]
    bamboo_server_ip = '127.0.0.1'
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  elsif node['recipes'].include?('jmh-bamboo::install')
    bamboo_server_ip = '127.0.0.1'
  else
    found = false
    search(:node, 'recipes:jmh-bamboo\:\:install') do |n|
      bamboo_server_ip = n['ipaddress']
      found = true
      break     
    end
    if !found
      Chef::Application.fatal!("Could not find bamboo server!")
    end
  end
end

hostsfile_entry bamboo_server_ip do
  hostname node['jmh_bamboo']['server_name']
  aliases [node['jmh_bamboo']['server_alias']]
  unique true
  comment 'JMH Build Server'
  action :create
end

# http://ebiz-build.hsys.local/bamboo/agentServer/agentInstaller/atlassian-bamboo-agent-installer-5.9.7.jar
remote_file "/home/bamboo/#{node['jmh_bamboo']['agent']['jar_file']}" do
  source "http://#{bamboo_server_ip}:8085/bamboo/agentServer/agentInstaller/#{node['jmh_bamboo']['agent']['jar_file']}"
  action :create_if_missing
  notifies :start, 'service[bamboo_agent]', :delayed
end

template '/etc/init.d/bamboo_agent' do
  source 'bamboo_agent.erb'
  mode 0755
  variables(
    :java_home => JmhJavaUtil.get_java_home(node['jmh_bamboo']['java']['server_version'], node),
    :bamboo_server => "http://#{node['jmh_bamboo']['server_name']}:8085/bamboo/agentServer/",
    :agent_name => node['jmh_bamboo']['agent']['jar_file'],
    :agent_home => '/home/bamboo/agent_home'
  )
  action :create
  notifies :restart, 'service[bamboo_agent]', :delayed
end

systemd_service 'bamboo_agent' do
  unit_description 'Atlassian Bamboo Linux Agent'
  after %w( network.target syslog.target )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    exec_start "/etc/init.d/bamboo_agent start"
    exec_stop "/etc/init.d/bamboo_agent stop"
    user node['jmh_bamboo']['run_as']
    group node['jmh_bamboo']['run_as']
    type 'forking'
  end
end

service 'bamboo_agent' do
  action :enable
end
