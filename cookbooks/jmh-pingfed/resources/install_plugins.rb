# install_plugins.rb

actions :install
default_action :install

attribute :plugin_array, :kind_of => Array, :required => true
attribute :install_path, :kind_of => String, :required => true
attribute :resource_service, :kind_of => String, :required => true

def initialize(*args)
  super
end
