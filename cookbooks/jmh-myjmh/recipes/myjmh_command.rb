# Installs myjmh-command.jar from bamboo server and needed java 11 version
# Code is located in https://bitbucket.org/jmhebiz-ondemand/myjmh-command
# built by running mvn clean package -DskipTests=true

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

jmh_java_install 'install java for myjmhcommand' do
  version node['jmh_myjmh']['myjmh_command']['java_version']
  action :install
end

directory node['jmh_myjmh']['myjmh_command']['install_dir'] do
  owner node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode '0700'
  action :create
end

remote_file File.join(node['jmh_myjmh']['myjmh_command']['install_dir'], 'myjmh-command.jar') do
  source node['jmh_myjmh']['myjmh_command']['download_url']
  owner node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode '0644'
  action :create
end

# add database user to profile
if node['jmh_myjmh']['myjmh_command']['db_password'].nil?
  node.normal['jmh_myjmh']['myjmh_command']['db_password'] = random_password
end

jmh_db_user 'myjmhcommand_client_user' do
  database node['jmh_myjmh']['db']['database']
  username node['jmh_myjmh']['myjmh_command']['db_user']
  password node['jmh_myjmh']['myjmh_command']['db_password']
  parent_node_query node['jmh_myjmh']['myjmh_client']['db']['node_query'] unless node['recipes'].include?(node['jmh_myjmh']['myjmh_client']['db']['local_recipe'])
  privileges [:SELECT, :UPDATE]
  connect_over_ssl true
end

epic_config = JmhEpic.get_epic_config(node)


unless node['recipes'].include?(node['jmh_myjmh']['myjmh_client']['db']['local_recipe'])
  search(:node, "#{node['jmh_myjmh']['client']['db']['node_query']}") do |n|
    next unless node.environment == n.environment
    node.default['jmh_myjmh']['myjmh_command']['db_hostname']  =  n['cloud'] ? n['cloud']['public_hostname'] : n['ipaddress']
    break
  end
end

myjmhcommand_props = [ "epic.baseUrl=#{epic_config['interconnect']['protocol']}://#{epic_config['interconnect']['hostname']}/#{epic_config['interconnect']['context']}",
                       "epic.service.clientId=#{epic_config['interconnect']['clientid']}",
                       "jdbc.url=jdbc:mysql://#{node['jmh_myjmh']['myjmh_command']['db_hostname'] }/#{node['jmh_myjmh']['db']['database']}?verifyServerCertificate=false&useSSL=true&requireSSL=true",
                       "jdbc.username=#{node['jmh_myjmh']['myjmh_command']['db_user']}",
                       "jdbc.password=#{node['jmh_myjmh']['myjmh_command']['db_password']}"
                       ] + node['jmh_myjmh']['myjmh_command']['additional_properties']

template File.join(node['jmh_myjmh']['myjmh_command']['install_dir'], node['jmh_myjmh']['myjmh_command']['properties_file']) do
  source 'myjmh_command_properties.erb'
  mode '0600'
  user 'jmhbackup'
  variables(
      props: myjmhcommand_props
  )
end