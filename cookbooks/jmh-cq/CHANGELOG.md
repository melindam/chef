# AEM Change Log


# 3.2

## 3.2.0

- comments about additional_cond_rewrites for video visits to be availble if needed
- removed screener proxies

# 3.1

## 3.1.20

- added /mychartscheduling context re-write

## 3.1.19

- added MS QNA maker properties

## 3.1.18

- added ms.webchat.bot.directline.secret.key property

## 3.1.17

- added back crypto syncing per environment

## 3.1.16

- added SP 3.5.6 (can be overidden in environment)

## 3.1.15

- fixed some package install problems
- update check port to check a page.  (more reliable)

## 3.1.14

- removed `['cq']['author']['user_asset']` - deprecated
- removing of 6.4.0 things
- added author only bundle to 6.5
- removed `['cq']['dispatcher']['config']['dispatcher_no_server_header']`

## 3.1.13

- include directories for apache path /var/www/html/vv

## 3.1.12

- updated dispatcher.any to exclude screener from caching

3.1.11

- dispatcher rewrites for videovisits to point to vvisits-client HTML page

## 3.1.10
 
- removed `jsse.enableSNIExtension=false` from jvm opts for aem 6.5

## 3.1.9

- included /vv context for vvisits_client

## 3.1.8

- Added begin/rescue in cq.rb `upload_and_install`
- moved test publisher to poc in `dispatcher-testmode.rb`

## 3.1.7

- removed proxy for /tn and made RedirectMatch /tn to vvisits lookupUrl
- added all domain_maps variables for all global website names

## 3.1.6

- added proxy for /tn to /vvisits/v1/lookupUrl

## 3.1.5

- added rewrite for /videovisit to /app_widgets code 

## 3.1.3

- added `['cq']['dispatcher']['additional_cond_rewrites']`
- added supportportal to list of ignore the domain redirects

## 3.1.2

- Remove oidc code for mychart

## 3.1.1

- Updated server_aliases to get it from the global variables

## 3.1.0

- testing for AEM 6.5
- Moved bundles to a version variable, so we can have 2 versions of aem in the same code base


# 3.0

3.0.36
-----
- update backup to zip job to start with a compact and to drain and disable the load balancer for those needed environments

3.0.35
------
- updated aws bag for aws push in `scripts.rb`

3.0.34
------ 
- updated final redirect in `domain_redirects` from http to https
- update http site to redirect with 301


3.0.33
-------
- Removing old mychart proxies

3.0.32
-------
- Removed myjmh-client

3.0.31
------
- moved openidc values to attributes

3.0.30
------
- included dispatcher config for prerender.io for /doctor
- removed tcell reference
- changed FADSitemap.xml to be /fad/sitemap service call

3.0.29
------
- new anonymous access for mychart for guest bill pay

3.0.28
------
- don't allow dispatcher to cache doctor* 

3.0.27
------
- reverted all FAD proxies to /fad

3.0.26
------
- added script `runGarbageCollection_sh.erb`

3.0.25
------
- removed /fad context as a direct path available from apache

3.0.24
-------
- updated patientportal name to MyChart

3.0.23
------
- removed broker proxies at `['cq']['app_proxies']['broker_proxies']`

3.0.22
-----
- removed billpay proxies at `['cq']['app_proxies']['billpay_proxies']`

3.0.21
------
- moved customphone book to template in `jmh-webserver` cookbook

3.0.20
------
- added `['cq']['patientportal']` properties to the `jmh_properties.erb`
- updated `customphonebook.xml`
- added /fad/api proxies for new fad

3.0.19
------
- mychart overrides on authentication - `['cq']['mychartsso_proxies_unauthenticated_locations']`
- added /mychart/billing/guestpay goes to correct mychart instance.

3.0.18
-----
- added mychart_sso proxies
- add /mychart redirect to go to mychart instance for that environment
- added customphonebook

3.0.17
-----
- removed /custom from `['cq']['app_proxies']['subsite_proxies']['proxies']`

3.0.16
------
- added new `www_openidc.conf`

3.0.15
------
- included rewrite for ^/doctor to www_configs

3.0.14
-----
- upgrade oak-run to 1.9.9
- fix `compact_sh.erb` job
- update /etc/httpd reference to `['apache']['conf_dir']`

3.0.13
------
- Added header control to dispatcher: `['cq']['dispatcher']['https']['header_access_control']`

3.0.12
------
- Adding a properties file name jmh-aem.properties

3.0.11
------
- Added new openidc stuff for myjmh proxy


#3.0.10
------
- Added /myjmh-client/registration /myjmh-client/login-help to the pass throughs for myjmh-client

# 3.0.9
-------
- Removed `['cq']['app_proxies']['api']`

# 3.0.8
-------
- Updated `['cq']['app_proxies']['myjmh']['target_recipe']`

# 3.0.7
-------
- Add `/myjmh-client/authorizeSSOToken` for non-session URI's for myjmh-client
- Removed `/myjmh-client/login-help`
- put back php proxy for /mdstart

3.0.6
----
 - profile-client-v2 is now profile-client

3.0.5
-----
- Adding new personalized features in AEM, dispatcher.any and //content/campaigns
- removing all HR PHP subsite proxies 

3.0.4
-----
- Adding mychart camel case context

3.0.3
-----
- created global config for max_header_size for apache config LimitRequestFieldSize

3.0.2
-----
- AEM 6.4.1 service pack install aem-service-pkg-6.4.1.zip
- robots.txt update for /tests* pattern
- publisher dev/sbx instances to use 2048 shared memory

3.0.1
-----
- added api proxies in `app_proxies.rb`
- enabled java option -Djsse.enableSNIExtension=false to allow external link checker to UCSF to work :-\

3.0.0
------
- Upgrade AEM to 6.4
- including forms package

2.2.15
------
- added locations to the proxy template call

2.2.14
-------
- moved from jmh-myjmh to jmh-epic for mychart proxy

2.2.13
-----
- idp authorization
- fixed download_assets_s3.sh to work without perl

2.2.12
------
- updates for webserver names to be used from new standard jmh-server attributes

2.2.11
------
- removed static context for mychart and moved the call to the data bag
- moved all ignore context's for app proxies into a dynamic call

2.2.10
-----
- Updated apache servers to use jmh_webserver instead of going directly to webapp for apache
- updated maintenance windows to not be environment specific: set it in the environment and it only runs on that environment.
- added mychart proxy to the maintenance windows 

2.2.9
------
- Added forms lib to initial packages
- Added /content/forms to apache rewrites

2.2.8
------
- move some variables to jmh-webserver calls from apache2

# 2.2.7
-------
- Cleanup for Chef 13 update
- Removed perl and updated aws_push to only a shell script
- Removed discovery_all from dispatcher

# 2.2.6
-------
- remove webrequest proxy to error page, and redirect to Service Now permenantly

# 2.2.5
-------
- Full time webquest maintenace

# 2.2.4
-------
- Added sleep to be set after a package is installed
- update install_package to upload and install at the same time. had to switch the xml from json
- Added forms packages, but commented them out
- update check for new versions of oak-run.jar, since we will not update this.  (It is only part initial install)
- added `['cq']['bundles_additional']` to allow bundles to be defined in environnment

# 2.2.3
-------
- moved www_configs out of a data bag and into attributes

# 2.2.2
-------
- added package for jquery-update-3.2.1.zip

# 2.2.1
-------
 - moved default.attribute to `_default.rb` because sequential read of variables by chef was making cq-author fail
 -- problem was with `node['cq']['dispatcher']['document_root']`
 - update publisher search to handle when local publisher is not built yet 


## 2.2.0
--------
- Install of Service Pack 1 for AEM 6.2
- simplified install package code
- added remove_content functionality, if needed

# 2.1

# 2.1.9
-------
- allow for dispatcher.any path /libs/granite/csrf/token.json

# 2.1.8
-------
- updates scripts to only work with current environment

# 2.1.7
-------
- Added systemd functionality

# 2.1.6
-------
- Fix to scripts to allow all publishers and authors to be seens

# 2.1.4
-------
- added apache 2.4 intelligence
- fix to server aliases

# 2.1.3
--------
- Added back site map
- Added cool functionality that guesses the name of the cq folder from version

# 2.1.2
-------
- removed sitemap because we dont have one.

## 2.1.1
--------
- moved epic downtime variable to jmh-webserver
- disallowed cache on dispatcher for path /content/jmh/en/home/services/*

## 2.1.0
--------
- remove canopyhealth.com references

# 2.0

## 2.0.7
--------
- Starting move of app proxes from data bags to variables

## 2.0.6
--------
- including attribute to header_ie11

## 2.0.5
--------
- update dispatcher.any for internetAddress to be available for anyalytics

## 2.0.4
--------
- Updated dispatcher configuration

## 2.0.3
--------
- including context for /jmh-loader-widget
- removing legacy openscheduling-widget

## 2.0.2
--------
- updated dispatcher to allow regapp to work

## 2.0.1
--------
- moved s3 bucket jmhaem

## 2.0.0
-----
- AEM upgrade to 6.2
- Removed install_code, since we dont use it that way
- Updates install_content to be by server type
- Upgraded Dispatcher
- Geo code only installed in dev and default
- Updated admin password code
- updated start/stop scripts to be better about shutting down cq during bad times.
- remove dependency on lynx in cq check process
- updated service to start every chef run and updated start script to handle start command when service when already running
- added ldap package
- removed garbage collection crons to instead to the daily maintenance
- Still need to: 
-- Users package installs do not work in AEM 6.2, I think we need remove the admin user

# 1.2

## 1.2.4
-------
- canopy error pages and new proxy to canopy-fad

## 1.2.3
-------
- memory updates to dev env, and MaxPermgen increased to 1024M

## 1.2.2
-------
- included ssl rewrite log
- added regapp rewrite conditions for profile-client/registration/new(*)

# 1.1

## 1.1.2
-------
- Apache to allow more than one certificate

## 1.1.1
--------
- Updated all /var/www/html references and moved to a variable
- moved prc to its own recipe
- created dispatcher-canopy recipe to include new canopy app proxies 

## 1.1.0
---------
- Added www.canopyhealth.com
- Migrated to new LDAP server for authentication


# 1.0

## 1.0.16
--------
- fixed shutdown script to be more aggressive in the face of a failed shutdown.
- added better remove cache

## 1.0.15
---------
- Added `[cq][<server_type>][jvm_additional_opts]`

## 1.0.14
---------
- move site over https
- remove ssl_redirects array because not necessary anymore 

## 1.0.13
--------
New script for getting assets from S3 vs. prod system 

## 1.0.12
--------
Including OpenSchedule proxy

## 1.0.11
--------
Moved jmherror to the `jmh-webserver`

## 1.0.10
---------
- Cleaned up password stuff
- Added new remote ip

## 1.0.9
--------
new LDAP servers 

## 1.0.8
--------
Update restart script to email us the lock file mail

## 1.0.6
--------
included 2 LDAP servers for authentication

## 1.0.5
--------
added sitemap to the robots file

## 1.0.4
--------
Added ability to search by recipes

## 1.0.3
--------
added broker

## 1.0.2
--------
* Update to use jmh-webserver for author
* Updates to accomodate new apache 2

# 0.6

## 0.6.6
-----
comment out patch cq-5.5.0-hotfix-3394-1.0.zip, removed geometrixx content sites 

## 0.6.5
-----
included patch cq-5.5.0-hotfix-3394-1.0.zip

## 0.6.4
-----
new package names for author & publisher

## 0.6.0
-----
new PRC site for Firehost Dev

# 0.5

## 0.5.0
-----
LDAP integration for login to publisher and author

## 0.5.2
-----
new PRC site configuration for dispatcher


