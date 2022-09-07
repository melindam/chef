jmh-operations CHANGELOG
======================

1.2.16
------
- updated salesforce sftp server to marketingcloudops.com domain instead of exacttarget.com domain

1.2.15
-----
- removal of diapp1 mongodb backup
- updated `archcorp_copy.rb` for the move soon.
- changed jive mount user to `nasjive`
- cleaned up awstats done processing directory
- deactivated recipe for jive_utilities and removed from role ebiz-tools

1.2.14
------
- added `zipsync.rb`
- added `archive_videovisits_logs`

1.2.13
------
- added mongodb weekly archive script

1.2.12
------
- added mongodb archive script
- removed awsdev & added awstst & awspoc

1.2.11
------
- Added `mdsuspendion_echo_import.rb`
- Added dependency on `jmh-dev`

1.2.10
------
- Added jive utilities recipe for removing ex-employees, which uses NFS mount using ediadmin user
- Added mongo DB archive script and directory  

1.2.9
-----
- Added profile db framework to setup, for when we want to allow access to the profile db.
- Added echo import scripts for all environments NOT `arprod`

1.2.8
-----
- Added `stage_reset_crowd_db.rb` and `stage_reset_profile_db.rb`

1.2.7
------
- Added clientid to the interconnect calls

1.2.6
------
- remove cert checks for java 7 and below
- Upgrade SSLPoke to be compiled by jdk8

1.2.5
-----
- included sftp process to Salesforce for epic_email_gen.sh

1.2.4
------
- node.set changed to node.normal
- secure_password changed to random_password
- fixed bug in directory creation

1.2.3
-----
- update mychart DB feed to include OnlineScheduleAppts.txt, and index MRN columns

1.2.2
------
- update fad image upload script for 2 node FAD

1.2.1
------
- Adding mychart mobile checks to interconnect check page

1.2.0
-----
- upgrade of awstats to the standard yum version

1.1.1
------
- Added Developer section

1.1.0
------
- updating interconnect page to use jmh-epic

1.0.16
------
- updating interconnect page

1.0.15
------
- Added mysql slow query

1.0.14
------
- updates to handle upgrade to chef 13

1.0.13
--------
- added archcorp copy

1.0.11
--------
- implemented rsync for pingfed backups
- awstats fix for new arprod environment

1.0.10
--------
- Added better recipe for db backup
- bitbucket update to known_hosts

1.0.9
-------
- removed canopyhealth references and recipe

1.0.8
-------
- update data bag locations for credentials
- added mime for 7z to webserver

1.0.7
-------
- Awstats
-- upgrade to 7.5
-- removed timezone checking. already pacific
- adding jmh-encrypt
- removed some package dependencies from subversion

1.0.5
-------
- moved myjmh-command recipe to jmh-myjmh cookbook, and included dependency

1.0.4
-------
- new interconnect checks for Epic 2015 servers
- new interconnect-SECURE checks

1.0.3
-------
- Updated analytics call to use jmh_db_mysql_local_user to create users

1.0.2
--------
- Fixed firehost variables calls that do not work on non firehost servers
- Fixed weekly backup job.

1.0.1
--------
- moved mysql connection strings to use 127.0.0.1 instead of localhost
- updated scripts for Analytics mychart DB scripts
- subversion now points to production crowd

1.0.0
--------
- analytics database: final ebiz-tools01 job moved over
- updates to myjmh command to work with moved analytics db

# 0.1

0.1.11
--------
Added Shared Folder

0.1.10
--------
Adding event reporting

0.1.9
---------
Added awstats

0.1.8
-----
Using jmh-webserver

0.1.7
-----
including myjmh-command java script to run for automatically sending output of MyJMH Activation Codes

0.1.4
-----
including billpay archive scripts which will be defined in rundeck
