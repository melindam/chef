jmh-java
=====================
The jmh-java cookbook will install java version determined by jmh-apps variables, or default to java 6


Requirements
------------

Attributes
----------

* `['jmh_java']['java_security']['jars']` - security JAR files needed for Billpay
* `['jmh_java']['java_security']['cert_files']` - certificates for EPIC MyChart MyJMH connectivity to Interconnect systems

Usage
-----

```
 jmh_java_install "install java" do
    version '8'
    action :install
  end
```

Upgrading the JDK Version
------------

## Update entire environment  
  1. Add the new version to the `['jmh_java']['java_hash']`
  1. Update the `['jmh_java]'['jdk'][JAVA_VERSION]['version']`

## Update node by node
  1. Add the new version to the `['jmh_java']['java_hash']`
  1. Set a default attribute in the environment for `['jmh_java]'['jdk'][JAVA_VERSION]['version']`to the current version 
  1. Update the override in the node attributes to the new version in `['jmh_java]'['jdk'][JAVA_VERSION]['version']`
  1. run chef on that system.
  1. When done with the environment remove the attributes from the environment & then from each node.

License and Authors
-------------------
Authors: Scott Marshall

Contributing
------------
Scott Marshall, Melinda Moran


