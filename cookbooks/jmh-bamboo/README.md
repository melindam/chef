Description
============
Installs and configures Atlassian Bamboo.

Recipes
========
* `default` - runs `install`, `web_server`, and sets up iptables
* `dependencies` - installs the executables used by Bamboo
* `install` - installs a master bamboo server
* `mysql` - create mysql database for use by bamboo
* `web_server` - drops an apache server in front of bamboo
* `remote_agent_win` - installs bamboo remote agent on windows server
* `testcafe` - installs NodeJS testcafe and all dependencies


Notable Attributes
==================
* `['jmh_bamboo']['install']['dir']` - defaults to /usr/local/bamboo
* `['jmh_bamboo']['version']` - bamboo version to install
* `['jmh_bamboo']['executables']` - Array of executables used by bamboo

Upgrading
=========
* Server Upgrade: https://jmhebiz.jira.com/wiki/spaces/SYS/pages/11995209/Bamboo#Bamboo-Upgrading
* Agent upgrade: set attribute `['jmh_bamboo']['windows']['bamboo_update']` to true for a single chef run



Testing
=======
Because you will test the backup ahead of time, you want to make sure it is turned off
- https://answers.atlassian.com/questions/140721/is-there-a-way-to-start-bamboo-that-forces-all-agents-to-be-disabled
"Though I typically discourage messing with the database, the safest thing is to jump into the database. The remote agents are listed in the QUEUE table. If you update the ENABLED field to 0 for each agent, it will disable them upon start.update QUEUE set ENABLED=0"

