default['jmh_myjmh']['admin']['appserver']['enable_ssl'] = true
default['jmh_myjmh']['admin']['appserver']['enable_http'] = true
default['jmh_myjmh']['admin']['appserver']['app_server_type'] = 'tomcat'
default['jmh_myjmh']['admin']['appserver']['port'] = 8098
default['jmh_myjmh']['admin']['appserver']['ssl_port'] = 8467
default['jmh_myjmh']['admin']['appserver']['jmx_port'] = 6986
default['jmh_myjmh']['admin']['appserver']['shutdown_port'] = 8066

default['jmh_myjmh']['admin']['appserver']['iptables'] = {
    node['jmh_myjmh']['admin']['appserver']['port'] => { 'target' => 'ACCEPT' },
    node['jmh_myjmh']['admin']['appserver']['ssl_port'] => { 'target' => 'ACCEPT' },
    node['jmh_myjmh']['admin']['appserver']['jmx_port'] => { 'target' => 'ACCEPT' } }


default['jmh_myjmh']['admin']['appserver']['java_version'] = '8'
default['jmh_myjmh']['admin']['appserver']['tomcat_version'] = '9'
default['jmh_myjmh']['admin']['appserver']['max_heap_size'] = '256m'
default['jmh_myjmh']['admin']['appserver']['directories'] = %w(/usr/local/webapps/myjmh/keys)
default['jmh_myjmh']['admin']['appserver']['rollout_array'] = [{ 'bamboo_name' => 'myjmh-admin', 'war_name' => 'myjmh-admin' }]
default['jmh_myjmh']['admin']['appserver']['java_options'] = ["-Dcrypto.private.key.path=/usr/local/webapps/myjmh/keys/jmh_private_key.der " +
                                                              "-Dcrypto.public.key.path=/usr/local/webapps/myjmh/keys/jmh_public_key.der " +
                                                              "-Dcrowd.properties=#{node['jmh_tomcat']['target']}myjmh-admin/conf/catalina.properties"]

default['jmh_myjmh']['admin']['db']['username'] = 'myjmh_admin'
default['jmh_myjmh']['admin']['db']['database'] = 'profile'
default['jmh_myjmh']['admin']['db']['local_recipe'] = 'jmh-myjmh::db'
default['jmh_myjmh']['admin']['db']['node_query'] = 'recipes:jmh-myjmh\:\:db OR recipe:jmh-myjmh\:\:db'
default['jmh_myjmh']['admin']['db']['privileges'] = [:all]
default['jmh_myjmh']['admin']['db']['connect_over_ssl'] = true


