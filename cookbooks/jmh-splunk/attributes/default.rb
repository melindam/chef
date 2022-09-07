default['splunk']['accept_license'] = true
default['splunk']['web_port'] = '8000'
default['splunk']['receiver_port'] = '9997'
default['splunk']['upgrade_enabled'] = true
force_override['splunk']['setup_auth'] = false

default['jmh_splunk']['upgrade'] = false

default['jmh_splunk']['databag'] = 'jmh_apps'
default['jmh_splunk']['databag_item'] = 'splunk-secure'
default['jmh_splunk']['admin_email'] = 'melinda.moran@johnmuirhealth.com'

default['jmh_splunk']['recipe'] = 'recipes:jmh-splunk\:\:server'

default['jmh_splunk']['server_environment'] = node['jmh_server']['environment'] == 'prod' ? 'arprod' : 'awstst2'
default['jmh_splunk']['keyserver']['name'] = 'infosec-splunkmon.hsys.local'
default['jmh_splunk']['keyserver']['ip'] = '172.23.69.114'

node.default['jmh_webserver']['listen'] = [80,443]
default['jmh_splunk']['http']['config']['port'] = 80
default['jmh_splunk']['http']['config']['ip_address'] = '*'
default['jmh_splunk']['http']['config']['docroot'] = '/var/www/html'
default['jmh_splunk']['http']['config']['server_name'] = node['jmh_server']['environment'] == 'prod' ? 'splunk.johnmuirhealth.com' : 'splunk-aws.johnmuirhealth.com'


default['jmh_splunk']['http']['config']['locations'] =  { '/' => ['Require all Granted'] }
default['jmh_splunk']['http']['config']['cond_rewrites'] =
                        { "^/(.*) https://#{node['jmh_splunk']['http']['config']['server_name']}%{REQUEST_URI} [NC,L]" => ['%{HTTPS} off'] }

# Splunk webserver over SSL
default['jmh_splunk']['https']['config']['port'] = 443
default['jmh_splunk']['https']['config']['ip_address'] = '*'
default['jmh_splunk']['https']['config']['docroot'] = '/var/www/html'
default['jmh_splunk']['https']['config']['server_name'] = node['jmh_splunk']['http']['config']['server_name']
default['jmh_splunk']['https']['config']['custom_log'] =  ['logs/splunk_access_log-ssl combined']
default['jmh_splunk']['https']['config']['error_log'] = "logs/splunk_error_log-ssl"
default['jmh_splunk']['https']['config']['proxy_passes'] = ["/  http://localhost:8000/"]
default['jmh_splunk']['https']['config']['proxy_pass_reverses'] = ["/  http://localhost:8000/"]
default['jmh_splunk']['https']['config']['locations'] = { '/' => ['Require all Granted'] }
default['jmh_splunk']['https']['config']['ssl']['encrypted'] = true
default['jmh_splunk']['https']['config']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_splunk']['https']['config']['ssl']['data_bag_item'] = 'johnmuirhealth_com_cert'
default['jmh_splunk']['https']['config']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
default['jmh_splunk']['https']['config']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
default['jmh_splunk']['https']['config']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'


default['jmh_splunk']['version'] = '8.0.0'
default['jmh_splunk']['version_hash'] = {
                                         '7.0.3': {server: 'https://s3-us-west-1.amazonaws.com/jmhpublic/linux/splunk-7.0.3-fa31da744b51-linux-2.6-x86_64.rpm',
                                                   forwarder: 'https://s3-us-west-1.amazonaws.com/jmhpublic/linux/splunkforwarder-7.0.3-fa31da744b51-linux-2.6-x86_64.rpm'},
                                         '8.0.0': {server: 'https://s3-us-west-1.amazonaws.com/jmhpublic/linux/splunk-8.0.0-1357bef0a7f6-linux-2.6-x86_64.rpm',
                                                   forwarder: 'https://s3-us-west-1.amazonaws.com/jmhpublic/linux/splunkforwarder-8.0.0-1357bef0a7f6-linux-2.6-x86_64.rpm'}
                                          }

# https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.0.3&product=universalforwarder&filename=splunkforwarder-7.0.3-fa31da744b51-linux-2.6-x86_64.rpm&wget=true
# https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.0.3&product=splunk&filename=splunk-7.0.3-fa31da744b51-Linux-x86_64.tgz&wget=true