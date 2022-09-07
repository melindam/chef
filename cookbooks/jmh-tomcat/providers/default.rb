# Definition for mutiple tomcat applications
# jmh_tomcat

action :create do
  @run_context.include_recipe 'jmh-tomcat'
  @run_context.include_recipe 'ark'

  key = new_resource.name

  tomcat_version = node['jmh_tomcat'][new_resource.version]['version']
  tomcat9 = new_resource.version == '9' ? true : false

  mysql_j_version = new_resource.mysql_j_version ? new_resource.mysql_j_version : node['jmh_tomcat'][new_resource.version]['mysql_j_version']

  upgrade = false
  if ::File.exist?("/etc/init.d/#{key}") && ::File.exist?("#{node['jmh_tomcat']['target']}#{key}")
    cmd = Mixlib::ShellOut.new("/etc/init.d/#{key} version | grep 'Server number:' | grep #{tomcat_version}")
    cmd.run_command

    upgrade = cmd.error? ? true : false
    Chef::Log.info("Tomcat Upgrade is #{upgrade}")
  end

  Chef::Log.warn('**This is a tomcat upgrade**') if upgrade

  # default to repo name, if needed
  tomcat_repo = node['jmh_tomcat']['repo'] ? node['jmh_tomcat']['repo'] :
                "#{node['jmh_tomcat']['download_url']}/tomcat-#{new_resource.version}/v#{tomcat_version}/bin/apache-tomcat-#{tomcat_version}.tar.gz"

  tomcat_symlink_home = ::File.join(node['jmh_tomcat']['target'], key)
  tomcat_home = ::File.join(node['jmh_tomcat']['target'], "#{new_resource.name}-#{tomcat_version}")

  tc_install_path = node['jmh_tomcat']['target']
  tomcat_app = new_resource.name

  ## Install Java
  jmh_java_install "install java for #{new_resource.name}" do
    version new_resource.java_version ? new_resource.java_version : nil
    action :install
  end

  java_home = JmhJavaUtil.get_java_home(new_resource.java_version, node)

  # Get the tomcat binary
  ark ::File.basename(tomcat_home) do
    url node['jmh_tomcat']['repo'] ? node['jmh_tomcat']['repo'] : tomcat_repo
    path tc_install_path
    version tomcat_version
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    action :put
    not_if { ::File.exist?(tomcat_home) }
  end

  ## Move log file to lukscrypt
  if node['recipes'].include?('jmh-encrypt::lukscrypt')

    directory ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'tomcat') do
      owner node['jmh_tomcat']['user']
      group node['jmh_tomcat']['group']
      mode '0755'
      action :create
    end

    directory ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'tomcat', "#{new_resource.name}-#{tomcat_version}") do
      owner node['jmh_tomcat']['user']
      group node['jmh_tomcat']['group']
      mode '0755'
      action :create
    end

    ruby_block 'Move Logs to Encryption Location' do
      block do
        FileUtils.mv(::File.join(tomcat_home, 'logs'),
                     ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'tomcat', "#{new_resource.name}-#{tomcat_version}", 'logs'))
      end
      not_if { ::File.symlink?(::File.join(tomcat_home, 'logs')) }
      notifies :create, 'link[Create Log Symlink]', :immediately
    end

    link 'Create Log Symlink' do
      target_file ::File.join(tomcat_home, 'logs')
      to ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'tomcat', "#{new_resource.name}-#{tomcat_version}", 'logs')
      link_type :symbolic
      action :nothing
      notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
    end
  end

  # Create JVM Opts for the tomcats service
  # The if statements are so that we do not try to set parameters that are not needed to be
  # set.  JVM will tailor to the amount of memory on the system, so we try to stay away from
  # setting parameters that can just default to jvm best practices
  java_opts = []
  java_opts.push(*new_resource.java_options)

  if new_resource.max_heap_size
    java_opts.push("-Xmx#{new_resource.max_heap_size}")
  end
  # if new_resource.max_permgen
  #   java_opts.push("-XX:MaxPermSize=#{new_resource.max_permgen}")
  # end
  if new_resource.thread_stack_size
    java_opts.push("-Xss#{new_resource.thread_stack_size}")
  end
  if new_resource.newrelic
    java_opts.push(" -javaagent:#{tomcat_home}/newrelic/newrelic.jar")
    if node['test_run']
      java_opts.push(' -Dnewrelic.environment=test')
    else
      case node['jmh_server']['environment']
      when 'dev'
        java_opts.push(' -Dnewrelic.environment=development')
      when 'stage'
        java_opts.push(' -Dnewrelic.environment=staging')
      when 'prod'
        java_opts.push(' -Dnewrelic.environment=production')
      else
        java_opts.push(' -Dnewrelic.environment=test')
      end
    end
  end

  jmx_opts = new_resource.jmx_port ? ['-Dcom.sun.management.jmxremote',
                                      '-Dcom.sun.management.jmxremote.ssl=false',
                                      '-Dcom.sun.management.jmxremote.authenticate=false',
                                      "-Dcom.sun.management.jmxremote.port=#{new_resource.jmx_port}"].join(' ') : nil

  mysql_connector_j  "mysqlconnector for #{new_resource.name}" do
    path ::File.join(tomcat_home, 'lib')
    jar_file "mysql-connector-java-#{mysql_j_version}.jar"
    version mysql_j_version
    url node['jmh_tomcat']['mysql_j_hash'][mysql_j_version]
    action :create
  end

  execute "change owner mysql-connector*jar for #{new_resource.name}" do
    command "chown #{node['jmh_tomcat']['user']}:#{node['jmh_tomcat']['group']} mysql-connector*.jar"
    cwd ::File.join(tomcat_home, 'lib')
  end

  # Remove the old connectors and restart, if necessary
  old_connectors = %x(cd #{::File.join(tomcat_home, 'lib')}; find . -name 'mysql-connector*'| grep -v #{mysql_j_version})
  Chef::Log.debug("** Old Mysql_J Connectors to be removed: #{old_connectors}")
  if old_connectors.length > 0
    old_connectors.split.each do |old_jar|
      file ::File.join(tomcat_home, 'lib', old_jar) do
        action :delete
        notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
      end
    end
  end

  catalina_opts = new_resource.catalina_opts ? new_resource.catalina_opts : []
  catalina_opts.push("-Dspring.config.location=file:#{::File.join(tomcat_home, 'conf/application.properties')}") if new_resource.app_properties

  template ::File.join(tomcat_home, 'bin/setenv.sh') do
    source 'setenv_sh.erb'
    cookbook 'jmh-tomcat'
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0755'
    variables(
      :catalina_base => tomcat_home,
      :catalina_home => tomcat_home,
      :tomcat_user => node['jmh_tomcat']['user'],
      :java_opts => java_opts.join(' '),
      :jmx_opts => jmx_opts,
      :java_home => java_home,
      :catalina_opts => catalina_opts.join(' ')
    )
    notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
  end

  template ::File.join(tomcat_home, 'bin/catalina.sh') do
    source tomcat9 ? 'catalina.erb' : 'catalina7.erb'
    cookbook 'jmh-tomcat'
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0755'
    variables(
      :runuser => node['jmh_tomcat']['user']
    )
    notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
  end


  systemd_service key do
    description "Tomcat for #{key}"
    after %w( network.target syslog.target mysql-default.service )
    install do
      wanted_by 'multi-user.target'
    end
    service do
      working_directory "#{tomcat_home}/bin"
      exec_start "#{tomcat_home}/bin/catalina.sh start"
      exec_start_pre new_resource.exec_start_pre
      exec_stop "#{tomcat_home}/bin/catalina.sh stop"
      pid_file "#{tomcat_home}/bin/tomcat.pid"
      user node['jmh_tomcat']['user']
      group node['jmh_tomcat']['group']
      type 'forking'
    end
    # only_if { ::File.open('/proc/1/comm').gets.chomp == 'systemd' } # systemd
    only_if { JmhServerHelpers.rhel7?(node) } # systemd
  end

  # If ssl is enabled, put the certs on the system
  if new_resource.enable_ssl
    bag = Chef::EncryptedDataBagItem.load(node['jmh_tomcat']['ssl']['data_bag'], node['jmh_tomcat']['ssl']['data_bag_item']).to_hash

    ssl_cert_password = bag['password']

    directory "#{node['jmh_tomcat']['ssl']['cert_folder']} for #{new_resource.name}" do
      path node['jmh_tomcat']['ssl']['cert_folder']
      recursive true
      mode 0700
      owner node['jmh_tomcat']['user']
      group node['jmh_tomcat']['group']
      action :create
    end

    %w(key pem).each do |sslkey|
      next unless bag[sslkey]
      ssl_file_path = ::File.join(node['jmh_tomcat']['ssl']['cert_folder'], "#{bag['id']}.#{sslkey}")
      file "#{ssl_file_path} for #{new_resource.name}" do
        path ssl_file_path
        content bag[sslkey]
        owner node['jmh_tomcat']['user']
        group node['jmh_tomcat']['group'] || node['jmh_tomcat']['user']
        mode 0600
        notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
      end
      node.default['jmh_tomcat']['ssl'][sslkey] = ssl_file_path
    end
  end

  template ::File.join(tomcat_home, 'conf/server.xml') do
    source tomcat9 ? 'server_xml.erb' : 'server_xml7.erb'
    cookbook 'jmh-tomcat'
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0644'
    mode '0644'
    variables(
      :tc_enable_http => new_resource.enable_http,
      :tc_enable_ssl => new_resource.enable_ssl || false,
      :tc_port => new_resource.port,
      :tc_ssl_port => new_resource.ssl_port,
      :ssl_cert_file => node['jmh_tomcat']['ssl']['pem'],
      :ssl_key_file => node['jmh_tomcat']['ssl']['key'],
      :ssl_chain_file => node['jmh_tomcat']['ssl']['chain'],
      :max_http_header_size => node['jmh_tomcat']['max_http_header_size'],
      :tc_shutdown_port => new_resource.shutdown_port,
      :tc_relax_query_chars => new_resource.relax_query_chars,
      :ssl_cert_password => ssl_cert_password
    )
    notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
  end

  Chef::Log.debug("Application properties ARE #{new_resource.app_properties}")
  if new_resource.app_properties
    template ::File.join(tomcat_home, 'conf/application.properties') do
      source 'application_properties.erb'
      cookbook 'jmh-tomcat'
      owner node['jmh_tomcat']['user']
      group node['jmh_tomcat']['group']
      mode '0600'
      variables(
        :props => new_resource.app_properties
      )
      notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
    end
  else
    template ::File.join(tomcat_home, 'conf/application.properties') do
      source 'application_properties.erb'
      cookbook 'jmh-tomcat'
      action :delete
      notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
    end
  end

  template ::File.join(tomcat_home, 'conf', 'catalina.properties') do
    source tomcat9 ? 'catalina_properties.erb' : 'catalina_properties7.erb'
    cookbook 'jmh-tomcat'
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode 0600
    variables(
      :catalina_properties => new_resource.catalina_properties ? new_resource.catalina_properties : nil
    )
    notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
  end

  #  If we need to turn on newrelic
  jmh_tomcat_newrelic tomcat_app do
    folder tomcat_home
    service tomcat_app
    action new_resource.newrelic ? :create : :remove
  end

  # Chef::Log.warn("IP tables is #{new_resource.iptables.to_s}")
  #
  iptables_list = { 'portlist' => new_resource.iptables }

  # creates iptables for ports on tomcat
  iptables_rule "tomcat_#{tomcat_app}" do
    cookbook 'jmh-tomcat'
    source 'tomcat_iptables.erb'
    variables iptables_list
    enable iptables_list['portlist'].length != 0 ? true : false
  end

  logrotate_app "tomcat_#{tomcat_app}" do
    cookbook 'logrotate'
    path "#{tomcat_home}/logs/catalina.out"
    frequency 'weekly'
    rotate 14
    options %w(compress missingok copytruncate dateext)
  end

  # When chef runs, clean up X many days of log files
  execute "removing old tomcat logs #{node['jmh_tomcat']['keep_days_of_logs']} old for #{new_resource.name}" do
    command "/usr/bin/find -L #{tomcat_home}/logs -type f -mtime +#{node['jmh_tomcat']['keep_days_of_logs']} -exec rm -f {} \\;"
    action :run
  end

  %w(examples docs).each do |dirname|
    directory ::File.join(tomcat_home, 'webapps', dirname) do
      recursive true
      action :delete
      only_if { %w(prod stage).include?(node['jmh_server']['environment']) }
    end
  end

  template ::File.join(tomcat_home, 'conf/tomcat-users.xml') do
    source tomcat9 ? 'tomcat_users.xml.erb' : 'tomcat_users.xml7.erb'
    cookbook 'jmh-tomcat'
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0600'
    only_if { node['jmh_tomcat']['manager_available'] }
    notifies node['jmh_tomcat']['restart_on_config_change'] ? :restart : :nothing, "service[#{tomcat_app}]", :delayed
  end

  if upgrade
    service tomcat_app do
      action :stop
    end
    rollout_array = if new_resource.rollout_array
                       new_resource.rollout_array
                    else
                       node['jmh_tomcat']['rollout_script']['legacy_hash'][key]
                    end
    rollout_array.each do |warfile|
      Chef::Log.warn(rollout_array.to_s)
      next unless ::File.exist?(::File.join(tomcat_symlink_home, 'webapps', "#{warfile['war_name']}.war"))
      file ::File.join(tomcat_home, 'webapps', "#{warfile['war_name']}.war") do
        owner node['jmh_tomcat']['user']
        group node['jmh_tomcat']['group']
        mode 0644
        content ::File.open(::File.join(node['jmh_tomcat']['target'], key, 'webapps', "#{warfile['war_name']}.war")).read
        action :create
      end
    end
    ruby_block "Move non-sym #{key} dir" do
      block do
        FileUtils.mv tomcat_symlink_home, "#{tomcat_symlink_home}-bak"
      end
      action :run
      not_if { ::File.symlink?(tomcat_symlink_home) }
    end
  end

  # If link exists, remove it.
  # If link exist and realpath points bad loction, remove it
  # create link
  link "Remove #{tomcat_symlink_home}" do
    target_file tomcat_symlink_home
    action :delete
    only_if do
      ::File.symlink?(tomcat_symlink_home) &&
        ::File.realpath(tomcat_symlink_home) != tomcat_home
    end
  end

  link "Create Symlink #{tomcat_home}" do
    target_file tomcat_symlink_home
    to tomcat_home
    link_type :symbolic
    action :create
  end

  template ::File.join('/etc/init.d', tomcat_app) do
    source 'init_rh.erb'
    cookbook 'jmh-tomcat'
    owner 'root'
    group 'root'
    mode '0755'
    variables(
      :java_home => java_home,
      :catalina_base => ::File.join(node['jmh_tomcat']['target'], key),
      :catalina_home => ::File.join(node['jmh_tomcat']['target'], key),
      :tomcat_user => node['jmh_tomcat']['user'],
      # :remove_dirs => new_resource.remove_dirs ? new_resource.remove_dirs : nil,
      :use_security_manager => node['jmh_tomcat']['use_security_manager'],
      :tomcat_app => key,
      :systemd => JmhServerHelpers.rhel7?(node)
    )
  end

  template ::File.join('/home/tomcat/bin/', "rollout_#{key}.sh") do
    source 'app_rollout_sh.erb'
    cookbook 'jmh-tomcat'
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0755'
    variables(
      :root_passwd => node['mysql'] ? node['mysql']['server_root_password'] : '',
      :rollout_variables => new_resource.rollout_array ? new_resource.rollout_array : node['jmh_tomcat']['rollout_script']['legacy_hash'][key],
      :app_name => key,
      :systemd => JmhServerHelpers.rhel7?(node)
    )
  end

  # Sudoers entry for systemctl for each tomcat_app
  template "/etc/sudoers.d/tomcat_#{key}" do
    source 'sudoers_systemctl.erb'
    cookbook 'jmh-tomcat'
    mode '0440'
    variables(
      :app_name => key
    )
  end

  # Used by all default web tomcat applications
  # If node includes encrypted partition, link to that directory

  if node['recipes'].include?('jmh-encrypt::lukscrypt')
    if ::File.exist?(::File.join(node['jmh_tomcat']['local'], node['jmh_tomcat']['webapps_dir']))
      web_dir = ::File.new(::File.join(node['jmh_tomcat']['local'],  node['jmh_tomcat']['webapps_dir']))
      unless ::File.symlink?(web_dir)
        ::FileUtils.mv ::File.join(node['jmh_tomcat']['local'],  node['jmh_tomcat']['webapps_dir']),
                     ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'],  node['jmh_tomcat']['webapps_dir'])
      end
    end

    directory ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_tomcat']['webapps_dir']) do
      owner node['jmh_tomcat']['user']
      group node['jmh_tomcat']['group']
      mode '0775'
      action :create
    end

    link ::File.join(node['jmh_tomcat']['local'], node['jmh_tomcat']['webapps_dir']) do
      to ::File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_tomcat']['webapps_dir'])
      action :create
    end
  else
    directory ::File.join(node['jmh_tomcat']['local'], node['jmh_tomcat']['webapps_dir']) do
      owner node['jmh_tomcat']['user']
      group node['jmh_tomcat']['group']
      mode '0755'
      action :create
    end
  end


  if new_resource.directories
    new_resource.directories.each do |dir|
      directory "#{dir} for #{new_resource.name}" do
        path dir
        recursive true
        mode '0755'
        owner node['jmh_tomcat']['user']
        group node['jmh_tomcat']['group']
      end
    end
  end

  service tomcat_app do
    action [:enable, :start]
  end
  new_resource.updated_by_last_action(true)
end
