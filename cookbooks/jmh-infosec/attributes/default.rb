default['neprofile']['db']['database'] = 'neprofile'

default['neprofile']['openldap']['databag']['name'] = 'jmh_apps'
default['neprofile']['openldap']['databag']['item'] = 'canopy'
default['neprofile']['openldap']['ssl_cert_name'] = 'canopy_openldap'
default['neprofile']['openldap']['databag']['key_field_name'] = 'openldap_ssl_key'
default['neprofile']['openldap']['databag']['cert_field_name'] = 'openldap_ssl_pem'
default['neprofile']['openldap']['custom_schemas'] = nil
default['neprofile']['openldap']['seedfile'] = 'neprofile-seed.ldif'
default['neprofile']['openldap']['iptables'] = { 'portlist' => { '389' => { 'target' => 'ACCEPT' },
                                                                    '636' => { 'target' => 'ACCEPT' } } }
default['openldap']['ldaps_enabled'] = true
default['openldap']['tls_enabled'] = true
default['openldap']['certs_folder'] = "/etc/openldap/certs"
default['openldap']['tls_cert'] = "#{node['openldap']['certs_folder']}/ldap.cert"
default['openldap']['tls_key'] = "#{node['openldap']['certs_folder']}/ldap.pem"
default['openldap']['basedn'] = 'o=neaccess'
default['openldap']['cn'] = 'admin'
default['openldap']['slapd_conf']['cookbook'] = 'jmh-infosec'
default['openldap']['schemas'] = %w(core.schema cosine.schema nis.schema inetorgperson.schema)

default['iis']['accept_eula'] = true
