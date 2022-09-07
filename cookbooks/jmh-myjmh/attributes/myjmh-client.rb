# DEPRECATED #

default['jmh_myjmh']['myjmh_client']['appserver']['enable_ssl'] = true
default['jmh_myjmh']['myjmh_client']['appserver']['enable_http'] = true
default['jmh_myjmh']['myjmh_client']['appserver']['version'] = '9'
default['jmh_myjmh']['myjmh_client']['appserver']['app_server_type'] = 'tomcat'
default['jmh_myjmh']['myjmh_client']['appserver']['port'] = 8098
default['jmh_myjmh']['myjmh_client']['appserver']['ajp_port'] = 8026
default['jmh_myjmh']['myjmh_client']['appserver']['ssl_port'] = 8467
default['jmh_myjmh']['myjmh_client']['appserver']['jmx_port'] = 6986
default['jmh_myjmh']['myjmh_client']['appserver']['shutdown_port'] = 8066
default['jmh_myjmh']['myjmh_client']['appserver']['rollout_array'] = [{ 'bamboo_name' => 'myjmh-client', 'war_name' => 'myjmh-client' }]
default['jmh_myjmh']['myjmh_client']['java_heap_dump_folder'] = '/data/jvm_dumps'
default['jmh_myjmh']['myjmh_client']['appserver']['iptables'] = {
    node['jmh_myjmh']['myjmh_client']['appserver']['port'] => { 'target' => 'ACCEPT' },
    node['jmh_myjmh']['myjmh_client']['appserver']['ssl_port'] => { 'target' => 'ACCEPT' },
    node['jmh_myjmh']['myjmh_client']['appserver']['jmx_port'] => { 'target' => 'ACCEPT' } }

default['jmh_myjmh']['myjmh_client']['appserver']['java_options'] = ["-Dcrowd.properties=#{node['jmh_tomcat']['target']}myjmh-client/conf/catalina.properties"]
default['jmh_myjmh']['myjmh_client']['appserver']['newrelic'] = false

default['jmh_myjmh']['client']['db']['username'] = 'myjmh_client'
default['jmh_myjmh']['client']['db']['database'] = 'profile'
default['jmh_myjmh']['client']['db']['local_recipe'] = 'jmh-myjmh::db'
default['jmh_myjmh']['client']['db']['node_query'] = 'recipes:jmh-myjmh\:\:db OR recipe:jmh-myjmh\:\:db'
default['jmh_myjmh']['client']['db']['privileges'] = [:all]
default['jmh_myjmh']['client']['db']['connect_over_ssl'] = true

default['jmh_myjmh']['myjmh_client']['enable_tcell'] = false
default['jmh_myjmh']['myjmh_client']['tcell_config'] = case
                                                 when node['jmh_server']['environment'] == 'prod'
                                                   { 'app_id' => 'myjmharprod-itWEl',
                                                     'api_key' => 'AQEBBAFjYLl_7m9N4Z9hjvDs5nw1kuDIPQtKTDKwJfO-58NaZriP7IGybjkMoIN4N7BSnJQ',
                                                     'allow_unencrypted_appsensor_payloads' => true,
                                                     'tcell_input_url' => 'https://input.tcell.io/api/v1',
                                                     'disable_axis2' => true
                                                   }
                                                 when node['jmh_server']['environment'] == 'stage'
                                                   { 'app_id' => 'myjmharstage-GhZQO',
                                                     'api_key' => 'AQEBBAFjYLl_7m9N4Z9hjvDs5nw1kuDIPQtKTDKwJfO-58NaZriP7IGybjkMoIN4N7BSnJQ',
                                                     'allow_unencrypted_appsensor_payloads' => true,
                                                     'tcell_input_url' => 'https://input.tcell.io/api/v1',
                                                     'disable_axis2' => true
                                                   }
                                                 when node['jmh_server']['environment'] == 'sbx'
                                                   { 'app_id' => 'myjmhawssbx-ZjO4y',
                                                     'api_key' => 'AQEBBAFjYLl_7m9N4Z9hjvDs5nw1kuDIPQtKTDKwJfO-58NaZriP7IGybjkMoIN4N7BSnJQ',
                                                     'allow_unencrypted_appsensor_payloads' => true,
                                                     'tcell_input_url' => 'https://input.tcell.io/api/v1',
                                                     'disable_axis2' => true
                                                   }
                                                 when node['jmh_server']['environment'] == 'dev'
                                                   { 'app_id' => 'myjmhawsdev-SXFPM',
                                                     'api_key' => 'AQEBBAFjYLl_7m9N4Z9hjvDs5nw1kuDIPQtKTDKwJfO-58NaZriP7IGybjkMoIN4N7BSnJQ',
                                                     'tcell_input_url' => 'https://input.tcell.io/api/v1',
                                                     'allow_unencrypted_appsensor_payloads' => true,
                                                     'disable_axis2' => true
                                                   }
                                                 else
                                                   { 'app_id' => 'noapp',
                                                     'api_key' => 'apikey',
                                                     'tcell_input_url' => 'https://saninput.tcell.io/api/v1',
                                                     'allow_unencrypted_appsensor_payloads' => true,
                                                     'hmac_key' => '4b748f0871dfedfa9d7f1fb4e90f064e',
                                                     'disable_axis2' => true,
                                                     'disable' => true
                                                   }
      end
default['jmh_myjmh']['myjmh_client']['appserver']['java_version'] = '8'
default['jmh_myjmh']['myjmh_client']['opinionlab_onentry'] = '100'
default['jmh_myjmh']['myjmh_client']['properties'] = []

default['jmh_myjmh']['myjmh_client']['appserver']['directories'] = ['/usr/local/webapps/myjmh',
                                                 '/usr/local/webapps/myjmh/images',
                                                 '/usr/local/webapps/myjmh/scripts',
                                                 '/usr/local/webapps/myjmh/import',
                                                 '/usr/local/webapps/myjmh/processed',
                                                 '/usr/local/webapps/myjmh/keys',
                                                 node['jmh_myjmh']['myjmh_client']['java_heap_dump_folder']]
default['jmh_myjmh']['scripts_dir'] = %w(/usr/local/webapps /usr/local/webapps/myjmh /usr/local/webapps/myjmh/scripts /usr/local/webapps/myjmh/import /usr/local/webapps/myjmh/processed)

default['jmh_myjmh']['myjmh_client']['db']['username'] = 'myjmh_clientv2'
default['jmh_myjmh']['myjmh_client']['db']['database'] = 'profile'
default['jmh_myjmh']['myjmh_client']['db']['local_recipe'] = 'jmh-myjmh::db'
default['jmh_myjmh']['myjmh_client']['db']['node_query'] = 'recipes:jmh-myjmh\:\:db OR recipe:jmh-myjmh\:\:db'
default['jmh_myjmh']['myjmh_client']['db']['privileges'] = [:all]
default['jmh_myjmh']['myjmh_client']['db']['connect_over_ssl'] = true

# Deprecated watch script.  Keeping it for historical review
default['jmh_myjmh']['myjmh_client']['watch_script']['email'] = 'melinda.moran@johnmuirhealth.com'
default['jmh_myjmh']['myjmh_client']['watch_script']['check_page'] = '/myjmh-client/login.jsp'
default['jmh_myjmh']['myjmh_client']['watch_script']['pid_dir'] = '/usr/local/tomcat/myjmh/bin'
default['jmh_myjmh']['myjmh_client']['watch_script']['pid_name'] = 'tomcat.pid'
default['jmh_myjmh']['myjmh_client']['watch_script']['restart_script'] = '/etc/init.d/myjmh'
default['jmh_myjmh']['myjmh_client']['watch_script']['username'] = 'superSunny123'
default['jmh_myjmh']['myjmh_client']['watch_script']['password'] = 'superSunny123'

default['jmh_myjmh']['myjmh_client']['epic']['identity_file'] = '/home/tomcat/.ssh/ebusiness_id_rsa'

default['jmh_myjmh']['myjmh_client']['oauth']['wellbe']['client_id'] =  case node['jmh_server']['environment']
                                                             when 'prod'
                                                               '0bb021ca4aea84f66b30a1cdd0e900755ea5ef9abb413edcb016b2fa00dab76d'
                                                             else
                                                               '3d7268c05a40cd52f6895674a6e90b52d0b5789850e49a24683cb1ff96c3df85'
                                                             end

default['jmh_myjmh']['myjmh_client']['oauth']['wellbe']['client_secret'] =  case node['jmh_server']['environment']
                                                             when 'prod'
                                                               'fa507a54ab3165636f38d1b5eba671af34581e6841ddbb9f350864ffbddf48d5'
                                                             else
                                                               '229a88801fe8a85b1d04ce03922fb47b53622c8ce4c0335bab8f7ae734f9f132'
                                                             end
default['jmh_myjmh']['myjmh_client']['oauth']['wellbe']['base_url'] =  case node['jmh_server']['environment']
                                                             when 'prod'
                                                               'https://careguides.wellbe.me'
                                                             when 'stage'
                                                               'https://experimental.wellbe.me'
                                                             else
                                                               'https://share.wellbe.me'
                                                             end

default['jmh_myjmh']['myjmh_client']['tealium']['env'] = case node['jmh_server']['environment']
                                                           when 'prod', 'stage'
                                                              'prod'
                                                           else
                                                              'dev'
                                                           end

default['jmh_myjmh']['myjmh_client']['tealium']['suite'] = case node['jmh_server']['environment']
                                                           when 'prod', 'stage'
                                                             'jmhprod2'
                                                           else
                                                             'jmhdev2'
                                                           end
