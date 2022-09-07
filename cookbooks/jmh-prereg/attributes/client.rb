default['jmh_prereg']['client']['appserver']['name'] = 'preregistration'
default['jmh_prereg']['client']['appserver']['app_server_type'] = "tomcat"
default['jmh_prereg']['client']['appserver']['directories'] = %w(/usr/local/webapps/preregistration /usr/local/webapps/preregistration/indexes)
default['jmh_prereg']['client']['appserver']['port'] = 8081
default['jmh_prereg']['client']['appserver']['ssl_port'] = 8444
default['jmh_prereg']['client']['appserver']['jmx_port'] = 6970
default['jmh_prereg']['client']['appserver']['shutdown_port'] = 8051
default['jmh_prereg']['client']['appserver']['iptables'] = {
            "8081" => {"target" =>"ACCEPT" },
            "8444" => {"target" => "ACCEPT"},
            "6970" => {"target" => "ACCEPT"} }
default['jmh_prereg']['client']['appserver']['max_heap_size'] = "256M"
default['jmh_prereg']['client']['appserver']['thread_stack_size'] = "228K"
default['jmh_prereg']['client']['appserver']['java_version'] = "8"
default['jmh_prereg']['client']['appserver']['exec_start_pre'] = '/bin/sleep 10'
default['jmh_prereg']['client']['appserver']['version'] = '9'
default['jmh_prereg']['client']['appserver']['mysql_j_version'] = '5.1.46'
default['jmh_prereg']['client']['appserver']['exec_start_pre'] = '-/bin/rm -R /usr/local/webapps/preregistration/indexes/'

default['jmh_prereg']['client']['database'] = "preregistration"
default['jmh_prereg']['client']['db']['username'] = "preregconsumer"
default['jmh_prereg']['client']['db']['bind_address'] = "0.0.0.0"
default['jmh_prereg']['client']['db']['privileges'] = [:all]
default['jmh_prereg']['client']['db']['ssl'] = true
default['jmh_prereg']['client']['db']['connect_over_ssl'] = false
default['jmh_prereg']['client']['db']['node_query'] = 'recipe:jmh-prereg\:\:db OR recipes:jmh-prereg\:\:db'
default['jmh_prereg']['client']['db']['local_recipe'] = 'jmh-prereg::db'

default['jmh_prereg']['db']['developer_user'] = 'prereg_dev'
default['jmh_prereg']['db']['developer_password'] = '!@#prereg!@#'

default['jmh_prereg']['client']['myjmh_services']['node_query'] = 'recipes:jmh-myjmh\:\:services OR recipe:jmh-myjmh\:\:services'
default['jmh_prereg']['client_recipe'] = 'recipes:jmh-prereg\:\:client'
default['jmh_prereg']['prod_env'] = 'arprod'
default['jmh_prereg']['data_bag'] = 'jmh_apps'
default['jmh_prereg']['data_bag_item'] = 'preregistration'


