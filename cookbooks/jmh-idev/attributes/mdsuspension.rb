# in role => override['jmh_tomcat']['7']['version'] = '7.0.52'
default['jmh_idev']['appserver']['mdsuspension']['enable_ssl'] = false
default['jmh_idev']['appserver']['mdsuspension']['enable_http'] = true
default['jmh_idev']['appserver']['mdsuspension']['name'] = 'mdsuspension'
default['jmh_idev']['appserver']['mdsuspension']['port'] = 8105
default['jmh_idev']['appserver']['mdsuspension']['jmx_port'] = 6995
default['jmh_idev']['appserver']['mdsuspension']['shutdown_port'] = 8075
default['jmh_idev']['appserver']['mdsuspension']['version'] = '7'
default['jmh_idev']['appserver']['mdsuspension']['catalina_properties'] = []
default['jmh_idev']['appserver']['mdsuspension']['iptables'] = { node['jmh_idev']['appserver']['mdsuspension']['port'] => { 'target' => 'ACCEPT' },
                                                             node['jmh_idev']['appserver']['mdsuspension']['jmx_port'] => { 'target' => 'ACCEPT' } }
#TODO Remove the https.protocols once we upgrade tp Java 8
default['jmh_idev']['appserver']['mdsuspension']['catalina_opts'] = ["-Dhttps.protocols=TLSv1.2",
                                                                     "-Dcrowd.properties=#{node['jmh_tomcat']['target']}mdsuspension/conf/catalina.properties"]

default['jmh_idev']['appserver']['mdsuspension']['java_version'] = '7'
default['jmh_idev']['appserver']['mdsuspension']['rollout_array'] = [ 'bamboo_name' => 'mdsuspension', 'war_name' => 'mdsuspension' ]

default['jmh_idev']['mdsuspension']['db']['name'] = 'mdsuspension'
default['jmh_idev']['mdsuspension']['db']['username'] = 'mdsuspension'
default['jmh_idev']['mdsuspension']['db']['privileges'] = [:all]
default['jmh_idev']['mdsuspension']['db']['connect_over_ssl'] = false
default['jmh_idev']['mdsuspension']['db']['developer_user'] = 'mdsuspension_dev'
default['jmh_idev']['mdsuspension']['db']['developer_password'] = 'mdsuspension_dev'

default['jmh_idev']['mdsuspension']['crowd']['application.name'] = 'mdsuspension'
default['jmh_idev']['mdsuspension']['crowd']['application.login.url'] = 'https://crowd.jmh.internal:8495/crowd/'
default['jmh_idev']['mdsuspension']['crowd']['crowd.server.url'] = 'https://crowd.jmh.internal:8495/crowd/services/'
default['jmh_idev']['mdsuspension']['crowd']['session.isauthenticated'] = 'session.isauthenticated'
default['jmh_idev']['mdsuspension']['crowd']['session.tokenkey'] = 'session.tokenkey'
default['jmh_idev']['mdsuspension']['crowd']['session.validationinterval'] = 0
default['jmh_idev']['mdsuspension']['crowd']['session.lastvalidation'] = 'session.lastvalidation'
# Password is filled in at runtime from a data bag
# default['jmh_idev']['mdsuspension']['crowd']['application.password'] = nil
default['jmh_idev']['mdsuspension']['crowd_password_key'] = 'default'
