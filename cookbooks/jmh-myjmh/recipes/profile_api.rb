
nodejs_version = node['jmh_myjmh']['profile_api']['nodejs_version']

include_recipe 'jmh-utilities::hostsfile_epic_servers'
include_recipe 'jmh-utilities::hostsfile_www_servers'
include_recipe 'jmh-utilities::hostsfile_profile_servers'
include_recipe 'jmh-utilities::hostsfile_crowd_servers'
include_recipe 'jmh-utilities::hostsfile_hsysdc'


::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

if node['jmh_myjmh']['profile_api']['db']['password'].nil?
  node.normal['jmh_myjmh']['profile_api']['db']['password'] = random_password
end

include_recipe 'jmh-myjmh::definitions'


jmh_nodejs_install "nodejs for #{node['jmh_myjmh']['profile_api']['name']}" do
  version nodejs_version
  action :install
end

nodejs_path = JmhNodejsUtil.get_nodejs_home(nodejs_version,node)

secure_cert_databag_item = Chef::EncryptedDataBagItem.load(node['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_name'],
                                                      node['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_item'])

public_cert_databag_item = data_bag_item( node['jmh_myjmh']['myjmh_keys']['public_ssh_key']['databag_name'],
                                          node['jmh_myjmh']['myjmh_keys']['public_ssh_key']['databag_item'])

directory File.join(node['jmh_nodejs']['webserver_path'],"certs") do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0700
  action :create
end

file File.join(node['jmh_nodejs']['webserver_path'],"certs","#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.cert")  do
  content secure_cert_databag_item[node['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_key_name']]
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0600
  action :create
end


file File.join(node['jmh_nodejs']['webserver_path'],"certs","#{node['jmh_myjmh']['myjmh_keys']['public_ssh_key']['name']}.cert")  do
  content public_cert_databag_item[node['jmh_myjmh']['myjmh_keys']['public_ssh_key']['databag_key_name']]
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0600
  action :create
end

systemd_service node['jmh_myjmh']['profile_api']['name'] do
  unit_description "profile-api nodejs server"
  after %w( network.target syslog.target mysql.service )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    working_directory File.join(node['jmh_nodejs']['webserver_path'],node['jmh_myjmh']['profile_api']['name'])
    exec_start "#{nodejs_path}/bin/npm start"
    user node['jmh_nodejs']['user']
    group node['jmh_nodejs']['user']
    type 'simple'
  end
  notifies :restart, 'service[profile-api]', :delayed
end


template File.join('/etc/sudoers.d' , node['jmh_myjmh']['profile_api']['name']) do
  source 'sudoers_systemctl.erb'
  mode '0440'
  variables(
      :app_name => node['jmh_myjmh']['profile_api']['name'],
      :user => node['jmh_nodejs']['user'],
      :actions => ['stop','start','restart','status']
  )
end

iptables_list = { 'portlist' => {
    '8096' => { 'target' => 'ACCEPT' },
    '8465' => { 'target' => 'ACCEPT' } } }

# creates iptables for ports on tomcat
iptables_rule "nodejs_profile_api" do
  cookbook 'jmh-nodejs'
  source 'nodejs_iptables.erb'
  variables node['jmh_myjmh']['profile_api']['iptables_list']
  enable node['jmh_myjmh']['profile_api']['iptables_list']['portlist'].length != 0 ? true : false
end

template File.join('/home', node['jmh_nodejs']['user'], 'bin', 'deploy_profile_api.sh') do
  source 'deploy_profile_api_sh.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
  variables(
    newrelic_enabled: node['jmh_myjmh']['profile_api']['nodejs_newrelic_enabled'],
    yaml_file: node['jmh_myjmh']['profile_api']['yaml_file'],
    newrelic_file: node['jmh_myjmh']['profile_api']['nodejs_newrelic_file']
  )
end

jmh_db_user node['jmh_myjmh']['profile_api']['db']['username'] do
  database node['jmh_myjmh']['profile']['db']['database']
  username node['jmh_myjmh']['profile_api']['db']['username']
  password node['jmh_myjmh']['profile_api']['db']['password']
  parent_node_query node['jmh_myjmh']['profile']['db']['node_query'] unless node['recipes'].include?(node['jmh_myjmh']['profile']['db']['local_recipe'])
  privileges node['jmh_myjmh']['profile']['db']['privileges']
  connect_over_ssl node['jmh_myjmh']['profile']['db']['connect_over_ssl']
end

epic_config = JmhEpic.get_epic_config(node)

interconnect_base_url = "#{epic_config['interconnect']['protocol']}://#{epic_config['interconnect']['hostname']}/#{epic_config['interconnect']['context']}"
interconnect_secure_url = "#{epic_config['interconnect']['protocol']}://#{epic_config['interconnect']['hostname']}/#{epic_config['interconnect']['secure_context']}"

interconnect_secure_user = JmhEpic.get_interconnect_auth_client('opensched',node)

aws_databag = EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['aws_data_bag'][0],node['jmh_myjmh']['profile_api']['aws_data_bag'][1])

# Get the basic auth from a databag
profile_api_databag = EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['data_bag'][0],node['jmh_myjmh']['profile_api']['data_bag'][1])
if profile_api_databag['basic_auth'][node['jmh_server']['environment']]
  node.default['jmh_myjmh']['profile_api']['basic_auth_username'] = profile_api_databag['basic_auth'][node['jmh_server']['environment']]['username']
  node.default['jmh_myjmh']['profile_api']['basic_auth_password'] = profile_api_databag['basic_auth'][node['jmh_server']['environment']]['password']
else
  node.default['jmh_myjmh']['profile_api']['basic_auth_username'] = profile_api_databag['basic_auth']['default']['username']
  node.default['jmh_myjmh']['profile_api']['basic_auth_password'] = profile_api_databag['basic_auth']['default']['password']

end

idp_properties = node['jmh_myjmh']['profile_api']['yaml']['idp'].to_h

pingone_databag = EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['pingone_databag'][0],node['jmh_myjmh']['profile_api']['pingone_databag'][1])

pingone_databag['profile_api_properties'][node['jmh_myjmh']['profile_api']['pingone_environment_type']].each_key do |propname|
  idp_properties[propname] = pingone_databag['profile_api_properties'][node['jmh_myjmh']['profile_api']['pingone_environment_type']][propname]
end


# need the yaml in 2 locations
# 1) to be in the node app
# 2) to be copied into the node app at install
template File.join('/home', node['jmh_nodejs']['user'],node['jmh_myjmh']['profile_api']['yaml_file']) do
  source 'profile_local_yaml.erb'
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0644
  action :create
  variables(
    https_port: node['jmh_myjmh']['profile_api']['https_port'],
    www_server_name: node['jmh_server']['global']['apache']['www']['server_name'],
    hostname: node['cloud'] ? node['cloud']['public_hostname'] : node['ipaddress'],
    db: node['jmh_myjmh']['profile']['db']['database'],
    db_user: node['jmh_myjmh']['profile_api']['db']['username'],
    db_password: node['jmh_myjmh']['profile_api']['db']['password'],
    db_host: node['jmh_myjmh']['db']['server'],
    crowd_server: 'https://crowd.jmh.internal:8495/crowd',
    crowd_password: node['jmh_myjmh']['crowd_application_password'],
    crowd_username: 'profile',
    basic_auth_username: node['jmh_myjmh']['profile_api']['basic_auth_username'],
    basic_auth_password: node['jmh_myjmh']['profile_api']['basic_auth_password'],
    interconnect_base_url: interconnect_base_url,
    interconnect_secure_url: interconnect_secure_url,
    interconnect_secure_user: interconnect_secure_user['username'],
    interconnect_secure_user_password: interconnect_secure_user['password'],
    interconnect_client_id: epic_config['interconnect']['clientid'],
    log_dir: File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_myjmh']['profile_api']['name']}-logs"),
    public_key_file: File.join(node['jmh_nodejs']['webserver_path'],"certs","#{node['jmh_myjmh']['myjmh_keys']['public_ssh_key']['name']}.cert"),
    private_key_file: File.join(node['jmh_nodejs']['webserver_path'],"certs","#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.cert"),
    whitelist_ips: node['jmh_myjmh']['profile_api']['whitelist_ips'],
    idp_properties: idp_properties,
    chatbot_properties: profile_api_databag['chatbot'][node['jmh_myjmh']['profile_api']['chatbot_environment_type']],
    aws_properties: aws_databag['iam']['pinpoint'][node['jmh_myjmh']['profile_api']['aws_environment_type']],
    ldap_properties: profile_api_databag['ldap'][node['jmh_myjmh']['profile_api']['ldap_environment_type']],
    google_captcha_secret_key: node['jmh_server']['global']['google_captcha_secret_key']
  )
  notifies :restart, 'service[profile-api]', :delayed
end

file File.join(node['jmh_nodejs']['webserver_path'],node['jmh_myjmh']['profile_api']['name'],'config','local.yaml') do
  content lazy{File.open( File.join('/home', node['jmh_nodejs']['user'],node['jmh_myjmh']['profile_api']['yaml_file']) ).read}
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0640
  action :create
  notifies :restart, 'service[profile-api]', :delayed
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_myjmh']['profile_api']['name']))}
end

template File.join('/home', node['jmh_nodejs']['user'],"profile-api-#{node['jmh_myjmh']['profile_api']['nodejs_newrelic_file']}") do
  cookbook 'jmh-nodejs'
  source 'node_newrelic_js.erb'
  variables(
    application_name: 'profile-api',
    environment: node.environment,
    license_key: node['jmh_myjmh']['profile_api']['nodejs_newrelic_license'],
    log_level: node['jmh_myjmh']['profile_api']['nodejs_newrelic_loglevel']
  )
  action node['jmh_myjmh']['profile_api']['nodejs_newrelic_enabled'] ? :create : :delete
  notifies :restart, 'service[profile-api]', :delayed
end

file File.join(node['jmh_nodejs']['webserver_path'],node['jmh_myjmh']['profile_api']['name'],node['jmh_myjmh']['profile_api']['nodejs_newrelic_file']) do
  content lazy{File.open( File.join('/home', node['jmh_nodejs']['user'],"profile-api-#{node['jmh_myjmh']['profile_api']['nodejs_newrelic_file']}") ).read}
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0640
  action node['jmh_myjmh']['profile_api']['nodejs_newrelic_enabled'] ? :create : :delete
  notifies :restart, 'service[profile-api]', :delayed
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_myjmh']['profile_api']['name']))}
end


directory File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_myjmh']['profile_api']['name']}-logs") do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0744
  action :create
  notifies :restart, 'service[profile-api]', :delayed
  not_if { node['recipes'].include?('jmh-encrypt::lukscrypt') }
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
      FileUtils.mv(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_myjmh']['profile_api']['name']}-logs"),
                   File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'nodeapp', "#{node['jmh_myjmh']['profile_api']['name']}-logs"))
    end
    not_if { ::File.symlink?(File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_myjmh']['profile_api']['name']}-logs")) }
    notifies :create, 'link[Create Profile-api Log Symlink]', :immediately
  end

  link 'Create Profile-api Log Symlink' do
    target_file File.join(node['jmh_nodejs']['webserver_path'],"#{node['jmh_myjmh']['profile_api']['name']}-logs")
    to ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'nodeapp', "#{node['jmh_myjmh']['profile_api']['name']}-logs")
    link_type :symbolic
    action :nothing
    notifies :restart , "service[profile-api]", :delayed
  end
end

service 'profile-api' do
  action [:start,:enable]
  only_if { File.exist?(File.join(node['jmh_nodejs']['webserver_path'],node['jmh_myjmh']['profile_api']['name']))}
end

logrotate_app 'profile-api' do
  cookbook 'logrotate'
  path "#{node['jmh_nodejs']['webserver_path']}/#{node['jmh_myjmh']['profile_api']['name']}-logs/*.log"
  frequency 'weekly'
  rotate 12
  options ['compress', 'missingok', 'notifempty', 'copytruncate', 'sharedscripts', 'dateext' ]
end
