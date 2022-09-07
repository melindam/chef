default['jmh_webserver']['mychart']['https']['port'] = 443

default['jmh_webserver']['mychart']['apache_name'] = 'mychart'
default['jmh_webserver']['mychart']['https']['ip_address'] = '*'
default['jmh_webserver']['mychart']['https']['server_name'] =  'mychart.johnmuirhealth.com'
default['jmh_webserver']['mychart']['https']['docroot'] = '/var/www/html'
default['jmh_webserver']['mychart']['https']['server_status'] = true

default['jmh_webserver']['mychart']['domain_maps']['base_domain'] = 'mychart.johnmuirhealth.com'

default['jmh_webserver']['default_app_proxies'] = ['jmherror']

default['jmh_webserver']['mychart']['https']['port'] = 443
default['jmh_webserver']['mychart']['https']['proxy_requests'] = false
default['jmh_webserver']['mychart']['https']['proxy_preserve_host'] = true
default['jmh_webserver']['mychart']['https']['ssl_proxy_engine'] = 'on'
default['jmh_webserver']['mychart']['https']['error_log'] = 'logs/mychart_error_log_ssl.log'
default['jmh_webserver']['mychart']['https']['custom_log'] = ['logs/mychart_access_log_ssl.log combinedproxy']
default['jmh_webserver']['mychart']['https']['ssl']['encrypted'] = true
default['jmh_webserver']['mychart']['https']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_webserver']['mychart']['https']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
default['jmh_webserver']['mychart']['https']['ssl']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
default['jmh_webserver']['mychart']['https']['ssl']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
default['jmh_webserver']['mychart']['https']['ssl']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
default['jmh_webserver']['mychart']['https']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
default['jmh_webserver']['mychart']['https']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
default['jmh_webserver']['mychart']['https']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
default['jmh_webserver']['mychart']['https']['ssl_protocol'] = node['jmh_webserver']['apache']['ssl_protocol']
default['jmh_webserver']['mychart']['https']['ssl_proxy_protocol'] = '+TLSv1.2'
# For IIS
default['jmh_webserver']['mychart']['proxy_directives'] = ["Require all granted",
                                                           "SetEnv force-proxy-request-1.0 1",
                                                           "SetEnv proxy-nokeepalive 1"]