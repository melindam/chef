# http://jmhapp.hsys.local/im/locations/269
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
include_recipe 'jmh-server::jmhbackup'
include_recipe 'git'

package 'dos2unix'

package 'mutt'

template "/home/jmhbackup/.muttrc" do
  source 'mutt.erb'
  owner 'jmhbackup'
  group 'jmhbackup'
  mode '0664'
end

analytics_bag = data_bag_item('operations', 'analytics')

# Create Database
jmh_db_database node['jmh_operations']['analytics']['db']['database'] do
  database node['jmh_operations']['analytics']['db']['database']
  bind_address node['jmh_operations']['analytics']['db']['bind_address']
  action :create
end

if node['jmh_operations']['analytics']['db_password'].nil?
  node.normal['jmh_operations']['analytics']['db_password'] = random_password
end

# Create local db user for running scripts
jmh_db_mysql_local_user node['jmh_operations']['analytics']['db_user'] do
  username node['jmh_operations']['analytics']['db_user']
  password node['jmh_operations']['analytics']['db_password']
  database node['jmh_operations']['analytics']['db']['database']
  privileges [:all]
  host_connection 'localhost'
  action :create
end

# Create profile database frame
#   Not planning on having it filled all the time, but it will allow us to have a profile db ready
#   when analytics wants to look at it
jmh_db_database node['jmh_myjmh']['db']['database'] do
  database node['jmh_myjmh']['db']['database']
  action :create
end

# Create DB Users who will connect
analytics_bag['admin_users'].each do |admin_user|
  jmh_db_mysql_local_user admin_user['name'] do
    username admin_user['name']
    password admin_user['mysql_password_hash']
    database '*'
    privileges [:all]
    host_connection admin_user['hostname']
    action admin_user['action']
  end
end

analytics_bag['db_users'].each do |db_user|
  jmh_db_mysql_local_user db_user['name'] do
    username db_user['name']
    password db_user['mysql_password_hash']
    database node['jmh_operations']['analytics']['db']['database']
    privileges [:select]
    host_connection db_user['hostname']
    action db_user['action']
  end
  # What we do for a workaround since we dont have any automation with someone having access to more than one
  #  db.  We just assume their access to the profile db for now.
  ruby_block "Add access to profile db" do
    block do
      @mysql_client = Mysql2::Client.new(
          :host => '127.0.0.1',
          :username => 'root',
          :password => node['mysql']['server_root_password']
      )
      grant_additional_statement = "GRANT ALL on #{node['jmh_myjmh']['db']['database']}.* to '#{db_user['name']}'@'#{db_user['hostname']}'"
      @mysql_client.query(grant_additional_statement)
    end
  end
end

# Create redwagon user
user node['jmh_operations']['analytics']['redwagon']['user'] do
  home File.join('/home', node['jmh_operations']['analytics']['redwagon']['user'])
  shell '/bin/bash'
  manage_home true
  action :create
end

directory File.join('/home', node['jmh_operations']['analytics']['redwagon']['user'], '.ssh') do
  owner node['jmh_operations']['analytics']['redwagon']['user']
  group node['jmh_operations']['analytics']['redwagon']['user']
  mode 0700
  action :create
end

redwagon_databag = Chef::EncryptedDataBagItem.load('credentials', 'redwagon')
file File.join('/home', node['jmh_operations']['analytics']['redwagon']['user'], '.ssh', 'authorized_keys') do
  content redwagon_databag['ssh_public_key']
  owner node['jmh_operations']['analytics']['redwagon']['user']
  group node['jmh_operations']['analytics']['redwagon']['user']
  mode 0600
  action :create
end

file File.join('/home', node['jmh_operations']['analytics']['redwagon']['user'], '.ssh', 'id_rsa') do
  content redwagon_databag['ssh_private_key']
  user node['jmh_operations']['analytics']['redwagon']['user']
  group node['jmh_operations']['analytics']['redwagon']['user']
  mode 0600
end

# Create redwagon drop location
directory node['jmh_operations']['analytics']['drop_location'] do
  action :create
end

script_dirs = [ "#{File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics')}",
                "#{File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics','scripts')}",
                "#{File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics','scripts','analytics_scripts')}"]

script_dir = File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics','scripts','analytics_scripts')

script_dirs.each do |s_dir|
  directory s_dir do
    owner node['jmh_operations']['analytics']['redwagon']['user']
    group node['jmh_server']['backup']['group']
    mode 0770
    action :create
  end
end

ruby_block 'chown_txt_files' do
  block do
    `cd #{File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics')}; chown redwagon *.txt`
  end
end

# Create global settings file
template File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics/scripts', 'global_settings.sh') do
  source 'analytics/global_settings_sh.erb'
  owner node['jmh_operations']['analytics']['redwagon']['user']
  group node['jmh_server']['backup']['group']
  mode 0660
  variables(
    :datadir => File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics'),
    :scriptdir => File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics', 'scripts', 'analytics_scripts'),
    :password => node['jmh_operations']['analytics']['db_password'],
    :db_user => node['jmh_operations']['analytics']['db_user']
  )
  action :create
end

template File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics/scripts/analytics_scripts', 'create_database.sql') do
  source 'analytics/create_database.sql.erb'
  owner node['jmh_operations']['analytics']['redwagon']['user']
  group node['jmh_server']['backup']['group']
  mode 0664
end

template File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics/scripts/analytics_scripts', 'load_mychart.sh') do
  source 'analytics/load_mychart.sh.erb'
  owner node['jmh_operations']['analytics']['redwagon']['user']
  group node['jmh_server']['backup']['group']
  mode 0775
end

include_recipe 'jmh-myjmh::myjmh_command'

salesforce_key = File.join('/home', node['jmh_operations']['analytics']['sftp_salesforce_user'],  '.ssh', node['jmh_operations']['analytics']['sftp_salesforce_id_rsa'])

# Script for Epic Activation Code Rundeck job
template File.join(script_dir, 'epic_email_gen.sh') do
  source 'analytics/epic_email_gen.sh.erb'
  mode '0755'
  user node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  variables(
    :emails => node['jmh_myjmh']['myjmh_command']['ac_emails'],
    :java_home => JmhJavaUtil.get_java_home(node['jmh_myjmh']['myjmh_command']['java_version'], node),
    :dbuser => node['jmh_operations']['analytics']['db_user'],
    :dbpassword => node['jmh_operations']['analytics']['db_password'],
    :install_dir => node['jmh_myjmh']['myjmh_command']['install_dir'],
    :ecrypt_dir => File.join(node['jmh_operations']['analytics']['drop_location'], 'analytics'),
    :properties_file => File.join(node['jmh_myjmh']['myjmh_command']['install_dir'], node['jmh_myjmh']['myjmh_command']['properties_file']),
    :salesforce_host => node['jmh_operations']['analytics']['sftp_salesforce_host'],
    :salesforce_user => node['jmh_operations']['analytics']['sftp_salesforce_user'],
    :ftp_user => node['jmh_operations']['analytics']['sftp_salesforce_remote_user'],
    :salesforce_key => salesforce_key
  )
  action :create
end

# add id_rsa private key
deploy_key_bag = Chef::EncryptedDataBagItem.load('deploy_keys', 'salesforce')

file salesforce_key do
  path salesforce_key
  content deploy_key_bag['deploy_key']
  owner node['jmh_operations']['analytics']['sftp_salesforce_user']
  group node['jmh_operations']['analytics']['sftp_salesforce_user']
  mode 0600
end