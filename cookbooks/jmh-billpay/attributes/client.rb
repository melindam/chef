default['jmh_billpay']['db']['database'] = 'billpay'
default['jmh_billpay']['db']['server'] = '127.0.0.1'
default['jmh_billpay']['db']['developer_user'] = 'billpay_dev'
default['jmh_billpay']['db']['developer_password'] = '!@#billpay!@#'

default['jmh_billpay']['client']['db']['username'] = 'billpay'
default['jmh_billpay']['client']['db']['bind_address'] = '0.0.0.0'
default['jmh_billpay']['client']['db']['local_recipe'] = 'jmh-billpay::db'
default['jmh_billpay']['client']['db']['node_query'] = 'roles:billpay-client OR recipe:jmh-billpay\:\:db OR recipes:jmh-billpay\:\:db'
default['jmh_billpay']['client']['db']['privileges'] = [:all]
default['jmh_billpay']['client']['db']['ssl'] = true
default['jmh_billpay']['client']['db']['connect_over_ssl'] = false

default['jmh_billpay']['client']['appserver']['name'] = 'billpay'
default['jmh_billpay']['client']['appserver']['enable_ssl'] = true
default['jmh_billpay']['client']['appserver']['enable_http'] = true
default['jmh_billpay']['client']['appserver']['app_server_type'] = 'tomcat'
default['jmh_billpay']['client']['appserver']['directories'] = %w(
            /usr/local/webapps/billpay
            /usr/local/webapps/billpay/import
            /usr/local/webapps/billpay/import/processed
            /usr/local/webapps/billpay/export
            /usr/local/webapps/billpay/export/archive
            /usr/local/webapps/billpay/ftp
          )
default['jmh_billpay']['client']['appserver']['port'] = 8084
default['jmh_billpay']['client']['appserver']['ajp_port'] = 8013
default['jmh_billpay']['client']['appserver']['ssl_port'] = 8448
default['jmh_billpay']['client']['appserver']['jmx_port'] = 6973
default['jmh_billpay']['client']['appserver']['shutdown_port'] = 8054
default['jmh_billpay']['client']['appserver']['iptables'] = {
            "8084" => {"target" =>"ACCEPT" },
            "8448" => {"target" => "ACCEPT"},
            "6973" => {"target" => "ACCEPT"} }
default['jmh_billpay']['client']['appserver']['max_heap_size'] = "256M"
# default['jmh_billpay']['client']['appserver']['max_permgen'] = ""
default['jmh_billpay']['client']['appserver']['thread_stack_size'] = "256K"
default['jmh_billpay']['client']['appserver']['java_version'] = "8"

default['jmh_billpay']['client']['gateway']['data_bag'] = 'jmh_apps'
default['jmh_billpay']['client']['gateway']['data_bag_item'] = 'trustcommerce-secure' 
