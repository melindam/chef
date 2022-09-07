# default.rb

actions :install, :remove
default_action :install

attribute :doc_root, :kind_of => String, :default => '/var/www/html'
# attribute :append_doc_root, kind_of: String
attribute :apache_config, :kind_of => Hash, :default => {}
attribute :cookbook, :kind_of => String, :default => 'jmh-webserver'
attribute :additional_modules, :kind_of => Array
