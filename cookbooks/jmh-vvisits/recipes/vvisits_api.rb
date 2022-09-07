
nodejs_version = node['jmh_vvisits']['api']['nodejs_version']

include_recipe 'jmh-utilities::hostsfile_www_servers'
include_recipe 'jmh-utilities::hostsfile_hsysdc'

group 'nodejs' do
  members 'jmhbackup'
  append true
  action :manage
end

jmh_nodejs_install "nodejs for #{node['jmh_vvisits']['api']['name']}" do
  version nodejs_version
  action :install
end

nodejs_path = JmhNodejsUtil.get_nodejs_home(nodejs_version,node)

systemd_service node['jmh_vvisits']['api']['name'] do
  unit_description "vvisits nodejs server"
  after %w( network.target syslog.target mysql.service )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    working_directory File.join(node['jmh_nodejs']['webserver_path'],node['jmh_vvisits']['api']['name'])
    exec_start "#{nodejs_path}/bin/node ./vvisits.js"
    environment "NEW_RELIC_APP_NAME=vvisits-#{node.environment}"
    user node['jmh_nodejs']['user']
    group node['jmh_nodejs']['user']
    type 'simple'
  end
  notifies :restart, 'service[vvisits]', :delayed
end


template File.join('/etc/sudoers.d' , node['jmh_vvisits']['api']['name']) do
  source 'sudoers_systemctl.erb'
  mode '0440'
  variables(
      :app_name => node['jmh_vvisits']['api']['name'],
      :user => node['jmh_nodejs']['user'],
      :actions => ['stop','start','restart','status']
  )
end

# creates iptables for ports
iptables_rule "nodejs_vvisits_api" do
  cookbook 'jmh-nodejs'
  source 'nodejs_iptables.erb'
  variables node['jmh_vvisits']['api']['iptables_list']
  enable node['jmh_vvisits']['api']['iptables_list']['portlist'].length != 0 ? true : false
end

# search for mongodb server for db connection
mongodb_ip = 'localhost'
search(:node, "#{node['jmh_vvisits']['api']['mongodb']['node_query']} AND chef_environment:#{node.environment}") do |n|
  if n['ipaddress'] == node['ipaddress']
    mongodb_ip = '127.0.0.1'
  elsif node['test_run'] && n['cloud']
    mongodb_ip = n['cloud']['public_hostname']
  else
    mongodb_ip = n['ipaddress']
  end
  break
end

mongodb_password = ''
search(:node, "#{node['jmh_vvisits']['api']['mongodb']['node_query']} AND chef_environment:#{node.environment}") do |n|
    mongodb_password = n['jmh_vvisits']['api']['mongodb']['password']
  break
end

template File.join('/home', node['jmh_nodejs']['user'], 'bin', 'deploy_vvisits_api.sh') do
  source 'deploy_vvisits_api_sh.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
  variables(
    newrelic_enabled: node['jmh_vvisits']['api']['nodejs_newrelic_enabled'],
    yaml_file: node['jmh_vvisits']['api']['yaml_file'],
    newrelic_file: node['jmh_vvisits']['api']['nodejs_newrelic_file']
  )
end

# Get the basic auth from a databag
api_databag = EncryptedDataBagItem.load(node['jmh_vvisits']['api']['data_bag'][0],node['jmh_vvisits']['api']['data_bag'][1])

# need the yaml in 2 locations
# 1) to be in the node app
# 2) to be copied into the node app at install
template File.join('/home', node['jmh_nodejs']['user'],node['jmh_vvisits']['api']['yaml_file']) do
  source 'vvisits_local_yaml.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0644
  action :create
  variables(
    https_port: node['jmh_vvisits']['api']['https_port'],
    www_server_name: node['jmh_server']['global']['apache']['www']['server_name'],
    hostname: node['cloud'] ? node['cloud']['public_hostname'] : node['ipaddress'],
    db: node['jmh_vvisits']['api']['mongodb']['database'],
    db_user: node['jmh_vvisits']['api']['mongodb']['username'],
    db_password: mongodb_password,
    db_host: mongodb_ip,
    log_dir: File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_vvisits']['api']['name']}-logs"),
    aws_properties: api_databag['aws'][node['jmh_vvisits']['api']['aws_environment_type']],
    videovisit_properties: api_databag['videovisit'][node['jmh_vvisits']['api']['videovisit_environment_type']],
    privacy_email: node['jmh_vvisits']['api']['privacy_email'],
    ldap_properties: api_databag['ldap'][node['jmh_vvisits']['api']['ldap_environment_type']],
    zoom_properties: api_databag['zoom'][node['jmh_vvisits']['api']['zoom_environment_type']],
    zoom_cleanup_period: node['jmh_vvisits']['api']['zoom_cleanup_period'],
    additional_properties: node['jmh_vvisits']['api']['additional_properties'],
    features_emailics: node['jmh_vvisits']['api']['features']['emailIcs'],
    features_testing: node['jmh_vvisits']['api']['features']['testing']
  )
  notifies :restart, 'service[vvisits]', :delayed
end

file File.join(node['jmh_nodejs']['webserver_path'],node['jmh_vvisits']['api']['name'],'config','local.yaml') do
  content lazy{File.open( File.join('/home', node['jmh_nodejs']['user'],node['jmh_vvisits']['api']['yaml_file']) ).read}
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0640
  action :create
  notifies :restart, 'service[vvisits]', :delayed
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_vvisits']['api']['name']))}
end

template File.join('/home', node['jmh_nodejs']['user'],"vvisits-#{node['jmh_vvisits']['api']['nodejs_newrelic_file']}") do
  cookbook 'jmh-nodejs'
  source 'node_newrelic_js.erb'
  variables(
    application_name: 'vvisits',
    environment: node.environment,
    license_key: node['jmh_vvisits']['api']['nodejs_newrelic_license'],
    log_level: node['jmh_vvisits']['api']['nodejs_newrelic_loglevel']
  )
  action node['jmh_vvisits']['api']['nodejs_newrelic_enabled'] ? :create : :delete
  notifies :restart, 'service[vvisits]', :delayed
end

file File.join(node['jmh_nodejs']['webserver_path'],node['jmh_vvisits']['api']['name'],node['jmh_vvisits']['api']['nodejs_newrelic_file']) do
  content lazy{File.open( File.join('/home', node['jmh_nodejs']['user'],"vvisits-#{node['jmh_vvisits']['api']['nodejs_newrelic_file']}") ).read}
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0640
  action node['jmh_vvisits']['api']['nodejs_newrelic_enabled'] ? :create : :delete
  notifies :restart, 'service[vvisits]', :delayed
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_vvisits']['api']['name']))}
end


directory File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_vvisits']['api']['name']}-logs") do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0770
  action :create
  notifies :restart, 'service[vvisits]', :delayed
  not_if { ::File.symlink?(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_vvisits']['api']['name']}-logs")) }

end

if node['recipes'].include?('jmh-encrypt::lukscrypt')
  directory File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'nodeapp') do
    user node['jmh_nodejs']['user']
    group node['jmh_nodejs']['user']
    mode '0755'
    action :create
  end

  ruby_block 'Move Logs to Encryption Location' do
    block do
      FileUtils.mv(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_vvisits']['api']['name']}-logs"),
                   File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'nodeapp', "#{node['jmh_vvisits']['api']['name']}-logs"))
    end
    not_if { ::File.symlink?(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_vvisits']['api']['name']}-logs")) }
    notifies :create, 'link[Create vvisits Log Symlink]', :immediately
  end

  link 'Create vvisits Log Symlink' do
    target_file File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_vvisits']['api']['name']}-logs")
    to ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'nodeapp', "#{node['jmh_vvisits']['api']['name']}-logs")
    link_type :symbolic
    action :nothing
    notifies :restart , "service[vvisits]", :delayed
  end
end

service 'vvisits' do
  action [:start,:enable]
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_vvisits']['api']['name']))}
end

logrotate_app 'vvisits' do
  cookbook 'logrotate'
  path "#{node['jmh_nodejs']['webserver_path']}/#{node['jmh_vvisits']['api']['name']}-logs/*.log"
  frequency 'weekly'
  rotate 12
  options ['compress', 'missingok', 'notifempty', 'copytruncate', 'sharedscripts', 'dateext' ]
end