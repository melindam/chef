# Create the cert for TLS for sensu.
# A TLS cert is created for sensu's api and front end, and then a CA is created for the agents to trust

group node['sensugo']['group'] do
  action :create
end

user node['sensugo']['user'] do
  comment 'Sensu Account'
  home '/opt/sensu'
  shell '/bin/false'
end

remote_file "/usr/local/bin/cfssl" do
  source "https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64"
  mode 0775
  action :create
end

remote_file "/usr/local/bin/cfssljson" do
  source "https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssljson_1.4.1_linux_amd64"
  mode 0775
  action :create
end

directory '/etc/sensu/tls' do
  recursive true
  action :create
end

ca_cert_filepath = File.join(node['jmh_monitor']['sensugo']['cert_folder'],node['jmh_monitor']['sensugo']['ca_cert_name'])
address_list=['localhost',
              '127.0.0.1',
              node['jmh_monitor']['sensugo']['export_name'],
              node['jmh_monitor']['sensugo']['servername'] ]
address_list.push(node['ipaddress'])
if node['cloud']
  %w( local_hostname local_ipv4 public_hostname public_ipv4 ).each do | address |
    address_list.push(node['cloud'][address])
  end
end

Chef::Log.warn("Addresses are :#{address_list.join(',')}")

bash "create sensu certs" do
  cwd node['jmh_monitor']['sensugo']['cert_folder']
  code <<-EOH
    # Create the Certificate Authority
    echo '{"CN":"Sensu JMH CA","key":{"algo":"rsa","size":2048}}' | /usr/local/bin/cfssl gencert -initca - | /usr/local/bin/cfssljson -bare ca -
    # Define signing parameters and profiles. Note that agent profile provides the "client auth" usage required for mTLS.
    echo '{"signing":{"default":{"expiry":"43800h","usages":["signing","key encipherment","client auth"]},"profiles":{"backend":{"usages":["signing","key encipherment","server auth","client auth"],"expiry":"43800h"},"agent":{"usages":["signing","key encipherment","client auth"],"expiry":"43800h"}}}}' > ca-config.json

    #export ADDRESS=localhost,127.0.0.1,192.168.114.230,18.144.83.22,ec2-18-144-83-22.us-west-1.compute.amazonaws.com,#{node['jmh_monitor']['sensugo']['export_name']}
    export ADDRESS=#{address_list.join(',')}
    export NAME=#{node['jmh_monitor']['sensugo']['export_name']}
    echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | /usr/local/bin/cfssl gencert -config=ca-config.json -profile="backend" -ca=#{node['jmh_monitor']['sensugo']['ca_cert_name']} -ca-key=ca-key.pem -hostname="$ADDRESS" - | /usr/local/bin/cfssljson -bare $NAME

    chown sensu. *.pem
    chmod 700 #{node['jmh_monitor']['sensugo']['ca_cert_name']}
  EOH
  not_if { File.exists?(ca_cert_filepath) }
  notifies :restart, 'service[sensu-backend]', :delayed
end

# put the ca.pem into a property
#
ruby_block "Copy ca.pem to a property" do
  block do
    caFile = File.open(ca_cert_filepath)
    node.normal['jmh_monitor']['sensugo']['ca_data'] = caFile.read
  end
end
