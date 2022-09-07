include_recipe 'jmh-billpay::client'

package 'ftp'
package 'mutt'

# Add ssh1.hsys.local key
ssh_known_hosts_entry node['jmh_billpay']['epic']['server'] do
  key node['jmh_billpay']['epic']['host_key']
  key_type node['jmh_billpay']['epic']['key_type']
  action :create
end

deploy_key_bag = Chef::EncryptedDataBagItem.load("deploy_keys", "ebusiness_ssh1")

file File.join('home', node['jmh_tomcat']['user'],  '.ssh', 'ebusiness_id_rsa') do
  content deploy_key_bag['deploy_key']
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['user']
  mode '0600'
end
 
directory node['jmh_billpay']['scripts_dir'] do
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['user']
  mode '0755'
end

# Iterates through the array of scripts to write and sets their path
# to the scripts directory and makes them executable
node['jmh_billpay']['scripts'].each do |basename|
  template File.join(node['jmh_billpay']['scripts_dir'], basename) do
    source "#{basename}.erb"
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['user']
    mode '0755'
  end
end  
