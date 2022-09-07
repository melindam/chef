# Client
default['can_mycanopy']['client']['user'] = 'jmhbackup'
default['can_mycanopy']['client']['app_name'] = 'canopy-client'
default['can_mycanopy']['client']['misc_dir'] = File.join('/home', node['can_mycanopy']['client']['user'], 'canopy-misc')
default['can_mycanopy']['client']['docroot'] = '/var/www/html'
default['can_mycanopy']['client']['url'] = case node['jmh_server']['environment']
                                           when 'prod'
                                             'https://www.canopyhealth.com'
                                           when 'stage'
                                             'https://stage.canopyhealth.com'
                                           when 'dev'
                                             'https://www-dev.canopyhealth.com'
                                           else
                                             'https://www-sbx.canopyhealth.com'
                                           end
default['can_mycanopy']['jmh']['server'] = case node['jmh_server']['environment']
                                           when 'prod'
                                             'www.johnmuirhealth.com'
                                           when 'stage'
                                             'stage.johnmuirhealth.com'
                                           when 'dev'
                                             'www-dev.johnmuirhealth.com'
                                           else
                                             'www-sbx.johnmuirhealth.com'
                                           end  
default['can_mycanopy']['ucsf']['server'] = case node['jmh_server']['environment']
                                            when 'prod','stage'
                                             'ucsf.canopyhealth.com'
                                            else
                                             'ucsf-dev.canopyhealth.com'
                                           end  

                                                                            
default['can_mycanopy']['client']['production_mode'] = node['jmh_server']['environment'] == 'sbx' ? false : true
default['can_mycanopy']['client']['url_api'] = ::File.join(node['can_mycanopy']['client']['url'], 'api')
default['can_mycanopy']['client']['url_idp'] =  ::File.join(node['can_mycanopy']['client']['url'], 'as')
default['can_mycanopy']['client']['url_sapi'] =  ::File.join(node['can_mycanopy']['client']['url'], 'sapi')
default['can_mycanopy']['client']['url_idp_logout'] =  ::File.join(node['can_mycanopy']['client']['url'], 'ext/signout')
default['can_mycanopy']['client']['url_client'] = ::File.join(node['can_mycanopy']['client']['url'], 'canopy-client')
default['can_mycanopy']['client']['url_idp_return_uri'] =  ::File.join(node['can_mycanopy']['client']['url_client'], 'login/callback')

# TODO make this into encrypted data bag
default['can_mycanopy']['ucsf']['jwt_key_secret'] = case node['jmh_server']['environment']
                                                    when 'prod', 'stage'
                                                      'BLANK NEED TO CREATE'
                                                    when 'dev'
                                                      'NlhoeDlvd3BTMWhabGhiMzlmaDI5QXBUSERkdzkzMmhTQjE0ZnhsMjQ='
                                                    else                                                   
                                                      'MDEyMzQ1Njc4OTBsdW1pMDEyMzQ1Njc4OTBsdW1pMDEyMzQ1Njc4OTBsdW1p'
                                                    end 
                                                    
default['can_mycanopy']['jmh']['jwt_key_secret'] = case node['jmh_server']['environment']
                                                    when 'prod', 'stage'
                                                      'BLANK NEED TO CREATE'
                                                    else
                                                      'MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2'
                                                    end
default['can_mycanopy']['ucsf']['interconnect_host'] = case node['jmh_server']['environment']
                                                    when 'prod', 'stage'
                                                      "ucsf.canopyhealth.com/interconnect-jmh"
                                                    when 'dev'
                                                      # "qcapexwic805.ucsfmedicalcenter.org/interconnect-jmhtst"
                                                      "epicinterxvbld1.hsys.local/Interconnect-TSTXV-eBiz"
                                                    else                                                   
                                                      # "qcapexwic805.ucsfmedicalcenter.org/interconnect-jmhpoc"
                                                      "epicinterxvbld1.hsys.local/Interconnect-POC-eBiz"
                                                    end
# TODO make this into encrypted data bag
default['can_mycanopy']['client']['jwt_key_secret'] = case node['jmh_server']['environment']
                                                    when 'prod', 'stage'
                                                      'BLANK NEED TO CREATE'
                                                    when 'dev'
                                                      'MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2MTIzNDU2'
                                                    else
                                                      'MDEyMzQ1Njc4OTBsdW1pMDEyMzQ1Njc4OTBsdW1pMDEyMzQ1Njc4OTBsdW1p'
                                                    end  
default['can_mycanopy']['jmh']['mychart'] = case node['jmh_server']['environment']
                                            when 'prod', 'stage'
                                              'https://epicmychartprd.hsys.local/MyChartCanopyPRD/inside.asp'
                                            when 'dev'
                                              'https://epicmchrtxvbld1.hsys.local/MyChartCanopyTST/inside.asp'
                                            else
                                              'https://epicmchrtxvbld1.hsys.local/MyChartCanopyPOC/inside.asp'
                                            end
default['can_mycanopy']['jmh']['federated_base'] = ::File.join('https://', node['can_mycanopy']['jmh']['server'], 'myjmh-client')
default['can_mycanopy']['ucsf']['federated_base'] =  case node['jmh_server']['environment']
                                                  when 'prod', 'stage'
                                                    ::File.join('https://', node['can_mycanopy']['ucsf']['server'] + '/mychartPRD/inside.asp')
                                                  else 
                                                    'https://ucsf-dev-mychart.canopyhealth.com/mycharttst/inside.asp'
                                                  end
default['can_mycanopy']['ucsf']['tiled_mychart'] =  case node['jmh_server']['environment']
                                                    when 'prod', 'stage'
                                                      ::File.join('https://', node['can_mycanopy']['ucsf']['server'] + '/mychartPRD/inside.asp')
                                                    else 
                                                      ::File.join('https://', node['can_mycanopy']['ucsf']['server'] + '/mycharttst/inside.asp')
                                                    end 
                                                                                                                                                
default['can_mycanopy']['client']['disable_login'] = 'false'
default['can_mycanopy']['client']['cookie_domain'] = 'canopyhealth.com'
default['can_mycanopy']['client']['cookie_name'] = 'AUTH_TOKEN'
default['can_mycanopy']['client']['cookie_expiration'] = '10'
default['can_mycanopy']['client']['mock_api'] = 'false'
default['can_mycanopy']['client']['federations'] = [
  { 'name' => 'jmh',
    'description' => 'MyJohnMuirHealth',
    'url_redirect' => node['can_mycanopy']['client']['url_idp'] +
                      '/authorization.oauth2?client_id=jmh-portal&response_type=token&scope=edit',
    'url_federated_base' => node['can_mycanopy']['jmh']['federated_base'],
    'url_federated_landing' => '/dashboard',
    'url_tile' => node['can_mycanopy']['jmh']['mychart'],
    'auth_cookie_name' => 'JMH_AUTH_TOKEN'
   },
  { 'name' => 'ucsf',
    'description' => 'UCSF MyChart',
    'url_redirect' =>  node['can_mycanopy']['client']['url_idp'] +
                       '/authorization.oauth2?client_id=ucsf-portal&response_type=token&scope=edit',
    'url_federated_base' => node['can_mycanopy']['ucsf']['federated_base'],
    'url_federated_landing' => '?mode=messages&mbox=1',
    'url_tile' => node['can_mycanopy']['ucsf']['tiled_mychart'],
    'auth_cookie_name' => 'UCSF_AUTH_TOKEN'
  },
  { 'name' => 'hill',
    'description' => 'Hill Physicians',
    'url_redirect' => node['can_mycanopy']['client']['url_idp'] +
                      '/the_ping_url_for_redirecting_to_hill',
    'url_federated_base' => 'https://hillphysician.com/mychart/inside.asp',         
    'url_federated_landing'  => "?mode=messages&mbox=1",
    'url_tile' => "https://bcho-dev.canopyhealth.com/mycharttst/inside.asp",
    'auth_cookie_name' => "BCHO_AUTH_TOKEN"
  }
]


# API - Mule
default['can_mycanopy']['mule']['name'] = 'api'
default['can_mycanopy']['mule']['path'] = ::File.join(node['jmh_mule']['target'], node['can_mycanopy']['mule']['name'])
default['can_mycanopy']['mule']['in_path'] = node['can_mycanopy']['mule']['path'] + '/import/in'
default['can_mycanopy']['mule']['out_path'] = node['can_mycanopy']['mule']['path'] + '/import/out'
default['can_mycanopy']['mule']['directories'] = [ node['can_mycanopy']['mule']['in_path'], node['can_mycanopy']['mule']['out_path'] ]
default['can_mycanopy']['mule']['iptables'] = { '7777' => { 'target' => 'ACCEPT' },
                                                '8100' => { 'target' => 'ACCEPT' },
                                                '8101' => { 'target' => 'ACCEPT' } }

# MDM
default['can_mycanopy']['ucsf']['mdm']['proxy_server'] = case node['jmh_server']['environment']
                                                when 'prod','stage'
                                                  'TO_BE_DETERMINED'
                                                else
                                                  'vip-canopyhealthdev.ucsfmedicalcenter.org'
                                                end
default['can_mycanopy']['ucsf']['mdm']['databag']['name'] = 'jmh_apps'
default['can_mycanopy']['ucsf']['mdm']['databag']['item'] = 'canopy'
default['can_mycanopy']['ucsf']['mdm']['databag']['item_name'] = 'mdm'
default['can_mycanopy']['ucsf']['mdm']['portal_user'] =  'portaluser'
default['can_mycanopy']['ucsf']['mdm']['proxy_user'] = 'canopyhealth'

# OpenLDAP
default['can_mycanopy']['openldap']['iptables'] = { 'portlist' => { '389' => { 'target' => 'ACCEPT' },
                                                                    '636' => { 'target' => 'ACCEPT' } } }
default['can_mycanopy']['openldap']['connect_port'] = '636'
default['can_mycanopy']['openldap']['connect_protocol'] = 'ldaps'
default['can_mycanopy']['openldap']['custom_schemas'] = ['canopy.schema']
default['can_mycanopy']['openldap']['node_query'] = 'recipes:can-mycanopy\:\:openldap'
default['can_mycanopy']['openldap']['service_accounts']['mule']['dn'] = 'cn=mule,ou=serviceaccounts,dc=canopyhealth,dc=com'
default['can_mycanopy']['openldap']['service_accounts']['pingfed']['dn'] = 'cn=pingfed,ou=serviceaccounts,dc=canopyhealth,dc=com'
default['can_mycanopy']['openldap']['databag']['name'] = 'jmh_apps'
default['can_mycanopy']['openldap']['databag']['item'] = 'canopy'
default['can_mycanopy']['openldap']['ssl_cert_name'] = 'canopy_openldap'
default['can_mycanopy']['openldap']['databag']['key_field_name'] = 'openldap_ssl_key'
default['can_mycanopy']['openldap']['databag']['cert_field_name'] = 'openldap_ssl_pem'
default['can_mycanopy']['openldap']['node_query'] = 'recipes:can-mycanopy\:\:openldap'
default['cam_mycanopy']['openldap']['server_name'] = 'openldap.canopyhealth.local'

default['openldap']['manage_ssl'] = false
default['openldap']['tls_enabled'] = true
default['openldap']['ssl_cert_source_path'] = 'openldap/ldap.cert'
default['openldap']['ssl_cert_source_cookbook'] = 'can-mycanopy'
default['openldap']['ssl_key_source_path'] = 'openldap/newreq.pem'
default['openldap']['ssl_key_source_cookbook'] = 'can-mycanopy'
default['openldap']['basedn'] = 'dc=canopyhealth,dc=com'
default['openldap']['cn'] = 'admin'
default['openldap']['tls_enabled'] = true
default['openldap']['slapd_conf']['cookbook'] = 'can-mycanopy'
default['openldap']['schemas'] = %w(core.schema cosine.schema nis.schema inetorgperson.schema).concat(node['can_mycanopy']['openldap']['custom_schemas'])

# Pingfederate
default['can_mycanopy']['pingfederate']['java_version'] = '8'
default['can_mycanopy']['pingfederate']['license_file'] = node['jmh_server']['environment'] == 'prod' ? 'production.lic' : 'development.lic'
default['can_mycanopy']['pingfederate']['iptables'] = { 'portlist' => { '9999' => { 'target' => 'ACCEPT' },
                                                                        '9031' => { 'target' => 'ACCEPT' } } }
default['can_mycanopy']['pingfederate']['node_query'] = 'recipes:can-mycanopy\:\:pingfederate'
default['cam_mycanopy']['pingfederate']['server_name'] = 'pingfed-local.canopyhealth.com'
default['pingfed']['java_home'] = JmhJavaUtil.get_java_home(node['can_mycanopy']['pingfederate']['java_version'], node)