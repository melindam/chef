#
# NOTE:
# These variables are set here, and the "true" value will be per environment -
#   edit all environments to include the new server name for that environment

# to replace ['cq']['dispatcher']['www']['server_name'] and ....
default['jmh_server']['global']['apache']['www']['server_name'] = 'www-local.johnmuirhealth.com'

default['jmh_server']['global']['apache']['api']['server_name'] = 'api-local.johnmuirhealth.com'

# to replace ['cq']['dispatcher']['prc']['server_name']
default['jmh_server']['global']['apache']['prc']['server_name'] = 'prc-local.johnmuirhealth.com'

# to replace ['jmh_pingfed']['idp']['server_name']
default['jmh_server']['global']['apache']['idp']['server_name'] = 'idp-local.johnmuirhealth.com'

# to replace ['jmh_webproxy']['supportportal']['apache']['server_name']
default['jmh_server']['global']['apache']['supportportal']['server_name'] = 'supportportal-local.johnmuirhealth.com'

default['jmh_server']['global']['google_analytics_id'] = 'UA-133170530-1'
default['jmh_server']['global']['google_analytics_id_vvisits'] = 'UA-133170530-7'

# to replace ['jmh_fad']['client']['captcha_key']
default['jmh_server']['global']['google_captcha_site_key'] =  '6Lc2u48UAAAAAO_LaMF7OaCsURddndqhocxb3v3p'
# to replace ['cq']['scheduling_captcha_site_key']
default['jmh_server']['global']['google_captcha_secret_key'] = '6Lc2u48UAAAAABnPmetM9SYn7CPeirAIO3en2wdw'
# to replace ....
default['jmh_server']['global']['google_maps_api_key'] = 'AIzaSyBacsGUfwKhddxA1peO0SLl9Qp4piRtRHk'

# New attributes for webcommon - production set in the environment
default['jmh_server']['global']['google_api_key'] = 'AIzaSyAAxkAHvH50BMM2933X79nY2blxM-QdVSI'
default['jmh_server']['global']['google_uc_doc_maps_api_key'] = 'AIzaSyArElYfclELvuaLU5o1IQ-E5qsa7ijDYTg'

# Attributes for patientportal
default['jmh_server']['global']['patientportal']['url'] = '/patientportal'
default['jmh_server']['global']['patientportal']['name'] = 'MyChart'

default['jmh_server']['global']['tealium_reportsuite_id'] = node['jmh_server']['environment'] == 'prod' ? 'jmhprod2' : 'jmhdev2'
default['jmh_server']['global']['tealium_profile'] = 'main'
default['jmh_server']['global']['tealium_account'] = 'jmh'
default['jmh_server']['global']['tealium_environment'] = node['jmh_server']['environment'] == 'prod' ? 'prod' : 'dev'
default['jmh_server']['global']['tealium_datasource'] = 'voue45'

