Description
===========

Installs and configures Mulesoft EE

Requirements
============

Platform:

* Debian, Ubuntu (OpenJDK, Oracle)
* CentOS 6+, Red Hat 6+, Fedora (OpenJDK, Oracle)

The following Opscode cookbooks are dependencies:

* java
* ark
* jmh-java
* jmh-tomcat
* iptables

Attributes
==========

* `['jmh_mule']['base_url']` = URL of Mule EE tar.gz file to download and use for install
* `['jmh_mule']['version']` = version of Mulesoft to install
* `['jmh_mule']['iptables']` = port(s) to open for IP Tables
* `['jmh_mule']['keep_days_of_logs']` = Number of days to keep logs
* `['jmh_mule']['license']` = licnese name at S3 bucket under jmhapps/mule path


Resources
==================
`jmh_mule` 
- :name, String => :required [ name of the mule instance to create ]
- :version, String => :default => node['jmh_mule']['version'] 
- :java_version, String => :default => node['jmh_mule']['java_version']
- :iptables,  Array => :default => {}
- :enable_ssl, String => :default => false
- :directories, Array
- :remove_dirs,  Array



Author
======
melindam,scottymarshall