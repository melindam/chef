# Deploys a web server with PHP installed along with the files from git

action :install do
  new_resource.updated_by_last_action(true)
  doc_root = new_resource.doc_root || new_resource.web_app['docroot']

  # Create the document root for the application
  directory doc_root do
    action :create
    owner node['apache']['user']
    group node['apache']['group']
    recursive true
  end

  if new_resource.git
    package 'git'
    append_doc_root = new_resource.append_doc_root.nil? ? new_resource.git.size > 1 : new_resource.append_doc_root

    new_resource.git.each do |key, args|
      args = Mash.new(args)
      dest = append_doc_root ? ::File.join(doc_root, key) : doc_root

      # TODO: Lame, but the initial checkout makes a branch called deploy locally.  Would like it
      # to just clone as master
      git "#{key} #{args[:tag]}" do
        repository args['repository']
        reference args['branch']
        revision args['branch']
        user node['apache']['user']
        group node['apache']['group']
        destination dest
        action :checkout
      end
    end
  end

  apache_config = new_resource.web_app.to_hash
  apache_config['cookbook'] = 'jmh-webserver'

  # Definition provided by this cookbook to configure apache. We set
  # the parameter values to a temporary variable above to prevent
  # conflicting namespacing since `params` will not relate to the
  # instance in this definition when it is evaluated in the block
  # below (it will be in the context of jmh_app instead)

  jmh_webserver new_resource.name do
    apache_config apache_config
    doc_root doc_root
    if new_resource.additional_modules
      additional_modules new_resource.additional_modules
    end
    action :install
  end

  @run_context.include_recipe 'jmh-webserver::php_dependencies'

  # Create and required directories and update their ownership
  if new_resource.config
    if new_resource.config['directories']
      Array(new_resource.config['directories']).each do |dir|
        directory dir do
          recursive true
          (owner new_resource.config['owner'] || node['apache']) ? node['apache']['user'] : 'root'
          (group new_resource.config['group'] || node['apache']) ? node['apache']['group'] : 'root'
        end
      end
    end
  end
end
