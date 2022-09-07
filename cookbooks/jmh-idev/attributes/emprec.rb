# DEPRECATED #
# in role => override['jmh_tomcat']['7']['version'] = '7.0.52'
default['jmh_idev']['appserver']['emprec']['enable_ssl'] = false
default['jmh_idev']['appserver']['emprec']['enable_http'] = true
default['jmh_idev']['appserver']['emprec']['name'] = 'emprec'
default['jmh_idev']['appserver']['emprec']['port'] = 8100
default['jmh_idev']['appserver']['emprec']['ajp_port'] = 8030
default['jmh_idev']['appserver']['emprec']['jmx_port'] = 6990
default['jmh_idev']['appserver']['emprec']['shutdown_port'] = 8070
default['jmh_idev']['appserver']['emprec']['version'] = '7'
default['jmh_idev']['appserver']['emprec']['iptables'] = { node['jmh_idev']['appserver']['emprec']['port'] => { 'target' => 'ACCEPT' },
                                                             node['jmh_idev']['appserver']['emprec']['jmx_port'] => { 'target' => 'ACCEPT' } }

default['jmh_idev']['appserver']['emprec']['java_version'] = '7'
default['jmh_idev']['appserver']['emprec']['rollout_array'] = [ 'bamboo_name' => 'emprec', 'war_name' => 'emprec' ]

default['jmh_idev']['emprec']['db']['name'] = 'emprec'
default['jmh_idev']['emprec']['db']['username'] = 'emprec'
default['jmh_idev']['emprec']['db']['privileges'] = [:all]
default['jmh_idev']['emprec']['db']['host_connections'] = '%'
