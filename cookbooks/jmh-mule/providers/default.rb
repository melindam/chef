# Definition for mule applications
# jmh_mule

action :create do
  @run_context.include_recipe 'jmh-mule'
  @run_context.include_recipe 'ark'

  license_file = ::File.join(node['jmh_mule']['scratch_dir'], node['jmh_mule']['license'])
  mule_install_path = node['jmh_mule']['target']
  mule_app = new_resource.name
  mule_service = 'mule_' + mule_app
  
  upgrade = false
  if ::File.exist?("/etc/init.d/#{mule_service}") && ::File.exist?("#{node['jmh_mule']['target']}#{mule_app}")
    cmd = Mixlib::ShellOut.new("/etc/init.d/#{mule_service} version | grep #{new_resource.version}")
    cmd.run_command
    upgrade = cmd.error? ? true : false
    
    #TODO need to get old version from init script
     #ruby_block 'get old version' do
        #block do
         old_version = '3.7.3'
        #end
      #end

    mule_old_home = ::File.join(node['jmh_mule']['target'], "#{mule_app}-#{old_version}")
     
    # If upgrade = need to re-install mule license
    file license_file do
      action :delete
      only_if { upgrade }  
      Chef::Log.warn("*****Mule Upgrade is #{upgrade} and removed license file ")
    end 
  end
  
  Chef::Log.warn('**This is a mule upgrade**') if upgrade

  mule_symlink_home = ::File.join(node['jmh_mule']['target'], "#{mule_app}")
  mule_version_home = ::File.join(node['jmh_mule']['target'], "#{mule_app}-#{new_resource.version}")

  mule_home = !upgrade ? mule_symlink_home : mule_version_home

  ## Install Java
  jmh_java_install 'install java' do
    version new_resource.java_version ? new_resource.java_version : nil
    action :install
  end

  java_home = JmhJavaUtil.get_java_home(new_resource.java_version, node)

  # Get the mule binary
  ark ::File.basename(mule_version_home) do
    url node['jmh_mule']['base_url']
    path mule_install_path
    version new_resource.version
    owner node['jmh_mule']['user']
    group node['jmh_mule']['group']
    action :put
    not_if { ::File.exist?(mule_home) }
  end

  # License file is now being loaded from XML file from previous installed system, still located here:
  # jmh_utilities_s3_download license_file do 
    # remote_path 'mule/mule_ee_license.lic'
    # bucket 'jmhapps'
  # end
  


  # Move log file to ecryptfs
  if node['recipes'].include?(node['jmh_mule']['ecryptfs_recipe'])
    directory ::File.join(node['ecryptfs']['mount'], 'mule', "#{mule_app}-#{new_resource.version}") do
      owner node['jmh_mule']['user']
      group node['jmh_mule']['group']
      mode '0755'
      action :create
    end

    # To move log files to encrypted location
    if !upgrade
      ruby_block 'Move Logs to Encryption Location' do
        block do
          FileUtils.mv(::File.join(mule_home, 'logs'),
                       ::File.join(node['ecryptfs']['mount'], 'mule', "#{mule_app}-#{new_resource.version}", 'logs'))
        end
        not_if { ::File.symlink?(::File.join(mule_home, 'logs')) }
        notifies :create, 'link[Create Log Symlink]', :immediately
      end

      link 'Create Log Symlink' do
        target_file ::File.join(mule_home, 'logs')
        to ::File.join(node['ecryptfs']['mount'], 'mule', "#{mule_app}-#{new_resource.version}", 'logs')
        link_type :symbolic
        action :nothing
        notifies :restart, "service[#{mule_service}]", :delayed
      end
    end
  end

  # If this is an upgrade, move old version to -bak, copy app files to new directory
  if upgrade
    service mule_service do
      action :stop
    end
    # If link exists, remove it.
    # If link exist and real path points bad location, remove it
    link "Remove #{mule_symlink_home}" do
      target_file mule_symlink_home
      action :delete
      # not_if legacy_home_directory
      only_if do
        ::File.symlink?(mule_symlink_home) &&
          ::File.realpath(mule_symlink_home) != mule_home
      end
      Chef::Log.warn(">>> Link removed #{mule_symlink_home} to be recreated")
    end
  
      
    # Copy files recursively instead of read -> put
    ruby_block 'Move mule upgrade dir' do
      block do
        FileUtils.cp_r mule_old_home +'/apps/.', mule_home + '/apps'
        FileUtils.mv mule_old_home, "#{mule_old_home}-bak"       
      end
      action :run
      # not_if { ::File.symlink?(mule_symlink_home) }
    end  
  end
  
  link "Create Symlink #{mule_home}" do
    target_file mule_symlink_home
    to mule_version_home
    link_type :symbolic
    action :create
    Chef::Log.warn(">>> Link is CREATED as #{mule_symlink_home} to #{mule_version_home}")
  end
  
  # copy in the license file
  template ::File.join(mule_home, 'conf/muleLicenseKey.lic') do
    cookbook 'jmh-mule'
    source 'muleLicenseKey.erb'
    owner node['jmh_mule']['user']
    group node['jmh_mule']['group']
    mode '0644'
    notifies :restart, "service[#{mule_service}]", :delayed
  end
    
  template ::File.join('/etc/init.d', mule_service) do
    source 'init_mule.erb'
    cookbook 'jmh-mule'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :java_home => java_home,
      :mule_home =>  mule_version_home,
      :mule_app => mule_app,
      :mule_user => node['jmh_mule']['user'],
      :mule_service => mule_service,
      :mule_version => node['jmh_mule']['version']
    )
    notifies :restart, "service[#{mule_service}]", :delayed
  end

  service mule_service do
    action :enable
  end
  
  Chef::Log.warn("IP tables is #{new_resource.iptables.to_s}")
  iptables_list = { 'portlist' => new_resource.iptables }

  # creates iptables for ports on mule
  iptables_rule "mule_#{mule_app}" do
    cookbook 'jmh-mule'
    source 'mule_iptables.erb'
    variables iptables_list
    enable iptables_list['portlist'].length != 0 ? true : false
  end
  
  if new_resource.app_properties
    template mule_home + '/conf/' + mule_app + '-override.properties' do
      source 'override_properties.erb'
      cookbook 'jmh-mule'
      owner node['jmh_mule']['user']
      group node['jmh_mule']['group']
      mode '0600'
      variables(
        :props => new_resource.app_properties
      )
      notifies :restart, "service[#{mule_service}]", :delayed
    end
  else
    template mule_home + '/conf/' + mule_app + '-override.properties' do
      source 'override_properties.erb'
      cookbook 'jmh-mule'
      action :delete
      notifies :restart, "service[#{mule_service}]", :delayed
    end
  end
  
  template '/home/tomcat/bin/rollout_mule_' + mule_app + '.sh' do
    source 'rollout_mule.erb'
    cookbook 'jmh-mule'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :java_home => java_home,
      :mule_home =>  mule_home,
      :mule_app => mule_app + '.zip',
      :mule_user => node['jmh_mule']['user']
    )
  end

  if new_resource.directories
    new_resource.directories.each do |dir|
      directory dir do
        recursive true
        owner node['jmh_mule']['user']
        group node['jmh_mule']['group']
      end
    end
  end

  # When chef runs, clean up X many days of log files
  execute "removing old mule logs #{node['jmh_mule']['keep_days_of_logs']} old" do
    command "/usr/bin/find -L #{mule_home}/logs -type f -mtime +#{node['jmh_mule']['keep_days_of_logs']} -exec rm -f {} \\;"
    action :run
  end

  new_resource.updated_by_last_action(true)
end
