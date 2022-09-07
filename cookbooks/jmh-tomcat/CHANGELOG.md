jmh-tomcat CHANGELOG
======================

This file is used to list changes made in each version of the jmh-tomcat cookbook.

0.6.11
------
- tomcat 9 update to 9.0.41

0.6.10
------
- disabled AJP Port and removed attributes 

0.6.9
-----
- resource attributes for specific mysql_j_connector version per tomcat instance
- moved mysql_j url to a hash: `['jmh_tomcat']['mysql_j_hash']`
- updated tomcat-all script to use `service` command

0.6.8
-----
- removed provider tcell logic
- updated README for memory attributes

0.6.7
------
- upgrade to tomcat 7.0.93 and 9.0.16

0.6.6
-----
- moved mysql_j connector url to jmh S3 instance

0.6.5
-----
- updated cert to jmh_internal_cert_2024 X509 valid to 2024

0.6.4
-----
- created server Connector parameter for relaxedQueryChars

0.6.3
------
- Change tomcat version for 7 to 7.0.92
- Changes java version for 9 to 9.0.13

0.6.2
-----
- use the provider to define the version for tomcat

0.6.1 
-----
- increase maxHttpHeaderSize to 12000

0.6.0
-----
- upgrade to tomcat 9 is now a switch, currently defaulting to false
- removed ecryptfs and legacy things

0.5.11
-----
- upgrade to newrelic 4.2.0

0.5.10
------
- upgrade tomcat to 7.0.85 
- update mysql connector to 5.1.46


0.5.9
----
- tcell update of variables 
- tcell upgrade to 0.4.4

0.5.8
-----
- allowed for systemctl exec_start_pre to be used for an exact command

0.5.7
-----
- updated mysql connector code to upgrade an remove old connector

0.5.6
-----
- upgrade to tomcat 7.0.81
- upgraded tomcat SSLProtocol to TLSv1.2
- included encrypted webapps directory when needed

0.5.5
-----
- added sudoers file for each application start/stop to use systemctl

0.5.4
----
- added start to tomcat service 
- updated init.d script to redirect to systemctl

0.5.3
-----
- adding permissions to ['directories'] attributes when called by jmh_tomcat

0.5.2
-----
- adding lukscrypt

0.5.1
-----
- newrelic 3.39.1 and new S3 bucket location URL
- tomcat uid and guid conflicts no longer needed

0.5.0
-----
- tomcat 7.0.73
- mysql connector 5.1.40

0.4.6
-----
- Bug fix for SYS-4400

0.4.5
-----
- updated tcell to upgrade code when a new version is requested.

0.4.4
-----
- moved bamboo hash values to provider resource

0.4.3
-----
- removed line from tcell confi

0.4.1
-----
- Tcell install
- Catalina.out maintenance
- added new tar cookbook

0.4.0
-----
- Upgrade path for tomcat instances
- Remove general rollout script
- update restart all script to be stop,start,restart

0.3.17
------
- Added version to the init script

0.3.16
------
- Changed tomcat app to resource
- Added rollout scripts to be per application
- updated ssl certs file name from .key to <cer>.key
- rubocop and foodcritic

0.3.14 & 0.3.15
------
*never implemented*

0.3.13
------
Updated tomcat Rollout script to include apptapi 

0.3.12
------
- Added ability to change core files without tomcat restart
- Moved user tomcat creation to new recipe so that it can be called from other recipes (see jmh-myjmh::environment_properties)

0.3.11
------
new version of Newrelic JAR file 3.18.0

0.3.10
------
Updated application properties to remove app props if not in use.

0.3.9
-----
- Moved tomcat-native to own recipe
- Made it so only tomcat can run catalina file
- Allowed for new variables in the catalina.properties file

0.3.8
-----
Including tomcat manager to be accessible in sbx and dev environments with generic user id / password

0.3.7
-----
Added JMH broker to the run script

0.3.6
-----
moved to use mysql_connector_j cookbook provider

0.3.5
-----
Remove examples and docs from webapps directory after installing the server
Fixed SSL protocol connection string for TLSv1

0.3.0
-----

