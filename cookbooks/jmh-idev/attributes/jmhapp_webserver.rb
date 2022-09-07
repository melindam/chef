# To configure idev prod web server jmhweb
default['jmh_idev']['jmhweb']['apache_name'] = 'jmhapp'
default['jmh_idev']['jmhweb']['apache']['ip_address'] = '*'
default['jmh_idev']['jmhweb']['apache']['server_name'] = 'test-jmhapp.johnmuirhealth.com'

default['jmh_idev']['jmhweb']['apache']['server_aliases'] = ['test-jmhapp.hsys.local']
default['jmh_idev']['jmhweb']['apache']['docroot'] = '/var/www/html'
default['jmh_idev']['jmhweb']['apache']['server_status'] = true
default['jmh_idev']['jmhweb']['domain_maps']['base_domain'] = 'jmhapp.johnmuirhealth.com'

default['jmh_idev']['jmhweb']['http']['port'] = 80
default['jmh_idev']['jmhweb']['http']['error_log'] = 'logs/jmhapp-error.log'
default['jmh_idev']['jmhweb']['http']['custom_log'] = ['logs/jmhapp-access.log combinedproxy']
default['jmh_idev']['jmhweb']['http']['cond_rewrites'] =
                      { "^/(.*) https://#{node['jmh_idev']['jmhweb']['apache']['server_name']}%{REQUEST_URI} [NC,L]" => ['%{HTTPS} off'] }

default['jmh_idev']['jmhweb']['https']['port'] = 443
default['jmh_idev']['jmhweb']['https']['proxy_requests'] = true
default['jmh_idev']['jmhweb']['https']['proxy_preserve_host'] = true
default['jmh_idev']['jmhweb']['https']['header_access_control'] = false
default['jmh_idev']['jmhweb']['https']['ssl_proxy_engine'] = 'on'
default['jmh_idev']['jmhweb']['https']['error_log'] = 'logs/jmhapp-error-ssl.log'
default['jmh_idev']['jmhweb']['https']['custom_log'] = ['logs/jmhapp-access-ssl.log combinedproxy']
default['jmh_idev']['jmhweb']['https']['ssl']['encrypted'] = true
default['jmh_idev']['jmhweb']['https']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_idev']['jmhweb']['https']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
default['jmh_idev']['jmhweb']['https']['ssl']['ssl_pem_file'] = File.join(node['apache']['dir'], 'ssl/johnmuirhealth_com_cert.pem')
default['jmh_idev']['jmhweb']['https']['ssl']['ssl_key_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.key')
default['jmh_idev']['jmhweb']['https']['ssl']['ssl_chain_file'] = File.join(node['apache']['dir'], 'ssl/johnmuirhealth_com_cert.chain')
default['jmh_idev']['jmhweb']['https']['ssl_pem_file'] = File.join(node['apache']['dir'], 'ssl/johnmuirhealth_com_cert.pem')
default['jmh_idev']['jmhweb']['https']['ssl_key_file'] = File.join(node['apache']['dir'], 'ssl/johnmuirhealth_com_cert.key')
default['jmh_idev']['jmhweb']['https']['ssl_chain_file'] = File.join(node['apache']['dir'],'ssl/johnmuirhealth_com_cert.chain')
default['jmh_idev']['jmhweb']['https']['ssl_protocol'] = node['jmh_webserver']['apache']['ssl_protocol']
default['jmh_idev']['jmhweb']['https']['ssl_app_proxy_protocol'] = 'all +TLSv1.2 -SSLv2 -SSLv3'
default['jmh_idev']['jmhweb']['https']['proxy_timeout'] = 240

# default['jmh_idev']['jmhweb']['nas_share'] = '\\nassvcs01\DIAPPS\ebiz_webserver'
default['jmh_idev']['jmhweb']['nas_mount_dir'] = '/var/www/html/jmhweb'

default['jmh_idev']['jmhweb']['app_proxies']['sbo_proxies']['id'] = 'sbo_proxies'
default['jmh_idev']['jmhweb']['app_proxies']['sbo_proxies']['port'] = '8103'
default['jmh_idev']['jmhweb']['app_proxies']['sbo_proxies']['target_recipe'] = 'jmh-idev\:\:sbo'
default['jmh_idev']['jmhweb']['app_proxies']['sbo_proxies']['proto'] = 'http'
default['jmh_idev']['jmhweb']['app_proxies']['sbo_proxies']['proxies'] = { '/sbo' => '/sbo' }

default['jmh_idev']['jmhweb']['app_proxies']['jmpn_proxies']['id'] = 'jmpn_proxies'
default['jmh_idev']['jmhweb']['app_proxies']['jmpn_proxies']['port'] = '8104'
default['jmh_idev']['jmhweb']['app_proxies']['jmpn_proxies']['target_recipe'] = 'jmh-idev\:\:jmpn'
default['jmh_idev']['jmhweb']['app_proxies']['jmpn_proxies']['proto'] = 'http'
default['jmh_idev']['jmhweb']['app_proxies']['jmpn_proxies']['proxies'] = { '/jmpn' => '/jmpn' }

default['jmh_idev']['jmhweb']['app_proxies']['mdsuspension_proxies']['id'] = 'mdsuspension_proxies'
default['jmh_idev']['jmhweb']['app_proxies']['mdsuspension_proxies']['port'] = '8105'
default['jmh_idev']['jmhweb']['app_proxies']['mdsuspension_proxies']['target_recipe'] = 'jmh-idev\:\:mdsuspension'
default['jmh_idev']['jmhweb']['app_proxies']['mdsuspension_proxies']['proto'] = 'http'
default['jmh_idev']['jmhweb']['app_proxies']['mdsuspension_proxies']['proxies'] = { '/mdsuspension' => '/mdsuspension' }
