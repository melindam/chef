# default['jmh_mule']['version'] = '3.7.3'
default['jmh_mule']['version'] = '3.8.2'
default['jmh_mule']['user'] = node['jmh_tomcat']['user']
default['jmh_mule']['group'] = node['jmh_tomcat']['group']
default['jmh_mule']['target'] = '/usr/local/mule/'
default['jmh_mule']['local'] = '/usr/local'
default['jmh_mule']['java_version'] = '8'

default['jmh_mule']['scratch_dir'] = '/usr/local/src'
default['jmh_mule']['license'] = 'mule_ee_license.lic'

# default['jmh_mule']['base_url'] = 'https://s3.amazonaws.com/MuleEE/fe49c9b102bcce22304d198936ea663f/mule-ee-distribution-standalone-3.7.3.tar.gz'
default['jmh_mule']['base_url'] = 'https://s3.amazonaws.com/jmhapps/mule/mule-ee-distribution-standalone-3.8.2.zip'

default['jmh_mule']['keep_days_of_logs'] = 90

default['jmh_mule']['iptables'] = { '7777' => { 'target' => 'ACCEPT' } }

default['jmh_mule']['ecryptfs_recipe'] = 'ecryptfs::default'
default['jmh_mule']['ecryptfs_folder'] = if node['recipes'].include?(node['jmh_mule']['ecryptfs_recipe']) 
                                           File.join(node['ecryptfs']['mount'], 'mule')
                                         else
                                           '/data/ecryptfs/mule'
                                         end

# default['jmh_mule']['manager_available'] = false
# default['jmh_mule']['java_options'] = ['-server -Djava.awt.headless=true -Duser.timezone=America/Los_Angeles']
# default['jmh_mule']['ssl']['cert_folder'] = "/home/#{node['jmh_mule']['user']}/ssl"
# default['jmh_mule']['ssl']['data_bag'] = 'apache_ssl'
# default['jmh_mule']['ssl']['data_bag_item'] = 'jmh_internal_cert'

default['jmh_mule']['singleton']['name'] = 'default'
default['jmh_mule']['singleton']['enable_ssl'] = false
default['jmh_mule']['singleton']['port'] = 7777
default['jmh_mule']['singleton']['iptables'] = { '7777' => { 'target' => 'ACCEPT' } }
default['jmh_mule']['singleton']['app_properties'] = [ '#App Properties', 'db.host=localhost', 'db.port=3306', 'db.user=root', 'db.password=password', 'db.database=canopy' ]

default['jmh_mule']['api_manager'] = true
