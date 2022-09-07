jmh-billpay CHANGELOG
======================

This file is used to list changes made in each version of the jmh-billpay cookbook.

0.3.5
------
- node.set changed to node.normal
- secure_password changed to random_password
- included hostsfile_crowd_servers for billpay-admin recipe

0.3.4
-----
- added privilege parameter to mysql local user creation

0.3.3
-----
- changed export legacy ftp job to email job, and included in rundeck

0.3.2
-----
- Update to get ssh1 key in correct format for ssh_known_hosts
- deprecated the FTP job

0.3.1
-----
- permissions conflicts for directories

0.3.0
-----
- billpay client and billpay-admin recipe to use jmh_tomcat resource

0.2.6
-----
- billpay-admin java 8 and threadsize increased to 256K

0.2.5
-----
- trustcommerce data bag now encrypted

0.2.4
-----
- trust_commerce databag update for billpay prod or dev attributes

0.2.3
-----
- billpay client upgrade to java 8

0.2.2
-----
- created local DB user for developers in sbx and dev environments

0.2.1
-----
- localhost check for creating db user.  Search for a local recipe first
  before doing a query to the server looking for the correct client.

0.2.0
-----
- move database and db user creation to use jmh-db cookbook
- created new recipe db

0.1.0
-----
- initial build
- Using JmhJavaUtil instead of JMH_java_util
- update to billpay export script to error out when no file is present
