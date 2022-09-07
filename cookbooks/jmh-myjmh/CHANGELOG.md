# jmh-myjmh

# 0.4


## 0.4.19

- switched nodejs version to 14 on profile

## 0.4.18

- added jdbc timezone America/Los_Angeles

## 0.4.17

- added google_captcha_secret_key to profile-api local.yaml
- added tealium.datasource to profile-client catalina properties
- reverted code for version 4.16 to "allowed MRN merge script to automatically execute profile-api curl command for patient cleanup"

## 0.4.16

- switched aws properties in `profile_local_yaml.erb` to use pinpoint properties in data bag `credentials/aws.json` 
- added new value,`mychart.signup.google.captcha.sitekey`, to catalina.properties for profile-client
- allowed MRN merge script to automatically execute profile-api curl command for patient cleanup

## 0.4.15

- updated profile api start from swagger to npm
- myjmh-admin added jdbc connection string `&serverTimezone=PST`

## 0.4.14

- myjmh-admin added jdbc connection string `&serverTimezone=UTC`

## 0.4.13

- added website URL to `profile_local_yaml.erb`

## 0.4.12

- `myjmh_command.rb`
  - added database properties to command file
  - updated environment to be current environment
  - upgrade to java 11

## 0.4.11

- clean up of video visits yaml entries

## 0.4.10

- tomcat 9 for admin

## 0.4.9

- Added hostsfiles crowd to `admin.rb`

## 0.4.8

- moved the logs directory to the encrypted folder
- add ldap to the databag and to the yaml file.

## 0.4.7

- added ldap params to YAML file, and domain controller hosts entry to profile-api
- excluded remote DB calls for admin when running tests

## 0.4.6

- added videovists properties to profile api

## 0.4.5

- added aws properties to profile api

## 0.4.4

- profile-api YAML file updates for videovisit

## 0.4.3

- added chatbot properties to profile api
- myjmh-admin added `['max_heap_size']`

## 0.4.2

- moved pingone properties to a databag

## 0.4.1

- updated `profile_local_yaml.erb` for idp pingfed properties

## 0.4.0

- deprecated myjmh-client
- changed tomcat port for admin to use myjmh-client # 8098
- updated local.yaml from 0644 to 0640
- updated newrelic.js from 0644 to 0640

# 0.3
0.3.17
------
- added more crowd properties
- added crowd.properties property to the command line

0.3.16
------
- add `api.server.url` profile-client

0.3.15
------
- Added newrelic to profile-api

0.3.14
-------
- Added IDP redirects for development to be able to use one mychart server and many chef environments. (`['jmh_myjmh']['profile_client']['enable_idp_redirects']`)
- Deprecated fatal put on myjmh-client

0.3.13
-------
- included whitelist IP in local.yaml file to restrict who can call this API

0.3.12
------
- removed patient.api.url and updated profile.api.url 

0.3.11
-------
- myjmh-admin catalina.properties cleanup

0.3.10
------
- updated myjmh_command properties for clientID
- updated myjmh-admin to have new properties, use jmh_tomcat resource, and include myjmh_public_key recipe

0.3.9
-----
- added `mychart.enabled` to `profile-client.rb`
- fix bad `=` for profile.api.url and patient.api.url in `profile-client.rb` and `myjmh-client.rb`

0.3.8
-----
- updated profile.api.url to use ['jmh_server']['global']['apache']['api']['server_name']

0.3.7
----
- added the public and private key to profile-api

0.3.6
-----
- changed myjmh.public.key.path to crypto.public.key.path 
- added crypto.private.key.path to catalina.properties in myjmh-client and profile-client recipe

0.3.5
-----
- added `serverTimezone=PST` to `['jmh_myjmh']['db']['ssl_connection_parameter']`

0.3.4
-----
- separated out zipnosis keys from jmh keys since we are now using them 2 different ways
- added keys to `myjmh-client.rb`, `profile-client.rb`

0.3.3
-----
- included in profile-api profile_local_yaml the interconnect clientId parameter

0.3.2
------
- updated google.analytics.tracking.id to be in `myjmh-client.rb` and `profile-client.rb`
- added log rotation to the profile-api logs

0.3.1
------
- node.set changed to node.normal
- secure_password changed to random_password
- added new google.analytics.tracking.id

0.3.0
------
- removed recipes `profile.rb`, `client.rb`,`services.rb`,`myjmh02.rb`, `watch_scripts.rb`
- removed attribute files `client.rb`, `services.rb`
- removed templates `check_myjmh.erb`

0.2.23
-----
- update catalina.properties file for myjmh-client

0.2.22
----
- added basic auth to profile-api on `profile_local_yaml.erb` and password in `profile_api.rb`

0.2.21
-----
- added `myjmh-client.rb` to replace `client.rb`
- removed uneeded port in profile-api

0.2.20
-------
- added `['jmh_myjmh']['crowd_java_properties']` to `definitions.rb`

0.2.19
------
- added `profile-client.rb`
- update secure_password to random_password

0.2.18
------
- profile gets its profile-api location from `['jmh_webserver]['api']['app_proxies']['profile_api']`

0.2.17
------
- Added profile-api properties to profile
- updated profile appserver call from definition to the jmh-tomcat resource

0.2.16
------
- Added profile-api
- moved `['jmh_myjmh']['db']['server']` from `environment_properties.rb` to `definitions.rb`
- added crowd_location call to `definitions.rb`

0.2.14
------
- cache disabled for myjmh services

0.2.13
-------
- updated `watch_scripts` from being able to be installed

0.2.12
------
- updated environment properties to use jmh-epic

0.2.11
------
- updated `['jmh_myjmh']['client']['oauth']['idp_url']` to use `['jmh_server']['global']['apache']['idp']['server_name']` instead
- updated secret keys for pingfed to be calls to pingfed

0.2.10
------
- updates for webserver names to be used from new standard jmh-server attributes

0.2.9
------
- Removed installation of java certs.  Moved to jmh-java

0.2.8
------
- moved crowd password to a databag

0.2.7
-----
- Updated crowd password and added stage password

0.2.6
-----
- updates to tcell variables

0.2.5
----
- added privilege parameter to mysql local user creation

0.2.4
-----
- required ssl for client, service, profile, and myjmh-admin
- moved cache variables to only to services config.

0.2.3
-----
- Removed webapps dir move. Will be handled by jmh-tomcat code, if need be.

0.2.2
------
- scripts recipe to be used on profile DB server

0.2.1
------
- added directories to jmh_tomcat call which was not correct
- added oauth properties for PingFederate

0.2.0
------
- added catalina.properties as its own recipe to create for Dev team for local use

0.1.30
-------
- WellBe oAuth java property values added

0.1.29
-------
- remove all of canopyhealth references and JWT keys

0.1.28
------
- moved crowd hostIP to now use crowd.jmh.internal hostname and included the recipe for hostsfiles_crowd_servers

0.1.27
------
- added switch for AEM or CQ environment server for cq.properties
- removed cq properties not needed in catalina

0.1.26
------
- myjmh-client increased memory
- Removed permgen from all apps (not in java 8)

0.1.25
------
- Bug fix to allow newrelic and tcell at same time.

0.1.24
------
- added canopy JWT properties

0.1.23
-------
- Adding tcell configs
- rubocop updates

0.1.22
------
- Added new federated properties for zipnosis and canopy

0.1.21
------
- Added recaptcha secret file

0.1.20
------
- Added opinionlab myjmh property to client

0.1.19
------
- updated check script

0.1.18
------
- moved recipe myjmh-command from operations cookbook

0.1.17
------
- Added new prd cert for interconnect

0.1.16
------
- Added certificate www insert for client and profile
- Rubocopy cleanups

0.1.15
------
- Move databag for epic in variables

0.1.14
------
- Added property com.johnmuirhealth.myjmh.server.baseUrl to myjmh-admin
- removed rmi.server from java opts

0.1.13
------
- Added myjmh-admin
- rubocop fixes to scripts recipe

0.1.12
-------
- Updated production url for zipnosis, and used in stage
- Now use https versions of publisher vs http
- bind address set to 0.0.0.0

0.1.11
------
* Adding MRN merge scripts and SFTP job from SSH1
* Create necessary dirctories for scripts and archive locations
* take epic properties from the jmh_apps/epic databag
* creation of profile user for developers testing

0.1.10
------
* local recipe check for db before making parent node query
* rubocop/foodcritic cleanup

0.1.9
------
Zipnosis Additions

0.1.8
-----
Added Zipnosis variables

0.1.7
-----
including HeapDump java parameters

0.1.6
-----
Added myjmh watch script

0.1.5
-----
- Added more global variables as defined by dev

0.1.4
-----
- Added Crowd cert to be installed into java
- added hosts file changes

0.1.3
-----
Getting profile to be set by hostfiles

0.1.2
-----
Dynamic Properties!

0.1.0
------
- Consolidated all myjmh apps into one cookbook
- using new jmh-db for database build.
