include_recipe 'jmh-db::dependencies'

mysql_client 'default' do
   action :create
end

user node['mysql']['user'] do
  action :create
end

include_recipe 'jmh-db::mysql_config'