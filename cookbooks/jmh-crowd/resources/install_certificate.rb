# crowd_certificate

actions :create, :remove, :update
default_action :create

attribute :java_home, :kind_of => String
attribute :java_version, :kind_of => String
attribute :keystore_pass, :kind_of => String, :default => node['jmh_java']['java_security']['storepass']

def initialize(*args)
  super
end
