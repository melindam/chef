include_recipe 'apache2::mod_ssl'

# Create the SSL directory to store certificates

ssl_dir = File.join(node['apache']['dir'], 'ssl')

directory "#{ssl_dir} for cq" do
  path ssl_dir
  recursive true
end

# Retrieve data bag item containing the SSL certificate information.

node['cq']['dispatcher']['ssl']['cert_hash'].each_key do  |webserver|
  cert = node['cq']['dispatcher']['ssl']['cert_hash'][webserver]

  Chef::Log.debug("Cert is #{cert}")
  bag = Chef::EncryptedDataBagItem.load(node['cq']['dispatcher']['ssl']['data_bag'], node['cq']['dispatcher']['ssl']['cert_hash'][webserver]).to_hash

  # Create the SSL files that are defined within the certificate data
  # bag item we retrieved and set the ssl attributes for the apache
  # configuration to use when writing out SSL enabled vhost information
  %w(chain key pem).each do |key|
    next unless bag[key]
    ssl_file_path = File.join(ssl_dir, "#{bag['id']}.#{key}")
    file "#{ssl_file_path} for AEM #{webserver}" do
      path ssl_file_path
      content bag[key]
      owner node['apache']['user']
      group node['apache']['group'] || node['apache']['user']
      mode 0600
    end
    node.default['cq']['dispatcher']['ssl']['apache'][webserver][key] = ssl_file_path
  end
end
