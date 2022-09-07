case node['jmh_crowd']['datastore'].to_sym
when :mysql
  include_recipe 'jmh-crowd::mysql'
when :hsqldb
  Chef::Log.info 'Using internal crowd database for storage'
else
  fail 'Unsupported datastore'
end
