# DEPRECATED #

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

Chef::Application.fatal!("The Recipe myjmh-client is DEPRECATED!!!")

if node['jmh_myjmh']['myjmh_client']['db']['password'].nil?
  node.normal['jmh_myjmh']['myjmh_client']['db']['password'] = random_password
end

jmh_db_user 'myjmh_client_user' do
  database node['jmh_myjmh']['myjmh_client']['db']['database']
  username node['jmh_myjmh']['myjmh_client']['db']['username']
  password node['jmh_myjmh']['myjmh_client']['db']['password']
  parent_node_query node['jmh_myjmh']['myjmh_client']['db']['node_query'] unless node['recipes'].include?(node['jmh_myjmh']['myjmh_client']['db']['local_recipe'])
  privileges node['jmh_myjmh']['myjmh_client']['db']['privileges']
  connect_over_ssl node['jmh_myjmh']['myjmh_client']['db']['connect_over_ssl']
end

# Zipnosis
directory node['jmh_myjmh']['zipnosis']['key_dir'] do
  recursive true
  action :create
end

include_recipe 'jmh-utilities::hostsfile_epic_servers'
include_recipe 'jmh-utilities::hostsfile_crowd_servers'
include_recipe 'jmh-myjmh::definitions'

zipnosis_secure_databag = Chef::EncryptedDataBagItem.load('broker', 'secure')
epic_config = JmhEpic.get_epic_config(node)

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
client_props = ['# External Server Urls']
client_props.push("web.server.url=https://#{node['jmh_server']['global']['apache']['www']['server_name']}")
client_props.push("idp.server.url=https://#{node['jmh_server']['global']['apache']['idp']['server_name']}")
client_props.push("application.server.name=#{node['jmh_server']['global']['apache']['www']['server_name']}")
client_props.push("com.johnmuirhealth.myjmh.server=#{node['jmh_server']['global']['apache']['www']['server_name']}")
client_props.push("profile.security.client.cookie.domain=#{node['jmh_server']['global']['apache']['www']['server_name']}")

client_props.push("profile.api.url=https://#{node['jmh_server']['global']['apache']['api']['server_name']}/profile-api")

client_props.push("# Tealium/Google Settings")
client_props.push("google.analytics.tracking.id=#{node['jmh_myjmh']['google']['analytics_code']}")
client_props.push("tealium.environment=#{node['jmh_myjmh']['myjmh_client']['tealium']['env']}")
client_props.push("cq.publish.host=https://#{node['jmh_server']['global']['apache']['www']['server_name']}")
client_props.push("cq.css.host=https://#{node['jmh_server']['global']['apache']['www']['server_name']}")

client_props.push("# Epic Settings")
client_props.push("epic.baseUrl=#{epic_config['interconnect']['protocol']}://#{epic_config['interconnect']['hostname']}/#{epic_config['interconnect']['context']}")
client_props.push("com.jmh.exam.zip.base.url=#{node['jmh_myjmh']['zipnosis']['zip_url']}")
client_props.push("mychart.host=#{epic_config['mychart']['hostname']}")
client_props.push("mychart.cookie.domain=#{node['jmh_server']['global']['apache']['www']['server_name']}")
client_props.push("mychart.datatile.url=https://#{node['jmh_server']['global']['apache']['www']['server_name']}/#{epic_config['mychart']['context']}/")
client_props.push("mychart.base.path=/#{epic_config['mychart']['context']}/")
client_props.push("epic.service.clientId=#{epic_config['interconnect']['clientid']}")
client_props.concat(epic_config['java_properties'])

# DB properties
client_props.push('# DB Connections')
client_props.push("hibernate.connection.username=#{node['jmh_myjmh']['myjmh_client']['db']['username']}")
client_props.push("hibernate.connection.password=#{node['jmh_myjmh']['myjmh_client']['db']['password']}")
if node['jmh_myjmh']['myjmh_client']['db']['connect_over_ssl']
  client_props.push("hibernate.connection.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/" +
                    "#{node['jmh_myjmh']['myjmh_client']['db']['database']}?#{node['jmh_myjmh']['db']['ssl_connection_parameter']}")
  client_props.push("jdbc.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/" +
                    "#{node['jmh_myjmh']['myjmh_client']['db']['database']}?#{node['jmh_myjmh']['db']['ssl_connection_parameter']}")
else
  client_props.push("hibernate.connection.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/#{node['jmh_myjmh']['myjmh_client']['db']['database']}")
  client_props.push("jdbc.url=jdbc:mysql://#{node['jmh_myjmh']['db']['server']}/#{node['jmh_myjmh']['myjmh_client']['db']['database']}")
end
client_props.push("jdbc.database.server=#{node['jmh_myjmh']['db']['server']}")
client_props.push("jdbc.password=#{node['jmh_myjmh']['myjmh_client']['db']['password']}")
client_props.push("jdbc.username=#{node['jmh_myjmh']['myjmh_client']['db']['username']}")

include_recipe 'jmh-myjmh::myjmh_private_key'
include_recipe 'jmh-myjmh::myjmh_public_key'

client_props.push('# Profile Question Encryption Keys')
client_props.push("myjmh.private.key.path=#{node['jmh_myjmh']['myjmh_keys']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
client_props.push("crypto.private.key.path=#{node['jmh_myjmh']['myjmh_keys']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
client_props.push("crypto.public.key.path=#{node['jmh_myjmh']['myjmh_keys']['key_dir']}/#{node['jmh_myjmh']['myjmh_keys']['public_ssh_key']['name']}.der")

include_recipe 'jmh-myjmh::zipnosis_keys'
# Zipnosis
client_props.push('# Zipnosis')
client_props.push('com.johnmuirhealth.jwt.clients=zipnosis')
client_props.push("com.johnmuirhealth.jwt.zipnosis.tokenkey=#{zipnosis_secure_databag[node['jmh_myjmh']['zipnosis']['databag']['jwt_key_name']]}")
client_props.push("com.johnmuirhealth.jwt.jmh.privatekey.path=#{node['jmh_myjmh']['zipnosis']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
client_props.push("com.johnmuirhealth.jwt.zipnosis.publickey.path=#{node['jmh_myjmh']['zipnosis']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name']}.der")
client_props.push("myjmh.zipnosis.jwt.key=#{zipnosis_secure_databag[node['jmh_myjmh']['zipnosis']['databag']['jwt_key_name']]}")
client_props.push('com.johnmuirhealth.jwt.zipnosis.audience=zipnosis.com')
client_props.push('com.johnmuirhealth.jwt.issuer=johnmuirhealth')

# OAuth properties
client_props.push("# WellBe oAuth properties")
client_props.push("wellbe.oauth2.client.clientId=#{node['jmh_myjmh']['myjmh_client']['oauth']['wellbe']['client_id']}")
client_props.push("wellbe.oauth2.client.clientSecret=#{node['jmh_myjmh']['myjmh_client']['oauth']['wellbe']['client_secret']}")
client_props.push("wellbe.oauth2.client.baseUrl=#{node['jmh_myjmh']['myjmh_client']['oauth']['wellbe']['base_url']}")
client_props.push("jmh.oauth2.idp.baseUrl=https://#{node['jmh_server']['global']['apache']['idp']['server_name']}")
client_props.push("jmh.oauth2.clientId=jmh-sso")
client_props.push("jmh.oauth2.clientSecret=#{node['jmh_pingfed']['client_secret']['jmh_sso']}")

node.default['jmh_myjmh']['myjmh_client']['appserver']['catalina_properties'] = node['jmh_myjmh']['myjmh_client']['properties'] +
                                                                          node['jmh_myjmh']['crowd_java_properties'] +
                                                                          client_props

jmh_tomcat 'myjmh-client' do
  name 'myjmh-client'
  version node['jmh_myjmh']['myjmh_client']['appserver']['version']
  enable_ssl node['jmh_myjmh']['myjmh_client']['appserver']['enable_ssl']
  enable_http node['jmh_myjmh']['myjmh_client']['appserver']['enable_http']
  catalina_properties node['jmh_myjmh']['myjmh_client']['appserver']['catalina_properties']
  port node['jmh_myjmh']['myjmh_client']['appserver']['port']
  ajp_port node['jmh_myjmh']['myjmh_client']['appserver']['ajp_port']
  ssl_port node['jmh_myjmh']['myjmh_client']['appserver']['ssl_port']
  jmx_port node['jmh_myjmh']['myjmh_client']['appserver']['jmx_port']
  shutdown_port node['jmh_myjmh']['myjmh_client']['appserver']['shutdown_port']
  java_options node['jmh_myjmh']['myjmh_client']['appserver']['java_options']
  iptables node['jmh_myjmh']['myjmh_client']['appserver']['iptables']
  newrelic node['jmh_myjmh']['myjmh_client']['appserver']['newrelic']
  max_heap_size node['jmh_myjmh']['myjmh_client']['appserver']['max_heap_size']
  java_version node['jmh_myjmh']['myjmh_client']['appserver']['java_version']
  install_tcell node['jmh_myjmh']['myjmh_client']['enable_tcell']
  tcell_config node['jmh_myjmh']['myjmh_client']['tcell_config']
  rollout_array node['jmh_myjmh']['myjmh_client']['appserver']['rollout_array']
  directories node['jmh_myjmh']['myjmh_client']['appserver']['directories']
end

jmh_crowd_install_certificate 'Client Install Crowd cert in jre' do
  java_home JmhJavaUtil.get_java_home(node['jmh_myjmh']['myjmh_client']['appserver']['java_version'], node)
  action :create
end
