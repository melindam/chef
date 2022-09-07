default['jmh_billpay']['admin']['appserver']['name'] = 'billpay-admin'
default['jmh_billpay']['admin']['appserver']['enable_ssl'] = true
default['jmh_billpay']['admin']['appserver']['port'] = 8086
default['jmh_billpay']['admin']['appserver']['ajp_port'] = 8015
default['jmh_billpay']['admin']['appserver']['ssl_port'] = 8450
default['jmh_billpay']['admin']['appserver']['jmx_port'] = 6975
default['jmh_billpay']['admin']['appserver']['shutdown_port'] = 8056
default['jmh_billpay']['admin']['appserver']['iptables'] = {
            "8086" => {"target" =>"ACCEPT" },
            "8450" => {"target" => "ACCEPT"},
            "6975" => {"target" => "ACCEPT"} }
default['jmh_billpay']['admin']['appserver']['max_heap_size'] = "256M"
default['jmh_billpay']['admin']['appserver']['thread_stack_size'] = "256K"
default['jmh_billpay']['admin']['appserver']['java_version'] = "8"

default['jmh_billpay']['admin']['db']['node_query'] = 'roles:billpay-client OR recipe:jmh-billpay\:\:db OR recipes:jmh-billpay\:\:db'
# default['jmh_billpay']['admin']['db']['app_alias'] = 'billpay_client'
default['jmh_billpay']['admin']['db']['username'] = 'billpay-admin'
default['jmh_billpay']['admin']['db']['privileges'] = ['select']
default['jmh_billpay']['admin']['db']['connect_over_ssl'] = true