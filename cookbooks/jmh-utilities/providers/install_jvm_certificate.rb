action :install do
  unless new_resource.data_bag && new_resource.data_bag_item && new_resource.data_bag_field
    Chef::Application.fatal!('Missing some data bag information')
  end
  # http://stackoverflow.com/questions/34212746/private-method-in-custom-resource-does-not-work/34233538

  keytool = "#{new_resource.java_home}/jre/bin/keytool"

  install_cert = false
  cert_in_keystore = false

  # Check if it is in the keystore.  If not, we need to install it.
  system("#{keytool} -list -alias #{new_resource.cert_name} -keystore #{new_resource.java_home}/jre/lib/security/cacerts -storepass #{new_resource.keystore_pass}")
  if $?.exitstatus == 0
    install_cert = false
    cert_in_keystore = true
  else
    install_cert = true
  end

  cert_data_bag = Chef::EncryptedDataBagItem.load(new_resource.data_bag, new_resource.data_bag_item)

  cert_file = file "#{new_resource.cert_name}.cer for #{new_resource.name}" do
    path ::File.join(Chef::Config[:file_cache_path], "#{new_resource.cert_name}.cer")
    content cert_data_bag[new_resource.data_bag_field]
    action :create
  end
  # If we update the file, then we need to update the keystoe
  install_cert = true if cert_file.updated_by_last_action?

  Chef::Log.warn("install_cert is: #{install_cert} and cert_in_keystore is: #{cert_in_keystore}")

  execute "Remove #{new_resource.cert_name} Cert for #{new_resource.name}" do
    command "#{keytool} -delete -noprompt -alias #{new_resource.cert_name} -keystore #{new_resource.java_home}/jre/lib/security/cacerts \
             -storepass #{new_resource.keystore_pass}"
    action :run
    only_if { cert_in_keystore && install_cert }
  end

  execute "Import #{new_resource.cert_name} cert for #{new_resource.name}" do
    command "#{keytool} -importcert -noprompt -trustcacerts -alias #{new_resource.cert_name} \
             -file #{Chef::Config[:file_cache_path]}/#{new_resource.cert_name}.cer \
             -keystore #{new_resource.java_home}/jre/lib/security/cacerts -storepass #{new_resource.keystore_pass}"
    action :run
    only_if { install_cert }
  end

  new_resource.updated_by_last_action(install_cert)
end

action :remove do
  keytool = "#{new_resource.java_home}/jre/bin/keytool"

  execute "Remove #{new_resource.cert_name} Cert for #{new_resource.name}" do
    command "#{keytool} -delete -noprompt -alias #{new_resource.cert_name} -keystore #{new_resource.java_home}/jre/lib/security/cacerts \
             -storepass #{new_resource.keystore_pass}"
    action :run
  end
  new_resource.updated_by_last_action(true)
end
