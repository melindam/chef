::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

include_recipe 'jmh-utilities::hostsfile_epic_servers'
include_recipe 'jmh-utilities::hostsfile_profile_servers'
include_recipe 'jmh-utilities::hostsfile_crowd_servers'
include_recipe 'jmh-myjmh::myjmh_public_key'
include_recipe 'jmh-myjmh::myjmh_private_key'

if node['jmh_myjmh']['admin']['db']['password'].nil?
  node.normal['jmh_myjmh']['admin']['db']['password'] = random_password
end

if node['test_run']
  log "NOTHING TO DO ON CHEF-ZERO for remote db calls"
else
  jmh_db_user 'myjmh_admin_user' do
    database node['jmh_myjmh']['admin']['db']['database']
    username node['jmh_myjmh']['admin']['db']['username']
    password node['jmh_myjmh']['admin']['db']['password']
    parent_node_query node['jmh_myjmh']['admin']['db']['node_query'] unless node['recipes'].include?(node['jmh_myjmh']['admin']['db']['local_recipe'])
    privileges node['jmh_myjmh']['admin']['db']['privileges']
    connect_over_ssl node['jmh_myjmh']['admin']['db']['connect_over_ssl']
  end
end

include_recipe 'jmh-myjmh::definitions'

admin_databag = Chef::EncryptedDataBagItem.load('jmh_apps', 'myjmh-admin')

if admin_databag['crowd_password'][node['jmh_server']['environment']]
  node.default['jmh_myjmh']['admin']['crowd_app_password'] = admin_databag['crowd_password'][node['jmh_server']['environment']]
else
  node.default['jmh_myjmh']['admin']['crowd_app_password'] = admin_databag['crowd_password']['default']
end


db_client_properties = ['# DB Connections']
db_client_properties.push("hibernate.connection.username=#{node['jmh_myjmh']['admin']['db']['username']}")
db_client_properties.push("hibernate.connection.password=#{node['jmh_myjmh']['admin']['db']['password']}")
db_client_properties.push("hibernate.connection.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/#{node['jmh_myjmh']['admin']['db']['database']}?verifyServerCertificate=false&useSSL=true&requireSSL=true&serverTimezone=America/Los_Angeles")
db_client_properties.push("jdbc.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/#{node['jmh_myjmh']['admin']['db']['database']}?verifyServerCertificate=false&useSSL=true&requireSSL=true&serverTimezone=America/Los_Angeles")
db_client_properties.push("jdbc.database.server=#{node['jmh_myjmh']['db']['server']}")
db_client_properties.push("jdbc.password=#{node['jmh_myjmh']['admin']['db']['password']}")
db_client_properties.push("jdbc.username=#{node['jmh_myjmh']['admin']['db']['username']}")

aem_server = node['jmh_server']['global']['apache']['www']['server_name']
admin_properties = ['# MyJmh Admin Properties']
admin_properties.push("com.johnmuirhealth.myjmh.server.baseUrl=https://#{aem_server}")
admin_properties.push("# Crowd Properties")
admin_properties.push("application.name=myjmh-admin")
admin_properties.push("application.password=#{node['jmh_myjmh']['admin']['crowd_app_password']}")
admin_properties.push("crowd.server.url=https://crowd.jmh.internal:8495/crowd/services/")
admin_properties.push("application.login.url=https://crowd.jmh.internal:8495/crowd/")
admin_properties.push("crowd.server=crowd.jmh.internal")
admin_properties.push("api.server.url=https://#{node['jmh_server']['global']['apache']['api']['server_name']}")

admin_properties.push('#Basic Auth for getting to profile-api')
profile_api_databag = EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['data_bag'][0],node['jmh_myjmh']['profile_api']['data_bag'][1])
if profile_api_databag['basic_auth'][node['jmh_server']['environment']]
  admin_properties.push("api.basic_auth.username=#{profile_api_databag['basic_auth'][node['jmh_server']['environment']]['username']}")
  admin_properties.push("api.basic_auth.password=#{profile_api_databag['basic_auth'][node['jmh_server']['environment']]['password']}")
else
  admin_properties.push("api.basic_auth.username=#{profile_api_databag['basic_auth']['default']['username']}")
  admin_properties.push("api.basic_auth.password=#{profile_api_databag['basic_auth']['default']['password']}")
end

## Need to update the one epic call and make sure we get any default properties for the epic environment
epic_config = JmhEpic.get_epic_config(node)
epic_profile_properties=["# Epic Properties",
                         "epic.baseUrl=https://#{epic_config['interconnect']['hostname']}/#{epic_config['interconnect']['context']}",
                         "epic.service.clientId=#{epic_config['interconnect']['clientid']}"]

node.default['jmh_myjmh']['admin']['appserver']['catalina_properties'] = db_client_properties +
                                                                         admin_properties +
                                                                         epic_profile_properties


jmh_tomcat 'myjmh-admin' do
  name 'myjmh-admin'
  version node['jmh_myjmh']['admin']['appserver']['tomcat_version']
  enable_ssl node['jmh_myjmh']['admin']['appserver']['enable_ssl']
  enable_http node['jmh_myjmh']['admin']['appserver']['enable_http']
  catalina_properties node['jmh_myjmh']['admin']['appserver']['catalina_properties']
  port node['jmh_myjmh']['admin']['appserver']['port']
  ssl_port node['jmh_myjmh']['admin']['appserver']['ssl_port']
  jmx_port node['jmh_myjmh']['admin']['appserver']['jmx_port']
  shutdown_port node['jmh_myjmh']['admin']['appserver']['shutdown_port']
  rollout_array node['jmh_myjmh']['admin']['appserver']['rollout_array']
  java_options node['jmh_myjmh']['admin']['appserver']['java_options']
  iptables node['jmh_myjmh']['admin']['appserver']['iptables']
  java_version node['jmh_myjmh']['admin']['appserver']['java_version']
  max_heap_size node['jmh_myjmh']['admin']['appserver']['max_heap_size']
end

jmh_crowd_install_certificate 'Myjmh Admin - Install Crowd cert in jre' do
  java_home JmhJavaUtil.get_java_home(node['jmh_myjmh']['admin']['appserver']['java_version'], node)
  action :create
end
