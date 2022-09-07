name 'jmh-tomcat'
maintainer 'Melinda Moran'
maintainer_email 'melinda.moran@johnmuirhealth.com'
license 'AGPL'
description 'Installs/Configures jmh tomcat binary distribution'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.6.11'

recipe 'jmh-tomcat', 'Installs and configures JMH Tomcat7'

depends 'ark'
depends 'iptables'
depends 'jmh-encrypt'
depends 'jmh-java'
depends 'jmh-utilities'
depends 'logrotate'
depends 'mysql_connector'
depends 'systemd'
depends 'tar'

%w(centos redhat).each do |os|
  supports os
end
