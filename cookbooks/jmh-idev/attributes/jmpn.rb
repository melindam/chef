# in role => override['jmh_tomcat']['7']['version'] = '7.0.52'
default['jmh_idev']['appserver']['jmpn']['enable_ssl'] = false
default['jmh_idev']['appserver']['jmpn']['enable_http'] = true
default['jmh_idev']['appserver']['jmpn']['name'] = 'jmpn'
default['jmh_idev']['appserver']['jmpn']['port'] = 8104
default['jmh_idev']['appserver']['jmpn']['jmx_port'] = 6994
default['jmh_idev']['appserver']['jmpn']['shutdown_port'] = 8074
default['jmh_idev']['appserver']['jmpn']['version'] = '7'
default['jmh_idev']['appserver']['jmpn']['iptables'] = { node['jmh_idev']['appserver']['jmpn']['port'] => { 'target' => 'ACCEPT' },
                                                             node['jmh_idev']['appserver']['jmpn']['jmx_port'] => { 'target' => 'ACCEPT' } }

default['jmh_idev']['appserver']['jmpn']['java_version'] = '7'
default['jmh_idev']['appserver']['jmpn']['rollout_array'] = [ 'bamboo_name' => 'jmpn', 'war_name' => 'jmpn' ]
default['jmh_idev']['appserver']['jmpn']['directories'] = %w( /usr/local/jmh
                                                            /usr/local/jmh/batch
                                                            /usr/local/jmh/batch/cap
                                                            /usr/local/jmh/batch/cap/data
                                                            /usr/local/jmh/jmpnweb
                                                            /usr/local/jmh/jmpnweb/capitationload
                                                            /usr/local/jmh/jmpnweb/capitationload/in
                                                            /usr/local/jmh/jmpnweb/epiceligibility
                                                            /usr/local/jmh/jmpnweb/epiceligibility/in
                                                            /usr/local/jmh/jmpnweb/epicreport
                                                            /usr/local/jmh/jmpnweb/epicreport/in
                                                            )

# default['jmh_idev']['jmpn']['db']['name'] = 'jmpn'
# default['jmh_idev']['jmpn']['db']['username'] = 'jmpn'
# default['jmh_idev']['jmpn']['db']['privileges'] = [:all]
# default['jmh_idev']['jmpn']['db']['host_connections'] = '%'
