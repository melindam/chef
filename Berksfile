# -*- ruby -*-
source "https://supermarket.chef.io"

group :community do
  cookbook 'apache2', '3.3.0'
  cookbook 'ark'
  cookbook 'chefdk'
  cookbook "chef-solo-search"
  cookbook "chef-client"
  cookbook 'chef_client_updater'
  cookbook "chef-splunk", '5.0.2'
  cookbook "chef-vault", '4.0.0'
  cookbook "cloudcli"
  cookbook "systemd"
  cookbook 'dm-crypt'
  cookbook 'docker', '~> 2.6.5'
  cookbook 'git'
  cookbook "hostsfile", '2.4.3'
  cookbook 'iis_urlrewrite'
  cookbook "jenkins"
  cookbook "logrotate", '1.9.0'
  cookbook 'sc-mongodb', '~> 3.0.0'
  cookbook "mysql_connector"
  cookbook "os-hardening", '~> 4.0'
  cookbook "ntp", '~> 1.5.0'
  cookbook "openldap"
  cookbook "php"
  cookbook "rabbitmq", '2.0.0'
  cookbook 's3_file', git: 'git@github.com:adamsb6/s3_file.git', :tag => 'v2.5.3'
  cookbook 'sensu-go', git: 'git@github.com:sensu/sensu-go-chef.git', :branch => 'release/1.0.0'
  cookbook "ssh_known_hosts"
  cookbook "subversion"
  cookbook "sudo"
  cookbook 'tar'
  cookbook 'uchiwa', '~> 1.2.0'
  cookbook "users"
  cookbook "vsftpd", '0.0.1'
  cookbook "webpi"
  cookbook "windows-hardening"
  cookbook "xml", '1.1.2'
  cookbook "xmledit"
end

group :scottymarshall do
  cookbook 'database', git: 'git@github.com:scottymarshall/database.git'
  cookbook "iptables", git: 'git@github.com:scottymarshall/iptables.git'
  cookbook 'mysql', git: 'git@github.com:scottymarshall/mysql.git', branch: 'chef13_changes'
  cookbook 'pingfederate', git: 'git@github.com:scottymarshall/pingfederate.git', branch: 'java_removal'
  cookbook "postfix",  git: 'git@github.com:scottymarshall/postfix.git'
  cookbook 'selinux', git: 'git@github.com:scottymarshall/selinux.git'
  cookbook 'sensu', git: 'git@github.com:scottymarshall/sensu-chef.git', branch: 'chef14fix'
  cookbook 'sonarqube', git: 'git@github.com:scottymarshall/sonarqube.git', branch: 'sonar7.0'
  cookbook "timezone-ii", git: 'git@github.com:scottymarshall/timezone-ii.git'
end

group :melindam do
  cookbook 'activemq', git: 'git@github.com:melindam/activemq.git'
  cookbook 'ecryptfs', git: 'git@github.com:melindam/ecryptfs.git'
end

# can't use github: source method with private repos
group :jmh do
  cookbook 'jmh-apps', path: "./cookbooks/jmh-apps"
  cookbook 'jmh-archiva', path: "./cookbooks/jmh-archiva"
  cookbook 'jmh-bamboo', path: "./cookbooks/jmh-bamboo"
  cookbook 'jmh-billpay', path: './cookbooks/jmh-billpay'
  cookbook 'jmh-epic', path: './cookbooks/jmh-epic'
  cookbook 'jmh-events', path: './cookbooks/jmh-events'
  cookbook 'jmh-ci', path: './cookbooks/jmh-ci'
  cookbook 'jmh-cq', path: './cookbooks/jmh-cq'
  cookbook 'jmh-crowd', path: './cookbooks/jmh-crowd'
  cookbook 'jmh-db', path: './cookbooks/jmh-db'
  cookbook 'jmh-docker', path: './cookbooks/jmh-docker'
  cookbook 'jmh-encrypt', path: './cookbooks/jmh-encrypt'
  cookbook 'jmh-idev', path: './cookbooks/jmh-idev'
  cookbook 'jmh-iis', path: './cookbooks/jmh-iis'
  cookbook 'jmh-fad', path: './cookbooks/jmh-fad'
  cookbook 'jmh-java', path: './cookbooks/jmh-java'
  cookbook 'jmh-monitor', path: "./cookbooks/jmh-monitor"
  cookbook 'jmh-mongodb', path: "./cookbooks/jmh-mongodb"
  cookbook 'jmh-myjmh', path: './cookbooks/jmh-myjmh'
  cookbook 'jmh-mule', path: './cookbooks/jmh-mule'
  cookbook 'jmh-nodejs', path: './cookbooks/jmh-nodejs'
  cookbook 'jmh-operations', path: "./cookbooks/jmh-operations"
  cookbook 'jmh-paygateway', path: "./cookbooks/jmh-paygateway"
  cookbook 'jmh-pingfed', path: './cookbooks/jmh-pingfed'
  cookbook 'jmh-prereg', path: './cookbooks/jmh-prereg'
  cookbook 'jmh-rundeck', path: "./cookbooks/jmh-rundeck"
  cookbook 'jmh-server', path: "./cookbooks/jmh-server"
  cookbook 'jmh-sched', path: "./cookbooks/jmh-sched"
  cookbook 'jmh-splunk', path: "./cookbooks/jmh-splunk"
  cookbook 'jmh-tcserver', path: "./cookbooks/jmh-tcserver"
  cookbook 'jmh-tomcat', path: "./cookbooks/jmh-tomcat"
  cookbook 'jmh-utilities', path: "./cookbooks/jmh-utilities"
  cookbook 'jmh-vvisits', path: "./cookbooks/jmh-vvisits"
  cookbook 'jmh-warehouse', path: "./cookbooks/jmh-warehouse"
  cookbook 'jmh-webproxy', path: './cookbooks/jmh-webproxy'
  cookbook 'jmh-webserver', path: "./cookbooks/jmh-webserver"
  cookbook 'jmh-infosec', path: "./cookbooks/jmh-infosec"
end
