# install_jvm_certificate

actions :install, :remove
default_action :install

# The java version you want to insert
attribute :java_home, :kind_of => String, :default => node['java']['java_home']
# The name of the cert to be used in the jvm
attribute :cert_name, :kind_of => String, :required => true
# password of cacerts keystore
attribute :keystore_pass, :kind_of => String, :default => 'changeit'
# Folder of Encrypted Databag
attribute :data_bag, :kind_of => String
# Name of Encrypted Databag
attribute :data_bag_item, :kind_of => String
# Field in data bag json
attribute :data_bag_field, :kind_of => String

def initialize(*args)
  super
  @run_context.include_recipe 'java'
end
