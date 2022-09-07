default['jmh_tcserver']['user'] = 'tomcat'
default['jmh_tcserver']['group'] = 'tomcat'
default['jmh_tcserver']['install_dir'] = '/usr/local/tcserver'
default['jmh_tcserver']['repository'] = 'git@github.com:JohnMuirHealth/tcserver-instances.git'
default['jmh_tcserver']['revision'] = 'master'
default['jmh_tcserver']['enabled_apps'] = []
default['jmh_tcserver']['available_apps'] = %w(billpay billpay-admin events fad prereg-admin preregistration webrequest)
