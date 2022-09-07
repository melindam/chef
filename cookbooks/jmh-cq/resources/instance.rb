# install.rb

actions :install, :remove
default_action :install

# attribute :aem_type, kind_of: String, default: 'author'
attribute :disable_tar_compaction, :kind_of => [TrueClass, FalseClass], :default => true
attribute :load_balancer_enabled, :kind_of => [TrueClass, FalseClass], :default => false
attribute :load_balancer_pools, :kind_of => Array, :default => nil
attribute :load_balancer_pool_ip, :kind_of => String, :default => nil

def initialize(*args)
  super
end
