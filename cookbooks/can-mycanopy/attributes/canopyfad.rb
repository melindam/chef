
# FAD Database
default['can_mycanopy']['fad']['db']['database'] = 'canopyfad'
default['can_mycanopy']['fad']['db']['user'] = 'canopyfad'
default['can_mycanopy']['fad']['db']['privileges'] = [:all]
default['can_mycanopy']['fad']['db']['developer_user'] = 'fad_dev'
default['can_mycanopy']['fad']['db']['developer_password'] = '!@#fad!@#'
default['can_mycanopy']['fad']['db']['connect_over_ssl'] = false

# Tomcat application
default['can_mycanopy']['tomcat']['appserver']['name'] = 'canopy-fad'
default['can_mycanopy']['tomcat']['appserver']['java_version'] = '8'
default['can_mycanopy']['tomcat']['appserver']['max_heap_size'] = '512M'
default['can_mycanopy']['tomcat']['appserver']['max_permgen'] = '128M'
default['can_mycanopy']['tomcat']['appserver']['port'] = 8096
default['can_mycanopy']['tomcat']['appserver']['jmx_port'] = 6986
default['can_mycanopy']['tomcat']['appserver']['ssl_port'] = 8466
default['can_mycanopy']['tomcat']['appserver']['ajp_port'] = 8026
default['can_mycanopy']['tomcat']['appserver']['shutdown_port'] = 8066
default['can_mycanopy']['tomcat']['appserver']['rollout_array'] = [{ 'bamboo_name' => 'canopy-fad', 'war_name' => 'canopy-fad', 'db_name' => 'canopyfad' }]
default['can_mycanopy']['tomcat']['appserver']['iptables'] =  {
                                                          '8096' => { 'target' => 'ACCEPT' },
                                                          '8466' => { 'target' => 'ACCEPT' },
                                                          '6986' => { 'target' => 'ACCEPT' } }
                                                          