default['jmh_webserver']['jmhhr']['http']['port'] = 80
default['jmh_webserver']['jmhhr']['https']['port'] = 443

default['jmh_webserver']['jmhhr']['apache_name'] = 'jmhhr'
default['jmh_webserver']['jmhhr']['apache']['ip_address'] = '*'

default['jmh_webserver']['jmhhr']['apache']['server_name'] =  node['jmh_server']['global']['apache']['jmhhr']['server_name']
default['jmh_webserver']['jmhhr']['apache']['docroot'] = '/var/www/html'
default['jmh_webserver']['jmhhr']['apache']['server_status'] = true

default['jmh_webserver']['jmhhr']['domain_maps']['base_domain'] = 'johnmuirhr.com'

default['jmh_webserver']['jmhhr']['http']['cond_rewrites'] =
    { ".* https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/john-muir-hr.html [R=301,L]": ["%{HTTP_HOST} .*johnmuirhr.com"]}
default['jmh_webserver']['jmhhr']['http']['port'] = 80
default['jmh_webserver']['jmhhr']['http']['error_log'] = 'logs/jmhhr-error.log'
default['jmh_webserver']['jmhhr']['http']['custom_log'] = ['logs/jmhhr-access.log combinedproxy']

default['jmh_webserver']['jmhhr']['https']['port'] = 443
default['jmh_webserver']['jmhhr']['https']['proxy_requests'] = false
default['jmh_webserver']['jmhhr']['https']['proxy_preserve_host'] = true
default['jmh_webserver']['jmhhr']['https']['ssl_proxy_engine'] = 'on'
default['jmh_webserver']['jmhhr']['https']['header_access_control'] = true
default['jmh_webserver']['jmhhr']['https']['error_log'] = 'logs/jmhhr-error-ssl.log'
default['jmh_webserver']['jmhhr']['https']['custom_log'] = ['logs/jmhhr-access-ssl.log combinedproxy']
default['jmh_webserver']['jmhhr']['https']['ssl']['encrypted'] = true
default['jmh_webserver']['jmhhr']['https']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_webserver']['jmhhr']['https']['ssl']['data_bag_item'] =  'johnmuirhr_com_cert'
default['jmh_webserver']['jmhhr']['https']['ssl']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhr_com_cert.pem')
default['jmh_webserver']['jmhhr']['https']['ssl']['ssl_key_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhr_com_cert.key')
default['jmh_webserver']['jmhhr']['https']['ssl']['ssl_chain_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhr_com_cert.chain')
default['jmh_webserver']['jmhhr']['https']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhr_com_cert.pem')
default['jmh_webserver']['jmhhr']['https']['ssl_key_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhr_com_cert.key')
default['jmh_webserver']['jmhhr']['https']['ssl_chain_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhr_com_cert.chain')
default['jmh_webserver']['jmhhr']['https']['ssl_protocol'] = node['jmh_webserver']['apache']['ssl_protocol']
default['jmh_webserver']['jmhhr']['https']['ssl_proxy_protocol'] = 'all +TLSv1.2 -SSLv2 -SSLv3'
default['jmh_webserver']['jmhhr']['https']['rewrites'] =
[ "/logout-instructions.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/logout-instructions.html [R,L]",
  "/workday-login-instructions-former-employee.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/workday-login-instructions-former-employee.html [R,L]",
  "/workday-login-instructions.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/workday-login-instructions.html [R,L]",
  "/workday-logout-instructions.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/logout-instructions.html [R,L]"]
default['jmh_webserver']['jmhhr']['https']['cond_rewrites'] =
    { ".* https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/john-muir-hr.html [R=301,L]": ["%{HTTP_HOST} .*johnmuirhr.com"]}
