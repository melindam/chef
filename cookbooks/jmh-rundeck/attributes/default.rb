default['jmh_rundeck']['version'] = "3.3"

default['rundeck']['configdir'] = '/etc/rundeck'
default['rundeck']['basedir'] = '/var/lib/rundeck'
default['rundeck']['datadir'] = '/var/lib/rundeck'
default['rundeck']['tempdir'] = '/tmp/rundeck'
default['rundeck']['user'] = 'rundeck'
default['rundeck']['group'] = 'rundeck'
default['rundeck']['user_home'] = '/home/rundeck'
default['rundeck']['rpm']['version'] = 'rundeck-3.3.10.20210301-1.noarch'

default['rundeck']['rpm']['repo']['url'] = 'https://dl.bintray.com/rundeck/rundeck-rpm'
default['rundeck']['rpm']['repo']['gpgkey'] = 'http://rundeck.org/keys/BUILD-GPG-KEY-Rundeck.org.key'
default['rundeck']['rpm']['repo']['gpgcheck'] = true
default['rundeck']['secret_file'] = '/etc/chef/encrypted_data_bag_secret'
default['rundeck']['hostname'] = 'rundeck.johnmuirhealth.com'
default['rundeck']['rdbms']['enable'] = true
default['rundeck']['rdbms']['type'] = 'mysql'
default['rundeck']['rdbms']['location'] = 'localhost'
default['rundeck']['rdbms']['dbname'] = 'rundeck'
default['rundeck']['rdbms']['dbuser'] = 'rundeck'
default['rundeck']['rdbms']['privileges'] = ['ALL']
default['rundeck']['rdbms']['dialect'] = 'Oracle10gDialect'
default['rundeck']['rdbms']['port'] = '3306'
default['rundeck']['restart_on_config_change'] = true
default['rundeck']['mail']['enable'] = true
default['rundeck']['mail']['host'] = 'localhost'
default['rundeck']['mail']['port'] = 25
default['rundeck']['email'] = 'rundeck-donotreply@johnmuirhealth.net'
default['rundeck']['custom_jvm_properties'] = '-Djava.net.preferIPv4Stack=true'
default['rundeck']['apache-template']['cookbook'] = 'jmh-rundeck'
default['rundeck']['grails_port'] = 80
default['rundeck']['log_dir'] = File.join(node['rundeck']['basedir'],'logs')
default['rundeck']['datadir'] = '/var/lib/rundeck'
default['rundeck']['rundeck_databag'] = 'rundeck'
default['rundeck']['rundeck_projects_databag'] = 'rundeck_projects'
default['rundeck']['rundeck_databag_users'] = 'users'
default['rundeck']['rundeck_projects_databag'] = node['rundeck']['rundeck_databag']
default['rundeck']['data_bag']['rdbms'] = node['rundeck']['rundeck_databag']
default['rundeck']['rundeck_databag_rdbms'] = 'secure'
default['rundeck']['rundeck_databag_secure'] = 'secure'

default['jmh_rundeck']['db']['ssl'] = false
default['jmh_rundeck']['db']['connect_over_ssl'] = false
default['jmh_rundeck']['java_version'] = '8'

default['jmh_rundeck']['remote_db']['events']['parent_role'] = 'apps01'
default['jmh_rundeck']['remote_db']['events']['database'] = 'events'
default['jmh_rundeck']['remote_db']['events']['parent_node_query'] = 'recipes:jmh-events\:\:db'
default['jmh_rundeck']['remote_db']['events']['app_alias'] = 'events'
default['jmh_rundeck']['remote_db']['events']['username'] = 'events_rundeck'
default['jmh_rundeck']['remote_db']['events']['privileges'] = ['SELECT']
default['jmh_rundeck']['remote_db']['events']['connect_over_ssl'] = false
default['jmh_rundeck']['remote_db']['events']['ssl'] = false

# default['jmh_rundeck']['http']['port'] = 80
# default['jmh_rundeck']['https']['port'] = 443

default['jmh_rundeck']['apache_name'] = 'rundeck'
default['jmh_rundeck']['http']['ip_address'] = '*'

default['jmh_rundeck']['http']['server_name'] = node['rundeck']['hostname']

default['jmh_rundeck']['http']['docroot'] = '/var/www/html'
default['jmh_rundeck']['http']['server_status'] = true
# default['jmh_rundeck']['http']['cond_rewrites'] =
#     { "^/(.*) https://#{node['jmh_rundeck']['apache']['server_name']}%{REQUEST_URI} [NC,L]" => ['%{HTTPS} off'] }
default['jmh_rundeck']['http']['port'] = 80
default['jmh_rundeck']['http']['error_log'] = 'logs/rundeck-error.log'
default['jmh_rundeck']['http']['custom_log'] = ['logs/rundeck-access.log combinedproxy']
default['jmh_rundeck']['http']['proxies'] = {"*": {"Require": "all granted"}}
default['jmh_rundeck']['http']['proxy_passes'] = { "/logs": "!",
                                                   "/icons": "!",
                                                   "/": "http://localhost:4440/"}
default['jmh_rundeck']['http']['proxy_pass_reverses'] = { "/": "http://localhost:4440/"}
default['jmh_rundeck']['http']['directories'] = {"/var/www/html/logs": {"Options": "+Indexes"}}

# default['jmh_rundeck']['https']['port'] = 443
# default['jmh_rundeck']['https']['proxy_requests'] = false
# default['jmh_rundeck']['https']['proxy_preserve_host'] = true
# default['jmh_rundeck']['https']['header_access_control'] = true
# default['jmh_rundeck']['https']['ssl_proxy_engine'] = 'on'
# default['jmh_rundeck']['https']['error_log'] = 'logs/api-error-ssl.log'
# default['jmh_rundeck']['https']['custom_log'] = ['logs/api-access-ssl.log combinedproxy']
# default['jmh_rundeck']['https']['ssl']['encrypted'] = true
# default['jmh_rundeck']['https']['ssl']['data_bag'] = 'apache_ssl'
# default['jmh_rundeck']['https']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
# default['jmh_rundeck']['https']['ssl']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.pem')
# default['jmh_rundeck']['https']['ssl']['ssl_key_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.key')
# default['jmh_rundeck']['https']['ssl']['ssl_chain_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.chain')
# default['jmh_rundeck']['https']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.pem')
# default['jmh_rundeck']['https']['ssl_key_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.key')
# default['jmh_rundeck']['https']['ssl_chain_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.chain')
# default['jmh_rundeck']['https']['ssl_protocol'] = node['jmh_rundeck']['apache']['ssl_protocol']
# default['jmh_rundeck']['https']['ssl_proxy_protocol'] = 'all +TLSv1.2 -SSLv2 -SSLv3'
# default['jmh_rundeck']['https']['cond_rewrites'] =
#     { "^(.*)$ /jmherror/pagenotfound.html [PT,L]":
#           [ "%{REQUEST_URI}   ^/vvisits/v1/sendReminders.*" ] }

default['jmh_rundeck']['ssh_keypath'] = File.join(node['rundeck']['user_home'], '/.ssh/id_rsa')

default['java']['install_flavor'] = 'oracle'
default['java']['oracle']['accept_oracle_download_terms'] = true

default['jmh_rundeck']['project_data_bag'] = node['rundeck']['rundeck_databag']

default['jmh_events']['report']['script_folder'] = '/var/lib/rundeck'
default['jmh_events']['report']['archive_password'] = '0bL1cZEQI0RrXlsHI'
default['jmh_events']['report']['report_folder'] =  '/var/www/html/logs'
default['jmh_events']['report']['rsa_file'] = '/var/lib/rundeck/.ssh/id_rsa'
default['jmh_events']['report']['email_address'] = 'melinda.moran@johnmuirhealth.com'
default['jmh_events']['report']['user'] = node['rundeck']['rdbms']['dbuser']
default['jmh_events']['report']['group'] = node['rundeck']['rdbms']['dbuser']

default['jmh_rundeck']['remote_db_password']['base_dir'] = node['jmh_events']['report']['script_folder']