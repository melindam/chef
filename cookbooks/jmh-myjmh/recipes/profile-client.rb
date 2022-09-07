
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

if node['jmh_myjmh']['profile_client']['db']['password'].nil?
  node.normal['jmh_myjmh']['profile_client']['db']['password'] = random_password
end

jmh_db_user 'profile_client_user' do
  database node['jmh_myjmh']['profile_client']['db']['database']
  username node['jmh_myjmh']['profile_client']['db']['username']
  password node['jmh_myjmh']['profile_client']['db']['password']
  parent_node_query node['jmh_myjmh']['profile_client']['db']['node_query'] unless node['recipes'].include?(node['jmh_myjmh']['profile_client']['db']['local_recipe'])
  privileges node['jmh_myjmh']['profile_client']['db']['privileges']
  connect_over_ssl node['jmh_myjmh']['profile_client']['db']['connect_over_ssl']
end

include_recipe 'jmh-utilities::hostsfile_epic_servers'
include_recipe 'jmh-utilities::hostsfile_crowd_servers'
include_recipe 'jmh-myjmh::definitions'


# Database Connections
db_profile_properties = ['# DB Connections']
db_profile_properties.push("hibernate.connection.username=#{node['jmh_myjmh']['profile_client']['db']['username']}")
db_profile_properties.push("hibernate.connection.password=#{node['jmh_myjmh']['profile_client']['db']['password']}")
if node['jmh_myjmh']['profile_client']['db']['connect_over_ssl']
  db_profile_properties.push("hibernate.connection.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/" +
                    "#{node['jmh_myjmh']['client']['db']['database']}?#{node['jmh_myjmh']['db']['ssl_connection_parameter']}")
  db_profile_properties.push("jdbc.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/" +
                    "#{node['jmh_myjmh']['client']['db']['database']}?#{node['jmh_myjmh']['db']['ssl_connection_parameter']}")
else
  db_profile_properties.push("hibernate.connection.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/#{node['jmh_myjmh']['client']['db']['database']}")
  db_profile_properties.push("jdbc.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/#{node['jmh_myjmh']['client']['db']['database']}")
end
db_profile_properties.push("jdbc.database.server=#{node['jmh_myjmh']['db']['server']}")
db_profile_properties.push("jdbc.password=#{node['jmh_myjmh']['profile_client']['db']['password']}")
db_profile_properties.push("jdbc.username=#{node['jmh_myjmh']['profile_client']['db']['username']}")

# IDP redirects
idp_redirects_properties= Array.new
if node['jmh_myjmh']['profile_client']['enable_idp_redirects']
  idp_redirects = Array.new
  search(:node, 'recipes:jmh-webserver\:\:idp') do |n|
    idp_redirects.push("#{n['jmh_server']['global']['apache']['www']['server_name']}|#{n['jmh_server']['global']['apache']['idp']['server_name']}")
  end
  Chef::Log.info("idp redirects is #{idp_redirects.to_s}")
  unless idp_redirects.nil?
    idp_redirects.uniq!
    idp_redirects_properties.push('# IDP Redirects for Development')
    idp_redirects_properties.push("idp.servers.mapping=#{idp_redirects.join(';')}")

  end
end

# Google Analytics
google_props = ['# Google and Tealium']
google_props.push("google.analytics.tracking.id=#{node['jmh_myjmh']['google']['analytics_code']}")
google_props.push("mychart.signup.google.captcha.sitekey=#{node['jmh_server']['global']['google_captcha_site_key']}")
google_props.push("tealium.reportSuiteId=#{node['jmh_server']['global']['tealium_reportsuite_id']}")
google_props.push("tealium.environment=#{node['jmh_myjmh']['profile_client']['tealium_env']}")
google_props.push("tealium.datasource=#{node['jmh_myjmh']['profile_client']['tealium_datasource']}")


# Need to update the one epic call and make sure we get any default properties for the epic environment
epic_config = JmhEpic.get_epic_config(node)
epic_profile_properties=["# Epic Properties",
                         "epic.baseUrl=https://#{epic_config['interconnect']['hostname']}/#{epic_config['interconnect']['context']}",
                         "epic.service.clientId=#{epic_config['interconnect']['clientid']}",
                         "epic.mychart.url=https://#{node['jmh_server']['global']['apache']['www']['server_name']}/#{epic_config['mychart']['sso_context']}"] +
                        epic_config['java_properties']

# If a target_ipaddress is set for the app proxy, we assume we want the app to use this, too.
# (e.g.  Load balancer pools in stage and prod)
profile_api_ip = '127.0.0.1'
if node['jmh_webserver']['api']['app_proxies']['profile_api']['target_ipaddress']
  profile_api_ip = node['jmh_webserver']['api']['app_proxies']['profile_api']['target_ipaddress']
else
  search(:node, "#{node['jmh_myjmh']['profile_client']['profile_api_query']} AND chef_environment:#{node.environment}") do |n|
    if n['ipaddress'] == node['ipaddress']
      profile_api_ip = 'localhost'
    elsif node['test_run'] && n['cloud']
      profile_api_ip = n['cloud']['public_hostname']
    else
      profile_api_ip = n['ipaddress']
    end
    break
  end
end

# Environment Server Setup
profile_props = ["# Profile Client Properties",
                 "web.server.url=https://#{node['jmh_server']['global']['apache']['www']['server_name']}",
                 "idp.server.url=https://#{node['jmh_server']['global']['apache']['idp']['server_name']}",
                 "application.server.name=#{node['jmh_server']['global']['apache']['www']['server_name']}"]

profile_props.push('#Basic Auth for getting to profile-api')
profile_api_databag = EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['data_bag'][0],node['jmh_myjmh']['profile_api']['data_bag'][1])
if profile_api_databag['basic_auth'][node['jmh_server']['environment']]
  profile_props.push("api.basic_auth.username=#{profile_api_databag['basic_auth'][node['jmh_server']['environment']]['username']}")
  profile_props.push("api.basic_auth.password=#{profile_api_databag['basic_auth'][node['jmh_server']['environment']]['password']}")
else
  profile_props.push("api.basic_auth.username=#{profile_api_databag['basic_auth']['default']['username']}")
  profile_props.push("api.basic_auth.password=#{profile_api_databag['basic_auth']['default']['password']}")

end

include_recipe 'jmh-myjmh::myjmh_private_key'
include_recipe 'jmh-myjmh::myjmh_public_key'

profile_props.push('# Profile Question Encryption Keys')
profile_props.push("myjmh.private.key.path=#{node['jmh_myjmh']['myjmh_keys']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
profile_props.push("crypto.private.key.path=#{node['jmh_myjmh']['myjmh_keys']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
profile_props.push("crypto.public.key.path=#{node['jmh_myjmh']['myjmh_keys']['key_dir']}/#{node['jmh_myjmh']['myjmh_keys']['public_ssh_key']['name']}.der")

# Add the profile_api properties
# TODO Remove profile.api.url after October - SYS-6130
profile_props.push("profile.api.url=https://#{node['jmh_server']['global']['apache']['api']['server_name']}/profile-api")
profile_props.push("api.server.url=https://#{node['jmh_server']['global']['apache']['api']['server_name']}")
profile_props.push("mychart.enabled=#{node['jmh_myjmh']['profile_client']['mychart_enabled']}")


node.default['jmh_myjmh']['profile_client']['appserver']['catalina_properties'] = node['jmh_myjmh']['profile_client']['properties'] +
                                                                           node['jmh_myjmh']['crowd_java_properties'] +
                                                                           epic_profile_properties +
                                                                           db_profile_properties +
                                                                           google_props +
                                                                           idp_redirects_properties +
                                                                           profile_props
jmh_tomcat 'profile-client' do
  name 'profile-client'
  enable_ssl node['jmh_myjmh']['profile_client']['appserver']['enable_ssl']
  version node['jmh_myjmh']['profile_client']['appserver']['version']
  enable_http node['jmh_myjmh']['profile_client']['appserver']['enable_http']
  catalina_properties node['jmh_myjmh']['profile_client']['appserver']['catalina_properties']
  port node['jmh_myjmh']['profile_client']['appserver']['port']
  ssl_port node['jmh_myjmh']['profile_client']['appserver']['ssl_port']
  jmx_port node['jmh_myjmh']['profile_client']['appserver']['jmx_port']
  shutdown_port node['jmh_myjmh']['profile_client']['appserver']['shutdown_port']
  rollout_array node['jmh_myjmh']['profile_client']['appserver']['rollout_array']
  java_options node['jmh_myjmh']['profile_client']['appserver']['java_options']
  iptables node['jmh_myjmh']['profile_client']['appserver']['iptables']
  newrelic node['jmh_myjmh']['profile_client']['appserver']['newrelic']
  java_version node['jmh_myjmh']['profile_client']['appserver']['java_version']
end

jmh_crowd_install_certificate 'Profile install Crowd cert in jre for profile' do
  java_home JmhJavaUtil.get_java_home(node['jmh_myjmh']['profile_client']['appserver']['java_version'], node)
  action :create
end