jmh-rundeck CHANGELOG
=======================



## 0.7.3

- upgraded to rundeck-3.3.1## 0.20210301-1.noarch

## 0.7.2

- commented out the restart on the rundeck-config.properties
- updated cookbook for new location of projects

## 0.7.1

- removal of 3.1 

## 0.7.0

- removal of rundeck cookbook.
- apache install coming from jmh-webserver
- rundeck 3.3 compatible


# 0.6

## 0.6.0

- upgrade to 3.1.2.2019## 0.27-1
- include recipe hostsfile_www_servers to make calls out to www.

## 0.5.2

- upgrade to 3.0.17

## 0.5.1

- node.set changed to node.normal

## 0.5.0

- Upgrade to rundeck 3.0.7-20181008
- removed need for data bag rundeck/secure
- removed need for a number of rundeck recipes

## 0.4.0

- Upgrade to rundeck 2.1## 0.2-1
- Moved all data bags to rundeck folder
- added iptables and jmh-utilities dependencies
- removed apache legacy code checks

## 0.3.2

- added event report details

## 0.3.1

- consolidation of the credentials to one data bag
- removed realm.properties file, using rundeck cookbook version instead

## 0.3.0

- VM's are added by databag searches

## 0.2.9

Added new dispatcher servers at aws

## 0.2.7

* Added jmh-java

## 0.2.6

* Uses jmh-db recipe along new new mysql cookbook

## 0.2.5

* Using new jmh-webserver
