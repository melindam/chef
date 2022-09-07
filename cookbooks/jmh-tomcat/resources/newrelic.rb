# newrelic.rb

actions :create, :remove
default_action :create

attribute :folder, :kind_of => String
attribute :owner, :kind_of => String, :default => node['jmh_tomcat']['user']
attribute :group, :kind_of => String, :default => node['jmh_tomcat']['group']
attribute :appname, :kind_of => String
attribute :service, :kind_of => String

def initialize(*args)
  super
end
