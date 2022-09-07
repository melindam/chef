# install.rb

actions :install, :remove
default_action :install

attribute :name, kind_of: String, :required => true
attribute :version, kind_of: String

def initialize(*args)
  super
end
