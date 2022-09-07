actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :description, :kind_of => String, :default => 'No Description'
attribute :servers, :kind_of => Hash, :required => true
attribute :ssh_keypath, :kind_of => String, :default => node['jmh_rundeck']['ssh_keypath']
attribute :project_resources, :kind_of => Array, :required => true

def initialize(*args)
  super
end
