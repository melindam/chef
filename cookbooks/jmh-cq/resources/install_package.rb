# install.rb

actions :install
default_action :install

attribute :key, :kind_of => String, :required => true
attribute :asset_name, :kind_of => String, :required => true
attribute :port, :kind_of => Integer, :required => true
attribute :username, :kind_of => String, :default => node['cq']['admin']['username']
attribute :password, :kind_of => String, :default => node['cq']['admin']['password']
attribute :package_location, :kind_of => String, :required => true
attribute :local_package_location, :kind_of => String, :default => node['cq']['jar_directory']
attribute :restart_aem, :kind_of => [TrueClass, FalseClass], :default => false
attribute :delay, :kind_of => Integer, :default => 120

def initialize(*args)
  super
end
