# DEPRECATED #

override['jmh_idev']['appserver']['echo']['version'] = '9'
default['jmh_idev']['appserver']['echo']['enable_ssl'] = false
default['jmh_idev']['appserver']['echo']['enable_http'] = true
default['jmh_idev']['appserver']['echo']['name'] = 'echo'
default['jmh_idev']['appserver']['echo']['port'] = 8108
default['jmh_idev']['appserver']['echo']['ajp_port'] = 8038
default['jmh_idev']['appserver']['echo']['jmx_port'] = 6998
default['jmh_idev']['appserver']['echo']['shutdown_port'] = 8078
default['jmh_idev']['appserver']['echo']['iptables'] = { node['jmh_idev']['appserver']['echo']['port'] => { 'target' => 'ACCEPT' },
                                                             node['jmh_idev']['appserver']['echo']['jmx_port'] => { 'target' => 'ACCEPT' } }

default['jmh_idev']['appserver']['echo']['java_version'] = '8'
default['jmh_idev']['appserver']['echo']['rollout_array'] = [ 'bamboo_name' => 'echo', 'war_name' => 'echo' ]

