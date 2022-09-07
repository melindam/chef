# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'events'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'jmh-events::default'

include_policy 'base', policy_name: "base", server: 'https://api.opscode.com/organizations/jmhebiz'

# Specify a custom source for a single cookbook:
cookbook 'apache2', '3.3.0'
cookbook 'database',git: 'git@github.com:scottymarshall/database.git'
cookbook 'jmh-apps', path: '../cookbooks/jmh-apps'
cookbook 'jmh-crowd', path: '../cookbooks/jmh-crowd'
cookbook 'jmh-db', path: '../cookbooks/jmh-db'
cookbook 'jmh-encrypt', path: '../cookbooks/jmh-encrypt'
cookbook 'jmh-epic', path: '../cookbooks/jmh-epic'
cookbook 'jmh-events', path: '../cookbooks/jmh-events'
cookbook 'jmh-pingfed', path: '../cookbooks/jmh-pingfed'
cookbook 'jmh-java', path: '../cookbooks/jmh-java'
cookbook 'jmh-tomcat', path: '../cookbooks/jmh-tomcat'
cookbook 'jmh-utilities', path: '../cookbooks/jmh-utilities'
cookbook 'jmh-webserver', path: '../cookbooks/jmh-webserver'
cookbook 'mysql', git: 'git@github.com:scottymarshall/mysql.git', branch: 'chef13_changes'
cookbook 'openssl'
cookbook 'pingfederate', git: 'git@github.com:scottymarshall/pingfederate.git', branch: 'cluster-capable'
