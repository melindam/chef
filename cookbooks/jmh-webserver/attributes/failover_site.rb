default['jmh_webserver']['failover']['apache_config']['server_name'] = 'failover.jmh.local'
default['jmh_webserver']['failover']['apache_config']['docroot'] = '/var/www/html'
default['jmh_webserver']['failover']['apache_config']['ip_address'] = '*'
default['jmh_webserver']['failover']['apache_config']['server_status'] = true
default['jmh_webserver']['failover']['apache_config']['port'] = 83
default['jmh_webserver']['failover']['apache_config']['error_log'] = 'logs/error.log'
default['jmh_webserver']['failover']['apache_config']['cond_rewrites'] =
          { '.* /index.html' => ['%{REQUEST_URI} !^/jmherror','%{REQUEST_URI} !/index.html'] }
