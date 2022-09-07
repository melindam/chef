default['jmh_webserver']['webcommon']['user'] ='jmhbackup'
default['jmh_webserver']['webcommon']['group'] = 'jmhbackup'
default['jmh_webserver']['webcommon']['docroot_dir'] = node['apache']['docroot_dir']
default['jmh_webserver']['webcommon']['content_dir'] = 'webcommon'
default['jmh_webserver']['webcommon']['numschedulingdays'] = '90'

# Override this in environment
default['jmh_webserver']['webcommon']['newrelic_enabled'] = false

# All Google keys will be defined in the environment for global API keys
# e.g `node['jmh_server']['global']['google_api_keys']` ... etc, etc
