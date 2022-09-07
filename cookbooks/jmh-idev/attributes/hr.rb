# in role => override['jmh_tomcat']['7']['version'] = '7.0.52'
default['jmh_idev']['appserver']['hr']['enable_ssl'] = false
default['jmh_idev']['appserver']['hr']['enable_http'] = true
default['jmh_idev']['appserver']['hr']['name'] = 'hr'
default['jmh_idev']['appserver']['hr']['port'] = 8102
default['jmh_idev']['appserver']['hr']['ajp_port'] = 8032
default['jmh_idev']['appserver']['hr']['jmx_port'] = 6992
default['jmh_idev']['appserver']['hr']['shutdown_port'] = 8072
default['jmh_idev']['appserver']['hr']['version'] = '7'
default['jmh_idev']['appserver']['hr']['iptables'] = { node['jmh_idev']['appserver']['hr']['port'] => { 'target' => 'ACCEPT' },
                                                             node['jmh_idev']['appserver']['hr']['jmx_port'] => { 'target' => 'ACCEPT' } }

default['jmh_idev']['appserver']['hr']['java_version'] = '7'
default['jmh_idev']['appserver']['hr']['rollout_array'] = [ 'bamboo_name' => 'hr', 'war_name' => 'hr' ]

# This will be a MongoDB
default['jmh_idev']['hr']['mongo_db']['name'] = 'hr'
default['jmh_idev']['hr']['mongo_db']['username'] = 'hr'
default['jmh_idev']['hr']['mongo_db']['privileges'] = [:all]

default['jmh_idev']['hr']['mongo_db']['username_dev'] = 'hr_dev'
default['jmh_idev']['hr']['mongo_db']['password_dev'] = '!@#hr!@#'