default['cq']['dispatcher']['prc']['server_name'] = node['jmh_server']['global']['apache']['prc']['server_name']
default['cq']['dispatcher']['prc']['server_aliases'] = node['jmh_server']['global']['apache']['prc']['server_aliases']
default['cq']['dispatcher']['prc']['prc_configs_data_bag'] = 'prc_configs'

default['cq']['dispatcher']['prc']['common_http']['cookbook'] = 'jmh-webserver'
default['cq']['dispatcher']['prc']['common_http']['docroot'] = node['cq']['dispatcher']['document_root']
default['cq']['dispatcher']['prc']['common_http']['server_name'] = node['cq']['dispatcher']['prc']['server_name']
default['cq']['dispatcher']['prc']['common_http']['server_aliases'] = node['cq']['dispatcher']['prc']['server_aliases']
default['cq']['dispatcher']['prc']['common_http']['server_status'] = false
default['cq']['dispatcher']['prc']['common_http']['rewrite_log_level'] = 1
default['cq']['dispatcher']['prc']['common_http']['proxy_requests'] = false
default['cq']['dispatcher']['prc']['common_http']['proxy_preserve_host'] = true
default['cq']['dispatcher']['prc']['common_http']['ssl_proxy_engine'] = 'on'
default['cq']['dispatcher']['prc']['common_http']['includes'] = [File.join(node['apache']['conf_dir'],'jmherror.conf')]
default['cq']['dispatcher']['prc']['common_http']['ip_address'] = '*'

default['cq']['dispatcher']['prc']['http']['port'] = 80
default['cq']['dispatcher']['prc']['http']['error_log'] = 'logs/prc-error.log'
default['cq']['dispatcher']['prc']['http']['custom_log'] = 'logs/prc-access.log combinedproxy'
default['cq']['dispatcher']['prc']['http']['rewrite_log'] = 'logs/prc-rewrite.log'

default['cq']['dispatcher']['prc']['https']['port'] = 443
default['cq']['dispatcher']['prc']['https']['error_log'] = 'logs/prc-error-ssl.log'
default['cq']['dispatcher']['prc']['https']['custom_log'] = 'logs/prc-access-ssl.log combinedproxy'
default['cq']['dispatcher']['prc']['https']['rewrite_log'] = 'logs/prc-rewrite-ssl.log'
default['cq']['dispatcher']['prc']['https']['header_ie11'] = true
default['cq']['dispatcher']['prc']['https']['ssl']['encrypted'] = true
default['cq']['dispatcher']['prc']['https']['ssl']['data_bag'] = 'apache_ssl'
default['cq']['dispatcher']['prc']['https']['ssl']['data_bag_item'] = 'johnmuirhealth_com_cert'