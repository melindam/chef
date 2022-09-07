jmh-prereg CHANGELOG
======================

This file is used to list changes made in each version of the jmh-prereg cookbook.

# 0.3

## 0.3.8

- increased java heap size for admin

## 0.3.7

- removed tomcat AJP port for CVE-2020-1938

## 0.3.6

- added pre-exec step for startup to remove directories

## 0.3.5

- included new jmh_tomcat attribute for force use of mysql_j_version to 5.1

## 0.3.4

- upgraded to tomcat 9

## 0.3.3

- add a catalina_properties value for the build of client

## 0.3.2

- node.set changed to node.normal

## 0.3.1

- DECOMMISSIONED new ftp process to ssh1 server
- DECOMMISSIONED added version to prereg data copy mount

## 0.3.0

- new webapps forms directory
- new ftp process to ssh1 server
- new variables to include for catalina.properties
- added version to prereg data copy mount

# 0.2

## 0.2.3

- local DB user for prereg client

## 0.2.2

- mysql-service needs to start before systemctl start command
- application will SLEEP 10 seconds before it starts up due to needed mysql wait

## 0.2.1

- java 8 for prereg-client

## 0.2.0

- java 8 run time for admin

# 0.1

- initial build, no longer in jmh-apps cookbook
