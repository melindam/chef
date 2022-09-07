default['jmh_fad']['client']['images_url'] = "http://ebiz-tools.hsys.local/physicianimages/"
default['jmh_fad']['client']['images_path'] = "/usr/local/webapps/fad/images"
default['jmh_fad']['client']['export_dir'] = "/usr/local/webapps/fad/export"

default['jmh_fad']['client']['appserver']['name'] = 'fad'
default['jmh_fad']['client']['appserver']['java_version'] = "8"
default['jmh_fad']['client']['appserver']['app_server_type'] = "tomcat"
default['jmh_fad']['client']['appserver']['directories'] = %w(
            /usr/local/webapps/fad/manualimport
            /usr/local/webapps/fad/index
            /usr/local/webapps/fad
            )
default['jmh_fad']['client']['appserver']['port'] = 8085
default['jmh_fad']['client']['appserver']['ssl_port'] = 8449
default['jmh_fad']['client']['appserver']['jmx_port'] = 6974
default['jmh_fad']['client']['appserver']['rollout_array'] = [{ 'bamboo_name' => 'fad', 'war_name' => 'fad', 'db_name' => 'fad' }]
default['jmh_fad']['client']['appserver']['iptables'] = { node['jmh_fad']['client']['appserver']['port'] => {"target" =>"ACCEPT" },
                                                          node['jmh_fad']['client']['appserver']['ssl_port'] => {"target" => "ACCEPT"},
                                                          node['jmh_fad']['client']['appserver']['jmx_port'] => {"target" => "ACCEPT"} }

default['jmh_fad']['client']['appserver']['version'] = '9'

# Prod Key =  AIzaSyCuyyD24QD0G0SDBt-5Rk8WDd8LlsB8Hrs    defined in environment             
default['jmh_fad']['client']['google_maps_api_key'] = 'AIzaSyBacsGUfwKhddxA1peO0SLl9Qp4piRtRHk'
# Prod Key =  AIzaSyBwiJmPxPFkJOKAuwjZs3sHSwCj43Asevk   defined in environment             
default['jmh_fad']['client']['google_maps_backend_api_key'] = 'AIzaSyAHkqYujb8ZkR-ULoL_hKlUkDEEtmFoSMA'

default['jmh_fad']['client']['tealium'] = node['jmh_server']['environment'] == 'arprod' ? 'prod' : 'dev'
default['jmh_fad']['client']['omniture']= node['jmh_server']['environment'] == 'arprod' ? 'jmhprod' : 'jmhtestonly'
default['jmh_fad']['client']['appserver']['max_heap_size'] = "640M"
# Prod Key = 6LdDGo8UAAAAACYPmZtCoMuTaIAAAGnRtJSEmk9C  defined in environment for Captcha V3
default['jmh_fad']['client']['captcha_key'] = '6Lc2u48UAAAAAO_LaMF7OaCsURddndqhocxb3v3p'


default['jmh_fad']['client']['scheduling_search_query'] = 'recipes:jmh-sched\:\:scheduling AND chef_environment:' + node.environment
default['jmh_fad']['client']['scheduling_cache_context'] = node['jmh_sched']['appserver']['name']

default['jmh_fad']['client']['database'] = "fad"
default['jmh_fad']['client']['db']['username'] = "fad"
default['jmh_fad']['client']['db']['ssl'] = true
default['jmh_fad']['client']['db']['bind_address'] = '0.0.0.0'
default['jmh_fad']['client']['db']['local_recipe'] = 'jmh-fad::db'
default['jmh_fad']['client']['db']['node_query'] = 'recipes:jmh-fad\:\:db'
default['jmh_fad']['client']['db']['privileges'] = [:all]
default['jmh_fad']['client']['db']['connect_over_ssl'] = false

default['jmh_fad']['client']['upload']['user'] = 'fad'
default['jmh_fad']['client']['upload']['group'] = 'fad'
default['jmh_fad']['client']['upload']['folder'] = "/usr/local/fadupload"
default['jmh_fad']['client']['upload']['symlink'] = "echo_export"
# Does not override in catalina.properties from code correctly
default['jmh_fad']['client']['upload']['import_file_name'] = "FAD_EXPORT_v2.3.csv"
default['jmh_fad']['client']['numschedulingdays'] = '90'

default['jmh_fad']['db']['developer_user'] = 'fad_dev'
default['jmh_fad']['db']['developer_password'] = '!@#fad!@#'

# Attributes related to 2nd node configurations
default['jmh_fad']['client']['second_node_search_query'] = 'recipes:jmh-fad\:\:client AND chef_environment:' + node.environment
