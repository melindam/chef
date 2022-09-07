name 'jmh-mule'
maintainer 'Melinda Moran'
maintainer_email 'melinda.moran@johnmuirhealth.com'
license 'AGPL'
description 'Installs/Configures jmh tomcat7 binary distribution'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'

recipe 'jmh-mulesoft', 'Installs and configures JMH Mulesoft EE'

depends 'ark'
depends 'iptables'
depends 'jmh-java'
depends 'jmh-tomcat'

%w(centos redhat).each do |os|
  supports os
end
