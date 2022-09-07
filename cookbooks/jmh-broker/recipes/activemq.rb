include_recipe 'iptables'

jmh_java_install 'activemq java' do
  version node['jmh_broker']['activemq']['java_version']
  action :install
end

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
unless node['activemq']['admin_console']['credentials']['password']
  node.normal['activemq']['admin_console']['credentials']['password'] = random_password
end

unless node['activemq']['web_console']['system_password']
  node.normal['activemq']['web_console']['system_password'] = random_password
end

# How you know it is an upgrade
# (1) The symbolic link exists
# (2) The symbolic link points somewhere else than your activemq version folder
upgrade = false
old_home= ''
new_home= File.join(node['activemq']['home'] ,"apache-activemq-#{node['activemq']['version']}")
if File.exist?( File.join(node['activemq']['home'],'apache-activemq'))
  old_home= File.readlink(File.join(node['activemq']['home'],'apache-activemq'))
  if old_home != new_home
    Chef::Log.warn("**Upgrade detected.  Will move to #{node['activemq']['version']}")
    upgrade=true
  end
end


service "ActiveMQ Upgrade Stopper" do
  stop_command "/usr/sbin/service activemq stop"
  action :stop
  only_if {upgrade}
end

link '/usr/local/apache-activemq' do
  action :delete
  only_if {upgrade}
end

include_recipe 'activemq'

# if on an encrypted server, move it to the encrypted drive
if node['recipes'].include?('jmh-encrypt::lukscrypt')

  directory ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'activemq') do
    owner node['activemq']['run_user']
    group node['activemq']['run_user']
    mode '0755'
    action :create
  end

  if upgrade
    directory File.join(new_home,'data') do
      action :delete
      recursive true
      notifies :create, 'link[Create DataLog Symlink]', :immediately
    end
  else
    ruby_block 'Move Logs/data to Encryption Location' do
      block do
        FileUtils.mv(File.join(new_home, 'data'),
                     File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'activemq/data'))
      end
      not_if { ::File.symlink?(File.join(new_home, 'data')) }
      notifies :create, 'link[Create DataLog Symlink]', :immediately
    end
  end

  link 'Create DataLog Symlink' do
    target_file File.join(File.join(new_home, 'data'))
    to File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'activemq/data')
    link_type :symbolic
    action :nothing
    notifies :restart, 'service[activemq]', :immediately
  end
else
  # Only do the upgrade move if it is not a lukscrypt system
  ruby_block 'move data folder new instance' do
    block do
      %x(sleep 5; mv #{new_home}/data #{new_home}/data.bak; cp -rp #{old_home}/data #{new_home}/; chown -R activemq. #{new_home}/data   )
    end
    only_if { upgrade && !node['recipes'].include?('jmh-encrypt::lukscrypt') }
    notifies :restart, 'service[activemq]', :immediately
  end
end



iptables_rule 'activemq' do
  source 'activemq_iptables.erb'
  enable enable_activemq_rules
end

