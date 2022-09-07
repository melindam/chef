jmh-archiva Cookbook
====================
Will install base version of Apache Archiva and update apache to have vhosts file for system


Requirements
------------
RHEL systesms only and currenly sets it up with mysql right now

e.g.
#### packages
- `ark` - for downloading artifacts
- `java` - archiva is a java jetty app
- `jmh-db` - creates MySQL database
- `mysql` - used as the database core cookbook

Attributes
----------
* `node[:jmh_archiva][:rebuild_db]` = Boolean to build out the jmh database
* `node[:jmh_archiva][:install_repositories]` = Boolean to update the repo with the repositores 
* `node[:jmh_archiva][:install_apache_app_download]` = Boolean to install mobile app download site with archiva


Usage
-----
jmh-archiva::default
Write usage instructions for cookbook.

Just include `jmh-archiva` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[jmh-archiva]"
  ]
}
```

Contributing
------------


License and Authors
-------------------
Melinda and Scott
