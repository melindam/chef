use_inline_resources

# require "mixlib-shellout"
action :install do

  java_version = new_resource.version ?  new_resource.version : new_resource.name

  java_subversion = node['jmh_java']['jdk'][java_version]['version']

  Chef::Log.debug("Chef subversion is: #{java_subversion}")
  arch = node['jmh_java']['arch']
  java_home = JmhJavaUtil.get_java_home(java_version, node)
  tarball_url = node['jmh_java']['java_hash'][java_subversion][arch]['url']
  tarball_checksum = node['jmh_java']['java_hash'][java_subversion][arch]['checksum']
  tarball_name = tarball_url.split('/').last

  directory node['jmh_java']['install_dir'] do
    recursive true
  end

  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
    source tarball_url
    checksum tarball_checksum
    retries 3
    retry_delay 12
    mode '644'
  end

  archive_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
    destination node['jmh_java']['install_dir']
    overwrite true
    action :extract
    not_if { ::File.exists?(java_home) }
  end

 # Install Java Certs
  keystore = JmhJavaUtil.get_java_keystore_path(java_version, node)
  keytool = JmhJavaUtil.get_java_keytool_bin(java_version, node)

  # Collect all certs into a hash
  cert_hash = JmhJavaUtil.get_java_certs(node, java_version)

  # Drop the cert on the server, import it, and then remove it.
  cert_hash.each_key do |cert_name|
    cert_file_name = ::File.join( ::File.dirname(keystore), "#{cert_name}.cer")

    execute "Import Cert #{cert_name}" do
      command "#{keytool} -importcert -noprompt -trustcacerts -alias #{cert_name}  -file #{cert_file_name} " +
               "-keystore #{keystore} -storepass #{node['jmh_java']['java_security']['storepass']}; rm -f #{cert_file_name}"
      action :nothing
    end
    file cert_file_name do
      content cert_hash[cert_name]
      action :create
      not_if "#{keytool} -list -alias #{cert_name} -keystore #{keystore} -storepass #{node['jmh_java']['java_security']['storepass']}"
      notifies :run, "execute[Import Cert #{cert_name}]", :immediately
    end
  end

end

action :remove do

end
