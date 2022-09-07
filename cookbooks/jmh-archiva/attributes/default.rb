default['mysql']['bind_address'] = '127.0.0.1'

default['jmh_archiva']['scratch_dir'] = '/usr/local/src/archiva'
default['jmh_archiva']['install_dir'] = '/usr/local/archiva'
default['jmh_archiva']['java_version'] = '8'
default['jmh_archiva']['user'] = 'archiva'
default['jmh_archiva']['group'] = 'archiva'
default['jmh_archiva']['version'] = '2.2.5'
default['jmh_archiva']['install_name'] = 'apache-archiva'
default['jmh_archiva']['jetty']['port'] = 8080
default['jmh_archiva']['jmx']['port'] = 6960

default['jmh_archiva']['binary_archives'] = "https://apache.osuosl.org/archiva/#{node['jmh_archiva']['version']}/binaries/apache-archiva-#{node['jmh_archiva']['version']}-bin.tar.gz"
default['jmh_archiva']['localrepo'] = 'http://ebiz-tools.hsys.local/share'
default['jmh_archiva']['repositories'] = 'repositories.tgz'

default['jmh_archiva']['mysql']['bin_dir'] = '/usr/bin'
default['jmh_archiva']['mysql']['dbdriver'] = 'com.mysql.jdbc.jdbc2.optional.MysqlDataSource'
default['jmh_archiva']['mysql']['host'] = 'localhost'
default['jmh_archiva']['mysql']['username'] = 'archiva'
default['jmh_archiva']['mysql']['dbname'] = 'archiva_users'

default['jmh_webserver']['listen'] = [80,443]

default['jmh_archiva']['ebizrepo']['apache_config']['port'] = 443
default['jmh_archiva']['ebizrepo']['apache_config']['ip_address'] = '*'
default['jmh_archiva']['ebizrepo']['apache_config']['docroot'] = '/var/www/html'
default['jmh_archiva']['ebizrepo']['apache_config']['server_name'] = 'ebizrepo.johnmuirhealth.com'
default['jmh_archiva']['ebizrepo']['apache_config']['app_server'] = 'ebizrepo'
default['jmh_archiva']['ebizrepo']['apache_config']['custom_log'] =  ['logs/access_log combined']
default['jmh_archiva']['ebizrepo']['apache_config']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_archiva']['ebizrepo']['apache_config']['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
default['jmh_archiva']['ebizrepo']['apache_config']['ssl']['encrypted'] = true

default['jmh_archiva']['ebizrepo']['apache_config']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
default['jmh_archiva']['ebizrepo']['apache_config']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
default['jmh_archiva']['ebizrepo']['apache_config']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
default['jmh_archiva']['ebizrepo']['apache_config']['proxy_passes'] = ["/archiva  http://localhost:#{node['jmh_archiva']['jetty']['port']}/archiva"]
default['jmh_archiva']['ebizrepo']['apache_config']['proxy_pass_reverses'] = ["/archiva  http://localhost:#{node['jmh_archiva']['jetty']['port']}/archiva"]
default['jmh_archiva']['ebizrepo']['apache_config']['locations'] = { '/archiva' => ['Require all Granted'] }

default['jmh_archiva']['ebizrepo80']['apache_config']['port'] = 80
default['jmh_archiva']['ebizrepo80']['apache_config']['ip_address'] = '*'
default['jmh_archiva']['ebizrepo80']['apache_config']['docroot'] = '/var/www/html'
default['jmh_archiva']['ebizrepo80']['apache_config']['server_name'] = node['jmh_archiva']['ebizrepo']['apache_config']['server_name']
default['jmh_archiva']['ebizrepo80']['apache_config']['custom_log'] =  ['logs/access_log combined']
default['jmh_archiva']['ebizrepo80']['apache_config']['app_server'] = 'archiva'
default['jmh_archiva']['ebizrepo80']['apache_config']['rewrite_log'] = '/var/log/httpd/rewrite.log'
default['jmh_archiva']['ebizrepo80']['apache_config']['rewrite_log_level'] = 1
default['jmh_archiva']['ebizrepo80']['apache_config']['cond_rewrites'] = { '^/(.*) https://%{HTTP_HOST}%{REQUEST_URI} [NC,L]' => ['%{HTTPS} off'] }
