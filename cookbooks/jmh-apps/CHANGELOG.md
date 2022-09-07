jmh-apps CHANGELOG
======================

This file is used to list changes made in each version of the jmh-apps cookbook.

1.2.0
-----
- removed un-used databag attributes
- removed legacy apache 2.2 remote_ip modual reference
- removed un-used java recipe
- removed un-used hostsfiles recipe

1.1.8
-----
- remove proxy_site recipe for mob proxy
- deprecate gituser recipe

1.1.7
----
remove mysql attribute file

1.1.6
------
- remove mysql version

1.1.5
-----
- remove attributes and recipe for regapp and moved to jmh-webserver cookbook 

1.1.4
-----
- remove attributes and recipe for events 

1.1.3
------

1.1.2
------
- Prepare for java 8 upgrade of events

1.1.1
-----
- gituser needs new ssh key for bitbucket

1.1.0
-----
- Removed webrequest recipes and moved to jmh-webrequest cookbook
- Removed find a doctor (fad) recipe and moved to jmh-fad cookbook

1.0.2
-----
- Added recaptcha variable to fad

1.0.1
-----
- Removed all myjmh references

1.0.0
------
- Modified jmh_apps_db to use new jmh_db providers
- Moved prereg to use the new jmh_db_user provider
- created FAD user id with specific UID
- deleted unused cookbook recipies for myjmh & profile
- included install of mysql2 gem
- moved db_backup recipe to jmh-db::db_backup 

0.7.13
------
Adding mysql init script to the db section

0.7.12
------
Upgraded java 7 to prereg_client and prereg_admin app and increased thread stack size

0.7.11
------
- Remove supportportal. moved to `jmh-webproxy`

0.7.10
-----
moving the hostsfiles recipe to jmh-utilities cookbook, including attributes per application

0.7.9
-----
Added skip for chef-zero into database setup with parent roles

0.7.8
-----
Moving out billpay to `jmh-billpay`

0.7.7
-----
- Using JmhJavaUtil instead of JMH_java_util
- allow Zipnosis to see systems

0.7.6
-----
Repoint all web servers stuff to `jmh-webserver`

0.7.5
-----
Set RHEL 5 to only TLSv1

0.7.4
-----
Updated SSLProtocol to just TLS

0.7.2
-----
web_apps.conf.erb to include SSLProxyProtocol

0.7.1
-----
include apache new default variable for traceenable = Off

0.7.0
-----
moved php out of cookbook

0.6.21
------
include billpay archive scripts

0.6.13
------
allow for admin tools to connect over SSL

0.6.12
------
included jmh-apps::proxy_site which allows internal JMH networks to reach www-sbx, www-dev, stage servers

0.6.7
-----
Table permissioning for users in db_users databag

0.5.3
-----
Upgraded java 7 to profile/myjmh app and increased thread stack size
- - -

0.5.2
-----
Include the mobile app NewRelic java JAR file to include in the java options

0.5.1
-----
Excluded from recipe db_backup the EVENT priviledges that don't work in releases before MySQL 5.1.6