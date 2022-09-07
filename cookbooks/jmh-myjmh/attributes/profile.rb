default['jmh_myjmh']['profile']['db']['username'] = 'profile'
default['jmh_myjmh']['profile']['db']['database'] = 'profile'
default['jmh_myjmh']['profile']['db']['local_recipe'] = 'jmh-myjmh::db'
default['jmh_myjmh']['profile']['db']['node_query'] = 'recipes:jmh-myjmh\:\:db OR recipe:jmh-myjmh\:\:db'
default['jmh_myjmh']['profile']['db']['privileges'] = [:all]
default['jmh_myjmh']['profile']['db']['connect_over_ssl'] = true

default['jmh_myjmh']['profile']['db']['mrn_username'] = 'mrn_user'

default['jmh_myjmh']['profile']['profile_api_query'] = 'recipes:jmh-myjmh\\:\\:profile_api'

default['jmh_myjmh']['profile_api']['db']['username'] = 'profile_api'
default['jmh_myjmh']['profile_api']['pingfed_client'] = 'jmh_sso'
default['jmh_myjmh']['profile_api']['name'] = 'profile-api'
default['jmh_myjmh']['profile_api']['https_port'] = 8465
default['jmh_myjmh']['profile_api']['basic_auth_username'] = 'system'
default['jmh_myjmh']['profile_api']['basic_auth_password'] = 'password'
default['jmh_myjmh']['profile_api']['data_bag'] = ['jmh_apps','profile-api']
default['jmh_myjmh']['profile_api']['aws_data_bag'] = ['credentials','aws']
default['jmh_myjmh']['profile_api']['iptables_list'] = { 'portlist' => {node['jmh_myjmh']['profile_api']['https_port']  => { 'target' => 'ACCEPT' } } }

default['jmh_myjmh']['profile_api']['nodejs_version'] = '14'
default['jmh_myjmh']['profile_api']['yaml_file'] = 'profile-api-local.yaml'
default['jmh_myjmh']['profile_api']['nodejs_newrelic_enabled'] = false
default['jmh_myjmh']['profile_api']['nodejs_newrelic_license'] = 'b8248540110d9562d9623ffeb355f6874b372318'
default['jmh_myjmh']['profile_api']['nodejs_newrelic_loglevel'] = 'info'
default['jmh_myjmh']['profile_api']['nodejs_newrelic_file'] = 'newrelic.js'
default['jmh_myjmh']['profile_api']['whitelist_ips'] = case node['jmh_server']['environment']
                                                        when 'prod'
                                                          '::ffff:100.68.179.0/24'
                                                        when 'stage'
                                                          '::ffff:100.68.181.0/24'
                                                        else
                                                          '172.23.0.0/16,::ffff:192.168.114.0/24'
                                                       end

default['jmh_myjmh']['profile_api']['yaml']['idp']['server'] =  "https://#{node['jmh_server']['global']['apache']['idp']['server_name']}"
default['jmh_myjmh']['profile_api']['yaml']['idp']['client_secret'] =  JmhPingFed.get_pingfed_client_secret(node['jmh_myjmh']['profile_api']['pingfed_client'],node)
default['jmh_myjmh']['profile_api']['yaml']['idp']['client_id'] =  'jmh-sso'

default['jmh_myjmh']['profile_api']['pingone_databag'] = ['credentials','pingone']
default['jmh_myjmh']['profile_api']['pingone_environment_type'] = 'default'
default['jmh_myjmh']['profile_api']['chatbot_environment_type'] = 'default'
default['jmh_myjmh']['profile_api']['aws_environment_type'] = 'default'
default['jmh_myjmh']['profile_api']['ldap_environment_type'] = 'default'
