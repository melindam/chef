# jmh-db

0.5.18
-----
- moving check script from sensu to jmh-db
- 

0.5.17
------
- including default-time-zone to be SYSTEM for new mysql tomcat drivers

0.5.16
------
- Adding mysql_upgrade command to `server.rb`. Made it easy to turn off if dont want to run a regular basis

0.5.15
------
- node.set changed to node.normal
- secure_password changed to random_password

0.5.14
------
- fixed mysql user error when running with lukscrypt
- updated permissions for lukscrypt mysql folder

0.5.13
------
- slow query log configuration
- updated mysql_local_user to not show password in logs
- updated db_backup password being set by jmh_app variable

0.5.11
------
- Removal of mysql2_chef_gem dependency

0.5.10
------
- added mysqld server setting for innodb_lru_scan_depth for performance of InnoDB page cleaner error
- cleaned up legacy code for mysql 5.1

0.5.9
-----
- Added watch script for too many processes

0.5.8
-----
- updates mysql_local_user to allow for global privileges
- updates mysqlmonitor to be able to get "full" process list

0.5.7
----
- added maintenance user

0.5.6
-----
- added max_connections to mysqld (http://blog.endpoint.com/2013/12/increasing-mysql-55-maxconnections-on.html)
- added limit_no_file to mysql_service (https://www.grumpyland.com/blog/231/changing-limits-for-services-with-centos-7-rhel-7-systemd/)

0.5.5
-----
- move mysqlbackups directory to encrypted drive if recipe included

0.5.4
-----
- compatibility with old 5.1 server, need mysqld to have sql_mode set

0.5.3
-----
- Updates to work with lukscrypt

0.5.2
-----
- Works with Centos 7 and systemd

0.5.1
------
- force ssl for all remote root calls

0.5.0
-----
- Setting up for ssl for remote root connections
- Create a client.rb and server.rb recipe for ease of understanding
- removed ssl_config and create a mysql_config, to be used by client and server recipes

0.4.0
------
- Move to remote connections locked down by ip

# 0.3.0
-------
- entire db was installing when you only needed a client.

# 0.2.9
-------
- Add support for mysql-community to RHEL 7

# 0.2.8
-------
- removed collation-server from 5.7 and below
- Added luks encryption compatibility

# 0.2.7
-------
- Added updates to allow for changes to 5.7 database

# 0.2.6
--------
- Mysql 5.7 support

# 0.2.5
-------
- added default-storage-engine

# 0.2.4
-------
- Added tmp_dir to mysql service

# 0.2.3
-------
- Removed mysql2gem from a number of places to prep
- Updates mysql_local_user to be able to handle passing in a password hash vs. password

# 0.2.2
-------
- Added mysql_local_user so we can have more control of creating local mysql users

# 0.2.1
--------
- `jmh_db_user` - default to localhost when no parent node query given
- `jmh_db_user` - fail when no server found from parent node query
- rubocop and food critic run

# 0.2.0
--------
- moving to new mysql community cookbook version '6.0.23' which requires 'mysql2_chef_gem'
- version of mysql to install is 5.1 still
- removed default provider and mysql_init recipe as not needed

# 0.1.1
--------
- Adding the init template
