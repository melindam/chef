default['jmh_myjmh']['profile_client']['appserver']['enable_http'] = true
default['jmh_myjmh']['profile_client']['appserver']['enable_ssl'] = true
default['jmh_myjmh']['profile_client']['appserver']['app_server_type'] = 'tomcat'
default['jmh_myjmh']['profile_client']['appserver']['version'] = '9'
default['jmh_myjmh']['profile_client']['appserver']['port'] = 8097
default['jmh_myjmh']['profile_client']['appserver']['ssl_port'] = 8466
default['jmh_myjmh']['profile_client']['appserver']['jmx_port'] = 6985
default['jmh_myjmh']['profile_client']['appserver']['shutdown_port'] = 8065
default['jmh_myjmh']['profile_client']['appserver']['rollout_array'] = [{ 'bamboo_name' => 'profile-client', 'war_name' => 'profile-client' }]
default['jmh_myjmh']['profile_client']['appserver']['java_options'] = [" -Dcrowd.properties=#{node['jmh_tomcat']['target']}profile_client/conf/catalina.properties"]
default['jmh_myjmh']['profile_client']['appserver']['newrelic'] = false
default['jmh_myjmh']['profile_client']['appserver']['iptables'] =
    {
        node['jmh_myjmh']['profile_client']['appserver']['port']  => { 'target' => 'ACCEPT' },
        node['jmh_myjmh']['profile_client']['appserver']['ssl_port'] => { 'target' => 'ACCEPT' },
        node['jmh_myjmh']['profile_client']['appserver']['jmx_port'] => { 'target' => 'ACCEPT' }
    }
default['jmh_myjmh']['profile_client']['appserver']['java_version'] = '8'

default['jmh_myjmh']['profile_client']['tealium_env'] = node['jmh_server']['environment'] == 'prod' ? 'prod' : 'dev'
default['jmh_myjmh']['profile_client']['tealium_datasource'] = 'voue45'
default['jmh_myjmh']['profile_client']['properties'] = []
default['jmh_myjmh']['profile_client']['mychart_enabled'] = true

default['jmh_myjmh']['profile_client']['db']['username'] = 'profile_client'
default['jmh_myjmh']['profile_client']['db']['database'] = 'profile'
default['jmh_myjmh']['profile_client']['db']['local_recipe'] = 'jmh-myjmh::db'
default['jmh_myjmh']['profile_client']['db']['node_query'] = 'recipes:jmh-myjmh\:\:db'
default['jmh_myjmh']['profile_client']['db']['privileges'] = [:all]
default['jmh_myjmh']['profile_client']['db']['connect_over_ssl'] = true

default['jmh_myjmh']['profile_client']['db']['mrn_username'] = 'mrn_user'

default['jmh_myjmh']['profile_client']['profile_api_query'] = 'recipes:jmh-myjmh\\:\\:profile_api'

# Allows for on mychart instance over many development instances
default['jmh_myjmh']['profile_client']['enable_idp_redirects'] = false



