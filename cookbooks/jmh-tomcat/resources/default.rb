# tomcat_apps.rb

actions :create, :remove
default_action :create

attribute :name, :kind_of => String, :required => true
attribute :version, :kind_of => String, :default => node['jmh_tomcat']['default_version']
attribute :java_version, :kind_of => String, :default => node['jmh_java']['default_version']
attribute :java_options, :kind_of => Array, :default => node['jmh_tomcat']['java_options']
attribute :rollout_array, :kind_of => Array
attribute :max_heap_size, :kind_of => String
attribute :max_permgen, :kind_of => String
attribute :thread_stack_size, :kind_of => String
attribute :jmx_port, :kind_of => Integer
attribute :catalina_opts, :kind_of => Array
attribute :enable_http, :kind_of => [TrueClass, FalseClass], :default => true
attribute :enable_ssl, :kind_of => [TrueClass, FalseClass], :default => true
attribute :port, :kind_of => Integer, :default => node['jmh_tomcat']['port']
attribute :ssl_port, :kind_of => Integer, :default => node['jmh_tomcat']['ssl_port']
attribute :iptables, :kind_of => Hash, :default => {}
attribute :shutdown_port, :kind_of => Integer, :default => node['jmh_tomcat']['shutdown_port']
attribute :jmx_port, :kind_of => Integer
attribute :app_properties, :kind_of => Array
attribute :catalina_properties, :kind_of => Array
attribute :newrelic, :kind_of => [TrueClass, FalseClass], :default => false
attribute :directories, :kind_of => Array
attribute :install_tcell, :kind_of => [TrueClass, FalseClass], :default => false
attribute :tcell_config, :kind_of => Hash
attribute :exec_start_pre, :kind_of => String
attribute :relax_query_chars, :kind_of => [TrueClass, FalseClass], :default => false
attribute :mysql_j_version, :kind_of => String


def initialize(*args)
  super
end
