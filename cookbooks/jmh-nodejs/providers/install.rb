use_inline_resources

action :install do

  @run_context.include_recipe 'jmh-nodejs::nodejs_user'
  @run_context.include_recipe 'jmh-nodejs::dependencies'

  nodejs_version = new_resource.version
  Chef::Log.info("The Node Version is #{nodejs_version}")


  tarball_name =  ::File.basename(node['jmh_nodejs']['version'][nodejs_version]['download_url'])
  nodejs_path = JmhNodejsUtil.get_nodejs_home(new_resource.version,node)
  nodejs_folder_name = ::File.basename(tarball_name)

  remote_file ::File.join(Chef::Config[:file_cache_path],nodejs_folder_name) do
    source node['jmh_nodejs']['version'][nodejs_version]['download_url']
    action :create
  end

  execute "extract node #{nodejs_version}" do
    cwd node['jmh_nodejs']['node_base_path']
    command "/bin/tar xf #{Chef::Config[:file_cache_path]}/#{tarball_name}"
    action :run
    not_if { ::File.exist?(nodejs_path)}
    notifies :run , "execute[Change permissions of node #{nodejs_version} folders]", :delayed
    notifies :run , "execute[Change permissions of node #{nodejs_version} files]", :delayed
    notifies :run , "execute[Change owner:group of node #{nodejs_version} files]", :delayed
  end

  execute "Change permissions of node #{nodejs_version} folders" do
    command '/usr/bin/find . -type d -exec chmod o+rx {} \;'
    cwd nodejs_path
    action :nothing
  end

  execute "Change permissions of node #{nodejs_version} files" do
    command '/usr/bin/find . -type f -exec chmod o+r {} \;'
    cwd nodejs_path
    action :nothing
  end

  execute "Change owner:group of node #{nodejs_version} files" do
    command '/usr/bin/find . -exec chown -R nodejs. {} \;'
    cwd nodejs_path
    action :nothing
  end

  # Remove Symbolic link and put in our own wrapper

  %w(npm npx).each do |node_command|
    link ::File.join(nodejs_path,'bin', node_command) do
      action :delete
      only_if { ::File.symlink?(::File.join(nodejs_path,'bin', node_command)) }
    end

    template ::File.join(nodejs_path,'bin', node_command) do
      cookbook node['jmh_nodejs']['executable_template_cookbook']
      source 'node_command_wrapper.erb'
      mode 0777
      action :create
      variables(
          node_command: node_command,
          node_command_path: "/lib/node_modules/npm/bin/#{node_command}-cli.js",
          nodejs_path:  nodejs_path
      )
    end

  end

  # angular-cli
  node_packages = { "swagger" => {"swagger" => '/lib/node_modules/swagger/bin/swagger.js',
                              "swagger-project" => '/lib/node_modules/swagger/bin/swagger-project.js'},
                    "retire" => {"retire" => '/lib/node_modules/retire/bin/retire'}}


  node_packages.each_key do |node_package|
    execute "Install #{node_package} for #{nodejs_version}" do
      cwd nodejs_path
      command "#{nodejs_path}/bin/npm install -g #{node_package}"
      action :run
      not_if { ::File.exist?("#{nodejs_path}/bin/#{node_package}")}
    end

    node_packages[node_package].each do |node_command, node_command_path|
      Chef::Log.debug("***#{node_package} #{node_command} #{node_command_path}")
      link ::File.join(nodejs_path,'bin', node_command) do
        action :delete
        only_if { ::File.symlink?(::File.join(nodejs_path,'bin', node_command)) }
      end

      template ::File.join(nodejs_path,'bin', node_command) do
        cookbook node['jmh_nodejs']['executable_template_cookbook']
        source 'node_command_wrapper.erb'
        mode 0777
        action :create
        variables(
            node_command: node_command,
            node_command_path: node_command_path,
            nodejs_path:  nodejs_path
        )
      end

    end
  end
  # -g angular-cli
  #  install -g retire
  # execute "Install Swagger for #{nodejs_version}" do
  #   command "PATH=#{nodejs_path}/bin:$PATH npm install -g swagger"
  #   action :run
  #   not_if { ::File.exist?("#{nodejs_path}/bin/swagger")}
  # end

  # npm -> ../lib/node_modules/npm/bin/npm-cli.js

end