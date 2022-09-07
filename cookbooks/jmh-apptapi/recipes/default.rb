#
# Cookbook Name:: jmh-apptapi
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'jmh-utilities::hostsfile_epic_servers'

jwt_databag = Chef::EncryptedDataBagItem.load(node['jmh_apptapi']['jwt']['databag_name'], node['jmh_apptapi']['jwt']['databag_item'])

jvm_key_variables = ['# Begin Depreciate ZocDoc RSA Variables',
                     "apptapi.jmh.zocdoc.private.key=#{File.join(node['jmh_apptapi']['zocdoc']['key_dir'], node['jmh_apptapi']['zocdoc']['private_ssh_key']['name']) + '.der'}",
                     "apptapi.zocdoc.public.key=#{File.join(node['jmh_apptapi']['zocdoc']['key_dir'], node['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['name']) + '.der'}",
                     "apptapi.jwt.key=#{jwt_databag[node['jmh_apptapi']['jwt']['databag_key_name']]}",
                     '# End Depreciate ZocDoc RSA Variables',
                     "# JWT Vendor Properties",
                     "com.johnmuirhealth.jwt.clients=zocdoc",
                     "com.johnmuirhealth.jwt.zocdoc.tokenkey=#{jwt_databag[node['jmh_apptapi']['jwt']['databag_key_name']]}",
                     "com.johnmuirhealth.jwt.zocdoc.publickey.path=#{File.join(node['jmh_apptapi']['zocdoc']['key_dir'], node['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['name']) + '.der'}",
                     "com.johnmuirhealth.jwt.jmh.privatekey.path=#{File.join(node['jmh_apptapi']['zocdoc']['key_dir'], node['jmh_apptapi']['zocdoc']['private_ssh_key']['name']) + '.der'}"     
                     ]

# Epic Services
include_recipe 'jmh-epic::java_properties'
node.default['jmh_apptapi']['appserver']['catalina_properties'] = node['jmh_epic']['java_properties'] +
                                                                  jvm_key_variables


jmh_tomcat node['jmh_apptapi']['appserver']['name'] do
  name node['jmh_apptapi']['appserver']['name']
  java_version node['jmh_apptapi']['appserver']['java_version']
  max_heap_size node['jmh_apptapi']['appserver']['max_heap_size']
  port node['jmh_apptapi']['appserver']['port']
  thread_stack_size node['jmh_apptapi']['appserver']['thread_stack_size']
  shutdown_port node['jmh_apptapi']['appserver']['shutdown_port']
  jmx_port node['jmh_apptapi']['appserver']['jmx_port']
  ssl_port node['jmh_apptapi']['appserver']['ssl_port']
  ajp_port node['jmh_apptapi']['appserver']['ajp_port']
  jmx_port node['jmh_apptapi']['appserver']['jmx_port']
  iptables node['jmh_apptapi']['appserver']['iptables']
  catalina_properties node['jmh_apptapi']['appserver']['catalina_properties']
  directories node['jmh_apptapi']['appserver']['directories']
  action :create
end

# Install the keys for jvm transfer
directory '/usr/local/webapps/apptapi/keys' do
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  mode '0700'
  action :create
end

jmh_utilities_pem_to_der node['jmh_apptapi']['zocdoc']['private_ssh_key']['name'] do
  databag_name node['jmh_apptapi']['zocdoc']['private_ssh_key']['databag_name']
  databag_item node['jmh_apptapi']['zocdoc']['private_ssh_key']['databag_item']
  databag_key_name node['jmh_apptapi']['zocdoc']['private_ssh_key']['databag_key_name']
  secure_databag node['jmh_apptapi']['zocdoc']['private_ssh_key']['secure_databag']
  public_key false
  path node['jmh_apptapi']['zocdoc']['key_dir']
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  action :create
end

jmh_utilities_pem_to_der node['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['name'] do
  databag_name node['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['databag_name']
  databag_item node['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['databag_item']
  databag_key_name node['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['databag_key_name']
  secure_databag node['jmh_apptapi']['zocdoc']['public_zocdoc_ssh_key']['secure_databag']
  public_key true
  path node['jmh_apptapi']['zocdoc']['key_dir']
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  action :create
end
