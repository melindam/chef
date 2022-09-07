# Graphite
default['graphite']['password'] = 'change_me'
default['graphite']['user'] = 'apache'
default['graphite']['group'] = 'apache'

default['jmh_monitor']['carbon']['ip'] = '127.0.0.1'
default['jmh_monitor']['carbon']['port'] = 2003
default['jmh_monitor']['graphite']['hostname'] = 'test-graphite.johnmuirhealth.com'
default['jmh_monitor']['graphite']['libiconv_src'] = 'https://forensics.cert.org/centos/cert/7/x86_64/libiconv-1.15-1.el7.x86_64.rpm'

# https://github.com/grepory/wizardvan
default['jmh_monitor']['wizardvan']['queue_size'] = 256
default['jmh_monitor']['wizardvan']['relay_src'] = 'https://raw.githubusercontent.com/grepory/wizardvan/a344f083b6ae0c4942424e23efdf99aef39a5cd6/lib/sensu/extensions/handlers/relay.rb'
default['jmh_monitor']['wizardvan']['metrics_src'] = 'https://raw.githubusercontent.com/grepory/wizardvan/a344f083b6ae0c4942424e23efdf99aef39a5cd6/lib/sensu/extensions/mutators/metrics.rb'

default['jmh_monitor']['graphite']['http']['server_name'] =  node['jmh_monitor']['graphite']['hostname']
default['jmh_monitor']['graphite']['http']['port'] = 80
default['jmh_monitor']['graphite']['http']['docroot'] = '/opt/graphite/web'
default['jmh_monitor']['graphite']['http']['error_log'] = 'logs/graphite-error.log'
default['jmh_monitor']['graphite']['http']['custom_log'] = ['logs/graphite-access.log common']