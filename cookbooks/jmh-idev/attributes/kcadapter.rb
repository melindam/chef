default['jmh_idev']['nodejs_version'] = '14'

default['jmh_idev']['kcadapter_api']['db']['username'] = 'kcadapter_api'
default['jmh_idev']['kcadapter_api']['name'] = 'kcadapter-api'
default['jmh_idev']['kcadapter_api']['http_port'] = 8520
default['jmh_idev']['kcadapter_api']['data_bag'] = ['jmh_apps','kcadapter-api']
default['jmh_idev']['kcadapter_api']['iptables_list'] = { 'portlist' => {node['jmh_idev']['kcadapter_api']['http_port']  => { 'target' => 'ACCEPT' } } }
default['jmh_idev']['kcadapter_api']['context_property_list'] = { 'unknown.api.url': File.join(node['jmh_idev']['kcadapter_api']['name'],'unknown'),
                                                                 'kcadapter.api.url': File.join(node['jmh_idev']['kcadapter_api']['name'],'kcadapter')}

default['jmh_idev']['kcadapter_api']['emails'] = (%w(prod stage).include? node['jmh_server']['environment']) ? "Andrew.Gumperz@johnmuirhealth.com,Jason.Macomb@johnmuirhealth.com,Luminita.Nagy@johnmuirhealth.com" : "Luminita.Nagy@johnmuirhealth.com"
