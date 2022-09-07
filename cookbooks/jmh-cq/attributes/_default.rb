default['cq']['aem_version'] = '6.5'
default['cq']['cq_s3_key'] = "AEM_#{node['cq']['aem_version']}_Quickstart.jar"
default['cq']['java_version'] = '11'
default['cq']['admin']['username'] = 'admin'
default['cq']['admin']['default_password'] = 'admin'
default['cq']['default_gems'] = %w(multipart-post)
default['cq']['default_packages'] = %w(gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel)

default['cq']['omniture_prc_mode'] = 'jmhprcdev'
default['cq']['omniture_www_mode'] = 'jmhdev'

default['cq']['google_api_key'] = 'AIzaSyAAxkAHvH50BMM2933X79nY2blxM-QdVSI'
# override in production env
default['cq']['personalization_google_geolocation_apikey'] = "AIzaSyBlqFTv4Rcs5TbzJ3EMCa_B8Cif1IavCH8"
# override in production env
default['cq']['scheduling_captcha_site_key'] = '6Lc2u48UAAAAAO_LaMF7OaCsURddndqhocxb3v3p'
# MS Bot keys
default['cq']['ms_bot_secret_key'] = 
              (%w(prod stage).include? node['jmh_server']['environment']) ? 'hjYqgCDcaNg.DmwxmF6XT0Iprkm0jJkX97i91o8tHHEa5ERA8BxbhP8' : '4Q8USA9lD7M.E7mR0HLZGJatbNhjsUduXIxaU-45--XFsqcrkHzdeZI'
default['cq']['ms_qnamaker_kb_id'] = '25e56e0d-1393-4e87-96df-66a84fe256be'
default['cq']['ms_qnamaker_kb_ocp_key'] = '2973bb5ffca44b1aaeba0c8fd6db9dc1'

default['cq']['databag']['name'] = 'jmh_apps'
default['cq']['databag']['item'] = 'cq'
default['cq']['databag']['password_key'] = 'default_password'

default['cq']['patientportal']['url'] = '/patientportal'
default['cq']['patientportal']['name'] = 'MyChart'

# default['cq']['node_removals'] = {'/etc/clientlibs/granite/jquery.js' => '/etc/clientlibs/granite/jquery'}

default['cq']['6.5']['servicepack_name'] = 'aem-service-pkg-6.5.6.zip'

default['cq']['6.5']['bundles'] = [ { 'name' => 'jmh_ldap.zip',
                                      'file_location' => 'bundles',
                                      'package_location' => '/crx/packmgr/service/.json/etc/packages/jmh',
                                      'delay' => 20,
                                      'restart' => false
                                    },
                                    { 'name' => node['cq']['6.5']['servicepack_name'],
                                      'file_location' => 'bundles',
                                      'package_location' => '/crx/packmgr/service/.json/etc/packages/adobe/cq650/servicepack',
                                      'delay' => 90,
                                      'restart' => true
                                      },
                                    { 'name' => 'adobe-aemfd-linux-pkg-6.0.122.zip',
                                      'file_location' => 'bundles',
                                      'package_location' => '/crx/packmgr/service/.json/etc/packages/day/cq60/fd',
                                      'delay' => 90,
                                      'restart' => true
                                    }
                                  ]
default['cq']['6.5']['post_install_content']['bundles'] = []
default['cq']['6.5']['encryption_bundle'] = 'crx-quickstart/launchpad/felix/bundle25'

default['cq']['crypto_environment'] = 'dev'

default['cq']['base_directory'] = '/usr/local/cq'
default['cq']['share_directory'] = File.join(node['cq']['base_directory'], 'share')
default['cq']['jar_directory'] = File.join(node['cq']['base_directory'], 'src')
default['cq']['bin_dir'] = File.join(node['cq']['base_directory'], 'bin')
default['cq']['oak']['jar_version'] = '1.9.9'
default['cq']['oak']['jar_name'] = "oak-run-#{node['cq']['oak']['jar_version']}.jar"
default['cq']['oak']['url'] = "https://repo1.maven.org/maven2/org/apache/jackrabbit/oak-run/" + node['cq']['oak']['jar_version'] +
                              "/oak-run-" + node['cq']['oak']['jar_version'] + ".jar"

default['cq']['user'] = 'cq'
default['cq']['maintenance_user'] = 'cqadmin'
default['cq']['group'] = 'cq'

default['cq']['modes'] = %w(publisher author)

default['cq']['lb']['databag'] = ['credentials','brocade']
default['cq']['lb']['pools'] = ['www-https-round-robin','www-https-session-cookie']
default['cq']['dispatcher_publisher_hash'] = {"cq-publisher01": "cq-dispatcher01",
                                              "cq-publisher02": "cq-dispatcher02"}
default['cq']['dispatcher_role'] = 'cq-dispatcher'

default['cq']['aws']['s3_bucket'] = 'jmhaem'
default['cq']['license']['product_name'] = 'CRX'
default['cq']['license']['customer_name'] = 'John Muir Health'
default['cq']['license']['product_version'] = '2.0.0.20100122'
default['cq']['license']['download_id'] = '6dcb47e0-d7e5-3a41-bb15-27648ac761d8'

default['cq']['jvm_opts']['system_properties'] =  %w(java.awt.headless=true
                                                     org.apache.jackrabbit.core.state.validatehierarchy=true
                                                     crx.memoryCheckDisabled=true
                                                     com.sun.management.jmxremote
                                                     com.sun.management.jmxremote.ssl=false
                                                     com.sun.management.jmxremote.authenticate=false)

default['cq']['jvm_opts']['memory_size'] = '1536m'
default['cq']['jvm_opts']['max_perm_size'] = '1536m'
default['cq']['jvm_opts']['tmp_directory'] = '/usr/local/cq/tmp'

default['cq']['backup_directory'] = File.join(node['cq']['base_directory'], 'backup')
default['cq']['checksums'] = {}

default['cq']['check_page']['email'] = 'melinda.moran@johnmuirhealth.com'

default['cq']['install_content'] = false

default['cq']['geo_sites'] = %w(/content/geometrixx/ /content/geometrixx_mobile/ /content/geometrixx-outdoors/ /content/geometrixx-outdoors-mobile/
                                /content/dam/geometrixx/ /content/dam/geometrixx-outdoors/ /content/geometrixx-gov/
                                /content/dam/geometrixx-unlimited/ /content/dam/geometrixx-gov/ /content/dam/formsanddocuments/geometrixx-gov)

# separating author & publisher runs
# Zips seem to need at least 15 hours for them to run
default['cq']['maintenance_time']['zip_hour'] = 5
default['cq']['maintenance_time']['author_weekday'] = 1
default['cq']['maintenance_time']['publisher_weekday'] = 5
default['cq']['maintenance_time']['publisher_weekday_rolehash'] = {'cq-publisher01': 2,
                                                                   'cq-publisher02': 3 }

default['cq']['maintenance_scripts'] =   {
  'backup_cq' => {
    'template' => 'backup_cq.erb',
    'user' => node['cq']['maintenance_user'],
    'weekday' => '*',
    'hour' => 17,
    'minute' => 16
  },
  'backup_cq_to_zip' => {
    'template' => 'backup_cq_to_zip.erb',
    'user' => 'root',
    'hour' => node['cq']['maintenance_time']['zip_hour'],
    'minute' => 16
  }
}

default['cq']['dispatcher']['document_root'] = '/var/www/html'

default['cq']['scripts']['aws_databag']['bag'] = 'credentials'
default['cq']['scripts']['aws_databag']['file'] = 'aws'
#TODO need to remove the production environment names from the cookbooks.
default['cq']['scripts']['environments'] = %w(arprod arstage awspoc2 awstst awstst2)
default['cq']['scripts']['prod_environment'] = 'arprod'
default['cq']['scripts']['cron_environments'] = %w(arprod)
default['cq']['scripts']['perl_packages'] = %w( POSIX Test::More Digest::HMAC_SHA1 Digest::MD5 FindBin MIME::Base64 Getopt::Long)
## skip the aws_push script if it is not prod; don't need any accidental uploads
default['cq']['scripts']['script_array'] = if node['jmh_server']['environment'] == 'prod'
                                             %w( download-assets download_assets_s3 aws_push)
                                           else
                                             %w( download-assets download_assets_s3)
                                           end
default['cq']['scripts']['publisher_server_search'] = "recipes:jmh-cq\\:\\:publisher AND chef_environment:#{node.environment}"
default['cq']['scripts']['author_server_search'] = "recipes:jmh-cq\\:\\:author AND chef_environment:#{node.environment}"
default['cq']['scripts']['author_packages'] = %w(jmhbackup-content-jmh jmhbackup-dam-jmh-documents-a-m jmhbackup-dam-jmh-documents-n-z
                                                 jmhbackup-dam-jmh-no-documents jmhbackup-content-prc jmhbackup-dam-prc jmhbackup-forms)
default['cq']['scripts']['publisher_packages'] = %w(jmhbackup-pub-content-jmh jmhbackup-pub-dam-jmh-documents-a-m jmhbackup-pub-dam-jmh-documents-n-z
                                                    jmhbackup-pub-dam-jmh-no-documents jmhbackup-pub-content-prc jmhbackup-pub-dam-prc jmhbackup-pub-forms)
