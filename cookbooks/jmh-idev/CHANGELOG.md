# jmh-idev CHANGELOG

This file is used to list changes made in each version of the jmh-idev cookbook.

## 0.1.16

- kcadapter to node14

## 0.1.15

- removed AJP port for CVE-2020-1938
- added CAPRRDB.hsys.local hosts entry for SBO and JMPN recipe

## 0.1.14

- removed comhub `jmhapp_webserver.rb`

## 0.1.13

- removed hr `jmhapp_webserver.rb`
- removed redwagon from `index.html.erb`
- updated Proxy Timeout for webserver

## 0.1.12

- update mdsuspension to get crowd info from catalina.properties file
- update mdsuspension crowd to use ssl

## 0.1.11

- added https.protocols to mdsuspension

## 0.1.10

- decommissioned hr application

## 0.1.9

- deprecated echo and emprec applications

## 0.1.8

- forced /echo context on webserver to point to HTML file.

## 0.1.7

- update systemd

## 0.1.6

- moved echo application target_recipe
- removed hippalogviewer app 

## 0.1.5

- NAS mount for comhub application
- included new recipe for ECHO Physician Directory
- removed aid application and context from webserver

## 0.1.4

- updated `aid.rb` to have a database 
- updated `mdsuspension.rb` to have a database 
- new properties for smtp .yaml config for kcadapter 
- removed some delayed restarts on directory

## 0.1.3

- included jmh-webserver::php_site for install of php

## 0.1.2

- included webserver proxies for all IDEV apps

## 0.1.1

- added ComHub, HR, SBO, JMPN, MD Suspension Tomcat apps and webserver proxies

# 0.1.0

Initial release.
* Included Employee Recognition MySQL DB and Tomcat app.
* NAS share for webserver for both dev and prod servers

