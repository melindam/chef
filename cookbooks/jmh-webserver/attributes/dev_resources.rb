default['jmh_webserver']['dev_tools_web_server']['apache_config80']['port'] = 80
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['ip_address'] = '*'
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['docroot'] = '/var/www/html'
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['server_name'] = 'dev-resources.johnmuirhealth.com'
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['server_aliases'] = ['ebiz23.hsys.local']
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['cookbook'] = 'jmh-webserver'
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['custom_log'] = ['logs/access_log combined']
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['error_log'] = 'logs/error_log'
default['jmh_webserver']['dev_tools_web_server']['apache_config80']['directories'] = {'/var/www/html' => {'Options' => '+Indexes'}}