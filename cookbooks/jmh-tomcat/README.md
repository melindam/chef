Description
===========

Installs and configures Tomcat 7.

Requirements
============

Platform:

* Debian, Ubuntu (OpenJDK, Oracle)
* CentOS 6+, Red Hat 6+, Fedora (OpenJDK, Oracle)

The following Opscode cookbooks are dependencies:

* java
* ark
* jmh-java
* jmh-utilities
* mysql_connector
* iptables

Attributes
==========

* `node["jmh_tomcat"]["repo"]` - The full URL repository location, and file name of the .tar.gz file.
* `node["jmh_tomcat"]["name"]` - Application directory name to create under `["jmh_tomcat"]["target"]` directory, if nil, then no subdirectory created.  Default `nil`
* `node["jmh_tomcat"]["version"]` - The Tomcat version, default `7.0.73`.
* `node["jmh_tomcat"]["port"]` - The network port used by Tomcat\'s HTTP connector, default `8080`.
* `node["jmh_tomcat"]["ssl_port"]` - The network port used by Tomcat\'s SSL HTTP connector, default `8443`.
* `node["jmh_tomcat"]["user"]` - Tomcat user, default `tomcat`.
* `node["jmh_tomcat"]["group"]` - Tomcat group, default `tomcat`.
* `node["jmh_tomcat"]["target"]` - The target folder where tomcat is installed, default `/usr/local/tomcat`.
* `node["jmh_tomcat"]["max_heap_size"]` - Java max heap size -Xmx
* `node["jmh_tomcat"]["thread_stack_size"]` - Java thread stack size
* `node["jmh_tomcat"]["java_options"]` - Options to pass to the JVM, default `-server -Djava.awt.headless=true -Duser.timezone=America/Los_Angeles`, other options will NOT be appended.
* `node["jmh_tomcat"]["catalina_properties"]` - Array to pass in to create entries in conf/catalina.properties
* `node["jmh_tomcat"]["use_security_manager"]` - Run Tomcat under the Java Security Manager, default `false`.
* `node["jmh_tomcat"]["run_as_daemon"]` - Allows binary jsvc to run instead of using startup.sh script, default `false`
* `node["jmh_tomcat"]["enable_ssl"]` - Will run Tomcat service on SSL port.
* `node["jmh_tomcat"]["exec_start_pre"]` - Command to execute before tomcat application starts (e.g. remove directory)
* `node["jmh_tomcat"]["keep_days_of_logs"]` - Number of days to keep tomcat logs on the system before removing
* `node["jmh_tomcat"]["restart_on_config_change"]` - Boolean - true or false to allow for restart of tomcat instances on a config change - environment or node value can be set
* `node["jmh_tomcat"][<version>]["mysql_j_version"]` - Configure to each instances needs, otherwise defaults to tomcat version of attribute



Usage
=====

* As a stand alone:
** `recipe['jmh_tomcat']['single_tomcat_install']`
* As a LWRP
** see providers below

Simply include the recipe where you want Tomcat installed.

Resources 
=========
## jmh_tomcat
### Actions
* `create`
###  Required Attributes
* `name`, String :required => true
## newrelic
### Actions
* `create`
* `remove`
### Required Attributes
* none
    
Definitions
================
## tomcat_app
* This is *deprecated*.  Please use `jmh_tomcat`


Author
==================

Author:: melindam,scottymarshall