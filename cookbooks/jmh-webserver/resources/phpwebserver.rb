# php_web_server.rb

actions :install
default_action :install

attribute :doc_root, :kind_of => String
attribute :web_app, :kind_of => Mash, :default => Mash.new
attribute :append_doc_root, :kind_of => String
attribute :git, :kind_of => Mash, :default => Mash.new
attribute :config, :kind_of => Mash, :default => Mash.new
attribute :additional_modules, :kind_of => Array
