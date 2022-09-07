default['jmh_sched']['appserver']['enable_ssl'] = true
default['jmh_sched']['appserver']['enable_http'] = true
default['jmh_sched']['appserver']['name'] = 'scheduling'
default['jmh_sched']['appserver']['port'] = 8094
default['jmh_sched']['appserver']['ssl_port'] = 8464
default['jmh_sched']['appserver']['jmx_port'] = 6984
default['jmh_sched']['appserver']['shutdown_port'] = 8064
default['jmh_sched']['appserver']['version'] = '9'
default['jmh_sched']['appserver']['iptables'] = { node['jmh_sched']['appserver']['port'] => { 'target' => 'ACCEPT' },
                                                    node['jmh_sched']['appserver']['ssl_port'] => { 'target' => 'ACCEPT' },
                                                    node['jmh_sched']['appserver']['jmx_port'] => { 'target' => 'ACCEPT' } }
default['jmh_sched']['appserver']['java_version'] = '15'
default['jmh_sched']['appserver']['rollout_array'] = [ 'bamboo_name' => 'scheduling', 'war_name' => 'scheduling' ]
default['jmh_sched']['appserver']['newrelic'] = false
default['jmh_sched']['appserver']['max_heap_size'] = "3g"

default['jmh_sched']['google_secret'] = '6Lc2u48UAAAAABnPmetM9SYn7CPeirAIO3en2wdw'
# Prod key defined in environment 6LdDGo8UAAAAAO02xp1KdZ2hPS1VoC_xtIb4-inl
default['jmh_sched']['google_captcha_score'] = %w(prod).include?(node['jmh_server']['environment']) ? '0.5' : '0'

default['jmh_sched']['cache']['enabled'] = true
default['jmh_sched']['cache']['refresh_cron'] = '0 0/5 * * * ?'
default['jmh_sched']['cache']['timeout'] = 240
