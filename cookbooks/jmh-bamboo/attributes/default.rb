default['mysql']['bind_address'] = '0.0.0.0'
default['mysql']['version'] = '5.7' if node['platform_version'].start_with?('7.')
default['jmh_db']['default_storage_engine'] = 'InnoDB'

default['jmh_bamboo']['scratch_dir'] = '/usr/local/src/bamboo'
default['jmh_bamboo']['install']['dir'] = '/usr/local/bamboo'
default['jmh_bamboo']['server_name'] = 'ebiz-build.hsys.local'
default['jmh_bamboo']['server_port'] = '80'
default['jmh_bamboo']['server_alias'] = 'ebiz19.hsys.local'
default['jmh_bamboo']['mybase_bamboo_url'] = 'http://ebiz-build.hsys.local/bamboo'
default['jmh_bamboo']['base_local_url'] = 'http://ebiz-tools.hsys.local/share'
default['jmh_bamboo']['base_url'] = 'http://www.atlassian.com/software/bamboo/downloads/binary/'

default['jmh_bamboo']['version'] = '7.0.4'
# default['jmh_bamboo']['version'] = '6.6.2'
# Note: you can get the build number from the ReadME File
#  README.txt:Bamboo 5.15.5-#51518 README
default['jmh_bamboo']['build_number'] = { '6.4.1': '60405',
                                          '6.6.2': '60606',
                                          '7.0.4': '70018'}
default['jmh_bamboo']['flavor'] = :standalone # or :war or :jmh_bambooid
default['jmh_bamboo']['names']['standalone'] = 'atlassian-bamboo'
default['jmh_bamboo']['extensions']['standalone'] = '.tar.gz'
default['jmh_bamboo']['extensions']['war'] = '-war.zip'
default['jmh_bamboo']['extensions']['jmh_bambooid'] = '-war.zip'
default['jmh_bamboo']['run_as'] = 'bamboo'
default['jmh_bamboo']['mysql']['username'] = 'bamboo'
default['jmh_bamboo']['mysql']['dbname'] = 'bamboo'
default['jmh_bamboo']['crowd_authentication'] = true

default['jmh_bamboo']['windows']['bamboo_dir'] = 'C:\\bamboo'
default['jmh_bamboo']['windows']['nodejs_install_url'] = 'https://nodejs.org/dist/v12.13.0/node-v12.13.0-x86.msi'
default['jmh_bamboo']['windows']['bamboo_service'] = 'bamboo-remote-agent'
default['jmh_bamboo']['windows']['java']['jdk_version'] = '8'
default['jmh_bamboo']['windows']['java']['install_flavor'] = 'windows'
default['jmh_bamboo']['windows']['java']['oracle']['accept_oracle_download_terms'] = true
default['jmh_bamboo']['windows']['java']['java_home'] = "C:\\Program Files\\Java\\jdk1.8.0_231"
default['jmh_bamboo']['windows']['java']['package_name'] = 'Java(TM) SE Development Kit 8 (64-bit)'
default['jmh_bamboo']['windows']['java']['windows']['url'] = "https://jmhpublic.s3-us-west-1.amazonaws.com/java/jdk-8u231-windows-x64.exe"
default['jmh_bamboo']['windows']['nssm']['version'] = '2.24'
default['jmh_bamboo']['windows']['nssm']['url'] = "http://nssm.cc/release/nssm-#{node['jmh_bamboo']['windows']['nssm']['version']}.zip"
default['jmh_bamboo']['windows']['nssm']['binary'] = "C:\\bamboo\\nssm-#{node['jmh_bamboo']['windows']['nssm']['version']}\\win64\\nssm.exe"
default['jmh_bamboo']['windows']['bamboo_update'] = false

default['jmh_bamboo']['crowd_role'] = 'jmh-crowd'
default['jmh_bamboo']['config']['setup_variables_list'] = %w(setupStep setupType)

default['jmh_bamboo']['mysql']['bin_dir'] = '/usr/bin'
default['jmh_bamboo']['iptables'] = true
default['jmh_bamboo']['java']['versions'] = %w(7 8 11 15)
default['jmh_bamboo']['java']['server_version'] = '8'
# hard coded on bamboo node
# "jmh_java": {
#   "jdk": {
#     "8": {
#       "version": "jdk1.8.0_241"
#     }
#   }
# }
default['jmh_webserver']['listen'] = [80]
default['jmh_bamboo']['web_server']['port'] = 80
default['jmh_bamboo']['web_server']['ip_address'] = '*'
default['jmh_bamboo']['web_server']['proxy_passes'] = ['/bamboo http://localhost:8085/bamboo']
default['jmh_bamboo']['web_server']['proxy_pass_reverses'] = ['/bamboo http://localhost:8085/bamboo']
default['jmh_bamboo']['web_server']['docroot'] = '/var/www/html'
default['jmh_bamboo']['web_server']['server_name'] = node['jmh_bamboo']['server_name']
default['jmh_bamboo']['web_server']['server_aliases'] = [node['jmh_bamboo']['server_alias']]
default['jmh_bamboo']['web_server']['custom_log'] = ['logs/bamboo_access_log combined']
default['jmh_bamboo']['web_server']['app_server'] = 'bamboo'
default['jmh_bamboo']['web_server']['locations'] = { '/bamboo': ['Require all Granted'],
                                                     '/jenkins': ['Require all Granted'] }
default['jmh_bamboo']['web_server']['directories'] = { '/var/www/html/lighthouse_reports':
                                                                      ['DirectoryIndex disabled',
                                                                      'Options Indexes',
                                                                      'Require all Granted'] }

# TODO get the correct zip file to work for grails
default['jmh_bamboo']['executables'] = [
  { 'app_name' => 'apache-maven-3.2.5', 'url' => 'http://mirror.olnevhost.net/pub/apache//maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz' },
  { 'app_name' => 'apache-maven-3.3.9', 'url' => 'http://mirror.olnevhost.net/pub/apache//maven/maven-3/3.2.5/binaries/apache-maven-3.3.9-bin.tar.gz' },
  { 'app_name' => 'grails-2.5.6', 'url' => 'https://github.com/grails/grails-core/releases/download/v2.5.6/grails-2.5.6.zip' }
]
default['jmh_bamboo']['mvn']['archiva_server_name'] = 'https://ebizrepo.johnmuirhealth.com/archiva/repository/releases-and-snapshots'
default['jmh_bamboo']['mvn']['archiva_server_recipe'] = 'recipes:jmh-archiva\:\:default'

default['jmh_bamboo']['nodejs_install_action'] = :install
default['jmh_bamboo']['current_nodejs_version'] = '14'
default['jmh_bamboo']['nodejs_versions'] = [ node['jmh_bamboo']['current_nodejs_version'], '14', '15' ]

default['jmh_bamboo']['whitesource']['jar_url'] = 'https://unified-agent.s3.amazonaws.com/wss-unified-agent-20.9.1.jar'

default['jmh_bamboo']['agent']['jar_file'] = "atlassian-bamboo-agent-installer-#{node['jmh_bamboo']['version']}.jar"

default['jmh_bamboo']['npm_private_token'] = '3da38499-6496-4465-ba7a-8cf40ad2b7e0'

default['jmh_bamboo']['lighthouse_paths'] = "/ /doctor/npi/1346474020 /doctor/npi/1609106137 /locations/outpatient-center-berkeley.html?contentblock=doctors /locations/outpatient-center-berkeley.html?contentblock=urgent-care /doctor /patientportal /profile-client/registration/new"
default['jmh_bamboo']['dev_www_search_recipe'] = "role:cq-dispatcher"
default['jmh_bamboo']['lighthouse_env'] = ['awstst2']
default['jmh_bamboo']['lighthouse_report_dir'] = '/var/www/html/lighthouse_reports'
default['jmh_bamboo']['graphite_server_query'] = "recipes:jmh-monitor\\:\\:graphite AND chef_environment:awspoc"

default['jmh_bamboo']['mongodb']['vvisit']['username'] = 'vvisits'
default['jmh_bamboo']['mongodb']['vvisit']['password'] = 'vvisits123'
default['jmh_bamboo']['mongodb']['vvisit']['database'] = 'VideoVisitsQA'