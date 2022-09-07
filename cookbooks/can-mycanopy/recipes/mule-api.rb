
# Cookbook Name:: can-mycanopy
# Recipe:: mule-api
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Mulesoft installation for canopy api

# Search for node which has openldap recipe
openldap_server = 'localhost'
mule_password = ''
if Chef::Config[:solo]
  Chef::Log.warn('This recipe does not support solo search')
else
  search(:node, node['can_mycanopy']['openldap']['node_query']) do |n|
    if n.environment == node.environment
      openldap_server = (n['ipaddress'] == node['ipaddress']) ? '127.0.0.1' : n['ipaddress']
      mule_password = n['can_mycanopy']['openldap']['service_accounts']['mule']['password']
      break
    end
  end
end

include_recipe 'can-mycanopy::hostsfile_canopyhealth_servers'
canopy_databag = Chef::EncryptedDataBagItem.load(node['can_mycanopy']['ucsf']['mdm']['databag']['name'] ,node['can_mycanopy']['ucsf']['mdm']['databag']['item'] )
mdm_password = %w(prod stage).include?(node['jmh_server']['environment']) ? canopy_databag['mdm']['prod'] : canopy_databag['mdm']['dev']
proxy_password = %w(prod stage).include?(node['jmh_server']['environment']) ? canopy_databag['proxy']['prod'] : canopy_databag['proxy']['dev']


mule_properties = ['# Mule API properties']
mule_properties.push("idp.host=#{node['cam_mycanopy']['pingfederate']['server_name']}",
                     'idp.port=9031',
                     'idp.client_id=canopy-portal',
                     'idp.client_secret=DXd7Q9mjz6yYfkEDGdfbzP6mayIo4aOcuDTFJARixBHXwRGITI6lSNa7dO5JAKBy',
                     'idp.keystore.password=2Federate',
                     "ldap.protocol=#{node['can_mycanopy']['openldap']['connect_protocol']}",
                     "ldap.host=#{openldap_server}",
                     "ldap.port=#{node['can_mycanopy']['openldap']['connect_port']}",
                     "ldap.password=#{mule_password}",
                     "ldap.authDN=#{node['can_mycanopy']['openldap']['service_accounts']['mule']['dn']}",
                     "ldap.baseDN=#{node['openldap']['basedn']}",
                     "jmh.services.host=#{node['can_mycanopy']['jmh']['server']}",
                     "jmh.services.port=443",
                     "jmh.services.basepath=/api/v1.0",
                     "oauth.token.canopy.idp.jwt.key=#{node['can_mycanopy']['client']['jwt_key_secret']}",
                     "oauth.token.ucsf.idp.jwt.key=#{node['can_mycanopy']['ucsf']['jwt_key_secret']}",
                     "oauth.token.jmh.idp.jwt.key=#{node['can_mycanopy']['jmh']['jwt_key_secret']}",
                     # "ucsf.services.host=#{node['can_mycanopy']['ucsf']['interconnect_host']}",
                     "epicapi.ucsf.host=#{node['can_mycanopy']['ucsf']['interconnect_host']}",
                     "epicapi.jmh.host=#{node['can_mycanopy']['ucsf']['interconnect_host']}",
                     "registration.email.verification.baseurl=#{node['can_mycanopy']['client']['url_client']}",
                     "eligibility.import.input.path=#{node['can_mycanopy']['mule']['in_path']}",
                     "eligibility.import.output.path=#{node['can_mycanopy']['mule']['out_path']}",
                     "mdmapi.ws.location=/ibminitiatews/services/IdentityHub",
                     "mdmapi.ws.user=#{node['can_mycanopy']['ucsf']['mdm']['portal_user']}",
                     "mdmapi.ws.password=#{mdm_password}",
                     "mdmapi.ws.proxy.host=#{node['can_mycanopy']['ucsf']['mdm']['proxy_server']}",
                     "mdmapi.ws.proxy.user=#{node['can_mycanopy']['ucsf']['mdm']['proxy_user']}",
                     "mdmapi.ws.proxy.password=#{proxy_password}")

jmh_mule node['can_mycanopy']['mule']['name'] do
  name node['can_mycanopy']['mule']['name']
  app_properties mule_properties
  iptables node['can_mycanopy']['mule']['iptables']
  directories node['can_mycanopy']['mule']['directories']
end

jmh_utilities_install_jvm_certificate "Install OpenLDAP Cert" do
  java_home JmhJavaUtil.get_java_home(node['jmh_mule']['java_version'], node)
  cert_name node['can_mycanopy']['openldap']['ssl_cert_name']
  data_bag node['can_mycanopy']['openldap']['databag']['name']
  data_bag_item node['can_mycanopy']['openldap']['databag']['item']
  data_bag_field node['can_mycanopy']['openldap']['databag']['cert_field_name']
end
