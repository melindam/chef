include_recipe 'jmh-utilities::hostsfile_crowd_servers'

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['jmh_idev']['mdsuspension']['db']['password'] = random_password unless node['jmh_idev']['mdsuspension']['db']['password']

jmh_db_database node['jmh_idev']['mdsuspension']['db']['name'] do
  database node['jmh_idev']['mdsuspension']['db']['name']
  action :create
end

# only know it to be a local mysql db, so just make a local user
jmh_db_user node['jmh_idev']['mdsuspension']['db']['username'] do
  username node['jmh_idev']['mdsuspension']['db']['username']
  password node['jmh_idev']['mdsuspension']['db']['password']
  database node['jmh_idev']['mdsuspension']['db']['name']
  privileges node['jmh_idev']['mdsuspension']['db']['privileges']
  connect_over_ssl node['jmh_idev']['mdsuspension']['db']['connect_over_ssl']
  action :create
end

# create the developer testing user
jmh_db_mysql_local_user node['jmh_idev']['mdsuspension']['db']['developer_user'] do
  username node['jmh_idev']['mdsuspension']['db']['developer_user']
  database node['jmh_idev']['mdsuspension']['db']['name']
  password node['jmh_idev']['mdsuspension']['db']['developer_password']
  host_connection '%'
  privileges [:all]
  action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
end


idev_bag = Chef::EncryptedDataBagItem.load(node['jmh_idev']['data_bag'],node['jmh_idev']['data_bag_item'])

catalina_opts = Array.new
catalina_opts.push("application.password=#{idev_bag['mdsuspension']['crowd_password'][node['jmh_idev']['mdsuspension']['crowd_password_key']]}")
node['jmh_idev']['mdsuspension']['crowd'].each do |crowd_prop, crowd_value|
  catalina_opts.push("#{crowd_prop}=#{crowd_value}")
end

node.default['jmh_idev']['appserver']['mdsuspension']['catalina_properties'] = catalina_opts

jmh_tomcat node['jmh_idev']['appserver']['mdsuspension']['name'] do
  enable_http node['jmh_idev']['appserver']['mdsuspension']['enable_http']
  enable_ssl node['jmh_idev']['appserver']['mdsuspension']['enable_ssl']
  java_version node['jmh_idev']['appserver']['mdsuspension']['java_version']
  port node['jmh_idev']['appserver']['mdsuspension']['port']
  shutdown_port node['jmh_idev']['appserver']['mdsuspension']['shutdown_port']
  jmx_port node['jmh_idev']['appserver']['mdsuspension']['jmx_port']
  iptables node['jmh_idev']['appserver']['mdsuspension']['iptables']
  version node['jmh_idev']['appserver']['mdsuspension']['version']
  rollout_array node['jmh_idev']['appserver']['mdsuspension']['rollout_array']
  catalina_opts node['jmh_idev']['appserver']['mdsuspension']['catalina_opts']
  catalina_properties node['jmh_idev']['appserver']['mdsuspension']['catalina_properties']
  action :create
end

jmh_crowd_install_certificate 'Install Crowd cert mdsuspension' do
  java_home JmhJavaUtil.get_java_home(node['jmh_idev']['appserver']['mdsuspension']['java_version'], node)
  action :create
end