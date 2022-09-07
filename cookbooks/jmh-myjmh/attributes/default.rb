default['mysql']['bind_address'] = '0.0.0.0'
default['jmh_myjmh']['db']['database'] = 'profile'
default['jmh_myjmh']['db']['developer_user'] = 'profile_dev'
default['jmh_myjmh']['db']['developer_password'] = '!@#profile!@#'
default['jmh_myjmh']['db']['ssl_connection_parameter'] = 'verifyServerCertificate=false&useSSL=true&requireSSL=true&serverTimezone=PST'

default['jmh_myjmh']['epic']['data_bag_name'] = 'jmh_apps'
default['jmh_myjmh']['epic']['data_bag'] = 'jmh_apps'
default['jmh_myjmh']['epic']['data_bag_item'] = 'epic'

default['jmh_myjmh']['google']['analytics_code'] = 'UA-133170530-1'

default['jmh_myjmh']['profile']['default_properties'] = ['profile.security.client.cookie.domain=localhost',
                                                         'profile.security.client.cookie.age=1800',
                                                         'myjmh.client.session.timeout.minutes=30',
                                                         'myjmh.client.session.monitor.cron=0 0/10 * * * ?',
                                                         'myjmh.login.check.accountStatus=true',
                                                         'com.johnmuirhealth.myjmh.showAppBanner=true']

default['jmh_myjmh']['aem']['default_properties'] = [ "aem.header.url=/content/jmh/en/shared/top-navigation.html?wcmmode=disabled",
                                                      "aem.footer.url=/content/jmh/en/shared/footer.html?noTiq=true&wcmmode=disabled",
                                                      "aem.css.url=/etc/designs/jmh/clientlib-head.css",
                                                      "aem.css.application=/myjmh-client/resources/css/aemcompatibility.css",
                                                      "com.johnmuirhealth.myjmh.tealium.enabled=true" ]


# Zipnosis
default['jmh_myjmh']['zipnosis']['databag']['jwt_key_name'] = if %w(prod stage).include?(node['jmh_server']['environment'])
                                                                'jwt_prod_key'
                                                              else
                                                                'jwt_default_key'
                                                              end
default['jmh_myjmh']['zipnosis']['zip_url'] = case node['jmh_server']['environment']
                                              when 'prod', 'stage'
                                                'https://onlineexam.johnmuirhealth.com'
                                              else
                                                'https://jmhtraining.zipnosis.com'
                                              end
default['jmh_myjmh']['zipnosis']['zip_visits'] = '/api/v1/visits'
default['jmh_myjmh']['zipnosis']['key_action'] = :create
default['jmh_myjmh']['myjmh_keys']['key_dir'] = '/usr/local/webapps/myjmh/keys'
default['jmh_myjmh']['zipnosis']['key_dir'] = node['jmh_myjmh']['myjmh_keys']['key_dir']
default['jmh_myjmh']['zipnosis']['private_ssh_key']['name'] = 'jmh_private_key'
default['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_name'] = 'broker'
default['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_item'] = 'secure'
default['jmh_myjmh']['zipnosis']['private_ssh_key']['secure_databag'] = true
default['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_key_name'] = if %(prod stage).include?(node['jmh_server']['environment'])
                                                                            'broker_prod_private_key'
                                                                          else
                                                                            'broker_default_private_key'
                                                                          end

default['jmh_myjmh']['myjmh_keys']['public_ssh_key']['name'] = 'jmh_public_key'
default['jmh_myjmh']['myjmh_keys']['public_ssh_key']['databag_name'] = 'broker'
default['jmh_myjmh']['myjmh_keys']['public_ssh_key']['databag_item'] = 'broker'
default['jmh_myjmh']['myjmh_keys']['public_ssh_key']['secure_databag'] = false
default['jmh_myjmh']['myjmh_keys']['public_ssh_key']['databag_key_name'] = if %(prod stage).include?(node['jmh_server']['environment'])
                                                                            'broker_prod_public_key'
                                                                          else
                                                                            'broker_default_public_key'
                                                                         end

default['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name'] = 'zipnosis_public_key'
default['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_name'] = 'broker'
default['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_item'] = 'broker'
default['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['secure_databag'] = false
default['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_key_name'] = if %(prod stage).include?(node['jmh_server']['environment'])
                                                                                    'zipnosis_prod_public_key'
                                                                                  else
                                                                                    'zipnosis_default_public_key'
                                                                                  end
default['jmh_myjmh']['profile_server_hostname'] = 'profile.jmh.internal'
default['jmh_myjmh']['crowd']['role'] = 'jmh-crowd'
default['jmh_myjmh']['db']['server'] = 'localhost'


default['jmh_myjmh']['myjmh_crowd_databag'] = 'jmh_apps'
default['jmh_myjmh']['myjmh_crowd_databag_item'] = 'myjmh'

default['jmh_myjmh']['crowd']['default_properties'] =   ['application.name=profile',
                                                         'session.isauthenticated=session.isauthenticated',
                                                         'session.tokenkey=session.tokenkey',
                                                         'session.validationinterval=0',
                                                         'session.lastvalidation=session.lastvalidation',
                                                         'crowd.security.randomstring=fhjkds8*H3hj3ba$##@']
