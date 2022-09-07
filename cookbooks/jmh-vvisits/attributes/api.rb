default['jmh_vvisits']['api']['mongodb']['username'] = 'vvisits'
default['jmh_vvisits']['api']['mongodb']['database'] = 'VideoVisits'

default['jmh_vvisits']['api']['name'] = 'vvisits'
default['jmh_vvisits']['api']['https_port'] = 8521
default['jmh_vvisits']['api']['basic_auth_username'] = 'system'
default['jmh_vvisits']['api']['basic_auth_password'] = 'password'
default['jmh_vvisits']['api']['mongodb']['node_query'] = 'recipes:jmh-vvisits\:\:mongodb OR recipe:jmh-vvisits\:\:mongodb'

default['jmh_vvisits']['api']['data_bag'] = ['jmh_apps','vvisits-api']

default['jmh_vvisits']['api']['iptables_list'] = { 'portlist' => { node['jmh_vvisits']['api']['https_port'] => { 'target' => 'ACCEPT' } } }

default['jmh_vvisits']['api']['nodejs_version'] = '14'
default['jmh_vvisits']['api']['yaml_file'] = 'vvisits-local.yaml'
default['jmh_vvisits']['api']['nodejs_newrelic_enabled'] = false
default['jmh_vvisits']['api']['nodejs_newrelic_license'] = 'b8248540110d9562d9623ffeb355f6874b372318'
default['jmh_vvisits']['api']['nodejs_newrelic_loglevel'] = 'info'
default['jmh_vvisits']['api']['nodejs_newrelic_file'] = 'newrelic.js'

default['jmh_vvisits']['api']['aws_environment_type'] = 'default'
default['jmh_vvisits']['api']['videovisit_environment_type'] = 'default'
default['jmh_vvisits']['api']['ldap_environment_type'] = 'default'
default['jmh_vvisits']['api']['zoom_environment_type'] = %w(prod).include?(node['jmh_server']['environment']) ? 'prod' : 'default'
default['jmh_vvisits']['api']['zoom_cleanup_period'] =  %w(prod).include?(node['jmh_server']['environment']) ? '2' : '0'
default['jmh_vvisits']['api']['privacy_email'] = %w(prod).include?(node['jmh_server']['environment']) ? 'PrivacyOffice@johnmuirhealth.com' : 'jmhgreenauto@gmail.com'

default['jmh_vvisits']['api']['features']['emailIcs'] = true
default['jmh_vvisits']['api']['features']['testing'] = %w(prod).include?(node['jmh_server']['environment']) ? 'false' : 'true'