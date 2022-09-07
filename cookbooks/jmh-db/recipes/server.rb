include_recipe 'jmh-db::dependencies'

# package 'mysql-community-server' do
  # action :install
# end

# creates secure password if not already set.
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['mysql']['server_root_password'] = random_password unless node['mysql']['server_root_password']
node.normal['jmh_db']['monitor']['password'] = random_password unless node['jmh_db']['monitor']['password']

mysql_service node['jmh_db']['default_mysql_instance'] do
  bind_address node['mysql']['bind_address']
  version node['mysql']['version']
  data_dir node['mysql']['data_dir']
  service_manager node['jmh_db']['service_manager']
  initial_root_password node['mysql']['server_root_password']
  limit_no_file node['jmh_db']['5.7']['limit_no_file']
  tmp_dir node['jmh_db']['tmpdir']
  notifies :restart, 'mysql_service[default]', :delayed
  action [:create, :start]
end

directory File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_db']['data_dirpath']) do
  owner node['mysql']['user']
  group node['mysql']['user']
  mode 0770
  action :create
  only_if { node['recipes'].include?('jmh-encrypt::lukscrypt') }
end

include_recipe 'jmh-db::mysql_config'

# Drop the wildcard root
mysql_con_info = {:host => '127.0.0.1',
                  :username => 'root',
                  :password => node['mysql']['server_root_password'],
                  :default_file => node['jmh_db']['default_file']}
# mysql_database_user 'root' do
  # connection mysql_con_info
  # password node['mysql']['server_root_password']
  # host '%'
  # action :drop
# end

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.') if Chef::Config[:solo]
else
  search(:node, "chef_environment:#{node.environment} AND recipes:jmh-db*") do |n|
    ip_address = n['cloud'] ? n['cloud']['local_ipv4'] : n['ipaddress']
    unless ip_address.empty?
      mysql_database_user 'root' do
        connection mysql_con_info
        password node['mysql']['server_root_password']
        host ip_address
        require_ssl true
        action :grant
      end
      ruby_block "Grant Root Access to #{ip_address}" do
        block do
          client = Mysql2::Client.new(mysql_con_info)
          results = client.query("GRANT ALL on *.* to 'root'@'#{ip_address}' REQUIRE SSL WITH GRANT OPTION")
        end
      end
    else
       Chef::Log.warn("**I skipped this host for root #{n.to_s}. Hopefully this is a Kitchen Server!")
    end
  end
end

# Create System Monitor User
# Make SQL connection for local sensu to use
jmh_db_mysql_local_user "Mysql Maintenance User" do
  username node['jmh_db']['monitor']['user']
  database 'mysql'
  password node['jmh_db']['monitor']['password']
  host_connection '127.0.0.1'
  privileges node['jmh_db']['monitor']['mysqldb_permissions']
  global_privileges node['jmh_db']['monitor']['global_permissions']
end

# if the /etc/init.d/mysqld script is there then remove and disable for upgrade purposes
execute 'turn off mysqld' do
  command 'chkconfig mysqld off'
  action :run
  only_if { ::File.exist?('/etc/init.d/mysqld') }
end

ruby_block 'mysql_upgrade' do
  block do
    system("/usr/bin/mysql_upgrade -h 127.0.0.1 -u root -p#{node['mysql']['server_root_password']}")
    return_code = $?.exitstatus
    unless  [0,2].include?(return_code)
      Chef::Application.fatal!("mysql_upgrade returned with a bad error code:#{return_code}")
    end
  end
  action node['jmh_db']['run_mysql_upgrade'] ? :run : :nothing
end

include_recipe "jmh-db::watch_scripts"
