default['jmh_webserver']['vvisits_client']['user'] ='jmhbackup'
default['jmh_webserver']['vvisits_client']['group'] = 'jmhbackup'
default['jmh_webserver']['vvisits_client']['docroot_dir'] = node['apache']['docroot_dir']
default['jmh_webserver']['vvisits_client']['content_dir'] = 'vv'
default['jmh_webserver']['vvisits_client']['vvisits_time_allowance'] = 18