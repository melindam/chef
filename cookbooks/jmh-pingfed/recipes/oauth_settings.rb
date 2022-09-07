#
# Cookbook Name:: jmh-pingfed
# Recipe:: oauth_settings
# Description:: setup oAuth client settings for PingFederate in JMH environment
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

ping_databag = Chef::EncryptedDataBagItem.load(node['jmh_pingfed']['databag']['name'], node['jmh_pingfed']['databag']['item'] )
admin_password = ping_databag['password']["#{node['jmh_server']['environment']}"] ? ping_databag['password']["#{node['jmh_server']['environment']}"] : ping_databag['password']['default']

base_curl="curl -u #{node['jmh_pingfed']['admin_user']}:#{admin_password} -k -H \"X-XSRF-Header: PingFederate\" "

epic_config = JmhEpic.get_epic_config(node)
mychart_name = epic_config['mychart']['sso_context']

### Server Settings - /serverSettings
# PUT
server_settings=File.join(Chef::Config[:file_cache_path],'server_settings.json')

template server_settings do
  source 'oauth/server_settings.erb'
  mode 0600
  action :create
  variables(
    :idp_base_url => node['jmh_pingfed']['idp']['server_name'],
    :saml2_entry_id => 'pingfed' + node['jmh_server']['environment']
  )
end

# execute with option "live_stream true" will allow for command to be shown
# execute will not show command when attribute ['jmh_pingfed']['execute_do_not_show_sensitive_data'] = true
execute "server_settings" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X PUT -d @#{server_settings} https://localhost:9999/pf-admin-api/v1/serverSettings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

# Get the basic auth from profile api server
profile_api_databag = EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['data_bag'][0],node['jmh_myjmh']['profile_api']['data_bag'][1])
if profile_api_databag['basic_auth'][node['jmh_server']['environment']]
  node.default['jmh_pingfed']['basic_auth'] = profile_api_databag['basic_auth'][node['jmh_server']['environment']]['hash']
else
  node.default['jmh_pingfed']['basic_auth'] = profile_api_databag['basic_auth']['default']['hash']
end

# PUT for id = RESTCROWD
# Between WellBe and FHIR the 'token' attributes were updated,
# so a PUT of the id=RESTCROWD is needed and use the API call /passwordCredentialValidators/{id}
password_cred_restcrowd=File.join(Chef::Config[:file_cache_path],'password_cred_restcrowd.json')

template password_cred_restcrowd do
  source 'oauth/password_cred_restcrowd.erb'
  mode 0600
  action :create
  variables(
    :api_server_name => node['jmh_pingfed']['api']['server'],
    :server_hostname => node['jmh_pingfed']['server_hostname'],
    :basic_auth => node['jmh_pingfed']['basic_auth']
  )
end

execute "password_cred_restcrowd" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X PUT -v -d @#{password_cred_restcrowd} https://localhost:9999/pf-admin-api/v1/passwordCredentialValidators/RESTCROWD"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### IDP adapters - /idp/adapters
## ID = httpform
# POST
idp_adapters_httpform=File.join(Chef::Config[:file_cache_path],'idp_adapters_httpform.json')

template idp_adapters_httpform do
  source 'oauth/idp_adapters_httpform.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "idp_adapters_httpform" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{idp_adapters_httpform} https://localhost:9999/pf-admin-api/v1/idp/adapters"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### IDP adapters - /idp/adapters
## ID = fhirhtmlform
# POST
idp_adapters_fhirhtmlform=File.join(Chef::Config[:file_cache_path],'idp_adapters_fhirhtmlform.json')

template idp_adapters_fhirhtmlform do
  source 'oauth/idp_adapters_fhirhtmlform.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :mychart_name => mychart_name,
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "idp_adapters_fhirhtmlform" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{idp_adapters_fhirhtmlform} https://localhost:9999/pf-admin-api/v1/idp/adapters"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


###  Authentication Selectors - /authenticationSelectors
## ID =  httpselector
# POST
auth_selectors_httpselector=File.join(Chef::Config[:file_cache_path],'auth_selectors_httpselector.json')

template auth_selectors_httpselector do
  source 'oauth/auth_selectors_httpselector.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "auth_selectors_httpselector" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{auth_selectors_httpselector} https://localhost:9999/pf-admin-api/v1/authenticationSelectors"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


###  Authentication Selectors - /authenticationSelectors
## ID =  setcookieselector
# POST
auth_selectors_setcookieselector=File.join(Chef::Config[:file_cache_path],'auth_selectors_setcookieselector.json')

template auth_selectors_setcookieselector do
  source 'oauth/auth_selectors_setcookieselector.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "auth_selectors_setcookieselector" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{auth_selectors_setcookieselector} https://localhost:9999/pf-admin-api/v1/authenticationSelectors"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### Authentication Policies Settings - /authenticationPolicies/settings
# PUT
auth_policies_settings=File.join(Chef::Config[:file_cache_path],'auth_policies_settings.json')

template auth_policies_settings do
  source 'oauth/auth_policies_settings.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "auth_policies_settings" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X PUT -v -d @#{auth_policies_settings} https://localhost:9999/pf-admin-api/v1/authenticationPolicies/settings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### Authentication Policy Contracts - /authenticationPolicyContracts
# POST
auth_policy_contracts=File.join(Chef::Config[:file_cache_path],'auth_policy_contracts.json')

template auth_policy_contracts do
  source 'oauth/auth_policy_contracts.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "auth_policy_contracts" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{auth_policy_contracts} https://localhost:9999/pf-admin-api/v1/authenticationPolicyContracts"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### Authentication Policies Default - /authenticationPolicies/default
# PUT
auth_policies_default=File.join(Chef::Config[:file_cache_path],'auth_policies_default.json')

template auth_policies_default do
  source 'oauth/auth_policies_default.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "auth_policies_default" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X PUT -v -d @#{auth_policies_default} https://localhost:9999/pf-admin-api/v1/authenticationPolicies/default"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### IDP Adapter Mappings - /oauth/idpAdapterMappings
## ID = httpform
# POST
oauth_idp_adapter_mappings_httpform=File.join(Chef::Config[:file_cache_path],'oauth_idp_adapter_mappings_httpform.json')

template oauth_idp_adapter_mappings_httpform do
  source 'oauth/oauth_idp_adapter_mappings_httpform.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_idp_adapter_mappings_httpform" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_idp_adapter_mappings_httpform} https://localhost:9999/pf-admin-api/v1/oauth/idpAdapterMappings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### IDP Adapter Mappings - /oauth/idpAdapterMappings
## ID = fhirhtmlform
# POST
oauth_idp_adapter_mappings_fhirhtmlform=File.join(Chef::Config[:file_cache_path],'oauth_idp_adapter_mappings_fhirhtmlform.json')

template oauth_idp_adapter_mappings_fhirhtmlform do
  source 'oauth/oauth_idp_adapter_mappings_fhirhtmlform.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_idp_adapter_mappings_fhirhtmlform" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_idp_adapter_mappings_fhirhtmlform} https://localhost:9999/pf-admin-api/v1/oauth/idpAdapterMappings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### Access Token Manager - /oauth/accessTokenManagers
## ID = PORTAL
# POST
oauth_access_token_mgrs_portal=File.join(Chef::Config[:file_cache_path],'oauth_access_token_mgrs_portal.json')

template oauth_access_token_mgrs_portal do
  source 'oauth/oauth_access_token_mgrs_portal.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_access_token_mgrs_portal" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_access_token_mgrs_portal} https://localhost:9999/pf-admin-api/v1/oauth/accessTokenManagers"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### oAuth Access Token Management Settings for DEFAULT - /oauth/accessTokenManagers/settings
# PUT
oauth_access_token_mgrs_settings=File.join(Chef::Config[:file_cache_path],'oauth_access_token_mgrs_settings.json')

template oauth_access_token_mgrs_settings do
  source 'oauth/oauth_access_token_mgrs_settings.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_access_token_mgrs_settings" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_access_token_mgrs_settings} https://localhost:9999/pf-admin-api/v1/oauth/accessTokenManagers/settings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### Access Token Manager - /oauth/accessTokenManagers
## ID =  WELLBE
# POST
oauth_access_token_mgrs_wellbe=File.join(Chef::Config[:file_cache_path],'oauth_access_token_mgrs_wellbe.json')

template oauth_access_token_mgrs_wellbe do
  source 'oauth/oauth_access_token_mgrs_wellbe.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_access_token_mgrs_wellbe" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_access_token_mgrs_wellbe} https://localhost:9999/pf-admin-api/v1/oauth/accessTokenManagers"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### Access Token Manager - /oauth/accessTokenManagers
## ID = FHIR
# POST
oauth_access_token_mgrs_fhir=File.join(Chef::Config[:file_cache_path],'oauth_access_token_mgrs_fhir.json')

template oauth_access_token_mgrs_fhir do
  source 'oauth/oauth_access_token_mgrs_fhir.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_access_token_mgrs_fhir" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_access_token_mgrs_fhir} https://localhost:9999/pf-admin-api/v1/oauth/accessTokenManagers"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### Access Token Mappings - /oauth/accessTokenMappings
## ID =  authz_req|httpform|PORTAL
# POST
oauth_access_token_mappings_portal=File.join(Chef::Config[:file_cache_path],'oauth_access_token_mappings_portal.json')

template oauth_access_token_mappings_portal do
  source 'oauth/oauth_access_token_mappings_portal.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :mychart_name => mychart_name,
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_access_token_mappings_portal" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_access_token_mappings_portal} https://localhost:9999/pf-admin-api/v1/oauth/accessTokenMappings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### Access Token Mappings - /pf-admin-api/v1/oauth/accessTokenMappings
## ID =  authz_req|httpform|WELLBE
# POST
oauth_access_token_mappings_wellbe=File.join(Chef::Config[:file_cache_path],'oauth_access_token_mappings_wellbe.json')

template oauth_access_token_mappings_wellbe do
  source 'oauth/oauth_access_token_mappings_wellbe.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :mychart_name => mychart_name,
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_access_token_mappings_wellbe" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_access_token_mappings_wellbe} https://localhost:9999/pf-admin-api/v1/oauth/accessTokenMappings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### Access Token Mappings - /pf-admin-api/v1/oauth/accessTokenMappings
## ID = authz_req|fhirhtmlform|FHIR
# POST
oauth_access_token_mappings_fhir=File.join(Chef::Config[:file_cache_path],'oauth_access_token_mappings_fhir.json')

template oauth_access_token_mappings_fhir do
  source 'oauth/oauth_access_token_mappings_fhir.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :mychart_name => mychart_name,
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_access_token_mappings_fhir" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_access_token_mappings_fhir} https://localhost:9999/pf-admin-api/v1/oauth/accessTokenMappings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### OAuth - Authorization Server Settings AND Scope Management - /oauth/authServerSettings
## ALL
# PUT
oauth_auth_server_settings=File.join(Chef::Config[:file_cache_path],'oauth_auth_server_settings.json')

template oauth_auth_server_settings do
  source 'oauth/oauth_auth_server_settings.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_auth_server_settings" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X PUT -v -d @#{oauth_auth_server_settings} https://localhost:9999/pf-admin-api/v1/oauth/authServerSettings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### oAuth OpenID Settings  - /oauth/openIdConnect/settings
# PUT
oauth_openidconnect_settings=File.join(Chef::Config[:file_cache_path],'oauth_openidconnect_settings.json')

template oauth_openidconnect_settings do
  source 'oauth/oauth_openidconnect_settings.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_openidconnect_settings" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X PUT -v -d @#{oauth_openidconnect_settings} https://localhost:9999/pf-admin-api/v1//oauth/openIdConnect/settings"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end


### oAuth OpenID Policies  - /oauth/openIdConnect/policies
## ID = OAuth
# POST
oauth_openidconnect_policies=File.join(Chef::Config[:file_cache_path],'oauth_openidconnect_policies.json')

template oauth_openidconnect_policies do
  source 'oauth/oauth_openidconnect_policies.erb'
  mode 0600
  action :create
  variables(
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_openidconnect_policies" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_openidconnect_policies} https://localhost:9999/pf-admin-api/v1/oauth/openIdConnect/policies"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end



### oAuth Client - /oauth/clients
## ID = JMH-SSO (PORTAL)
# POST
oauth_clients_jmh_sso=File.join(Chef::Config[:file_cache_path],'oauth_clients_jmh_sso.json')

template oauth_clients_jmh_sso do
  source 'oauth/oauth_clients_jmh_sso.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :client_secret => node['jmh_pingfed']['client_secret']['jmh_sso'],
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_clients_jmh_sso" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_clients_jmh_sso} https://localhost:9999/pf-admin-api/v1/oauth/clients"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### oAuth Client - /oauth/clients
## ID = WELLBE
# POST
oauth_clients_wellbe=File.join(Chef::Config[:file_cache_path],'oauth_clients_wellbe.json')

template oauth_clients_wellbe do
  source 'oauth/oauth_clients_wellbe.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :redirect_uris => node['jmh_pingfed']['redirect_uris']['wellbe'],
    :client_secret => node['jmh_pingfed']['client_secret']['wellbe'],
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_clients_wellbe" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_clients_wellbe} https://localhost:9999/pf-admin-api/v1/oauth/clients"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

### oAuth Client - /oauth/clients
## ID = FHIR
# POST
oauth_clients_fhir=File.join(Chef::Config[:file_cache_path],'oauth_clients_fhir.json')

template oauth_clients_fhir do
  source 'oauth/oauth_clients_fhir.erb'
  mode 0600
  action :create
  variables(
    :www_server_name => node['jmh_pingfed']['jmh']['server'],
    :mychart_name => mychart_name,
    :server_hostname => node['jmh_pingfed']['server_hostname']
  )
end

execute "oauth_clients_fhir" do
  command "#{base_curl} -H \"Content-Type: application/json\" -X POST -v -d @#{oauth_clients_fhir} https://localhost:9999/pf-admin-api/v1/oauth/clients"
  sensitive node['jmh_pingfed']['execute_do_not_show_sensitive_data']
  action :run
end

