jmh-fad CHANGELOG
======================

This file is used to list changes made in each version of the jmh-fad cookbook.

0.3.12
------
- removed AJP port for CVE-2020-1938

0.3.11
------
- import_file_name changed to v2.3.csv

0.3.10
------
- added script for image base64 conversion and export directory

0.3.9
-----
- moved scheduling call to front end API hostnam

0.3.8
------
- added numofschedulingdays catalina property = 90

0.3.7
-----
- fix to `['jmh_fad']['client']['upload']['import_file_name']`

0.3.6
-----
- new echo import filename for v2.2 `['jmh_fad']['client']['upload']['import_file_name']`

0.3.5
----
- new value for com.johnmuirhealth.fad.captcha.google.secret V3

0.3.4
-----
- Re-did the way we do the images download so kitchen will work

0.3.3
------
- node.set changed to node.normal
- secure_password changed to random_password


0.3.2
-----
- fad rollout script for 2nd node system does not need DB backup

0.3.1
-----
- moved JMHAPP_Utils to `JmhFadUtils` for URL check to libraries section

0.3.0
-----
- added property com.johnmuirhealth.fad.admin.update.url for 2 node system
- added recipe for fad02 for 2 node system
- upgrade to Tomcat 9

0.2.6
-----
- added property com.johnmuirhealth.fad.googlemapsbackendapikey

0.2.5
-----
- Removed myjmh dependency

0.2.4
-----
- updated scheduling api url for `com.johnmuirhealth.fad.myjmhservicesavailabilityuri`

   - script now checks for scheduling first and uses that

0.2.3
-----
- Updating GoogleAPI key to production key

0.2.2
-----
- Adding captcha to properties

0.2.1
-----
- updates for webserver names to be used from new standard jmh-server attributes

0.2.0
-----
- grails properties now overridden at runtime.

0.1.6
-----
- removed option for -Dosw.showcaptcha true and false and catalina_options for java command line run

0.1.5
-----
-  Added remove list from echo file

0.1.4
-----
- Added the echo update file

0.1.3
-----
- umask set to 002 for fad user ID, added to .bash_profile
- chmod for echo file set to 600 to stop run from occuring

0.1.2
-----
- chown the image folder to fix and permission problems

0.1.1
-----
- removed uid on fad user

0.1.0
-----
- initial build, no longer in jmh-apps cookbook
