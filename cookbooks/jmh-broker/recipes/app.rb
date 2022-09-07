::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

include_recipe 'jmh-utilities::hostsfile_cloverleaf_servers'
include_recipe 'jmh-utilities::hostsfile_epic_servers'

broker_secure_databag = Chef::EncryptedDataBagItem.load('broker', 'secure')

db_server = '127.0.0.1'
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.') if Chef::Config[:solo]
  db_server = '127.0.0.1'
else
  search(:node, node['jmh_broker']['db']['parent_node_search']) do |n|
    next unless n.environment == node.environment
    db_server = n['ipaddress'] unless n['ipaddress'] == node['ipaddress']
    break
  end
end

if node['jmh_broker']['db_password'].nil?
  node.normal['jmh_broker']['db_password'] = random_password
end

jmh_db_user 'broker_db_user' do
  database node['jmh_myjmh']['db']['database']
  username node['jmh_broker']['db']['user_name']
  password node['jmh_broker']['db_password']
  parent_node_query node['jmh_broker']['db']['parent_node_search'] unless node['recipes'].include?(node['jmh_broker']['db']['unless_recipe'])
  privileges [:all]
  connect_over_ssl node['jmh_broker']['db']['ssl']
  not_if { node['test_run'] }
end

# Broker and Consumer Tomcat catalina properties variables
global_props = []
# Broker
global_props.push('# Broker variables')
global_props.push("broker.jmh.key.path=#{node['jmh_broker']['keys_folder']}")
global_props.push("broker.jmh.private.key.path=#{node['jmh_broker']['keys_folder']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
global_props.push("broker.jmh.public.key.path=#{node['jmh_broker']['keys_folder']}/#{node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name']}.der")
global_props.push("broker.zipnosis.public.key.path=#{node['jmh_broker']['keys_folder']}/#{node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name']}.der")
global_props.push("broker.jmh.jwt.key=#{broker_secure_databag[node['jmh_myjmh']['zipnosis']['databag']['jwt_key_name']]}")
global_props.push("jmh.private.key.path=#{node['jmh_broker']['keys_folder']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")

# Consumer
global_props.push('# Consumer variables')
global_props.push("epic.hl7MessageDestination.host=#{node['jmh_broker']['cloverleaf_server']}")
global_props.push("epic.hl7MessageDestination.port=#{node['jmh_broker']['cloverleaf_port']}")
global_props.push("jms.url=tcp://#{node['jmh_broker']['jms_host']}:#{node['jmh_broker']['jms_port']}")
global_props.push("jms.username=#{node['activemq']['simple_auth_user']}")
global_props.push("jms.password=#{node['activemq']['simple_auth_password']}")

# Database
global_props.push('# Database variables')
global_props.push("hibernate.connection.username=#{node['jmh_broker']['db']['user_name']}")
global_props.push("hibernate.connection.password=#{node['jmh_broker']['db_password']}")
global_props.push("hibernate.connection.url=jdbc:mysql://#{db_server}/#{node['jmh_myjmh']['db']['database']}#{node['jmh_broker']['db']['jdbc_suffix']}")
global_props.push("jdbc.url=jdbc:mysql://#{db_server}/#{node['jmh_myjmh']['db']['database']}#{node['jmh_broker']['db']['jdbc_suffix']}")
global_props.push("jdbc.database.server=#{db_server}")
global_props.push("jdbc.username=#{node['jmh_broker']['db']['user_name']}")
global_props.push("jdbc.password=#{node['jmh_broker']['db_password']}")


# Epic Services
include_recipe 'jmh-epic::java_properties'
node.default['jmh_broker']['appserver']['catalina_properties'] = global_props +
                                                                 node['jmh_broker']['static_properties'] +
                                                                 node['jmh_epic']['java_properties']

jmh_tomcat node['jmh_broker']['appserver']['name'] do
    name node['jmh_broker']['appserver']['name']
    java_version node['jmh_broker']['appserver']['java_version']
    jmx_port node['jmh_broker']['appserver']['jmx_port']
    catalina_properties node['jmh_broker']['appserver']['catalina_properties']
    enable_http node['jmh_broker']['appserver']['enable_http']
    enable_ssl node['jmh_broker']['appserver']['enable_ssl']
    iptables node['jmh_broker']['appserver']['iptables']
    shutdown_port node['jmh_broker']['appserver']['shutdown_port']
    port node['jmh_broker']['appserver']['port']
    ssl_port node['jmh_broker']['appserver']['ssl_port']
    ajp_port node['jmh_broker']['appserver']['ajp_port']
    directories node['jmh_broker']['appserver']['directories']
end

# Setup keys
directory node['jmh_broker']['keys_folder'] do
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['user']
  mode '0700'
  action :create
end


# Install Zipnosis Public and Private Key with myjmh attributes
jmh_utilities_pem_to_der node['jmh_myjmh']['zipnosis']['private_ssh_key']['name'] do
  databag_name node['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_name']
  databag_item node['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_item']
  databag_key_name node['jmh_myjmh']['zipnosis']['private_ssh_key']['databag_key_name']
  secure_databag node['jmh_myjmh']['zipnosis']['private_ssh_key']['secure_databag']
  cert_name
  public_key false
  path node['jmh_broker']['keys_folder']
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  action node['jmh_myjmh']['zipnosis']['key_action']
end

jmh_utilities_pem_to_der node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name'] do
  databag_name node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_name']
  databag_item node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_item']
  databag_key_name node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_key_name']
  secure_databag node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['secure_databag']
  public_key true
  path node['jmh_broker']['keys_folder']
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  action node['jmh_myjmh']['zipnosis']['key_action']
end
