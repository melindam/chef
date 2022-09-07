actions :create, :drop
default_action :create

attribute :database, :kind_of => String
attribute :username, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :host_connection, :kind_of => String, :default => '127.0.0.1'
attribute :privileges, :kind_of => Array, :required => true
attribute :global_privileges, :kind_of => Array

def initialize(*args)
  super
end
