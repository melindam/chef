actions :create, :remove
default_action :create

attribute :database, :kind_of => String, :required => true
attribute :username, :kind_of => String, :required => true
attribute :password, :kind_of => String, :required => true
attribute :parent_node_query, :kind_of => String
attribute :privileges, :kind_of => Array, :default => [:all]
attribute :config_client, :kind_of => Mash
attribute :connect_over_ssl, :kind_of => [TrueClass, FalseClass], :default => true

def initialize(*args)
  super
end
