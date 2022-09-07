use_inline_resources

action :install do
  key = new_resource.name

  # Ensure the required recipes are included
  @run_context.include_recipe 'jmh-cq::install'

  # Build all the paths we will be using and store them in easy to use variables
  cq_dir = ::File.join(node['cq']['base_directory'], node['cq'][key]['name'])
  cq_jar = ::File.join(cq_dir, ::File.basename(node['cq']['current_jar']))
  start_script = ::File.join(cq_dir, 'crx-quickstart/bin/start')
  stop_script = ::File.join(cq_dir, 'crx-quickstart/bin/stop')
  status_script = ::File.join(cq_dir, 'crx-quickstart/bin/status')
  jar_dir = ::File.join(node['cq']['jar_directory'], key)
  java_home = JmhJavaUtil.get_java_home(node['cq']['java_version'], node)
  property_dir = ::File.join(cq_dir, 'crx-quickstart/conf')
  property_file = ::File.join(property_dir, 'jmh-aem.properties')

  # Creates an init script specifically for this instance
  template "/etc/init.d/cq-#{key}" do
    source 'cq.init.erb'
    mode 0755
    variables(
      :app => "cq-#{key}",
      :app_dir => cq_dir,
      :bin_path => ::File.join(cq_dir, 'crx-quickstart/bin'),
      :user => node['cq']['user'],
      :systemd => JmhServerHelpers.rhel7?(node)
    )
  end

  [node['cq']['base_directory'], node['cq']['jvm_opts']['tmp_directory'], cq_dir, jar_dir].each do |new_dir|
    directory "#{new_dir} for AEM Setup" do
      path new_dir
      owner node['cq']['user']
      group node['cq']['group']
      mode 0775
    end
  end

  template ::File.join(cq_dir, 'license.properties') do
    source 'license.properties.erb'
    mode 0644
  end

  # Make a copy of the CQ jar for the new instance
  ruby_block "Copy CQ jar for #{key}" do
    block do
      FileUtils.copy(node['cq']['current_jar'], cq_jar)
    end
    not_if { ::File.exist?(cq_jar) }
  end

  # Unpacks the copied jar for the new instance
  execute "Unpack CQ jar for #{key}" do
    command "#{java_home}/bin/java -jar #{::File.basename(cq_jar)} -unpack"
    cwd cq_dir
    action :run
    user node['cq']['user']
    notifies :create, 'directory[install_dir]', :immediately
    notifies :create, 'template[SegmentNodeStore]', :immediately
    notifies :create, "template[#{start_script}]", :immediately
    notifies :create, "systemd_service[cq-#{key}]", :immediately
    notifies :start, "service[cq-#{key}]", :immediately
    notifies :run, 'execute[Fresh_AEM_JAR_Wait_300]', :immediately
    not_if { ::File.exist?("#{cq_dir}/crx-quickstart") }
  end

  template stop_script do
    source 'cq.stop.erb'
    variables(
      :java_home => java_home,
      :cq_dir => cq_dir
    )
    owner node['cq']['user']
    group node['cq']['group']
    mode 0755
  end

  directory 'install_dir' do
    path ::File.join(cq_dir, 'crx-quickstart/install')
    mode 0755
    action :nothing
  end

  # Sets AEM to run garbage collection during it nightly maintenance
  template 'SegmentNodeStore' do
    path ::File.join(cq_dir, 'crx-quickstart/install', 'org.apache.jackrabbit.oak.plugins.segment.SegmentNodeStoreService.cfg')
    source 'SegmentNodeStoreService_cfg.erb'
    mode 0644
    variables(
      :repo_home => ::File.join(cq_dir, '/crx-quickstart/repository/segmentstore'),
      :tarmk => '256',
      :pauseCompact => new_resource.disable_tar_compaction
    )
    action :create
    notifies :restart, "service[cq-#{key}]", :delayed
    only_if { ::File.exist?(::File.join(cq_dir, 'crx-quickstart/install')) }
  end

  template start_script do
    source 'cq.start.erb'
    variables(
      :user => node['cq']['user'],
      :port => node['cq'][key]['port'],
      :mode => node['cq'][key]['mode'],
      :environment => node['cq'][key]['environment'],
      :sample_content_type => node['cq'][key]['show_sample_content'] ? 'samplecontent' : 'nosamplecontent',
      :ulimit => 8192,
      :cq_dir => cq_dir,
      :java_home => java_home,
      :jvm_opts => (
         ['-server',
          "-Xmx#{node['cq'][key]['max_memory']}",
          "-Xms#{node['cq'][key]['min_memory']}",
          '-XX:+HeapDumpOnOutOfMemoryError',
          '-Duser.timezone=America/Los_Angeles',
          "-XX:HeapDumpPath=#{node['cq']['base_directory']}",
          "-Dcom.jmh.aem.runtime.props.path=#{property_dir}",
          "-Djava.io.tmpdir=#{node['cq']['jvm_opts']['tmp_directory']}",
          node['cq'][key]['jvm_additional_opts'] ? node['cq'][key]['jvm_additional_opts'] : ''
         ] + node['cq']['jvm_opts']['system_properties'].map { |i| "-D#{i}" } + ["-Dcom.sun.management.jmxremote.port=#{node['cq'][key]['jmx_port']}"]
      ).join(' ')
    )
    owner node['cq']['user']
    group node['cq']['group']
    mode 0755
    action :create
    notifies :restart, "service[cq-#{key}]", :delayed
  end

  template status_script do
    source 'cq.status.erb'
    variables(
      :user => node['cq']['user'],
      :cq_dir => cq_dir,
      :java_home => java_home
    )
    owner node['cq']['user']
    group node['cq']['group']
    mode 0755
    action :create
  end

  systemd_service "cq-#{key}" do
    description "AEM cq-#{key}"
    after %w( network.target syslog.target )
    install do
      wanted_by 'multi-user.target'
    end
    service do
      exec_start start_script
      exec_stop stop_script
      pid_file "#{cq_dir}/crx-quickstart/conf/cq.pid"
      user node['cq']['user']
      group node['cq']['group']
      type 'forking'
    end
    only_if { JmhServerHelpers.rhel7?(node) } # systemd
  end

  template property_file do
    source 'jmh_properties.erb'
    user node['cq']['user']
    group node['cq']['group']
    variables(
      fad_url: node['cq']['fad_url'],
      www_server_domain: node['jmh_server']['global']['apache']['www']['server_name'],
      omniture_prc_mode: node['cq']['omniture_prc_mode'],
      omniture_www_mode: node['cq']['omniture_www_mode'],
      api_server_domain: node['jmh_server']['global']['apache']['api']['server_name'],
      profile_api_auth: node['cq']['profile_api_password'],
      idp_server_domain: node['jmh_server']['global']['apache']['idp']['server_name'],
      scheduling_captcha_site_key: node['cq']['scheduling_captcha_site_key'],
      patient_portal_url: node['cq']['patientportal']['url'],
      portal_name: node['cq']['patientportal']['name'],
      google_api_key: node['cq']['google_api_key'],
      personalization_google_geolocation_apikey: node['cq']['personalization_google_geolocation_apikey'],
      ms_bot_secret_key: node['cq']['ms_bot_secret_key'],
      ms_qnamaker_kb_id: node['cq']['ms_qnamaker_kb_id'],
      ms_qnamaker_kb_ocp_key: node['cq']['ms_qnamaker_kb_ocp_key']
    )
    mode 0600
    action :create
    notifies :restart, "service[cq-#{key}]", :delayed
  end

  service "cq-#{key}" do
    supports :start => true, :restart => true
    action [:enable, :start]
  end

  execute 'Fresh_AEM_JAR_Wait_300' do
    command 'sleep 300'
    action :nothing
  end

  #  Get only bundles for that version
  bundles = if  node['cq']['bundles_additional']
              node['cq'][node['cq']['aem_version']]['bundles'] + node['cq']['bundles_additional']
            else
              node['cq'][node['cq']['aem_version']]['bundles']
            end
  #  Get bundles only for that version & key type
  if node['cq'][key][node['cq']['aem_version']]
    bundles = bundles + node['cq'][key][node['cq']['aem_version']]['bundles'] if node['cq'][key][node['cq']['aem_version']]['bundles']
  end


  # Download bundles to be used in all instances
  bundles.each do |bundle|
    local_path = "#{node['cq']['jar_directory']}/#{bundle['name']}"
    remote_path = "#{bundle['file_location']}/#{bundle['name']}"
    jmh_utilities_s3_download local_path do
      remote_path remote_path
      bucket node['cq']['aws']['s3_bucket']
      owner 'root'
      group 'root'
      mode '0644'
      action :create
    end
  end

  if node['cq'][key]['install_content']
    # download content assets
    # we ignore checksums for content assets.  They will only be installed once..for now
    (node['cq'][key]['content_assets']).each do |s3_key|
      local_path = "#{node['cq']['jar_directory']}/#{key}/#{::File.basename(s3_key)}"
      log "Downloading Content Assets #{s3_key}"
      jmh_utilities_s3_download local_path do
        remote_path "#{key}/#{::File.basename(s3_key)}"
        bucket node['cq']['aws']['s3_bucket']
        owner 'root'
        group 'root'
        mode '0644'
        action :create
      end
    end
  end

  # Test the system is online
  ruby_block 'Waiting for valid response from crx' do
    block do
      for i in 1..10  do
        sleep 30
        if CQ.isAEMOnline?(node['cq'][key]['port'])
          check_password = node['cq']['admin']['password'] ? node['cq']['admin']['password'] : node['cq']['admin']['default_password']
          if CQ.valid_credentials?(node['cq'][key]['port'], node['cq']['admin']['username'], check_password)
            Chef::Log.warn('Service is accepting the password')
          else
            Chef::Log.warn('Service is Online, but I do not know the password yet')
          end
          break
        end
        Chef::Log.warn("Attempt ##{i}")
      end
    end
  end

  # Check that you have the correct bundle
  ruby_block "Check for correct bundle" do
    block do
      encrypted_bundle_info_file = ::File.join(node['cq']['base_directory'], node['cq'][key]['name'], node['cq'][node['cq']['aem_version']]['encryption_bundle'],'bundle.info')
      unless ::File.read(encrypted_bundle_info_file).include?('com.adobe.granite.crypto.file')
        Chef::Application.fatal!("The encryption bundle is incorrect: #{encrypted_bundle_info_file.to_s}")
      end
    end
    action :run
  end

  # Setup Crypto files for allow Forms to have google captcha to have sync from author -> publisher
  cookbook_file ::File.join(node['cq']['base_directory'], node['cq'][key]['name'], node['cq'][node['cq']['aem_version']]['encryption_bundle'] ,'data/hmac') do
    source "crypto/#{node['cq']['crypto_environment']}/hmac"
    mode 0644
    user node['cq']['user']
    group node['cq']['group']
    notifies :restart, "service[cq-#{key}]", :delayed
  end
  cookbook_file ::File.join(node['cq']['base_directory'], node['cq'][key]['name'], node['cq'][node['cq']['aem_version']]['encryption_bundle'] ,'data/master') do
    source "crypto/#{node['cq']['crypto_environment']}/master"
    mode 0644
    user node['cq']['user']
    group node['cq']['group']
    notifies :restart, "service[cq-#{key}]", :delayed
  end

  # Get admin password from the databag
  cq_databag = Chef::EncryptedDataBagItem.load(node['cq']['databag']['name'], node['cq']['databag']['item'])
  log "bag key = PASSWORD key is #{node['cq']['databag']['password_key']}"

  # If `new_password` is set, use that as password the system should be, else use the databag
  cq_password = node['cq']['admin']['new_password'].nil? ? cq_databag[node['cq']['databag']['password_key']] : node['cq']['admin']['new_password']

  # TODO: Not sure how to solve this, but since the password is 'set' in a ruby_block, it misses compile time and it takes 2 runs for the rest of
  #         the system to see the new password. (i.e. maintenance scripts)
  ruby_block 'Admin Password Maintenance' do
    block do
      # Check currently set password
      if CQ.valid_credentials?(node['cq'][key]['port'], node['cq']['admin']['username'], node['cq']['admin']['password'])
        Chef::Log.info('CQ Password is what I thought it was')
      # Check new password
      elsif node['cq']['admin']['new_password'].nil? &&
            CQ.valid_credentials?(node['cq'][key]['port'], node['cq']['admin']['username'], node['cq']['admin']['new_password'])
        Chef::Log.info 'Password is set to new password'
        node.normal['cq']['admin']['password'] = node['cq']['admin']['new_password']
      # Check default password
      elsif CQ.valid_credentials?(node['cq'][key]['port'], node['cq']['admin']['username'], node['cq']['admin']['default_password'])
        Chef::Log.info 'Password is set to default.'
        node.normal['cq']['admin']['password'] = node['cq']['admin']['default_password']
      # Check databag password
      elsif CQ.valid_credentials?(node['cq'][key]['port'], node['cq']['admin']['username'], cq_databag[node['cq']['databag']['password_key']])
        Chef::Log.info 'Password is set to databag'
        node.normal['cq']['admin']['password'] = cq_databag[node['cq']['databag']['password_key']]
      else
        Chef::Application.fatal!('I do not know the password for this cq system.' + node['cq']['admin']['password'])
      end

      # If they do not match, we need to update the cq server and the chef variable
      if node['cq']['admin']['password'] != cq_password
        if CQ.update_admin_password(node['cq'][key]['port'], node['cq']['admin']['username'], node['cq']['admin']['password'], cq_password)
          node.normal['cq']['admin']['password'] = cq_password
          Chef::Log.info('Password is reset')
        else
          Chef::Application.fatal!('Tried to reset admin password but failed!')
        end
      end
    end
    action :run
  end

  # Check and install bundles needed for all instances
  bundles.each do |bundle|
    jmh_cq_install_package "#{key}-#{bundle['name']}" do
      key key
      asset_name bundle['name']
      port node['cq'][key]['port']
      package_location bundle['package_location']
      delay bundle['delay'] if bundle['delay']
      password cq_password
      restart_aem bundle['restart']
      action :install
    end
  end

  if node['cq'][key]['install_content']
    Chef::Log.warn 'Install The Content is TRUE - installing now...'
    # the content assets
    node['cq'][key]['content_assets'].each do |s3_key|
      asset_name = ::File.basename(s3_key)
      jmh_cq_install_package "#{key}-#{asset_name}" do
        key key
        asset_name asset_name
        port node['cq'][key]['port']
        package_location '/crx/packmgr/service/.json/etc/packages/jmh'
        local_package_location ::File.join(node['cq']['jar_directory'], key)
        password cq_password
        action :install
      end
    end

    Chef::Log.warn("Post bundles are #{node['cq'][node['cq']['aem_version']]['post_install_content']['bundles']}")
    # Re-install some packages after content is deployed.
    node['cq'][node['cq']['aem_version']]['post_install_content']['bundles'].each do |bundle_name|
      bundles.each do |bundle|
        Chef::Log.warn("The bundle name is #{bundle_name} and #{bundle}")
        next unless bundle['name'] == bundle_name
        CQ.install(::File.join(bundle['install_location'], bundle_name),
                   node['cq'][key]['port'],
                   node['cq']['admin']['username'],
                   node['cq']['admin']['password'])
      end
    end

    node.normal['cq']['install_content'] = false
    node.normal['cq'][key]['install_content'] = false
  end

  # Remove Geometrixx content and DAM images for stage and production environments
  if %w(prod stage).include?(node['jmh_server']['environment'])
    ruby_block 'Removing Geometrixx content and DAM for stage/production environment' do
      block do
        if CQ.geo_installed?(node['cq'][key]['port'], node['cq']['admin']['username'], node['cq']['admin']['password'])
          Chef::Log.info 'Removing Geometrixx Content and DAM for stage and prod'
          CQ.geo_remove(node['cq'][key]['port'], node['cq']['admin']['username'], node['cq']['admin']['password'], node['cq']['geo_sites'])
        else
          Chef::Log.info 'GREAT! geometrixx already removed'
        end
      end
    end
  end

  # Remove uneeded nodes
  if node['cq']['node_removals']
    node['cq']['node_removals'].each_key do |node_key|
      ruby_block "Remove #{node_key}" do
        block do
          if CQ.node_exists?(node['cq'][key]['port'],
                             node['cq']['admin']['username'],
                             node['cq']['admin']['password'],
                             node_key)
             CQ.node_remove(node['cq'][key]['port'],
                            node['cq']['admin']['username'],
                            node['cq']['admin']['password'],
                            node['cq']['node_removals'][node_key])
          else
            Chef::Log.warn("Removal of #{node_key} skipped to it already being removed")
          end
        end
      end
    end
  end

  # Put backup scripts in place
  # Create Backup Directories
  [node['cq']['backup_directory'], ::File.join(node['cq']['backup_directory'], node['cq'][key]['name'])].each do |backup_dir|
    directory backup_dir do
      user node['cq']['maintenance_user']
      group node['cq']['group']
      mode 0775
      action :create
    end
  end

  # Install Backups Scripts

  node['cq']['maintenance_scripts'].keys.each do |script_name|
    template ::File.join(node['cq']['bin_dir'], "#{script_name}-#{node['cq'][key]['name']}.sh") do
      source node['cq']['maintenance_scripts'][script_name]['template']
      mode 0770
      user node['cq']['maintenance_scripts'][script_name]['user']
      group node['cq']['group']
      variables(
        :hostname => 'localhost',
        :port => node['cq'][key]['port'],
        :admin => node['cq']['admin']['username'],
        :password => node['cq']['admin']['password'],
        :key_name => node['cq'][key]['name'],
        :bin_dir => node['cq']['bin_dir'],
        :zip_file_name => "#{node['cq'][key]['name']}-backup.zip",
        :load_balancer_enabled => new_resource.load_balancer_enabled,
        :load_balancer_pools => new_resource.load_balancer_pools,
        :load_balancer_pool_ip => new_resource.load_balancer_pool_ip,
        :load_balancer_environment => node['jmh_server']['environment'],
        :backup_directory => ::File.join(node['cq']['backup_directory'], node['cq'][key]['name']),
        :backup_zip_directory => ::File.join(node['cq']['backup_directory'])
      )
    end

    weekday_time =  if node['cq']['maintenance_scripts'][script_name]['weekday']
                      node['cq']['maintenance_scripts'][script_name]['weekday']
                    elsif key == 'author'
                      node['cq']['maintenance_time']['author_weekday']
                    else
                      node['cq']['maintenance_time']['publisher_weekday']
                    end
    # Install CRON
    cron "#{script_name}-#{node['cq'][key]['name']}" do
      minute node['cq']['maintenance_scripts'][script_name]['minute']
      hour node['cq']['maintenance_scripts'][script_name]['hour']
      weekday weekday_time
      command "#{node['cq']['bin_dir']}/#{script_name}-#{node['cq'][key]['name']}.sh > #{node['cq']['bin_dir']}/#{script_name}-#{node['cq'][key]['name']}_run.log 2>&1"
      user node['cq']['maintenance_scripts'][script_name]['user']
      action :create
    end
  end

  # If you want to do offline compaction/clean up, this script will do it.
  template ::File.join(node['cq']['bin_dir'], "compact-#{node['cq'][key]['name']}.sh") do
    source 'compact_sh.erb'
    mode 0770
    user node['cq']['user']
    group node['cq']['group']
    variables(
      app_exe: "cq-#{key}",
      cq_basepath: node['cq']['base_directory'],
      cq_name: node['cq'][key]['name'],
      cq_instance: ::File.join(node['cq']['base_directory'], node['cq'][key]['name']),
      java_home: java_home,
      oak_jar: ::File.join(node['cq']['jar_directory'], node['cq']['oak']['jar_name'])
    )
  end

  # Garbage Collection to be run at least once a week.
  template ::File.join(node['cq']['bin_dir'], "runGarbageCollection-#{node['cq'][key]['name']}.sh") do
    source 'runGarbageCollection_sh.erb'
    mode 0770
    user node['cq']['maintenance_user']
    group node['cq']['group']
    variables(
        hostname: 'localhost',
        port: node['cq'][key]['port'],
        admin: node['cq']['admin']['username'],
        password: node['cq']['admin']['password'],
        cq_basepath: node['cq']['base_directory'],
        cq_instance: ::File.join(node['cq']['base_directory'], node['cq'][key]['name'])
        )
  end

  # Setup local watchdog check
  # Create root bin
  directory '/root/bin' do
    user 'root'
    group 'root'
    mode 0700
    action :create
  end

  # Create Watch Scipt
  template ::File.join('/root/bin', "check_cq-#{node['cq'][key]['name']}.sh") do
    source 'check_cq_process.erb'
    mode 0755
    user 'root'
    group 'root'
    variables(
      :hostname => 'localhost',
      :port => node['cq'][key]['port'],
      :check_page => node['cq'][key]['check_page']['url_suffix'],
      :cq_type => node['cq'][key]['mode'],
      :email => node['cq']['check_page']['email'],
      :pid_dir => ::File.join(cq_dir, 'crx-quickstart/conf'),
      :restart_script => "/etc/init.d/cq-#{key}",
      :log_file => "/root/check-#{key}.log",
      :lock_file => "/tmp/#{key}_restart.lck"
    )
  end

  cron "mon-fri-check_cq-#{node['cq'][key]['name']}" do
    minute '*/15'
    hour '20-23,0-6'
    weekday '1-5'
    command "/root/bin/check_cq-#{node['cq'][key]['name']}.sh > /root/check_cq-#{node['cq'][key]['name']}mon-fri.log 2>&1"
    action :create
    only_if { node['cq']['scripts']['cron_environments'].include?(node.chef_environment) }
  end
  
  cron "sat-sun-check_cq-#{node['cq'][key]['name']}" do
    minute '*/15'
    weekday '6,0'
    command "/root/bin/check_cq-#{node['cq'][key]['name']}.sh > /root/check_cq-#{node['cq'][key]['name']}sat-sun.log 2>&1"
    action :create
    only_if { node['cq']['scripts']['cron_environments'].include?(node.chef_environment) }
  end
end
