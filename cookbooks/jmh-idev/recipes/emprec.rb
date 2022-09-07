# DEPRECATED #

include_recipe 'jmh-utilities::hostsfile_crowd_servers'

catalina_properties = ['# JMH emprec Properties']
catalina_properties.push("# Dropped off by Chef")

node.default['jmh_idev']['appserver']['emprec']['catalina_properties'] = catalina_properties

# TODO put the value for enable_ssl node['jmh_idev']['appserver']['emprec']['enable_ssl']
jmh_tomcat node['jmh_idev']['appserver']['emprec']['name'] do
  enable_http node['jmh_idev']['appserver']['emprec']['enable_http']
  java_version node['jmh_idev']['appserver']['emprec']['java_version']
  port node['jmh_idev']['appserver']['emprec']['port']
  shutdown_port node['jmh_idev']['appserver']['emprec']['shutdown_port']
  jmx_port node['jmh_idev']['appserver']['emprec']['jmx_port']
  ajp_port node['jmh_idev']['appserver']['emprec']['ajp_port']
  iptables node['jmh_idev']['appserver']['emprec']['iptables']
  version node['jmh_idev']['appserver']['emprec']['version']
  rollout_array node['jmh_idev']['appserver']['emprec']['rollout_array']
  catalina_properties node['jmh_idev']['appserver']['emprec']['catalina_properties']
  action :create
end

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['jmh_idev']['emprec']['db']['password'] = random_password unless node['jmh_idev']['emprec']['db']['password']

jmh_db_database node['jmh_idev']['emprec']['db']['name'] do
  database node['jmh_idev']['emprec']['db']['name']
  action :create
end

# Create a hash to store our connection informtion
mysql_con_info = {
    :host =>  '127.0.0.1',
    :username => 'root',
    :password => node['mysql']['server_root_password'],
    :default_file => node['jmh_db']['default_file']
}

# LWRP provided via database cookbook to create DB user
mysql_database_user node['jmh_idev']['emprec']['db']['username'] do
  connection mysql_con_info
  password node['jmh_idev']['emprec']['db']['password']
  database_name node['jmh_idev']['emprec']['db']['name']
  privileges node['jmh_idev']['emprec']['db']['privileges']
  host node['jmh_idev']['emprec']['db']['host_connections']
  require_ssl false
  action :grant
end
