# jmh_utilities_s3_download
actions :create, :remove, :update
default_action :create

attribute :path, :kind_of => String, :name_attribute => true
attribute :remote_path, :kind_of => String
attribute :bucket, :kind_of => String
attribute :owner, :kind_of => String, :default => 'root'
attribute :group, :kind_of => String, :default => 'root'
attribute :mode, :kind_of => [String, Integer, NilClass], :default => nil
attribute :decryption_key, :kind_of => String, :default => nil
attribute :decrypted_file_checksum, :kind_of => String, :default => nil
