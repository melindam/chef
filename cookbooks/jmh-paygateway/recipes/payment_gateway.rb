
include_recipe 'jmh-paygateway::db'

nodejs_version = node['jmh_paygateway']['nodejs_version']

include_recipe 'jmh-utilities::hostsfile_www_servers'
# include_recipe 'jmh-utilities::hostsfile_hsysdc'

group 'nodejs' do
  members 'jmhbackup'
  append true
  action :manage
end

jmh_nodejs_install "nodejs for #{node['jmh_paygateway']['name']}" do
  version nodejs_version
  action :install
end

nodejs_path = JmhNodejsUtil.get_nodejs_home(nodejs_version,node)

systemd_service node['jmh_paygateway']['name'] do
  unit_description "payment gateway nodejs server"
  after %w( network.target syslog.target )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    working_directory File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name'])
    exec_start "#{nodejs_path}/bin/node build/payment-gateway.js"
    environment node['jmh_paygateway']['startup_env_mode']
    user node['jmh_nodejs']['user']
    group node['jmh_nodejs']['user']
    type 'simple'
  end
  notifies :restart, 'service[payment-gateway]', :delayed
end


template File.join('/etc/sudoers.d' , node['jmh_paygateway']['name']) do
  source 'sudoers_systemctl.erb'
  mode '0440'
  variables(
      :app_name => node['jmh_paygateway']['name'],
      :user => node['jmh_nodejs']['user'],
      :actions => ['stop','start','restart','status']
  )
end

# creates iptables for ports
iptables_rule "nodejs_payment-gateway" do
  cookbook 'jmh-nodejs'
  source 'nodejs_iptables.erb'
  variables node['jmh_paygateway']['iptables_list']
  enable node['jmh_paygateway']['iptables_list']['portlist'].length != 0 ? true : false
end

template File.join('/home', node['jmh_nodejs']['user'], 'bin/deploy_payment_gateway.sh') do
  source 'deploy_paygateway_sh.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
  variables(
    app_name: node['jmh_paygateway']['name'],
    yaml_file: node['jmh_paygateway']['yaml_file'],
    newrelic_file: node['jmh_paygateway']['nodejs_newrelic_file']
  )
end

#TODO add search node to the DB connection string in local.yaml file

# need the yaml in 2 locations
# 1) to be in the node app
# 2) to be copied into the node app at install
template File.join('/home', node['jmh_nodejs']['user'],node['jmh_paygateway']['yaml_file']) do
  source 'paygateway_local_yaml.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0644
  action :create
  variables(
    https_port: node['jmh_paygateway']['https_port'],
    log_dir: '/usr/local/nodeapp/payment-gateway-logs',
    hostname: node['cloud'] ? node['cloud']['public_hostname'] : node['ipaddress'],
    cert: '/home/nodejs/ssl/pem',
    key: '/home/nodejs/ssl/key',
    db_username: node['jmh_paygateway']['client']['db']['username'],
    db_password: node['jmh_paygateway']['client']['db']['password'],
    workday_url: node['jmh_paygateway']['workday']['url'],
    workday_jmh_location: node['jmh_paygateway']['workday']['jmh_location'],
    workday_user_token: node['jmh_paygateway']['workday']['user_token'],
    workday_username: node['jmh_paygateway']['workday']['username'],
    workday_password: node['jmh_paygateway']['workday']['password']
  )
  notifies :restart, 'service[payment-gateway]', :delayed
end

directory File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name']) do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0775
end

directory File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name'],'config') do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0775
end
  
file File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name'],'config','local.yaml') do
  content lazy{File.open( File.join('/home', node['jmh_nodejs']['user'],node['jmh_paygateway']['yaml_file']) ).read}
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0640
  action :create
  notifies :restart, 'service[payment-gateway]', :delayed
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name']))}
end

template File.join('/home', node['jmh_nodejs']['user'],"paygateway-#{node['jmh_paygateway']['nodejs_newrelic_file']}") do
  cookbook 'jmh-nodejs'
  source 'node_newrelic_js.erb'
  variables(
    application_name: node['jmh_paygateway']['name'],
    environment: node.environment,
    license_key: node['jmh_paygateway']['nodejs_newrelic_license'],
    log_level: node['jmh_paygateway']['nodejs_newrelic_loglevel']
  )
  action node['jmh_paygateway']['nodejs_newrelic_enabled'] ? :create : :delete
  notifies :restart, 'service[payment-gateway]', :delayed
end

file File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name'],node['jmh_paygateway']['nodejs_newrelic_file']) do
  content lazy{File.open( File.join('/home', node['jmh_nodejs']['user'],"paygateway-#{node['jmh_paygateway']['nodejs_newrelic_file']}") ).read}
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0640
  action node['jmh_paygateway']['nodejs_newrelic_enabled'] ? :create : :delete
  notifies :restart, 'service[payment-gateway]', :delayed
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name']))}
end

directory File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_paygateway']['name']}-logs") do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0770
  action :create
  notifies :restart, 'service[payment-gateway]', :delayed
  not_if { ::File.symlink?(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_paygateway']['name']}-logs")) }
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
      FileUtils.mv(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_paygateway']['name']}-logs"),
                   File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'nodeapp', "#{node['jmh_paygateway']['name']}-logs"))
    end
    not_if { ::File.symlink?(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_paygateway']['name']}-logs")) }
    notifies :create, 'link[Create paygateway Log Symlink]', :immediately
  end

  link 'Create paygateway Log Symlink' do
    target_file File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_paygateway']['name']}-logs")
    to ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'nodeapp', "#{node['jmh_paygateway']['name']}-logs")
    link_type :symbolic
    action :nothing
    notifies :restart , "service[payment-gateway]", :delayed
  end
end

service 'payment-gateway' do
  action [:start,:enable]
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_paygateway']['name']))}
end

logrotate_app 'payment-gateway' do
  cookbook 'logrotate'
  path "#{node['jmh_nodejs']['webserver_path']}/#{node['jmh_paygateway']['name']}-logs/*.log"
  frequency 'weekly'
  rotate 12
  options ['compress', 'missingok', 'notifempty', 'copytruncate', 'sharedscripts', 'dateext' ]
end
