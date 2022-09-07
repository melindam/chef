# mule_apps.rb

actions :create, :remove
default_action :create

attribute :name, :kind_of => String, :required => true
attribute :version, :kind_of => String, :default => node['jmh_mule']['version']
attribute :java_version, :kind_of => String, :default => node['jmh_mule']['java_version']
attribute :app_properties, :kind_of => Array
# attribute :java_options, :kind_of => Array, :default => node['jmh_mule']['java_options']
# attribute :port, :kind_of => Integer, :default => node['jmh_mule']['port']
attribute :iptables, :kind_of => Hash, :default => {}
attribute :enable_ssl, :kind_of => [TrueClass, FalseClass], :default => false
attribute :directories, :kind_of => Array
attribute :remove_dirs, :kind_of => Array

def initialize(*args)
  super
end
