jmh-utilities CHANGELOG
======================

0.1.21
------
- added novpn access to local servers for `hostsfile_crowd_servers`

0.1.20
------
- change the aws credentials to be moved to databag `credentials/aws`

0.1.19
------
- updated `hostsfile_crowd_servers` to fail if no crowd server is found.

0.1.18
-----
- updated crowd to allow for one instance in all of dev with `'jmh_server']['global']['crowd_chef_environment']`

0.1.17
-----
- updated `hostsfile_www_servers` to use environment for hostfile definition
- updates variables from hostsfiles to hostsfile

0.1.16
------
- added api to hostsfile_www_servers

0.1.15
-------
- updates for webserver names to be used from new standard jmh-server attributes

0.1.14
--------
- Added rest-client to the list of s3 depenencies

0.1.13
---------
- made data bag variable for epic into default variables so other recipes can use them

0.1.12
---------
- updates www hosts file to allow for more custom changes.

0.1.11
---------
- include entry for dispatcher to have idp.johnnmuirhealth.com 

0.1.10
---------
- updated dependencies for s3_file
- included recipe hostsfile_crowd_servers to find env specific crowd server

0.1.9
---------
- Removing build-essential and calling for less packages to be installed.

0.1.8
--------
- added remove epic hosts entry for old hostname cleanup
- added hostsfile_all_chef_clients recipe

0.1.7
--------
- added install_jvm_certificate
- rubocop cleanups

0.1.6
--------
- removed hostsfiles_myjmh_servers as no longer needed, replaced by profile.jmh.internal IP

0.1.5
--------
- Added pem to der 

0.1.4
--------
- added hostsfile recipe 

0.1.3
--------

0.1.2
--------
- added not_if to create statement for s3 download
- added update action to s3 download which just does not have the not_if

0.1.1
---------
Updated s3 download to include the "build-essentials" recipe to install needed dev packages.



