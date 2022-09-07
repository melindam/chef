default['jmh_monitor']['sensugo']['version'] = "6.1.2-3565"
default['jmh_monitor']['sensugo']['agent_port'] = "8001"
default['jmh_monitor']['sensugo']['api_port'] = "8083"
default['jmh_monitor']['sensugo']['web_port'] = "3000"
default['jmh_monitor']['sensugo']['admin_user'] = "admin"
default['jmh_monitor']['sensugo']['admin_password'] = 'Just like the 0LD!'
default['jmh_monitor']['sensugo']['new_admin_password'] = node['jmh_monitor']['sensugo']['admin_password']
# default['jmh_monitor']['sensugo']['new_admin_password'] = 'scottmarshall'

default['jmh_monitor']['subscriptions_databag'] = ['sensu_checks','subscriptions']
default['jmh_monitor']['sensu_checks']['databag'] = 'sensu_checks'

default['sensugo']['user'] = 'sensu'
default['sensugo']['group'] = 'sensu'

default['jmh_monitor']['sensugo_server']['role'] = 'sensugo-aws'
default['jmh_monitor']['sensugo']['servername'] = 'sensugo-aws.johnmuirhealth.com'
default['jmh_monitor']['sensugo']['return_address'] = 'sensugo_server@johnmuirhealth.net'
default['jmh_monitor']['sensugo']['default_email_addresses'] = 'melinda.moran@johnmuirhealth.com'
default['jmh_monitor']['sensugo']['business_hour_start'] = 7
default['jmh_monitor']['sensugo']['business_hour_end'] = 19
default['jmh_monitor']['sensugo']['production_environment'] = ['arprod']
default['jmh_monitor']['sensugo']['assets'] = [ "sensu/sensu-email-handler",
                                                'sensu/sensu-ruby-runtime',
                                                "sensu/monitoring-plugins",
                                                'sensu/sensu-pagerduty-handler',
                                                'fgouteroux/sensu-go-graphite-handler',
                                                'sensu-plugins/sensu-plugins-memory-checks',
                                                "sensu-plugins/sensu-plugins-filesystem-checks",
                                                "sensu-plugins/sensu-plugins-disk-checks",
                                                "sensu-plugins/sensu-plugins-process-checks",
                                                "sensu-plugins/sensu-plugins-network-checks",
                                                "sensu-plugins/sensu-plugins-cpu-checks",
                                                "sensu-plugins/sensu-plugins-mysql",
                                                "nixwiz/sensu-go-fatigue-check-filter"]

default['jmh_monitor']['sensugo']['default_subscriptions'] = ['base']
default['jmh_monitor']['sensugo']['pagerduty_event_key'] = '8869185609fc46f79d0288de0401f95a'
default['jmh_monitor']['sensugo']['check_removal'] = ['mychart_proxy','metrics_memory_percentage']
default['jmh_monitor']['sensugo']['cert_folder'] = '/etc/sensu/tls'
default['jmh_monitor']['sensugo']['cert_length'] = '43800h'
default['jmh_monitor']['sensugo']['ca_cert_name'] = 'ca.pem'
default['jmh_monitor']['sensugo']['export_name'] = "sensugo-backend.jmh.internal"
default['jmh_monitor']['sensugo']['cert_file_name'] = "sensugo-backend.jmh.internal.pem"
default['jmh_monitor']['sensugo']['key_file_name'] = "sensugo-backend.jmh.internal-key.pem"

default['jmh_monitor']['sensugo']['restart_action'] = :restart