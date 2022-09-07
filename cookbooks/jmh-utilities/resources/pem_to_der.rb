# jmh_utilities_pem_to_der
#  Take an ascii certificate on PEM format and convert it to DER format for use by Java

actions :create, :remove, :update
default_action :create

attribute :cert_name, :kind_of => String, :name_attribute => true
attribute :databag_name, :kind_of => String
attribute :databag_item, :kind_of => String
attribute :databag_key_name, :kind_of => String
attribute :secure_databag, :kind_of => [TrueClass, FalseClass]
attribute :public_key, :kind_of => [TrueClass, FalseClass]
attribute :path, :kind_of => String
attribute :owner, :kind_of => String
attribute :group, :kind_of => String
attribute :cache_path, :kind_of => String, :default => Chef::Config[:file_cache_path]
