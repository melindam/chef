# in role => override['jmh_tomcat']['7']['version'] = '7.0.52'
default['jmh_idev']['appserver']['sbo']['enable_ssl'] = false
default['jmh_idev']['appserver']['sbo']['enable_http'] = true
default['jmh_idev']['appserver']['sbo']['name'] = 'sbo'
default['jmh_idev']['appserver']['sbo']['port'] = 8103
default['jmh_idev']['appserver']['sbo']['jmx_port'] = 6993
default['jmh_idev']['appserver']['sbo']['shutdown_port'] = 8073
default['jmh_idev']['appserver']['sbo']['version'] = '7'
default['jmh_idev']['appserver']['sbo']['iptables'] = { node['jmh_idev']['appserver']['sbo']['port'] => { 'target' => 'ACCEPT' },
                                                             node['jmh_idev']['appserver']['sbo']['jmx_port'] => { 'target' => 'ACCEPT' } }

default['jmh_idev']['appserver']['sbo']['java_version'] = '7'
default['jmh_idev']['appserver']['sbo']['rollout_array'] = [ 'bamboo_name' => 'sbo', 'war_name' => 'sbo' ]

