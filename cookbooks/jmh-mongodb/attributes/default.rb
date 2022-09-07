# JMH Mongodb using all sc-mongodb resources
# OLD VERSION :  '4.2.5'
override['mongodb']['package_version'] = '4.2.15'

override['mongodb']['mongos_create_admin'] = true

override['mongodb']['config']['auth'] = true

# replication info
# default['mongodb']['cluster_name'] = 'repl'
# override['mongodb']['auto_configure']['replicaset'] = false
# only set to true when its the last node in cluster
# override['mongodb']['auto_configure']['replicaset'] = true

#   'password' =>  set in recipe now
default['mongodb']['admin'] = {
    'username' => 'admin',
    'roles' => %w(root),
    'database' => 'admin'
}

# Entries end up in /etc/mongod.conf
default['mongodb']['config']['mongod']['security']['authorization'] = "enabled"
# TODO push this config on the ['mongodb']['config'] so it appends to attribute
default['mongodb']['config']['mongod']['systemLog']['logRotate'] = "reopen"
# override['mongodb']['config']['mongod']['replication']['replSetName'] = "repl"

default['mongodb']['authentication']['username'] = 'admin'

default['jmh_mongodb']['port'] = 27017
default['jmh_mongodb']['iptables_list'] = { 'portlist' => {node['jmh_mongodb']['port']  => { 'target' => 'ACCEPT' } } }

default['jmh_mongodb']['backup']['minute_interval'] = '10'
default['jmh_mongodb']['backup']['hour_interval'] = '*/6'
default['jmh_mongodb']['backup']['day_interval'] = '*'
default['jmh_mongodb']['backup']['weekday_interval'] = '*'
default['jmh_mongodb']['backup']['base_dir'] = 'mongodb'