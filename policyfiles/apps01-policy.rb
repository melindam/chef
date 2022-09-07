# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'apps01'

default['mysql']['tunable']['wait_timeout'] = '360'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'jmh-events::default'

include_policy 'base', path: 'base-policy.lock.json'

# Specify a custom source for a single cookbook:
cookbook 'database', git: 'git@github.com:scottymarshall/database.git'
cookbook 'jmh-apps', path: "../cookbooks/jmh-apps"
cookbook 'jmh-archiva', path: "../cookbooks/jmh-archiva"
cookbook 'jmh-bamboo', path: "../cookbooks/jmh-bamboo"
cookbook 'jmh-billpay', path: '../cookbooks/jmh-billpay'
cookbook 'jmh-epic', path: '../cookbooks/jmh-epic'
cookbook 'jmh-events', path: '../cookbooks/jmh-events'
cookbook 'jmh-ci', path: '../cookbooks/jmh-ci'
cookbook 'jmh-cq', path: '../cookbooks/jmh-cq'
cookbook 'jmh-crowd', path: '../cookbooks/jmh-crowd'
cookbook 'jmh-db', path: '../cookbooks/jmh-db'
cookbook 'jmh-docker', path: '../cookbooks/jmh-docker'
cookbook 'jmh-encrypt', path: '../cookbooks/jmh-encrypt'
cookbook 'jmh-idev', path: '../cookbooks/jmh-idev'
cookbook 'jmh-fad', path: '../cookbooks/jmh-fad'
cookbook 'jmh-java', path: '../cookbooks/jmh-java'
cookbook 'jmh-monitor', path: "../cookbooks/jmh-monitor"
cookbook 'jmh-myjmh', path: '../cookbooks/jmh-myjmh'
cookbook 'jmh-mule', path: '../cookbooks/jmh-mule'
cookbook 'jmh-nodejs', path: '../cookbooks/jmh-nodejs'
cookbook 'jmh-operations', path: "../cookbooks/jmh-operations"
cookbook 'jmh-pingfed', path: '../cookbooks/jmh-pingfed'
cookbook 'jmh-prereg', path: '../cookbooks/jmh-prereg'
cookbook 'jmh-rundeck', path: "../cookbooks/jmh-rundeck"
cookbook 'jmh-server', path: "../cookbooks/jmh-server"
cookbook 'jmh-sched', path: "../cookbooks/jmh-sched"
cookbook 'jmh-splunk', path: "../cookbooks/jmh-splunk"
cookbook 'jmh-tcserver', path: "../cookbooks/jmh-tcserver"
cookbook 'jmh-tomcat', path: "../cookbooks/jmh-tomcat"
cookbook 'jmh-utilities', path: "../cookbooks/jmh-utilities"
cookbook 'jmh-warehouse', path: "../cookbooks/jmh-warehouse"
cookbook 'jmh-webproxy', path: '../cookbooks/jmh-webproxy'
cookbook 'jmh-webserver', path: "../cookbooks/jmh-webserver"
