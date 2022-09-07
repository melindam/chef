default['mysql']['version'] = '5.7'

default['mysql']['bind_address'] = '127.0.0.1'
default['jmh_db']['data_dirpath'] = 'mysql'
default['jmh_db']['default_mysql_instance'] = 'default'
default['jmh_db']['default_config_dir'] = '/etc/mysql-default'
default['jmh_db']['log_dir'] = "/var/log/mysql-#{node['jmh_db']['default_mysql_instance']}"
default['jmh_db']['default_file'] = File.join(node['jmh_db']['default_config_dir'],'my.cnf')
default['jmh_db']['run_mysql_upgrade'] = true

default['mysql']['data_dir'] = if node['recipes'].include?('jmh-encrypt::lukscrypt')
                                 File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_db']['data_dirpath'], 'data')
                               else
                                 '/var/lib/mysql'
                               end
default['mysql']['user'] = 'mysql'

default['jmh_db']['mysql_7_repo'] = 'http://repo.mysql.com/mysql57-community-release-el7-11.noarch.rpm'

default['jmh_db']['default_storage_engine'] = 'MyISAM'
default['jmh_db']['5.7']['innodb_log_file_size'] = '64MB'
default['jmh_db']['5.7']['max_allowed_packet'] = '16MB'
default['jmh_db']['5.7']['sql_mode'] = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
default['jmh_db']['5.7']['max_connections'] = 800
default['jmh_db']['5.7']['limit_no_file'] = 20000
default['jmh_db']['5.7']['innodb_lru_scan_depth'] = 256
default['jmh_db']['slow_query_log'] =  'on'
default['jmh_db']['long_query_time'] = 10
default['jmh_db']['mysql_share_dir'] = '/var/log/mysql-share'
default['jmh_db']['slow_query_log_file'] = File.join(node['jmh_db']['mysql_share_dir'],'slow_queries.log')

default['jmh_db']['dependencies'] = %w(gcc mysql-community-devel)

default['jmh_db']['service_manager'] = node['platform_version'].start_with?('7.') ? 'systemd' : 'auto'
default['jmh_db']['monitor']['user'] = 'mysqlmonitor'
default['jmh_db']['monitor']['mysqldb_permissions'] = ['select']
default['jmh_db']['monitor']['global_permissions'] = ['process']

default['mysql']['ssl']['directory'] = File.join(node['jmh_db']['default_config_dir'],'ssl')
default['mysql']['ssl']['data_bag'] = 'mysql'
default['mysql']['ssl']['data_bag_item'] = 'cert'

default['jmh_db']['mysql2_gem']['version'] = '0.4.5'
default['jmh_db']['tmpdir'] = '/tmp'

default['jmh_db']['backup']['username'] = 'jmhbackup'
default['jmh_db']['backup']['password'] = nil
default['jmh_db']['backup']['base_dir'] = 'mysqlbackup'
default['jmh_db']['backup']['minute_interval'] = '0'
default['jmh_db']['backup']['hour_interval'] = '*/3'
default['jmh_db']['backup']['day_interval'] = '*'
default['jmh_db']['backup']['weekday_interval'] = '*'
default['jmh_db']['backup']['expiration'] = '+15'

default['jmh_db']['backup']['backup_script'] = '/root/bin/backup_mysql.sh'

default['jmh_db']['watch_script']['name'] = '/root/bin/check_threads.sh'
default['jmh_db']['watch_script']['log'] = '/root/mysql_check.log'
default['jmh_db']['watch_script']['ruby_script'] = '/root/bin/check_mysql_processlist.rb'
default['jmh_db']['watch_script']['enable'] = true
default['jmh_db']['watch_script']['cron_minutes'] = '*/2'
default['jmh_db']['watch_script']['connection_limit'] = 120
default['jmh_db']['watch_script']['email_addresses'] = 'melinda.moran@johnmuirhealth.com'