default['jmh_prereg']['admin']['appserver']['name'] = 'prereg-admin'
default['jmh_prereg']['admin']['appserver']['app_server_type'] = 'tomcat'   
default['jmh_prereg']['admin']['appserver']['directories'] = %w(/usr/local/webapps/preregistration /usr/local/webapps/preregistration/indexes /usr/local/webapps/prereg-admin /usr/local/webapps/prereg-admin/indexes)
default['jmh_prereg']['admin']['appserver']['port'] = 8082
default['jmh_prereg']['admin']['appserver']['ssl_port'] = 8445
default['jmh_prereg']['admin']['appserver']['jmx_port'] = 6971
default['jmh_prereg']['admin']['appserver']['shutdown_port'] = 8052
default['jmh_prereg']['admin']['appserver']['iptables'] = { 
            "8082" => {"target" =>"ACCEPT" }, 
            "8445" => {"target" => "ACCEPT"},
            "6971" => {"target" => "ACCEPT"} }
default['jmh_prereg']['admin']['appserver']['max_heap_size'] = "288M"
default['jmh_prereg']['admin']['appserver']['thread_stack_size'] = "228K"
default['jmh_prereg']['admin']['appserver']['java_version'] = "8"
default['jmh_prereg']['admin']['appserver']['version'] = '9'
default['jmh_prereg']['admin']['appserver']['exec_start_pre'] = '-/bin/rm -R /usr/local/webapps/prereg-admin/indexes/'

default['jmh_prereg']['admin']['db']['node_query'] = 'recipes:jmh-prereg\:\:db OR recipe:jmh-prereg\:\:db'
default['jmh_prereg']['admin']['db']['app_alias'] = 'prereg_client'
default['jmh_prereg']['admin']['db']['username'] = 'preregadmin'
default['jmh_prereg']['admin']['db']['connect_over_ssl'] = true
