jmh-events CHANGELOG
======================

This file is used to list changes made in each version of the jmh-events cookbook.

0.2.8
-----
- removed AJP port for CVE-2020-1938

0.2.7
-----
- included new analytics DB user 

0.2.6
-----
- upgraded to tomcat 9

0.2.5
----
- added tomcat version to the tomcat resource definition

0.2.4
-----
- updates for relax_query_chars tomcat variable

0.2.3
-----
- created local DB dev user with all connection access
- removed old unused catalina.properties
 
0.2.2
-----
- changed pre-start script to remove both cache and indexes directories

0.2.1
-----
- added jmh_catalina_properties recipe for local developers
- changed tomcat call for start script from "remove_directories" to "exec_start_pre" to be exact command

0.2.0
-----
- moved db user calls to the client recipe
- remove password from databag for events db

0.1.0
-----
- initial build, no longer in jmh-apps cookbook
