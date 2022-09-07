
default['jmh_webserver']['api']['http']['port'] = 80
default['jmh_webserver']['api']['https']['port'] = 443

default['jmh_webserver']['api']['apache_name'] = 'api'
default['jmh_webserver']['api']['apache']['ip_address'] = '*'

default['jmh_webserver']['api']['apache']['server_name'] = node['jmh_server']['global']['apache']['api']['server_name']
default['jmh_webserver']['api']['apache']['server_aliases'] = node['jmh_server']['global']['apache']['api']['server_aliases']

default['jmh_webserver']['api']['apache']['docroot'] = '/var/www/html'
default['jmh_webserver']['api']['apache']['server_status'] = true

default['jmh_webserver']['api']['domain_maps']['base_domain'] = 'api.johnmuirhealth.com'

default['jmh_webserver']['api']['http']['cond_rewrites'] =
                        { "^/(.*) https://#{node['jmh_webserver']['api']['apache']['server_name']}%{REQUEST_URI} [NC,L]" => ['%{HTTPS} off'] }
default['jmh_webserver']['api']['http']['port'] = 80
default['jmh_webserver']['api']['http']['error_log'] = 'logs/api-error.log'
default['jmh_webserver']['api']['http']['custom_log'] = ['logs/api-access.log combinedproxy']

default['jmh_webserver']['api']['https']['port'] = 443
default['jmh_webserver']['api']['https']['proxy_requests'] = false
default['jmh_webserver']['api']['https']['proxy_preserve_host'] = true
default['jmh_webserver']['api']['https']['header_access_control'] = true
default['jmh_webserver']['api']['https']['ssl_proxy_engine'] = 'on'
default['jmh_webserver']['api']['https']['error_log'] = 'logs/api-error-ssl.log'
default['jmh_webserver']['api']['https']['custom_log'] = ['logs/api-access-ssl.log combinedproxy']
default['jmh_webserver']['api']['https']['ssl']['encrypted'] = true
default['jmh_webserver']['api']['https']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_webserver']['api']['https']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
default['jmh_webserver']['api']['https']['ssl']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.pem')
default['jmh_webserver']['api']['https']['ssl']['ssl_key_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.key')
default['jmh_webserver']['api']['https']['ssl']['ssl_chain_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.chain')
default['jmh_webserver']['api']['https']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.pem')
default['jmh_webserver']['api']['https']['ssl_key_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.key')
default['jmh_webserver']['api']['https']['ssl_chain_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.chain')
default['jmh_webserver']['api']['https']['ssl_protocol'] = node['jmh_webserver']['apache']['ssl_protocol']
default['jmh_webserver']['api']['https']['ssl_proxy_protocol'] = 'all +TLSv1.2 -SSLv2 -SSLv3'
default['jmh_webserver']['api']['https']['cond_rewrites'] =
    { "^(.*)$ /jmherror/pagenotfound.html [PT,L]":
          [ "%{REQUEST_URI}   ^/vvisits/v1/sendReminders.*" ] }