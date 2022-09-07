# jmh-ci

Jenkins
-------
`jmh-ci::jenkins`

Installing Jenkins
----
1. run recipe above
1. Go to jenkins web interface at : http://<jenkins server>:8080/jenkins
1. Install the `pipeline` plugin (http://jenkins-ci.org/solutions/pipeline/)
1. Install the `credentials` plugin
1. Install the `windows powershell` plugin
1. Upgrade all plugins until there are no more upgrades
1. If not new install, restore from backups
1. update ldap password in config.xml and restart
1. install the bamboo credential, if needed


Upgrade chefdk
----
1. Update the attribute, `['chefdk']['version']` to the version you want.  Use `latest` as a value if you just want the latest
1. Remove chefdk from server - `yum rease chefdk`
1. run chef-client