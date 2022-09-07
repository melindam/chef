default['pingfed']['version'] = '10.1.0'
default['pingfed']['filename'] = 'pingfederate-' + node['pingfed']['version']
default['pingfed']['download_url'] = 'https://s3.amazonaws.com/pingone/public_downloads/pingfederate/' +
    node['pingfed']['version'] + '/' + node['pingfed']['filename'] + '.tar.gz'

default['jmh_pingfed']['pingfederate']['java_version'] = '11'
default['pingfed']['java_home'] = JmhJavaUtil.get_java_home(node['jmh_pingfed']['pingfederate']['java_version'], node)

default['jmh_pingfed']['execute_do_not_show_sensitive_data'] = true

default['jmh_pingfed']['admin_user'] = 'Administrator'

default['jmh_pingfed']['jmh']['server'] = node['jmh_server']['global']['apache']['www']['server_name']
default['jmh_pingfed']['api']['server'] = node['jmh_server']['global']['apache']['api']['server_name']
default['jmh_pingfed']['idp']['server_name'] = node['jmh_server']['global']['apache']['idp']['server_name']

default['jmh_pingfed']['server_hostname'] = node['fqdn']

# The development licenses are by X.X while versions are x.x.x
#     so we slice off tht last triplet
default['jmh_pingfed']['pingfederate']['license_file'] =
      if node['jmh_server']['environment'] == 'prod'
        "production_#{node['pingfed']['version'].slice(0, node['pingfed']['version'].rindex('.'))}.lic"
      else
        "development_#{node['pingfed']['version'].slice(0, node['pingfed']['version'].rindex('.'))}.lic"
      end
default['jmh_pingfed']['pingfederate']['plugins'] = ["pf.plugins.pf-pcv-rest.jar",
                                                     "pf.plugin.set-cookie-authentication-selector.jar",
                                                     "pf.plugins.mfa-authentication-selector.jar"]
default['jmh_pingfed']['pingfederate']['iptables'] =
    { 'portlist' => { node['pingfed']['admin_port'] => { 'target' => 'ACCEPT' },
                     node['pingfed']['listen_port'] => { 'target' => 'ACCEPT' },
                     node['pingfed']['default_cluster_bind_port'] => { 'target' => 'ACCEPT' },
                     node['pingfed']['console_cluster_bind_port'] => { 'target' => 'ACCEPT' },
                     node['pingfed']['cluster_failure_detection_bind_port'] => { 'target' => 'ACCEPT' },
                    }
   }
default['jmh_pingfed']['pingfederate']['node_query'] = 'recipes:jmh-pingfed\:\:pingfederate'

default['jmh_pingfed']['databag']['name'] = 'jmh_apps'
default['jmh_pingfed']['databag']['item'] = 'pingfed'

default['jmh_pingfed']['samesite_exclusions'] = ['^.*PingdomTMS.*']

default['jmh_pingfed']['tealium_reportsuite_id'] = node['jmh_server']['environment'] == 'prod' ? 'jmhprod2' : 'jmhdev2'
default['jmh_pingfed']['tealium_utag_env'] = node['jmh_server']['environment'] == 'prod' ? 'prod' : 'dev'

# oAuth Access Token Manager
# WELLBE :
# Key = KEY_SIGN = 814C1DA349623BDBD963A7FF9377A814C1DA349623BDBD963A7FF9377A
# NEEDS HEX ENCODING = 38313443314441333439363233424442443936334137464639333737413831344331444133343936323342444244393633413746463933373741
# Key = KEY_ENCRYPT = 3F8D8779B749C948D17F5116753C5123
# NEED HEX ENCODED = 3346384438373739423734394339343844313746353131363735334335313233
#
# PORTAL - JMH-SSO :
# Key = KEY_SIGN = 3781B2AF8C38F385E124CD86BCB2A3781B2AF8C38F385E124CD86BCB2A
# NEEDS HEX ENCODING = 33373831423241463843333846333835453132344344383642434232413337383142324146384333384633383545313234434438364243423241
#
# FHIR :
# Key = KEY_SIGN = 14CA376B43CB4CDC5194521E14CEF123
# NEED HEX ENCODING = 3134434133373642343343423443444335313934353231453134434546313233
#

default['jmh_pingfed']['client_secret']['wellbe'] =  JmhPingFed.get_pingfed_client_secret('wellbe',node)

default['jmh_pingfed']['client_secret']['jmh_sso'] = JmhPingFed.get_pingfed_client_secret('jmh_sso',node)

default['jmh_pingfed']['redirect_uris']['wellbe'] = case node['jmh_server']['environment']
                                               when 'prod'
                                                   'https://careguides.wellbe.me/authentications/john_muir/callback'
                                               when 'stage'
                                                   'https://careguides.share.wellbe.me/authentications/john_muir/callback'
                                               when 'dev'
                                                    'https://careguides.share.wellbe.me/authentications/john_muir/callback '
                                               else
                                                    'http://localhost:8080/test'
                                               end
