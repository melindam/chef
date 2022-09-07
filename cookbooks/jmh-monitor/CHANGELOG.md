jmh-monitor CHANGELOG
======================

This file is used to list changes made in each version of the jmh-monitor cookbook.

0.12.1
------
- remove sensu-core removal code.  not needed anymore.
- reset password code in `sensugo-shared.rb`.  Notes in `README.md`


0.12.0
--------
- removal of sensu core legacy code
- removal of uchiwa and sensu cookbook dependencies
- update run to restart sensugo backend if front end is not working.
- Added timeout to graphite handler
- removed scott email

0.11.2
------
- added fad & sup handlers
- added timeouts to all checks

0.11.1
------
- Added TLS to sensugo
- Added hostfiles to sensugo
- pegged version to 6.1.2-3565
- added logrotate to sensugo
- added sensu-backend restart check at end of run 
- added keepalive host paging

0.11.0
-------
- initial installation of sensugo
- added memory metrics


0.10.2
--------
- remove interval filter
- add back occurences filter
- add default refresh rate to handle emails to 10 minutes (600 seconds)

0.10.1
---------
- fixed the emails to work at the interval of 1,2,5 and every 10 minutes

0.10.0
------
- added new pagerduty_mailer handler

0.9.1
-----
- upgrade 0.9.0 
- moved to different yum repo : https://eol-repositories.sensuapp.org

0.9.0
-----
- upgrade to sensu 1.7.0-2
- upgrade to uchiwa 1.7.0-1
- added SSL to uchiwa
- Uchiwa log rotation

0.8.7
------
- move subscription has to the databag 
- allowed for variable substitution on the commands per node

0.8.6
-----
- Added ping check to test vpn

0.8.5
----- 
- included EPIC-CLIENT-ID header in script check_secure_rest for EPIC 87 update

0.8.4
-----
- sensu upgrade to 1.7.0
- uchiwa upgrade to 1.6.0

0.8.3
-----
- included new iptables for connection from bamboo server to graphite

0.8.2
-----
- workaround in `default` due to https://github.com/sensu/sensu-chef/issues/627

0.8.1
-----
-  Updated python-django packages so graphite can work with yum packages

0.8.0
-----
- upgrade of sensu to 1.6.1-1
- upgrade of sensu to 1.3.1-1

0.7.0
-----
- new easier install of rabbitmq

0.6.2
-----
- new implementation of graphite without graphite cookbook.

0.6.1
-----
- Added 'afterhours' to the filters
- Removed some uneeded filters

0.6.0
-----
- Added graphite back into the mix with help from: https://blog.sensuapp.org/sensu-metrics-collection-beafdebf28bc
- fixed the occurences problems.  Now occurrences works.


0.5.1
-----
- Adding mysql process check functionality
- update to uchiwa 1.1.1-1

0.5.0
------
- Sensu upgrade to 1.0.2-1
- introduction of the filters
- make it work with systemd

0.4.2
----
- changes yum repo for sensu
- uchiwa version bump

0.4.1
------
- sensu version bump

0.4.0
-----
- sensu 0.26.x
- uchiwa dashboard

0.3.11
------
- Added chef gem mime-types since it is needed

0.3.10
------
- included check_secure_rest.sh for secure interconnect checks, uses base64 encoding for user/password

0.3.9
-----
- Updated Search used
- Added command list to check_procs WARN and Critical