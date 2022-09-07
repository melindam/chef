# in role => override['jmh_tomcat']['7']['version'] = '7.0.52'
default['jmh_idev']['appserver']['comhub']['enable_ssl'] = false
default['jmh_idev']['appserver']['comhub']['enable_http'] = true
default['jmh_idev']['appserver']['comhub']['name'] = 'comhub'
default['jmh_idev']['appserver']['comhub']['port'] = 8101
default['jmh_idev']['appserver']['comhub']['ajp_port'] = 8031
default['jmh_idev']['appserver']['comhub']['jmx_port'] = 6991
default['jmh_idev']['appserver']['comhub']['shutdown_port'] = 8071
default['jmh_idev']['appserver']['comhub']['version'] = '7'
default['jmh_idev']['appserver']['comhub']['iptables'] = { node['jmh_idev']['appserver']['comhub']['port'] => { 'target' => 'ACCEPT' },
                                                             node['jmh_idev']['appserver']['comhub']['jmx_port'] => { 'target' => 'ACCEPT' } }

default['jmh_idev']['appserver']['comhub']['java_version'] = '7'
default['jmh_idev']['appserver']['comhub']['rollout_array'] = [ 'bamboo_name' => 'comhub', 'war_name' => 'comhub' ]

default['jmh_idev']['comhub']['rec_directories'] = %w(/usr/local/jmh/ /usr/local/jmh/webapps /usr/local/jmh/webapps/hsysnas1)
default['jmh_idev']['comhub']['nas_mount_dir'] = '/usr/local/jmh/webapps/hsysnas1/DIAPPS'

# This will be a MongoDB
default['jmh_idev']['comhub']['mongo_db']['name'] = 'comhub'
default['jmh_idev']['comhub']['mongo_db']['username'] = 'comhub'
default['jmh_idev']['comhub']['mongo_db']['privileges'] = [:all]

default['jmh_idev']['comhub']['mongo_db']['username_dev'] = 'comhub_dev'
default['jmh_idev']['comhub']['mongo_db']['password_dev'] = '!@#comhub!@#'