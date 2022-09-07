
default['jmh_webserver']['idp']['http']['port'] = 80
default['jmh_webserver']['idp']['https']['port'] = 443

default['jmh_webserver']['idp']['apache_name'] = 'idp'
default['jmh_webserver']['idp']['apache']['ip_address'] = '*'

default['jmh_webserver']['idp']['apache']['server_name'] =  node['jmh_server']['global']['apache']['idp']['server_name']
default['jmh_webserver']['idp']['apache']['server_aliases'] =  node['jmh_server']['global']['apache']['idp']['server_aliases']
default['jmh_webserver']['idp']['apache']['docroot'] = '/var/www/html'
default['jmh_webserver']['idp']['apache']['server_status'] = true

default['jmh_webserver']['idp']['domain_maps']['base_domain'] = 'idp.johnmuirhealth.com'

default['jmh_webserver']['idp']['http']['cond_rewrites'] =
                        { "^/(.*) https://#{node['jmh_webserver']['idp']['apache']['server_name']}%{REQUEST_URI} [NC,L]" => ['%{HTTPS} off'] }
default['jmh_webserver']['idp']['http']['port'] = 80
default['jmh_webserver']['idp']['http']['error_log'] = 'logs/idp-error.log'
default['jmh_webserver']['idp']['http']['custom_log'] = ['logs/idp-access.log combinedproxy']

default['jmh_webserver']['idp']['https']['port'] = 443
default['jmh_webserver']['idp']['https']['proxy_requests'] = false
default['jmh_webserver']['idp']['https']['proxy_preserve_host'] = true
default['jmh_webserver']['idp']['https']['ssl_proxy_engine'] = 'on'
default['jmh_webserver']['idp']['https']['header_access_control'] = true
default['jmh_webserver']['idp']['https']['error_log'] = 'logs/idp-error-ssl.log'
default['jmh_webserver']['idp']['https']['custom_log'] = ['logs/idp-access-ssl.log combinedproxy']
default['jmh_webserver']['idp']['https']['ssl']['encrypted'] = true
default['jmh_webserver']['idp']['https']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_webserver']['idp']['https']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
default['jmh_webserver']['idp']['https']['ssl']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.pem')
default['jmh_webserver']['idp']['https']['ssl']['ssl_key_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.key')
default['jmh_webserver']['idp']['https']['ssl']['ssl_chain_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.chain')
default['jmh_webserver']['idp']['https']['ssl_pem_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.pem')
default['jmh_webserver']['idp']['https']['ssl_key_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.key')
default['jmh_webserver']['idp']['https']['ssl_chain_file'] = File.join(node['apache']['dir'],'/ssl/johnmuirhealth_com_cert.chain')
default['jmh_webserver']['idp']['https']['ssl_protocol'] = node['jmh_webserver']['apache']['ssl_protocol']
default['jmh_webserver']['idp']['https']['ssl_proxy_protocol'] = 'all +TLSv1.2 -SSLv2 -SSLv3'
default['jmh_webserver']['idp']['https']['cond_rewrites'] =
    { ".* https://#{node['jmh_server']['global']['apache']['www']['server_name']}/patientportal": "%{QUERY_STRING} ^.*redirect_uri=https.*?myjmh-client",
      "(.*)$  /ext/fhirlogout [PT,L]": "%{QUERY_STRING} ^.*mode=oauthredirect.*$" }

# Proxy to Pingfed server
default['jmh_webserver']['idp']['app_proxies']['pingfed']['id'] = 'idp_proxies'
default['jmh_webserver']['idp']['app_proxies']['pingfed']['target_recipe'] = 'jmh-pingfed\\:\\:pingfederate'
default['jmh_webserver']['idp']['app_proxies']['pingfed']['port'] = 9031
default['jmh_webserver']['idp']['app_proxies']['pingfed']['proto'] = 'https'
default['jmh_webserver']['idp']['app_proxies']['pingfed']['proxies'] = {'/jmherror' => nil, '/' => '/'  }
default['jmh_webserver']['idp']['app_proxies']['pingfed']['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']