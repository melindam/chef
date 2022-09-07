default['jmh_apptapi']['appserver']['enable_ssl'] = true
default['jmh_apptapi']['appserver']['enable_http'] = true
default['jmh_apptapi']['appserver']['name'] = 'apptapi'
default['jmh_apptapi']['appserver']['port'] = 8093
default['jmh_apptapi']['appserver']['ajp_port'] = 8023
default['jmh_apptapi']['appserver']['ssl_port'] = 8463
default['jmh_apptapi']['appserver']['jmx_port'] = 6983
default['jmh_apptapi']['appserver']['shutdown_port'] = 8063
default['jmh_apptapi']['appserver']['iptables'] = { node['jmh_apptapi']['appserver']['port'] => { 'target' => 'ACCEPT' },
                                                    node['jmh_apptapi']['appserver']['ssl_port'] => { 'target' => 'ACCEPT' },
                                                    node['jmh_apptapi']['appserver']['jmx_port'] => { 'target' => 'ACCEPT' } }
default['jmh_apptapi']['appserver']['java_version'] = '8'
default['jmh_apptapi']['appserver']['directories'] = %w(/usr/local/webapps/apptapi)

default['jmh_apptapi']['jwt']['databag_name'] = 'jmh_apps'
default['jmh_apptapi']['jwt']['databag_item'] = 'apptapi-secure'
default['jmh_apptapi']['jwt']['databag_key_name'] = %w(prod stage).include?(node['jmh_server']['environment']) ? 'jmh_jwt_prod_key' : 'jmh_jwt_default_key'


default['jmh_apptapi']['zocdoc']['key_action'] = :create
default['jmh_apptapi']['zocdoc']['key_dir'] = '/usr/local/webapps/apptapi/keys'
default['jmh_apptapi']['zocdoc']['private_ssh_key']['name'] = 'jmh_zocdoc_private_key'
default['jmh_apptapi']['zocdoc']['private_ssh_key']['databag_name'] = 'jmh_apps'
default['jmh_apptapi']['zocdoc']['private_ssh_key']['databag_item'] = 'apptapi-secure'
default['jmh_apptapi']['zocdoc']['private_ssh_key']['secure_databag'] = true
default['jmh_apptapi']['zocdoc']['private_ssh_key']['databag_key_name'] = if ['prod','stage'].include?(node['jmh_server']['environment'])
                                                                            'jmh_zocdoc_prod_private_key'
                                                                          else
                                                                            'jmh_zocdoc_private_key'
                                                                          end
default['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['name'] = 'zocdoc_public_key'
default['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['databag_name'] = 'jmh_apps'
default['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['databag_item'] = 'apptapi'
default['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['secure_databag'] = false
default['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['databag_key_name'] = if ['prod','stage'].include?(node['jmh_server']['environment'])
                                                                                  'zocdoc_prod_public_key'
                                                                                else
                                                                                  'zocdoc_public_key'
                                                                                end
