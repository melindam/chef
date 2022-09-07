# Local IP Definitions
# 206.107.211.5 - JMH Nat IP
# 96.64.252.134 - JMH Guest Network NAT IP
# 52.53.242.252 192.168.114.40 - win01-awsdev
# 52.53.186.89 192.168.114.206 - winqa01-awsdev
# 206.107.211.5 12.25.162.6 - JMH public facing IPs
default['jmh_webproxy']['jmh_ips'] = '206.107.211.5 96.64.252.134 52.53.242.252 52.53.186.89 54.219.145.189'
# IP Definitions
default['jmh_webproxy']['zipnosis_ips'] = ' 52.0.115.155 34.192.37.216 34.193.214.115 34.192.82.29 34.193.211.191 50.232.139.22'
default['jmh_webproxy']['herodigital_ips'] = ' 173.247.200.134 69.38.208.226 38.122.183.178 '
default['jmh_webproxy']['wellbe'] = ' 47.44.94.10 35.165.22.3 '
default['jmh_webproxy']['tealium_ips'] =  ' 69.75.90.42 69.75.90.43 69.75.90.44 69.75.90.45 69.75.90.46 166.141.105.194 52.26.114.118 50.18.187.169 '
default['jmh_webproxy']['tcell_ips'] = ' 199.83.220.164 '
default['jmh_webproxy']['zocdoc'] = ' 34.225.193.169 '
## Removed List
# 104.130.81.98 Doc ASAP (removed)
# 50.247.27.161 LaFleur Marketing (removed)
# 10.70.7 64.54.192.201 - ucsf (removed)
#  67.161.3.146 (removed...not sure who)

default['jmh_webproxy']['hostfile_proxy']['aem']['search_recipe'] = 'jmh-cq\:\:dispatcher'

# dont know if using aws sensu values below?
default['jmh_webproxy']['aws']['sensu']['name'] = 'sensu'
default['jmh_webproxy']['aws']['sensu']['port'] = 443
default['jmh_webproxy']['aws']['sensu']['search_recipe'] = 'jmh-monitor\:\:sensu-server'
default['jmh_webproxy']['aws']['sensu']['environment'] = 'awsdev'
default['jmh_webproxy']['aws']['sensu']['proxy_port'] = 3000
default['jmh_webproxy']['aws']['sensu']['proxy_context'] = '/'
default['jmh_webproxy']['aws']['sensu']['ssl_proxy_protocol'] = true
default['jmh_webproxy']['aws']['sensu']['server_name'] = 'sensu-aws.johnmuirhealth.com'
default['jmh_webproxy']['aws']['sensu']['enable_ssl'] = true
default['jmh_webproxy']['aws']['sensu']['protocol'] = 'https'
default['jmh_webproxy']['aws']['sensu']['custom_log'] = ['logs/sensu_access_log combined']
default['jmh_webproxy']['aws']['sensu']['error_log'] = 'logs/sensu_error_log'