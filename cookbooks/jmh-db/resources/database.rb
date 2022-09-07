# database.rb

actions :create, :remove
default_action :create

attribute :database, :kind_of => String
attribute :bind_address, :kind_of => String
attribute :config, :kind_of => Mash
attribute :ssl, :kind_of => [TrueClass, FalseClass], :default => true

def initialize(*args)
  super
end
