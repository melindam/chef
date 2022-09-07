jmh-broker CHANGELOG
======================

0.4.1
------
- node.set changed to node.normal
- secure_password changed to random_password

# 0.4.0
-------
- upgrade to java 8
- upgrade to ActiveMQ to 5.14.4
- added upgrade code so activemq will restart with new version and same queues
- added lukscrypt encryption to the data folder for activemq

# 0.3.3
--------
- use the new jmh-epic book

# 0.3.2
-------
- node.set attribute is not working, corrected by checking for unless password exists

# 0.3.1
-------
- Removed java cert install - moved to jmh-java

# 0.3.0
-------
- upgrade to jmh_tomcat resource
- upgrade to jmh_utilities_pem_to_der to create keys

# 0.2.4
-------
- Add SSL for as a property

# 0.2.2
--------
- upgraded broker tomcat app to use java 8

# 0.2.1
--------
- Added epicconnect prd cert insert into jvm
- updates to depreciated node.normal to node.default

# 0.2.0
-------
* Added epic properties to broker
* Database connectivity to profile database in myjmh

# 0.1.4
-------
- Added rsa keys from data basg
- Added jwt key from data bag

# 0.1.2
-------
- broke up activemq recipe and app
- moved the default binary keys into the cookbook until I figure out how we are going to deal with that
- Setup activemq before app because need password in auth to for properties in app
- remove shutdown port from iptable. no need for that remotely
- changed activemq connection user name
