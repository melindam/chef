jmh-webserver Cookbook
======================
JMH related code for creating a web server.


Requirements
------------
Centos 7.x tested

e.g.
#### packages
- `apache2`
- `php`
- `xml`


Attributes
----------

### ['jmh_webserver']['epic_maintenance_windows']
* For creating Epic maintenance windows - these reside in the Chef Environment now
`default['jmh_webserver']['epic_maintenance_windows'] = { "RA743" => { "env"=> "awsdev", "start"=> "2017-04-09 00:00:00 PDT", "stop"=> "2017-04-09 13:30:00 PDT" } }`


Usage
-----
### jmh-webserver::default
Runs default install of apache2

### jmh-webserver::php_site
Runs `jmh-webserver::php_site` if you haved defined `node['jmh_webserver]['php']`

### jmh-webserver::php_site_rollout
Port 81 site used to rollout new git versions of the sites

### jmh-webserver::php_site_tag
Port 81 site used to tag new versions of the site from the git repo

Providers Example
-----------------
```ruby
jmh_webserver 'archiva-ssl' do
  doc_root node['jmh_archiva']['ebizrepo']['apache_config']['docroot']
  apache_config node['jmh_archiva']['ebizrepo']['apache_config']
  action :install
end
```
Attributes
----------
## Where apache_config contains the following example values
- `default['jmh_archiva']['ebizrepo']['apache_config']['ssl']['port'] = 443`
- `default['jmh_archiva']['ebizrepo']['apache_config']['ip_address'] = '*'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['docroot'] = '/var/www/html'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['server_name'] = 'ebizrepo.johnmuirhealth.com'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['app_server'] = 'ebizrepo'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['custom_log'] =  ['logs/access_log combined']`
- `default['jmh_archiva']['ebizrepo']['apache_config']['error_log'] = 'logs/error_log'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['ssl']['data_bag'] = 'apache_ssl'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['ssl']['encrypted'] = true`
- `default['jmh_archiva']['ebizrepo']['apache_config']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'`
- `default['jmh_archiva']['ebizrepo']['apache_config']['proxy_passes'] = ["/archiva  http://localhost:#{node['jmh_archiva']['jetty']['port']}/archiva"]`
- `default['jmh_archiva']['ebizrepo']['apache_config']['proxy_pass_reverses'] = ["/archiva  http://localhost:#{node['jmh_archiva']['jetty']['port']}/archiva"]`
- `default['jmh_archiva']['ebizrepo']['apache_config']['locations'] = { '/archiva' => ['allow from all'] }`
- `default['jmh_archiva']['ebizrepo']['apache_config']['mod_ssl']['directives'] =  ['SSLProxyEngine on', 'SSLProxyVerify none']`

## Where a proxy is needed to be defined to point to an application server target recipe.  This is defined by the 'app_proxies' attributes with a unique name after to define proxy connection
- `default['jmh_webserver']['api']['app_proxies']['myjmh_services']['id'] = 'api_proxies'`
- `default['jmh_webserver']['api']['app_proxies']['myjmh_services']['target_recipe'] = 'jmh-myjmh\\:\\:services'`
- `default['jmh_webserver']['api']['app_proxies']['myjmh_services']['port'] = 8460`
- `default['jmh_webserver']['api']['app_proxies']['myjmh_services']['proto'] = 'https'`
- `default['jmh_webserver']['api']['app_proxies']['myjmh_services']['proxies'] = {'/api' => '/api'  }`
- `default['jmh_webserver']['api']['app_proxies']['myjmh_services']['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']`
- `default['jmh_webserver']['api']['app_proxies']['myjmh_services']['target_ipaddress']` - overrides the target recipe with IP address for load balancer IP
