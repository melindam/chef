# Policyfile.rb - Describe how you want Chef to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'base'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'jmh-server::default'

# Specify a custom source for a single cookbook:
cookbook 'jmh-server', path: '../cookbooks/jmh-server'
cookbook "iptables", git: 'git@github.com:scottymarshall/iptables.git'
cookbook "timezone-ii", git: 'git@github.com:scottymarshall/timezone-ii.git'
cookbook "hostsfile", '2.4.3'

# Policy Attribute
default["jmh_server"]["environment"] = "dev"
default["jmh_server"]["global"]["crowd_chef_environment"] =  "awsdev2"
default["jmh_server"]["global"]["apache"]["www"]["server_name"]= "test-www.johnmuirhealth.com"
default["jmh_server"]["global"]["apache"]["idp"]["server_name"]= "test-idp.johnmuirhealth.com"
default["jmh_server"]["global"]["apache"]["prc"]["server_name"]= "test-prc.johnmuirhealth.com"
default["jmh_server"]["global"]["apache"]["jmhhr"]["server_name"]= "test-www.johnmuirhr.com"
default["jmh_server"]["global"]["apache"]["api"]["server_name"]= "test-api.johnmuirhealth.com"
default["jmh_server"]["global"]["jmh_epic"]["environment"]= "poc"
