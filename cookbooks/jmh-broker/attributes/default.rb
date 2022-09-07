default['jmh_broker']['activemq']['java_version'] = '8'

default['activemq']['simple_auth_user'] = 'broker_user'
default['activemq']['home']  = '/usr/local'
default['activemq']['usejmx'] = true
default['activemq']['java_home'] = JmhJavaUtil.get_java_home(node['jmh_broker']['activemq']['java_version'], node)
default['activemq']['version'] = '5.14.4'
default['activemq']['enable_amqp'] = true

default['jmh_broker']['jms_host'] = 'localhost'
default['jmh_broker']['jms_port'] = '61616'

default['jmh_broker']['db']['user_name'] = 'broker_client'
default['jmh_broker']['db']['parent_node_search'] = 'recipes:jmh-myjmh\:\:db'
default['jmh_broker']['db']['unless_recipe'] = 'jmh-myjmh::db'
default['jmh_broker']['db']['ssl'] = true
default['jmh_broker']['db']['jdbc_suffix'] = node['jmh_broker']['db']['ssl'] ? '?verifyServerCertificate=false&useSSL=true&requireSSL=true' : ''

default['jmh_broker']['appserver']['name'] = 'broker'
default['jmh_broker']['appserver']['enable_ssl'] = true
default['jmh_broker']['appserver']['enable_http'] = true
default['jmh_broker']['appserver']['port'] = 8092
default['jmh_broker']['appserver']['ajp_port'] = 8022
default['jmh_broker']['appserver']['ssl_port'] = 8462
default['jmh_broker']['appserver']['jmx_port'] = 6982
default['jmh_broker']['appserver']['shutdown_port'] = 8062
default['jmh_broker']['appserver']['iptables'] = {
  '8092' => { 'target' => 'ACCEPT' },
  '8462' => { 'target' => 'ACCEPT' },
  '6982' => { 'target' => 'ACCEPT' } }

default['jmh_broker']['appserver']['java_version'] = '8'
default['jmh_broker']['appserver']['directories'] = %w(/usr/local/webapps/broker)

default['jmh_broker']['keys_folder'] = '/usr/local/webapps/broker/keys'

default['jmh_broker']['cloverleaf_server'] = node['jmh_server']['environment'] == 'prod' ? 'cloverleaf' : 'cloverleafdev'
default['jmh_broker']['cloverleaf_port'] = case node['jmh_server']['environment']
                                           when 'prod'
                                             '9854'
                                           when 'stage'
                                             '7856'
                                           when 'dev'
                                             '7855'
                                           else
                                             '7854'
                                           end

default['jmh_broker']['emails'] = case node['jmh_server']['environment']
                                           when 'prod'
                                             'pamela.baterina@johnmuirhealth.com,corina.cooke@johnmuirhealth.com,michael.lawless@johnmuirhealth.com,melinda.moran@johnmuirhealth.com'
                                           else
                                             'mark.haney@johnmuirhealth.com,luminita.nagy@johnmuirhealth.com,andre.krichikov@johnmuirhealth.com'
                                           end

default['jmh_broker']['static_properties'] = ['email.default.from=noreply@johnmuirhealth.com',
                                              'email.port=25',
                                              'email.host=localhost',
                                              "emails.ops.to=#{node['jmh_broker']['emails']}"]
