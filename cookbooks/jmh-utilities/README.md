# jmh-utilities

This coobook is a series of utilities used by the JMH to help with building the infrastructure

## Recipe
`hostsfile-*` - creates /etc/hosts entry per attribute defined by their data bag names, data bag item called "delete_hosts" will be deleted from system.
`hostsfile_www_servers` - first searches for a variable defined as `['jmh_utilities']['hostsfile']['www_servers']` and uses those for creating the hostsfile entries. If not, it uses a recipe search to find the front end
Requirements 
------------
- hostsfile recipe provided by Chef Community cookbook

## LWRP
`jmh_utilities_s3_download` - helps you download files from S3
`install_jvm_certificate` - installs database certificate into jvm so java accepts the cert as legit




