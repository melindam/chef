# Deploys an Apache web server along with directories needed
# use_inline_resources

action :install do
  new_resource.updated_by_last_action(true)
  doc_root = new_resource.doc_root || new_resource.apache_config['docroot']
  apache_config = new_resource.apache_config.to_hash
  port = apache_config['port']
    

  @run_context.include_recipe 'jmh-webserver::default'

  added_modules = node['jmh_webserver']['apache']['modules']
  if new_resource.additional_modules
    added_modules = node['jmh_webserver']['apache']['modules'] + new_resource.additional_modules
  end
  
  added_modules.each do |mod|
    @run_context.include_recipe "apache2::#{mod}"
  end

  if node['jmh_webserver']['apache']['native_install_remoteip'] 
    @run_context.include_recipe "apache2::mod_remoteip" 
  end



  # Create the directory if missing. Conditional is added
  # so if created else where, we don't stomp on perms
  # puts "Apache Webapp Config is #{apache_config}"
  directory "#{doc_root} for #{new_resource.name}:#{port}" do
    path doc_root
    recursive true
    not_if do
      ::File.directory?(doc_root)
    end
  end

  logrotate_app 'httpd' do
    cookbook 'logrotate'
    path '/var/log/httpd/*log'
    frequency 'weekly'
    rotate node['jmh_webserver']['logrotate']
    options ['compress', 'missingok', 'notifempty', 'copytruncate', 'sharedscripts', 'dateext' ]
    postrotate '/sbin/service httpd reload > /dev/null 2>/dev/null || true'
  end

  unless node['jmh_server']['jmh_local_server']
    if node['jmh_webserver']['apache']['native_install_remoteip'] 
       apache_conf 'remoteip' do
         cookbook 'jmh-webserver'
         source 'mods/remoteip.conf.erb'
         notifies :restart, 'service[apache2]', :delayed
       end
    else
      remote_file "#{::File.join(node['apache']['lib_dir'], 'modules', 'mod_remoteip.so')} for #{new_resource.name}:#{port}" do
        path ::File.join(node['apache']['lib_dir'], 'modules', 'mod_remoteip.so')
        source node['jmh_webserver']['apache']['mod_remoteip']['src_url']
        mode 0777
        action :create
        notifies :restart, 'service[apache2]', :delayed
      end
      apache_module 'remoteip' do
        enable true
        conf true
        notifies :restart, 'service[apache2]', :delayed
      end
    end
  end

  if apache_config['directories'].nil?
    if node['jmh_webserver']['apache']['legacy_apache']
      apache_config['directories'] = {
        doc_root => {
          'Options' => '-Indexes',
          'AllowOverride' => 'None',
          'Allow' => 'from All'
        }
      }
    else
      apache_config['directories'] = {
        doc_root => {
          'Options' => '-Indexes',
          'AllowOverride' => 'None',
          'Require' => 'all Granted'
        }
      }

    end
  end

  apache_config['directory_index'] ||= %w(index.php index.html)
  web_app_cookbook = new_resource.cookbook

  robots_file = apache_config['robots_file'] || node['jmh_webserver']['default']['robots']['file']
  template "#{::File.join(doc_root, robots_file)} for #{new_resource.name}:#{port}"  do
    path ::File.join(doc_root, robots_file)
    source 'robots.erb'
    user node['apache']['user']
    group node['apache']['group']
    mode 0655
    variables(
      :allow => apache_config['robots_allow'],
      :disallow => apache_config['robots_disallow']
    )
    action :create
    only_if { apache_config['robots_allow'] || apache_config['robots_disallow'] }
  end

  # If there are SSL configurations for the web server, include them here
  if apache_config['ssl']
    @run_context.include_recipe 'apache2::mod_ssl'

    ssl_dir = ::File.join(node['apache']['dir'], 'ssl')
    directory "#{ssl_dir} for #{new_resource.name}:#{port}" do
      path ssl_dir
      action :create
    end

    if apache_config['ssl']['encrypted']
      secret_bag_name = apache_config['ssl']['data_bag']
      secret_bag_item = apache_config['ssl']['data_bag_item']
      bag = Chef::EncryptedDataBagItem.load(secret_bag_name, secret_bag_item).to_hash
    else
      bag = Mash.new(
        data_bag_item(
          apache_config['ssl']['data_bag'] || 'apache_ssl',
          apache_config['ssl']['data_bag_item'] || 'default_cert'
        ).raw_data
      )
    end

    ssl_args = { :port => apache_config['ssl']['port'] || 443 }
    %w(chain key pem).each do |key|
      if bag[key]
        ssl_file_path = ::File.join(ssl_dir, "#{bag['id']}.#{key}")
        file "#{ssl_file_path} for #{new_resource.name}:#{port}" do
          path ssl_file_path
          content bag[key]
          owner node['apache']['user']
          group node['apache']['group'] || node['apache']['user']
          mode 0600
        end
        ssl_args[key] = ssl_file_path
      end
      next
    end

    ssl_srv_name = "#{new_resource.name}-ssl"
    web_app ssl_srv_name do
      cookbook web_app_cookbook
      ssl true
      apache_config.merge(ssl_args).each do |k, v|
        Chef::Log.debug("SSL value for k = #{k} and other Value for v = #{v}")
        send(k, v)
      end
    end

  else
    web_app new_resource.name do
      cookbook web_app_cookbook
      apache_config.each do |k, v|
        send(k, v)
      end
    end
  end # end if ssl
end
