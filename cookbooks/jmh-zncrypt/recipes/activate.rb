
# activate zncrypt, for that we need a master key and license administrator's email
passphrase = node[:zncrypt][:passphrase]
passphrase2 = node[:zncrypt][:passphrase2]

if passphrase.nil? 
 data_bag('masterkey_bag')
 # we also need a passhprase and second passphrase, we will generate a random one
 passphrase=data_bag_item('masterkey_bag', 'key1')['passphrase']
 passphrase2=data_bag_item('masterkey_bag', 'key1')['passphrase2']
end

# grab license key administrator's email from attributes
email1 = node[:zncrypt][:admin_email1]
email2 = node[:zncrypt][:admin_email2]
hostname = node.name
org = node[:zncrypt][:organization]
auth_code = node[:zncrypt][:auth_code]


# need to stop and click email here... so sleep 1 minute ??
execute "sleep60 " do
  command "/bin/sleep 60"
  action :nothing
end

# build the arguments to the activate command
activate_args="--org=#{org} --auth=#{auth_code} --key-type=single-passphrase --clientname=#{hostname} --trustee=#{email1} --trustee=#{email2} --votes 1"

# use printf to avoid logging of the passphrase
execute "activate zNcrypt" do
  command "printf '#{passphrase}\n#{passphrase}\n' | /usr/sbin/zncrypt register #{activate_args}"
  #  Don't know if both of these are needed, delete the 2nd command
  #  printf "#{passphrase}\n#{passphrase}\n" | /usr/sbin/zncrypt request-activation -c #{email1}
    not_if { ::File.exists?("/etc/zncrypt/ztrustee/ztrustee.conf") }
    notifies  :run, "execute[sleep60]", :immediately
end