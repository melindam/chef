# used in apache2 cookbook
default['apache']['traceenable'] = 'Off'

# will need to remove these from jmh_apps default attributes
default['jmh_webserver']['apache']['legacy_apache'] = node['apache']['version'] == '2.4' ? false : true
default['jmh_webserver']['apache']['ssl_protocol'] = if node['platform_version'].start_with?('5.')
                                                        '+TLSv1'
                                                      elsif node['platform_version'].start_with?('7.')
                                                        '+TLSv1.2'
                                                      else
                                                        '+TLSv1 +TLSv1.1 +TLSv1.2'
                                                      end
default['jmh_webserver']['apache']['ssl_cipher'] = 'ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:' \
                                                   'DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:' \
                                                   'ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:' \
                                                   'DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:' \
                                                   'AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:' \
                                                   'DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4'
default['jmh_webserver']['apache']['mod_remoteip']['src_url'] = 'https://s3-us-west-1.amazonaws.com/jmhpublic/linux/apache-2.2-mod_remoteip.so'
default['jmh_webserver']['apache']['modules'] = %w(mod_proxy mod_proxy_http mod_proxy_connect mod_status mod_remoteip)
default['jmh_webserver']['apache']['remote_ip_header'] = "X-Cluster-Client-Ip"
default['jmh_webserver']['apache']['remote_ip_proxy_servers'] = %w(100.68.181.21
                                                                   100.68.179.14)
default['jmh_webserver']['apache']['vpn_ips']= %w(147.75.12.49 146.88.122.49)
default['jmh_webserver']['apache']['proxy_timeout'] = 15
default['jmh_webserver']['apache']['native_install_remoteip'] = node['jmh_webserver']['apache']['legacy_apache'] ? false : true

default['jmh_webserver']['apache']['expires_default'] = 'access plus 1 day'
default['jmh_webserver']['apache']['expires_fonts'] = 'access plus 1 week'
default['jmh_webserver']['apache']['expires_scripts'] = 'access plus 2 hours'
default['jmh_webserver']['test_run']['port'] = 7443

default['jmh_webserver']['sso']['cjose_url'] = 'https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.3.0'
default['jmh_webserver']['sso']['cjose_file']  = 'cjose-0.5.1-1.el7.centos.x86_64.rpm'
default['jmh_webserver']['sso']['config_file'] = true
default['jmh_webserver']['sso']['state_timeout'] = 300
default['jmh_webserver']['sso']['frame_ancestors'] = "*.johnmuirhealth.com"
default['jmh_webserver']['sso']['mychart_frame_ancestors'] = "*"

# https://github.com/zmartzone/mod_auth_openidc/releases
default['jmh_webserver']['sso']['openidc_mod_url'] =
    'https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.3.10.2/mod_auth_openidc-2.3.10.2-1.el7.x86_64.rpm'


#default['jmh_webserver']['apache']['header_ie11'] = true
default['jmh_webserver']['security_allow_prefix'] = if node['jmh_webserver']['apache']['legacy_apache']
                                                      'Allow From '
                                                    else
                                                      'Require ip'
                                                    end
default['jmh_webserver']['security_all_allow'] = if node['jmh_webserver']['apache']['legacy_apache']
                                                      'Allow from All'
                                                    else
                                                      'Require all granted'
                                                    end
default['jmh_webserver']['security_deny_allow'] = if node['jmh_webserver']['apache']['legacy_apache']
                                                      'Deny from All'
                                                    else
                                                      'Require all denied'
                                                    end

default['jmh_webserver']['default']['robots']['file'] = 'robots.txt'

default['jmh_webserver']['customphonebook']['filename'] = 'customphonebook.xml'
default['jmh_webserver']['customphonebook']['directory'] = node['apache']['docroot_dir']
default['jmh_webserver']['customphonebook']['install'] = false

default['jmh_webserver']['prerender']['token'] = "49HM1qqd1W0MCbZ0c1IB"
default['jmh_webserver']['prerender']['apache_version'] = "prerender-apache@2.0.0"

default['jmh_webserver']['logrotate'] = %w(prod).include?(node['jmh_server']['environment']) ? '104' : '4'