# install.rb

actions :install, :remove
default_action :install

attribute :version, kind_of: String, default: node['jmh_nodejs']['default_version']
# attribute :service, :kind_of => String

def initialize(*args)
  super
end
