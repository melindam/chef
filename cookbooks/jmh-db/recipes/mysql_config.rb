# need to create a service for times when there is not mysql server and just a client
service 'mysql_jmh_db' do
  service_name 'mysql-default'
  action :nothing
end

# Sets default database parameters
mysql_config 'my-cnf-jmh' do
  source 'my_cnf_defaults.erb'
  cookbook 'jmh-db'
  instance node['jmh_db']['default_mysql_instance']
  variables(
    default_storage_engine: node['jmh_db']['default_storage_engine'],
    innodb_log_file_size: node['jmh_db']['5.7']['innodb_log_file_size'],
    max_allowed_packet: node['jmh_db']['5.7']['max_allowed_packet'],
    collation_server: node['jmh_db']['5.7']['collation-server'],
    mysql_version: node['mysql']['version'],
    sql_mode: node['jmh_db']['5.7']['sql_mode'],
    max_connections: node['jmh_db']['5.7']['max_connections'],
    innodb_lru_scan_depth: node['jmh_db']['5.7']['innodb_lru_scan_depth'],
    slow_query_log: node['jmh_db']['slow_query_log'],
    long_query_time: node['jmh_db']['long_query_time'],
    slow_query_log_file: node['jmh_db']['slow_query_log_file']
  )
  action :create
  notifies node['recipes'].include?('jmh-db::server') ? :restart : :nothing, 'service[mysql_jmh_db]', :immediately
end

directory node['jmh_db']['mysql_share_dir'] do
  user node['mysql']['user']
  group node['jmh_server']['backup']['group']
  mode 0750
  action :create
end

file node['jmh_db']['slow_query_log_file'] do
  user node['mysql']['user']
  group node['jmh_server']['backup']['group']
  mode 0640
  action :create
  notifies node['recipes'].include?('jmh-db::server') ? :restart : :nothing, 'service[mysql_jmh_db]', :immediately
end

logrotate_app "mysql-#{node['jmh_db']['default_mysql_instance']}" do
  cookbook 'logrotate'
  path node['jmh_db']['slow_query_log_file']
  frequency 'weekly'
  rotate 8
  options %w(compress delaycompress nodateext missingok copytruncate)
end

# Sets default database types to be UTF8
mysql_config 'utf8-server' do
  source 'mysql.cnf.erb'
  cookbook 'jmh-db'
  instance node['jmh_db']['default_mysql_instance']
  variables(
    :config => { 'character_set_server' => 'utf8'
    }
  )
  notifies node['recipes'].include?('jmh-db::server') ? :restart : :nothing, 'service[mysql_jmh_db]', :immediately
  action :create
end

# Set SSL
bag = Chef::EncryptedDataBagItem.load(node['mysql']['ssl']['data_bag'], node['mysql']['ssl']['data_bag_item']).to_hash

directory node['mysql']['ssl']['directory'] do
  recursive true
  mode 0700
  owner node['mysql']['user']
  group node['mysql']['user']
  action :create
end

bag.each do |filename, filecontent|
  next unless filename != 'id'
  file File.join(node['mysql']['ssl']['directory'], "#{filename}.pem") do
    content filecontent
    owner node['mysql']['user']
    group node['mysql']['user']
    mode 0600
    action :create
    notifies node['recipes'].include?('jmh-db::server') ? :restart : :nothing, 'service[mysql_jmh_db]', :delayed
  end
end

sslcfg = { 'ssl-capath' => node['mysql']['ssl']['directory'],
           'ssl-ca' => File.join(node['mysql']['ssl']['directory'], 'ca-cert.pem'),
           'ssl-cert' => File.join(node['mysql']['ssl']['directory'], 'server-cert.pem'),
           'ssl-key' => File.join(node['mysql']['ssl']['directory'], 'server-key.pem') }

mysql_config 'ssl-server' do
  source 'mysql.cnf.erb'
  cookbook 'jmh-db'
  instance node['jmh_db']['default_mysql_instance']
  variables(
    :config => sslcfg
  )
  notifies node['recipes'].include?('jmh-db::server') ? :restart : :nothing, 'service[mysql_jmh_db]', :immediately
  action :create
end

sslcfgclient = { 'ssl-ca' => File.join(node['mysql']['ssl']['directory'], 'ca-cert.pem'),
                 'ssl-cert' => File.join(node['mysql']['ssl']['directory'], 'client-cert.pem'),
                 'ssl-key' => File.join(node['mysql']['ssl']['directory'], 'client-key.pem') }

mysql_config 'ssl-client' do
  source 'mysql_client.cnf.erb'
  cookbook 'jmh-db'
  instance node['jmh_db']['default_mysql_instance']
  variables(
    :config => sslcfgclient
  )
  ## Restart not needed because only for client calls
  action :create
end

file node['jmh_db']['default_file'] do
  content '!includedir /etc/mysql-default/conf.d
          '
  owner node['mysql']['user']
  group node['mysql']['user']
  action :create
  not_if {node['recipes'].include?('jmh-db::server')}
end

# just makes life easy for making local calls from the command line
link "/root/.my.cnf" do
  link_type :symbolic
  to node['jmh_db']['default_file']
  action :create
end