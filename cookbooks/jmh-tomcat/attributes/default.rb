default['jmh_tomcat']['tomcat9'] = false
default['jmh_tomcat']['default_version'] = '7'

default['jmh_tomcat']['mysql_j_default_version'] = '8.0.12'
default['jmh_tomcat']['mysql_j_hash'] = { '5.1.46': 'https://s3-us-west-1.amazonaws.com/jmhpublic/java/mysql-connector-java-5.1.46.tar.gz',
                                          '8.0.12': 'https://s3-us-west-1.amazonaws.com/jmhpublic/java/mysql-connector-java-8.0.12.tar.gz'}

default['jmh_tomcat']['7']['version'] = '7.0.93'
default['jmh_tomcat']['7']['mysql_j_version'] = '5.1.46'

default['jmh_tomcat']['9']['version'] =  '9.0.41'
default['jmh_tomcat']['9']['mysql_j_version'] = node['jmh_tomcat']['mysql_j_default_version']

# default['jmh_tomcat']['download_url'] = "http://archive.apache.org/dist/tomcat/tomcat-#{node['jmh_tomcat']['version'][0,1]}"
default['jmh_tomcat']['download_url'] = "https://archive.apache.org/dist/tomcat"
default['jmh_tomcat']['user'] = 'tomcat'
default['jmh_tomcat']['group'] = 'tomcat'
default['jmh_tomcat']['target'] = '/usr/local/tomcat/'
default['jmh_tomcat']['local'] = '/usr/local'
default['jmh_tomcat']['port'] = 8080
default['jmh_tomcat']['ssl_port'] = 8443
default['jmh_tomcat']['shutdown_port'] = 8005
default['jmh_tomcat']['restart_on_config_change'] = true
default['jmh_tomcat']['max_http_header_size'] = node['jmh_server']['global']['max_header_size'] ? node['jmh_server']['global']['max_header_size'] : '8192'

default['jmh_tomcat']['java_options'] = ['-server -Djava.awt.headless=true -Duser.timezone=America/Los_Angeles']
default['jmh_tomcat']['use_security_manager'] = 'no'

default['jmh_tomcat']['manager_available'] = false

default['jmh_tomcat']['run_as_daemon'] = false
default['jmh_tomcat']['app_name'] = nil

default['jmh_tomcat']['ssl']['cert_folder'] = "/home/#{node['jmh_tomcat']['user']}/ssl"
default['jmh_tomcat']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_tomcat']['ssl']['data_bag_item'] = 'jmh_internal_cert_2024'

default['jmh_tomcat']['base'] = node['jmh_tomcat']['target']
default['jmh_tomcat']['home'] = node['jmh_tomcat']['target']
default['jmh_tomcat']['webapps_dir'] = 'webapps'

default['jmh_tomcat']['config_dir'] = File.join(node['jmh_tomcat']['base'], 'config')
default['jmh_tomcat']['log_dir'] = File.join(node['jmh_tomcat']['base'], 'logs')
default['jmh_tomcat']['keep_days_of_logs'] = 30

default['jmh_tomcat']['newrelic']['base_url'] = 'https://s3-us-west-1.amazonaws.com/jmhpublic/java'
default['jmh_tomcat']['newrelic']['agent'] = 'newrelic-java-4.2.0.zip'
default['jmh_tomcat']['newrelic']['license_key'] = 'b8248540110d9562d9623ffeb355f6874b372318'

default['jmh_tomcat']['singleton']['name'] = 'default'
default['jmh_tomcat']['singleton']['enable_http'] = true
default['jmh_tomcat']['singleton']['enable_ssl'] = false
default['jmh_tomcat']['singleton']['port'] = 8080
default['jmh_tomcat']['singleton']['ssl_port'] = 8443
default['jmh_tomcat']['singleton']['jmx_port'] = 6969
default['jmh_tomcat']['singleton']['iptables'] = { '8443' => { 'target' => 'REJECT' },
                                                   '8080' => { 'target' => 'ACCEPT' } }
default['jmh_tomcat']['singleton']['catalina_properties'] = ['# Chef Default catalina properties']
