# jmh-operations

Description
===============
A collection of maintenance scripts and tasks to be used by JMH EBusiness for ensuring disaster recovery and such.

Requirements
=============
* RHEL 5 or 6, 32bit and 64bit tested

Recipes
========
* `analytics.rb` - creates local mychart and open-scheduing tables for eBiz to run reports from EPIC data
* `archive_archiva_repo.rb` - backup all archiva artifacts via rsync.
* `archive_database_backups.rb` - backup all databases via rsync.  Daily backups along with weekly backups
* `archive_fad_images.rb` - backup all fad images via rsync.
* `archive_billpay_files.rb` - pulls down archived billpay import and export files from apps02 server via scp.
* `archcorp_copy.rb` - one off to transfer from a windows share to a box.com share

Awstats
-------
You will run into problems on rhel 7 because you need to also have the `rhel-7-server-optional-rpms` as part of your yum subscription.
To install the repo:

``
subscription-manager repos --enable rhel-7-server-optional-rpms
``

Archcorp_copy Recipe Instructions
----------------------------------
1. update the following variables for box credentials:
```
['jmh_operations']['box_user']
['jmh_operations']['box_password']
```
1. add to a chef server `recipe[jmh-operations::archcorp_copy]`
1. run chef
1. update /root/secret.txt with your windows credentials
```
username=<username>
password=<password>
```
1. run chef again

