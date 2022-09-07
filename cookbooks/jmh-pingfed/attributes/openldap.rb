# OpenLDAP
default['jmh_pingfed']['openldap']['iptables'] = { 'portlist' => { '389' => { 'target' => 'ACCEPT' },
                                                                    '636' => { 'target' => 'ACCEPT' } } }
default['jmh_pingfed']['openldap']['connect_port'] = '636'
default['jmh_pingfed']['openldap']['connect_protocol'] = 'ldaps'
default['jmh_pingfed']['openldap']['custom_schemas'] = ['canopy.schema']
default['jmh_pingfed']['openldap']['node_query'] = 'recipes:jmh-pingfed\:\:openldap'
default['jmh_pingfed']['openldap']['service_accounts']['mule']['dn'] = 'cn=mule,ou=serviceaccounts,dc=canopyhealth,dc=com'
default['jmh_pingfed']['openldap']['service_accounts']['pingfed']['dn'] = 'cn=pingfed,ou=serviceaccounts,dc=canopyhealth,dc=com'
default['jmh_pingfed']['openldap']['databag']['name'] = 'jmh_apps'
default['jmh_pingfed']['openldap']['databag']['item'] = 'canopy'
default['jmh_pingfed']['openldap']['ssl_cert_name'] = 'canopy_openldap'
default['jmh_pingfed']['openldap']['databag']['key_field_name'] = 'openldap_ssl_key'
default['jmh_pingfed']['openldap']['databag']['cert_field_name'] = 'openldap_ssl_pem'
default['jmh_pingfed']['openldap']['node_query'] = 'recipes:jmh-pingfed\:\:openldap'
default['jmh_pingfed']['openldap']['server_name'] = 'openldap.canopyhealth.local'

default['openldap']['manage_ssl'] = false
default['openldap']['tls_enabled'] = true
default['openldap']['ssl_cert_source_path'] = 'openldap/ldap.cert'
default['openldap']['ssl_cert_source_cookbook'] = 'jmh-pingfed'
default['openldap']['ssl_key_source_path'] = 'openldap/newreq.pem'
default['openldap']['ssl_key_source_cookbook'] = 'jmh-pingfed'
default['openldap']['basedn'] = 'dc=johnmuirhealth,dc=com'
default['openldap']['cn'] = 'admin'
default['openldap']['tls_enabled'] = true
default['openldap']['slapd_conf']['cookbook'] = 'jmh-pingfed'
default['openldap']['schemas'] = %w(core.schema cosine.schema nis.schema inetorgperson.schema).concat(node['jmh_pingfed']['openldap']['custom_schemas'])