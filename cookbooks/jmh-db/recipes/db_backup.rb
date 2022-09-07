# Create the database backup service used by all db systems
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

# make sure jmhbackup has been created
include_recipe 'jmh-server::jmhbackup'

package 'rsync'

# create mysqlbackup dir

# IF lukscrypt is present, it means there is an encrypted folder to use instead
if node['recipes'].include?('jmh-encrypt::lukscrypt')
    if ::File.exist?(File.join(node['jmh_server']['backup']['home'], node['jmh_db']['backup']['base_dir']))
      backup_dir = ::File.new(::File.join(node['jmh_server']['backup']['home'], node['jmh_db']['backup']['base_dir']))
      unless ::File.symlink?(backup_dir)
        FileUtils.mv File.join(node['jmh_server']['backup']['home'], node['jmh_db']['backup']['base_dir']),
                     File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_db']['backup']['base_dir'])
      end
    end

    directory File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'],  node['jmh_db']['backup']['base_dir']) do
      owner node['jmh_server']['backup']['username']
      group node['jmh_server']['backup']['group']
      mode '2740'
      action :create
    end

    link File.join(node['jmh_server']['backup']['home'], node['jmh_db']['backup']['base_dir']) do
      to File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_db']['backup']['base_dir'])
      action :create
    end

else
  directory File.join(node['jmh_server']['backup']['home'], node['jmh_db']['backup']['base_dir']) do
    owner node['jmh_server']['backup']['username']
    group node['jmh_server']['backup']['group']
    mode 00755
    action :create
  end
end

# Create a hash to store our connection information
mysql_con_info = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

node.normal['jmh_db']['backup']['password'] = random_password unless node['jmh_db']['backup']['password']

# LWRP provided by the database cookbook to create a mysql user
#  privileges ['SELECT','LOCK TABLES','EVENT']
mysql_database_user node['jmh_db']['backup']['username'] do
  connection mysql_con_info
  username node['jmh_db']['backup']['username']
  password node['jmh_db']['backup']['password']
  host 'localhost'
  privileges node['platform_version'].start_with?('5.') ? ['SELECT', 'LOCK TABLES'] : ['SELECT', 'LOCK TABLES', 'EVENT']
  action :grant
end

# put template into place
directory '/root/bin for db_backup' do
  path '/root/bin'
  owner 'root'
  group 'root'
  mode 0700
  action :create
end

template node['jmh_db']['backup']['backup_script'] do
  source 'backup_mysql.erb'
  mode 0700
  owner 'root'
  group 'root'
end

cron 'backup_mysql' do
  minute node['jmh_db']['backup']['minute_interval']
  hour node['jmh_db']['backup']['hour_interval']
  day node['jmh_db']['backup']['day_interval']
  weekday node['jmh_db']['backup']['weekday_interval']
  command '/root/bin/backup_mysql.sh > /root/backup_mysql.log 2>&1'
  user 'root'
  action :create
end
