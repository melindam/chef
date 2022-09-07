# jmh-splunk

cookbook to run splunk locally on a server to collect data into splunk.johnmuirhealth.com licensed server.

* `[jmh_splunk][inputs_conf][example_name]` - named application configurations and the log files it aquires (e.g. 'fad_catalina')
* `[jmh_splunk][inputs_conf][example_name][type]` - 'monitor'
* `[jmh_splunk][inputs_conf][example_name][input]` - '///usr/local/tomcat/fad/logs/catalina.out',
* `[jmh_splunk][inputs_conf][example_name][sourcetype]` - 'log4j'
* `[jmh_splunk][mgmt_port]` - include if need to override default port 8080

## Upgrades
1. Add the new version to `['jmh_splunk']['version_hash']` 
1. Update `[jmh_splunk]['version']` to version in the hash you want
1. Set `['jmh_splunk']['upgrade']` to `true`
1. Once the upgrade is complete, set `['jmh_splunk']['upgrade']` to `false`