# Maintenance Window
default['jmh_webserver']['epic_maintenance_windows'] = Hash.new
# See https://jmhebiz.jira.com/wiki/display/SYS/EPIC+Maintenance+Downtime+Process
# default['jmh_webserver']['epic_maintenance_windows'] = { "RA743" => { "env"=> "awsdev", "start"=> "2017-04-09 00:00:00 PDT", "stop"=> "2017-04-09 13:30:00 PDT" } }
# To have more than one window on a given system with epic:
#       { "RA7431" => { "env"=> "awsdev", "start"=> "2017-04-10 00:00:00 PDT", "stop"=> "2017-04-10 23:30:00 PDT" }}.merge(node['jmh_webserver']['epic_maintenance_windows'])

default['jmh_webserver']['api']['app_proxies']['mychart']['id'] = 'mychart_api_proxies'
default['jmh_webserver']['api']['app_proxies']['mychart']['target_recipe'] = 'jmh-webserver\:\:mychart_proxy'
default['jmh_webserver']['api']['app_proxies']['mychart']['port'] = 443
default['jmh_webserver']['api']['app_proxies']['mychart']['proto'] = 'https'
# Overwritten in the api recipe
default['jmh_webserver']['api']['app_proxies']['mychart']['proxies'] = {'/MyChart': '/MyChart'}
# For IIS
default['jmh_webserver']['api']['app_proxies']['mychart']['directives'] = ["Require all granted",
                                                                           "SetEnv force-proxy-request-1.0 1",
                                                                           "SetEnv proxy-nokeepalive 1"]
default['jmh_webserver']['api']['app_proxies']['mychart']['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']
default['jmh_webserver']['api']['app_proxies']['mychart']['maintenance'] = false
default['jmh_webserver']['api']['app_proxies']['mychart']['maintenance_page'] = '/jmherror/myjmh_maintenance.html'
default['jmh_webserver']['api']['app_proxies']['mychart']['maintenance_windows'] = node['jmh_webserver']['epic_maintenance_windows']

# Scheduling
default['jmh_webserver']['api']['app_proxies']['scheduling']['id'] = 'scheduling_proxies'
default['jmh_webserver']['api']['app_proxies']['scheduling']['target_recipe'] = 'jmh-sched\\:\\:scheduling'
default['jmh_webserver']['api']['app_proxies']['scheduling']['port'] = 8464
default['jmh_webserver']['api']['app_proxies']['scheduling']['proto'] = 'https'
default['jmh_webserver']['api']['app_proxies']['scheduling']['proxies'] = {'/scheduling': '/scheduling'  }
default['jmh_webserver']['api']['app_proxies']['scheduling']['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']
default['jmh_webserver']['api']['app_proxies']['scheduling']['maintenance'] = false
default['jmh_webserver']['api']['app_proxies']['scheduling']['maintenance_page'] = '/jmherror/myjmh_maintenance.html'
default['jmh_webserver']['api']['app_proxies']['scheduling']['maintenance_windows'] = node['jmh_webserver']['epic_maintenance_windows']
default['jmh_webserver']['api']['app_proxies']['scheduling']['directives'] = [ 'Require all granted' ]

# Profile API
default['jmh_webserver']['api']['app_proxies']['profile_api']['id'] = 'profile_api_proxies'
default['jmh_webserver']['api']['app_proxies']['profile_api']['target_recipe'] = 'jmh-myjmh\\:\\:profile_api'
default['jmh_webserver']['api']['app_proxies']['profile_api']['port'] = 8465
default['jmh_webserver']['api']['app_proxies']['profile_api']['proto'] = 'https'
default['jmh_webserver']['api']['app_proxies']['profile_api']['proxies'] = {'/profile-api/docs': nil,
                                                                            '/profile-api': '/profile-api'  }
default['jmh_webserver']['api']['app_proxies']['profile_api']['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']
default['jmh_webserver']['api']['app_proxies']['profile_api']['maintenance'] = false
default['jmh_webserver']['api']['app_proxies']['profile_api']['maintenance_page'] = '/jmherror/myjmh_maintenance.html'
default['jmh_webserver']['api']['app_proxies']['profile_api']['maintenance_windows'] = node['jmh_webserver']['epic_maintenance_windows']

# Video Visits API
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['id'] = 'vvisits_api_proxies'
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['target_recipe'] = 'jmh-vvisits\\:\\:vvisits_api'
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['port'] = 8521
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['proto'] = 'https'
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['proxies'] = { '/vvisits': '/vvisits' }
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['maintenance'] = false
default['jmh_webserver']['api']['app_proxies']['vvisits_api']['directives'] = [ 'Require all granted' ]

# Payment Gateway
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['id'] = 'payment_gateway_proxies'
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['target_recipe'] = 'jmh-paygateway\\:\\:payment_gateway'
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['port'] = 8523
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['proto'] = 'https'
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['proxies'] = { '/gw': '/gw' }
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['location_directives'] = [' RequestHeader set X-Forwarded-Ssl on']
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['maintenance'] = false
default['jmh_webserver']['api']['app_proxies']['payment_gateway']['directives'] = [ 'Require all granted' ]
