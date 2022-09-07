default['jmh_paygateway']['name'] = 'payment-gateway'
default['jmh_paygateway']['https_port'] = 8523

default['jmh_paygateway']['iptables_list'] = { 'portlist' => { node['jmh_paygateway']['https_port'] => { 'target' => 'ACCEPT' }} }

default['jmh_paygateway']['nodejs_version'] = '14'
default['jmh_paygateway']['yaml_file'] = 'payment-gateway-local.yaml'
default['jmh_paygateway']['nodejs_newrelic_enabled'] = false
default['jmh_paygateway']['nodejs_newrelic_license'] = 'b8248540110d9562d9623ffeb355f6874b372318'
default['jmh_paygateway']['nodejs_newrelic_loglevel'] = 'info'
default['jmh_paygateway']['nodejs_newrelic_file'] = 'newrelic.js'
default['jmh_paygateway']['startup_env_mode'] = node['jmh_server']['environment'] == 'prod' ? "NODE_ENV=production" : "NODE_ENV=production PG_TEST=true"

#Workday
default['jmh_paygateway']['workday']['host'] = node['jmh_server']['environment'] == 'prod' ? 'wd5-services1.myworkday.com' : 'wd5-impl-services1.workday.com'
default['jmh_paygateway']['workday']['url'] = node['jmh_server']['environment'] == 'prod' ? 'wd5.myworkday.com' : 'wd5-impl.workday.com'
default['jmh_paygateway']['workday']['jmh_location'] = node['jmh_server']['environment'] == 'prod' ? 'jmh' : 'jmh1'
default['jmh_paygateway']['workday']['client_id'] = node['jmh_server']['environment'] == 'prod' ? 'ZTllZGI1NTAtZmRmMi00Y2NhLWJhNWQtOWNlMjViOTY5YjVh' : 'NjNmMDc0MjctMjUxMS00ZmEyLWIwOWMtOWU5ZTYwYzFmZWFk'
default['jmh_paygateway']['workday']['client_secret'] = node['jmh_server']['environment'] == 'prod' ? 'tq44m8z951ywr0r68v175r73yntqlh204h98qxqmmvbpv0ad5r3toqmn1k6g1hxn6ekd5ypebdi48g3tjsfxpj7yu3l52uyu1lu' : 'l9947k3buj3tv1s2jexaxb0srygzevtw4fz61sofe4cza7qrnq8yyhnpgajikl7su2ku7k0mnjc14e2nalz3mumzwknika4q0t2'
# default['jmh_paygateway']['workday']['user_token'] = node['jmh_server']['environment'] == 'prod' ? 'XXX' : 'UsernameToken-33E628C2ECE52DDBC815879825702681'
default['jmh_paygateway']['workday']['user_token'] = 'UsernameToken-33E628C2ECE52DDBC815879825702681'

default['jmh_paygateway']['workday']['username'] = node['jmh_server']['environment'] == 'prod' ? 'ISU_WD_Customer_Portal@jmh' : 'ISU_WD_Customer_Portal@jmh1'
default['jmh_paygateway']['workday']['password'] = node['jmh_server']['environment'] == 'prod' ? 'x4C5V7&!' : 'WD2021!@'

#Chase
default['jmh_paygateway']['chase']['url'] = node['jmh_server']['environment'] == 'prod' ? 'jmh.chasepaymentechhostedpay.com' : 'jmh.chasepaymentechhostedpay-var.com'
default['jmh_paygateway']['orbital']['secureid'] = node['jmh_server']['environment'] == 'prod' ? 'cpt994592430762' : 'cpt519774774156SB'
default['jmh_paygateway']['orbital']['apitoken'] = node['jmh_server']['environment'] == 'prod' ? 'e3e72a1ae1af980573367aa6523cf685' : '2aef1540a74d362d0606c8988fc82e2d'

#MySQL DB
default['jmh_paygateway']['client']['database'] = 'pg'
default['jmh_paygateway']['client']['db']['username'] = 'pg'
default['jmh_paygateway']['client']['db']['developer_user'] = 'pg_dev'
default['jmh_paygateway']['client']['db']['developer_password'] = 'pg_dev'
default['jmh_paygateway']['client']['db']['node_query'] = 'recipes:jmh-paygateway\:\:db OR recipe:jmh-paygateway\:\:db'
default['jmh_paygateway']['client']['db']['connect_over_ssl'] = false