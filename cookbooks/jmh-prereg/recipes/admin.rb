if node['jmh_prereg']['admin']['db']['password'].nil?
  app_databag = Chef::EncryptedDataBagItem.load('jmh_apps','prereg-admin')
  password_key =  case node['jmh_server']['environment']
                  when 'prod'
                    'prod_password'
                  when 'stage'
                    'stage_password'
                  else
                    'dev_password'
                  end
  node.normal['jmh_prereg']['admin']['db']['password'] = app_databag[password_key]  
end

jmh_tomcat 'prereg-admin' do
  name node['jmh_prereg']['admin']['appserver']['name']
  java_version node['jmh_prereg']['admin']['appserver']['java_version']
  max_heap_size node['jmh_prereg']['admin']['appserver']['max_heap_size']
  max_permgen node['jmh_prereg']['admin']['appserver']['max_permgen']
  thread_stack_size node['jmh_prereg']['admin']['appserver']['thread_stack_size']
  catalina_opts node['jmh_prereg']['admin']['appserver']['catalina_opts']
  port node['jmh_prereg']['admin']['appserver']['port']
  jmx_port node['jmh_prereg']['admin']['appserver']['jmx_port']
  ssl_port node['jmh_prereg']['admin']['appserver']['ssl_port']
  jmx_port node['jmh_prereg']['admin']['appserver']['jmx_port']
  shutdown_port node['jmh_prereg']['admin']['appserver']['shutdown_port']
  iptables node['jmh_prereg']['admin']['appserver']['iptables']
  directories node['jmh_prereg']['admin']['appserver']['directories']
  version node['jmh_prereg']['admin']['appserver']['version']
  exec_start_pre node['jmh_prereg']['admin']['appserver']['exec_start_pre']
  action :create
end

jmh_crowd_install_certificate "Prereg admin - Install Crowd cert in jre" do
    java_home JmhJavaUtil.get_java_home(node['jmh_prereg']['admin']['appserver']['java_version'], node)
    action :create
end

if node['test_run']
  log "NOTHING TO DO ON CHEF-ZERO for remote db calls"
else  
  jmh_db_user 'prereg_admin_user' do
    database node['jmh_prereg']['client']['database']
    username node['jmh_prereg']['admin']['db']['username']
    password node['jmh_prereg']['admin']['db']['password']
    parent_node_query node['jmh_prereg']['admin']['db']['node_query']
    privileges node['jmh_prereg']['admin']['db']['privileges'] if node['jmh_prereg']['admin']['db']['privileges']
    connect_over_ssl node['jmh_prereg']['admin']['db']['connect_over_ssl']
  end
end

include_recipe 'jmh-utilities::hostsfile_crowd_servers'