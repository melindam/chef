default['jmh_webproxy']['md']['apache_name'] = 'md'
default['jmh_webproxy']['md']['apache']['ip_address'] = '*'
default['jmh_webproxy']['md']['apache']['port'] = 80
default['jmh_webproxy']['md']['apache']['server_name'] =  case node['jmh_server']['environment']
                                                          when 'prod'
                                                            'md.johnmuirhealth.com'
                                                          when 'stage'
                                                            'md-stage.johnmuirhealth.com'
                                                          else
                                                            'md-dev.johnmuirhealth.com'
                                                          end
default['jmh_webproxy']['md']['apache']['server_aliases'] = ['md03.johnmuirhealth.com']
default['jmh_webproxy']['md']['prc_site'] = case node['jmh_server']['environment']
                                            when 'prod'
                                              'https://prc.johnmuirhealth.com'
                                            else
                                              'https://prc-dev.johnmuirhealth.com'
                                            end
default['jmh_webproxy']['md']['apache']['docroot'] = '/usr/local/webapps/subsites/staticphp'
default['jmh_webproxy']['md']['apache']['custom_log'] = ['logs/md-access_log combined']
default['jmh_webproxy']['md']['apache']['server_status'] = true
default['jmh_webproxy']['md']['apache']['robots_disallow'] = '/'
default['jmh_webproxy']['md']['apache']['rewrites'] = [
  "^/medstaff/payments/concord(.*) #{node['jmh_webproxy']['md']['prc_site']}/public/payments/concord.html [L]",
  "^/medstaff/payments/walnut-creek(.*) #{node['jmh_webproxy']['md']['prc_site']}/public/payments/walnut-creek.html [L]"
]
