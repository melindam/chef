default['jmh_events']['client']['appserver']['name'] = 'events'
default['jmh_events']['client']['appserver']['directories'] = %w( /usr/local/webapps/events /usr/local/webapps/events/indexes )
default['jmh_events']['client']['appserver']['port'] = 8080
default['jmh_events']['client']['appserver']['ssl_port'] = 8443
default['jmh_events']['client']['appserver']['jmx_port'] = 6969
default['jmh_events']['client']['appserver']['shutdown_port'] = 8050
default['jmh_events']['client']['appserver']['iptables'] = {
  '8080' => { 'target' => 'ACCEPT' },
  '8443' => { 'target' => 'ACCEPT' },
  '6969' => { 'target' => 'ACCEPT' } }

default['jmh_events']['client']['appserver']['max_heap_size'] = '512M'
default['jmh_events']['client']['appserver']['thread_stack_size'] = '228K'
default['jmh_events']['client']['appserver']['version'] = '9'
default['jmh_events']['client']['appserver']['java_version'] = '8'
default['jmh_events']['client']['appserver']['relax_query_chars'] = false
default['jmh_events']['client']['appserver']['exec_start_pre'] = '-/bin/rm -R /usr/local/webapps/events/indexes/ /usr/local/webapps/events/cache/'

default['jmh_events']['client']['database'] = 'events'
default['jmh_events']['client']['db']['username'] = 'events'
default['jmh_events']['client']['db']['node_query'] = 'recipes:jmh-events\:\:db'
default['jmh_events']['client']['db']['local_recipe'] = 'jmh-events::db'
default['jmh_events']['client']['db']['privileges'] = [:all]

default['jmh_events']['db']['developer_user'] = 'events_dev'
default['jmh_events']['db']['developer_password'] = '!@#events!@#'

default['jmh_network'] = 'generic1.jmmdhs.net'