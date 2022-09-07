nodejs_version = node['jmh_idev']['nodejs_version']

jmh_nodejs_install "nodejs for #{node['jmh_idev']['kcadapter_api']['name']}" do
  version nodejs_version
  action :install
end

nodejs_path = JmhNodejsUtil.get_nodejs_home(nodejs_version,node)

systemd_service node['jmh_idev']['kcadapter_api']['name'] do
  unit_description "kcadapter-api nodejs server"
  after %w( network.target syslog.target mysql.service )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    working_directory File.join(node['jmh_nodejs']['webserver_path'],node['jmh_idev']['kcadapter_api']['name'])
    exec_start "#{nodejs_path}/bin/npm start"
    user node['jmh_nodejs']['user']
    group node['jmh_nodejs']['user']
    type 'simple'
  end
  notifies :restart, 'service[kcadapter-api]', :delayed
end


template File.join('/etc/sudoers.d' , node['jmh_idev']['kcadapter_api']['name']) do
  source 'sudoers_systemctl.erb'
  mode '0440'
  variables(
      :app_name => node['jmh_idev']['kcadapter_api']['name'],
      :user => node['jmh_nodejs']['user'],
      :actions => ['stop','start','restart','status']
  )
end

# creates iptables for ports on nodeJS
iptables_rule "nodejs_kcadapter_api" do
  cookbook 'jmh-nodejs'
  source 'nodejs_iptables.erb'
  variables node['jmh_idev']['kcadapter_api']['iptables_list']
  enable node['jmh_idev']['kcadapter_api']['iptables_list']['portlist'].length != 0 ? true : false
end

template File.join('/home', node['jmh_nodejs']['user'], 'bin', 'deploy_kcadapter_api.sh') do
  source 'deploy_kcadapter_api_sh.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
end

# Get the Workday info from a databag
kcadapter_api_databag = EncryptedDataBagItem.load(node['jmh_idev']['kcadapter_api']['data_bag'][0],node['jmh_idev']['kcadapter_api']['data_bag'][1])
if kcadapter_api_databag['workday_basic_auth'][node['jmh_server']['environment']]
  node.default['jmh_idev']['kcadapter_api']['workday_basic_auth_username'] = kcadapter_api_databag['workday_basic_auth'][node['jmh_server']['environment']]['username']
  node.default['jmh_idev']['kcadapter_api']['workday_basic_auth_password'] = kcadapter_api_databag['workday_basic_auth'][node['jmh_server']['environment']]['password']
  node.default['jmh_idev']['kcadapter_api']['workday_url'] = kcadapter_api_databag['workday_url'][node['jmh_server']['environment']]
else
  node.default['jmh_idev']['kcadapter_api']['workday_basic_auth_username'] = kcadapter_api_databag['workday_basic_auth']['default']['username']
  node.default['jmh_idev']['kcadapter_api']['workday_basic_auth_password'] = kcadapter_api_databag['workday_basic_auth']['default']['password']
  node.default['jmh_idev']['kcadapter_api']['workday_url'] = kcadapter_api_databag['workday_url']['default']
end


# Get the Knowledge Center info from databag
kcadapter_api_databag = EncryptedDataBagItem.load(node['jmh_idev']['kcadapter_api']['data_bag'][0],node['jmh_idev']['kcadapter_api']['data_bag'][1])
if kcadapter_api_databag['kc_basic_auth'][node['jmh_server']['environment']]
  node.default['jmh_idev']['kcadapter_api']['kc_basic_auth_username'] = kcadapter_api_databag['kc_basic_auth'][node['jmh_server']['environment']]['username']
  node.default['jmh_idev']['kcadapter_api']['kc_basic_auth_password'] = kcadapter_api_databag['kc_basic_auth'][node['jmh_server']['environment']]['password']
  node.default['jmh_idev']['kcadapter_api']['kc_url'] = kcadapter_api_databag['kc_url'][node['jmh_server']['environment']]
  node.default['jmh_idev']['kcadapter_api']['kc_cron'] = kcadapter_api_databag['kc_cron'][node['jmh_server']['environment']]
else
  node.default['jmh_idev']['kcadapter_api']['kc_basic_auth_username'] = kcadapter_api_databag['kc_basic_auth']['default']['username']
  node.default['jmh_idev']['kcadapter_api']['kc_basic_auth_password'] = kcadapter_api_databag['kc_basic_auth']['default']['password']
  node.default['jmh_idev']['kcadapter_api']['kc_url'] = kcadapter_api_databag['kc_url']['default']
  node.default['jmh_idev']['kcadapter_api']['kc_cron'] = kcadapter_api_databag['kc_cron']['default']
end

# need the yaml in 2 locations
# 1) to be in the node app
# 2) to be copied into the node app at install
template File.join('/home', node['jmh_nodejs']['user'],'kcadapter-api-local.yaml') do
  source 'kcadapter_local_yaml.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0644
  action :create
  variables(
      http_port: node['jmh_idev']['kcadapter_api']['http_port'],
      hostname: node['cloud'] ? node['cloud']['public_hostname'] : node['ipaddress'],
      log_dir: File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_idev']['kcadapter_api']['name']}-logs"),
      workday_url: node['jmh_idev']['kcadapter_api']['workday_url'],
      wd_username: node['jmh_idev']['kcadapter_api']['workday_basic_auth_username'],
      wd_password: node['jmh_idev']['kcadapter_api']['workday_basic_auth_password'],
      kc_url: node['jmh_idev']['kcadapter_api']['kc_url'],
      kc_username: node['jmh_idev']['kcadapter_api']['kc_basic_auth_username'],
      kc_password: node['jmh_idev']['kcadapter_api']['kc_basic_auth_password'],
      kc_emails: node['jmh_idev']['kcadapter_api']['emails'],
      kc_cron: node['jmh_idev']['kcadapter_api']['kc_cron']
  )
end

directory File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_idev']['kcadapter_api']['name']}") do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
end

directory File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_idev']['kcadapter_api']['name']}", 'config') do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
end

file File.join(node['jmh_nodejs']['webserver_path'],node['jmh_idev']['kcadapter_api']['name'],'config','local.yaml') do
  content lazy{File.open( File.join('/home', node['jmh_nodejs']['user'],'kcadapter-api-local.yaml') ).read}
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0644
  action :create
  notifies :restart, 'service[kcadapter-api]', :delayed
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_idev']['kcadapter_api']['name']))}
end


directory File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_idev']['kcadapter_api']['name']}-logs") do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
  notifies :restart, 'service[kcadapter-api]', :delayed
end

service 'kcadapter-api' do
  action [:start,:enable]
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_idev']['kcadapter_api']['name']))}
end

logrotate_app 'kcadapter-api' do
  cookbook 'logrotate'
  path "#{node['jmh_nodejs']['webserver_path']}/#{node['jmh_idev']['kcadapter_api']['name']}-logs/*.log"
  frequency 'weekly'
  rotate 12
  options ['compress', 'missingok', 'notifempty', 'copytruncate', 'sharedscripts', 'dateext' ]
end