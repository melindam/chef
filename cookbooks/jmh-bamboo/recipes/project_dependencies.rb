include_recipe 'jmh-db'

jmh_db_database 'profile' do
  database 'profile'
  action :create
end

jmh_db_user 'profile' do
  database 'profile'
  username 'profile'
  password 'profile'
  privileges ['all']
  connect_over_ssl false
end

jmh_db_database 'fad' do
  database 'fad'
  action :create
end

jmh_db_user 'fad' do
  database 'fad'
  username 'fad'
  password 'fad'
  privileges ['all']
  connect_over_ssl false
end
