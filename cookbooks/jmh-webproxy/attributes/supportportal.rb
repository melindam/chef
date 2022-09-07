
default['jmh_webproxy']['supportportal']['proxy']['prereg_admin']['name'] = 'prereg-admin'
default['jmh_webproxy']['supportportal']['proxy']['prereg_admin']['description'] = 'Preregistration Administrator Support Portal'
default['jmh_webproxy']['supportportal']['proxy']['prereg_admin']['recipe'] = 'jmh-prereg\:\:admin'
default['jmh_webproxy']['supportportal']['proxy']['prereg_admin']['proxy_port'] = node['jmh_prereg']['admin']['appserver']['ssl_port']
default['jmh_webproxy']['supportportal']['proxy']['prereg_admin']['protocol'] = 'https'
default['jmh_webproxy']['supportportal']['proxy']['prereg_admin']['proxy_context'] = '/prereg-admin'

default['jmh_webproxy']['supportportal']['proxy']['myjmh_admin']['name'] = 'myjmh-admin'
default['jmh_webproxy']['supportportal']['proxy']['myjmh_admin']['description'] = 'MyChart Profile Admin Support Portal'
default['jmh_webproxy']['supportportal']['proxy']['myjmh_admin']['recipe'] = 'jmh-myjmh\:\:admin'
default['jmh_webproxy']['supportportal']['proxy']['myjmh_admin']['proxy_port'] = node['jmh_myjmh']['admin']['appserver']['ssl_port']
default['jmh_webproxy']['supportportal']['proxy']['myjmh_admin']['protocol'] = 'https'
default['jmh_webproxy']['supportportal']['proxy']['myjmh_admin']['proxy_context'] = '/myjmh-admin'

default['jmh_webproxy']['supportportal']['proxy']['webcommon']['name'] = 'Webcommon'
default['jmh_webproxy']['supportportal']['proxy']['webcommon']['description'] = 'Webcommonn'
default['jmh_webproxy']['supportportal']['proxy']['webcommon']['hide_link'] = true
default['jmh_webproxy']['supportportal']['proxy']['webcommon']['recipe'] = 'jmh-webserver\:\:webcommon'
default['jmh_webproxy']['supportportal']['proxy']['webcommon']['local_recipe'] = 'jmh-webserver::webcommon'
default['jmh_webproxy']['supportportal']['proxy']['webcommon']['proxy_port'] = 443
default['jmh_webproxy']['supportportal']['proxy']['webcommon']['protocol'] = 'https'
default['jmh_webproxy']['supportportal']['proxy']['webcommon']['proxy_context'] = '/webcommon'

default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['name'] = 'vvisitsclient'
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['description'] = 'VideoVisit Create Appointment'
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['hide_link'] = true
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['recipe'] = 'jmh-webserver\:\:vvisits_client'
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['local_recipe'] = 'jmh-webserver::vvisits_client'
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['proxy_port'] = 443
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['protocol'] = 'https'
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['proxy_context'] = '/vv'
default['jmh_webproxy']['supportportal']['proxy']['vvisits_client']['link'] = '/vv/createvisit.html'


default['jmh_webproxy']['supportportal']['local_name'] = 'supportportal'

default['jmh_webproxy']['supportportal']['apache_name'] = 'supportportal'
default['jmh_webproxy']['supportportal']['apache']['ip_address'] = '*'
default['jmh_webproxy']['supportportal']['apache']['server_name'] = node['jmh_server']['global']['apache']['supportportal']['server_name']

default['jmh_webproxy']['supportportal']['apache']['server_aliases'] = [ node['jmh_webproxy']['supportportal']['local_name'] , 'supportportal.hsys.local']
default['jmh_webproxy']['supportportal']['apache']['docroot'] = '/var/www/html'
default['jmh_webproxy']['supportportal']['apache']['server_status'] = true

default['jmh_webproxy']['supportportal']['http']['cond_rewrites'] =
                        { "^/(.*) https://#{node['jmh_webproxy']['supportportal']['apache']['server_name']}%{REQUEST_URI} [NC,L]" => ['%{HTTPS} off'] }
default['jmh_webproxy']['supportportal']['http']['port'] = 80
default['jmh_webproxy']['supportportal']['http']['error_log'] = 'logs/supportportal-error.log'
default['jmh_webproxy']['supportportal']['http']['custom_log'] = ['logs/supportportal-access.log combined']

default['jmh_webproxy']['supportportal']['https']['port'] = 443
default['jmh_webproxy']['supportportal']['https']['proxy_requests'] = false
default['jmh_webproxy']['supportportal']['https']['proxy_preserve_host'] = true
default['jmh_webproxy']['supportportal']['https']['redirect_matches'] = {'^/createvisit': '/vv/createvisit.html', '^/multivisit': '/vv/createvisit.html?multi=1'}
default['jmh_webproxy']['supportportal']['https']['rewrites'] = [ "^/app_widgets/scheduling/video/createAppt.html /vv/createvisit.html [R,L]" ]
default['jmh_webproxy']['supportportal']['https']['ssl_proxy_engine'] = 'on'
default['jmh_webproxy']['supportportal']['https']['error_log'] = 'logs/supportportal-ssl-error.log'
default['jmh_webproxy']['supportportal']['https']['custom_log'] = ['logs/supportportal-ssl-access.log combined']
default['jmh_webproxy']['supportportal']['https']['ssl']['encrypted'] = true
default['jmh_webproxy']['supportportal']['https']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_webproxy']['supportportal']['https']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
default['jmh_webproxy']['supportportal']['https']['ssl']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
default['jmh_webproxy']['supportportal']['https']['ssl']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
default['jmh_webproxy']['supportportal']['https']['ssl']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
default['jmh_webproxy']['supportportal']['https']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
default['jmh_webproxy']['supportportal']['https']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
default['jmh_webproxy']['supportportal']['https']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
default['jmh_webproxy']['supportportal']['https']['ssl_protocol'] = node['jmh_webserver']['apache']['ssl_protocol']
default['jmh_webproxy']['supportportal']['https']['ssl_proxy_protocol'] =  'TLSv1.2'

default['jmh_webproxy']['supportportal']['https']['directories'] = { 
    node['jmh_webproxy']['supportportal']['apache']['docroot'] => {
        'Options' => '-Indexes',
        'AllowOverride' => 'None',
        'Require' => 'all Granted' },   
    '/var/www/html/vv' => {
        'RewriteCond %{REQUEST_FILENAME} -f' => '[OR]',
        'RewriteCond %{REQUEST_FILENAME}' => '-d',
        'RewriteRule ^ -' =>  '[L]',
        'RewriteRule' => '^ index.html [L]'} }
