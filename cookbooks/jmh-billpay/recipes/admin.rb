if node['jmh_billpay']['admin']['db']['password'].nil?
  app_databag = Chef::EncryptedDataBagItem.load('jmh_apps','billpay-admin')
  password_key =  case node['jmh_server']['environment']
                  when 'prod'
                    'prod_password'
                  when 'stage'
                    'stage_password'
                  else
                    'dev_password'
                  end
  node.normal['jmh_billpay']['admin']['db']['password'] = app_databag[password_key]  
end

jmh_tomcat node['jmh_billpay']['admin']['appserver']['name'] do
  name node['jmh_billpay']['admin']['appserver']['name']
  java_version node['jmh_billpay']['admin']['appserver']['java_version']
  max_heap_size node['jmh_billpay']['admin']['appserver']['max_heap_size']
  port node['jmh_billpay']['admin']['appserver']['port']
  thread_stack_size node['jmh_billpay']['admin']['appserver']['thread_stack_size']
  shutdown_port node['jmh_billpay']['admin']['appserver']['shutdown_port']
  jmx_port node['jmh_billpay']['admin']['appserver']['jmx_port']
  ssl_port node['jmh_billpay']['admin']['appserver']['ssl_port']
  ajp_port node['jmh_billpay']['admin']['appserver']['ajp_port']
  jmx_port node['jmh_billpay']['admin']['appserver']['jmx_port']
  iptables node['jmh_billpay']['admin']['appserver']['iptables']
  enable_ssl node['jmh_billpay']['admin']['appserver']['enable_ssl']
  action :create
end

include_recipe 'jmh-utilities::hostsfile_crowd_servers'

jmh_crowd_install_certificate "Billpay admin - Install Crowd cert in jre" do
    java_home JmhJavaUtil.get_java_home(node['jmh_billpay']['admin']['appserver']['java_version'], node)
    action :create
end

if node['test_run']
  log "NOTHING TO DO ON CHEF-ZERO for remote db calls"
else  
  jmh_db_user 'billpay_admin_user' do
    database node['jmh_billpay']['db']['database']
    username node['jmh_billpay']['admin']['db']['username']
    password node['jmh_billpay']['admin']['db']['password']
    parent_node_query node['jmh_billpay']['admin']['db']['node_query']
    privileges node['jmh_billpay']['admin']['db']['privileges']
    connect_over_ssl node['jmh_billpay']['admin']['db']['connect_over_ssl']
  end
end

