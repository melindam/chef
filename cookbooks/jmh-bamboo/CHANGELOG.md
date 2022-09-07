jmh-bamboo CHANGELOG
======================

## 0.7.6

- add directory for scripts for deploy child plan branch name
- default nodejs version to 14

## 0.7.5

- excluded google-chrome install - broken repo and install
- upgraded wss-unified-agent-20.9.1.jar
- updated checkProfileApi.sh with new endpoint
- npm install global typescript
- included java 15
- added node 15
- removed java 13

## 0.7.4

- removed `dependency_nodejs.rb`
- added the `.nmprc` file template to `nodejs.rb`

## 0.7.3

- added jdk7 settings file
- upgraded `wss-unified-agent_config.erb`
- updated LB API version to 7.0
- included node 14 for installs

## 0.7.2

- update to 7.0.4
- adding java 11 to mix
- added proxy info to `server_xml.erb`
- upgrade whitesource to 2## 0.5.2

## 0.7.1

- included node 13 install for new executable
- added mongodb recipe for testing
- added testcafe for all nodejs versions

## 0.7.0

- added `remote_agent_win.rb` to run a remote agent on windows
- removed attribute file `sonarqube.rb`
- added java13 to the list of java versions to install
- updates to bamboo_agent for new config needs

## 0.6.14

- Removed sonarqube from being seen
- included attribute server_name for bamboo agent JMS connection in bamboo.cfg.xml

## 0.6.13

- install of testcafe nodejs framework
- removed all references to sonarcube
- added firefox to `testcafe.rb`

## 0.6.12

- Adding whitesource install to `dependencies.rb`

## 0.6.11

- Added `checkProfileApi_sh.erb` to `dependencies.rb`

## 0.6.10

- included google-chrome and lighthouse for base measurements of website
- added www- hostsfile entry for all AWS dispatcher roles

## 0.6.9

- updated crowd check in `install.rb` but I think it reads that file once and them puts it in the db. need to review
 See the `cwd_directory_attribute` table in the bamboo db

## 0.6.8

- Upgrade to bamboo 6.6.2
- Added `update_lb_pool.rb` script
- Updated `checkURL_sh.erb` to handle http2 connections

## 0.6.7

- update nodejs to be installed by jmh-nodejs
- added -k (accept cert) and -X GET to checkURLString.sh

## 0.6.6

- Added index.html page

## 0.6.5

- Added Sonarqube
- upgrade to bamboo 6.4.1

## 0.6.4

- removed jdk 6 installations
- having bamboo started at end of run.
- include bamboo ~/.npmrc

## 0.6.2

- upgrade to version 6.2.1
- added retire.js
- added install_mychart script for MyChart files to be installed into myjmh-client code before WAR file created

## 0.6.1

- Updating administration.xml file with xmledit.

## 0.6.0

- Updated to allow for upgrade on fly.

# 0.5

## 0.5.3

- moved bamboo data bag 

## 0.5.2

- RHEL 7 support

## 0.5.1

- Added nodejs

## 0.5.0

- Upgrade to 5.10
- added node js
- added fad db
- remove grails 2.4.3

# 0.4

# 0.4.0

- Added remote_agent.rb
- split out user creation away from install.rb

# 0.3

## 0.3.0

- Bamboo 5.9
- Added crowd access from the get-go
- food critic and rubocop
- shift to java 1.8


## 0.2.1

- updated mysql statements to use jmh-db
- created `project_dependencies` recipe

## 0.2.0

- uses new mysql cookbook from jmh-db recipe

## 0.1.2

- Added local download to bamboo binaries
- now pointing at jmh-webserver
- changed variables to not be constants
