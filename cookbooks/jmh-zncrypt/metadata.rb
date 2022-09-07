name "jmh-zncrypt"
maintainer       "Gazzang, Inc. - JMH"
maintainer_email "eddie.garcia@gazzang.com"
license          "Apache 2.0"
description      "Installs/Configures zNcrypt 3.3"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.2"
%w{ apt yum openssl java }.each do |cb|
  depends cb
end
%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

recipe "jmh-zncrypt::default", "Installs and configures zNcrypt"
recipe "jmh-zncrypt::cassandra", "Installs and configures DataStax Cassandra"
recipe "jmh-zncrypt::mongodb", "Installs and configures MongoDB"
recipe "jmh-zncrypt::configdirs", "Sets up storage directories"
recipe "jmh-zncrypt::cronjob", "Sets up a backup cron job for /etc/zncrypt data"
recipe "jmh-zncrypt::encrypt_mysql", "Encrypts a list of DB provided in the role"
