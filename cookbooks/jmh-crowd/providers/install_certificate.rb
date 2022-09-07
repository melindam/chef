

action :create do
  crowd_databag = Chef::EncryptedDataBagItem.load(node['jmh_crowd']['databag']['name'], node['jmh_crowd']['databag']['databag_item'])
  java_version = new_resource.java_version ?  new_resource.java_version : JmhJavaUtil.get_java_version(new_resource.java_home, node)

  keytool = JmhJavaUtil.get_java_keytool_bin(java_version,node)
  keystore = JmhJavaUtil.get_java_keystore_path(java_version,node)

  system("#{keytool} -list -alias #{node['jmh_crowd']['ssl']['keystore_alias']} -keystore #{keystore} -storepass #{new_resource.keystore_pass}")
  if $?.exitstatus == 0
    Chef::Log.info('Skipping the Cert Install for Crowd')
    file "Delete keystore for #{new_resource.name}" do
      path ::File.join(node['jmh_crowd']['scratch_dir'], '.keystore')
      action :delete
    end
    file "Delete scratch keystore for #{new_resource.name}" do
      path ::File.join(node['jmh_crowd']['scratch_dir'], 'crowd.cer')
      action :delete
    end

  else
    directory node['jmh_crowd']['scratch_dir'] do
      action :create
    end

    cookbook_file ::File.join(node['jmh_crowd']['scratch_dir'], '.keystore') do
      cookbook 'jmh-crowd'
      source 'keystore'
      action :create
      owner 'root'
      group 'root'
      mode 0600
    end

    execute "Create Cert from keystore #{new_resource.name}" do
      command "#{keytool} -export -alias #{node['jmh_crowd']['ssl']['keystore_alias']} -file crowd.cer -keystore .keystore -rfc -storepass \
               #{node['jmh_crowd']['ssl']['keystorepass'] ? node['jmh_crowd']['ssl']['keystorepass'] : crowd_databag['keystore_password']}"
      cwd node['jmh_crowd']['scratch_dir']
      action :run
      only_if { !::File.exist?("#{node['jmh_crowd']['scratch_dir']}/crowd.cer") }
    end

    execute "import Crowd Cert crowd #{new_resource.name}" do
      command "#{keytool} -importcert -noprompt -trustcacerts -alias #{node['jmh_crowd']['ssl']['keystore_alias']} -file #{node['jmh_crowd']['scratch_dir']}/crowd.cer \
               -keystore #{keystore} -storepass #{new_resource.keystore_pass}"
      action :run
    end
  end
  new_resource.updated_by_last_action(true)
end

action :remove do

  java_version = new_resource.java_version ?  new_resource.java_version : get_java_version(java_home, node)
  keytool = JmhJavaUtil.get_java_keytool_bin(java_version,node)
  keystore = JmhJavaUtil.get_java_keystore_path(java_version,node)


  execute 'Remove Crowd Cert' do
    command "#{keytool} -delete -noprompt -alias #{node['jmh_crowd']['ssl']['keystore_alias']} -keystore #{keystore} -storepass #{new_resource.keystore_pass}"
  end
  new_resource.updated_by_last_action(true)
end

action :update do
  jmh_crowd_install_certificate new_resource.name do
    java_home new_resource.java_home
    action :remove
  end

  jmh_crowd_install_certificate new_resource.name do
    java_home new_resource.java_home
    action :create
  end
  new_resource.updated_by_last_action(true)
end
