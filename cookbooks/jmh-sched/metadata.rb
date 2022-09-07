name 'jmh-sched'
maintainer 'John Muir Health EBusiness'
maintainer_email 'scott.marshall@johnmuirhealth.com'
license 'All Rights Reserved'
description 'Installs/Configures jmh-sched'
long_description 'Installs/Configures jmh-sched'
chef_version '>= 12.14' if respond_to?(:chef_version)
issues_url 'https://github.com/JohnMuirHealth/chef-repo/issues'
source_url 'https://github.com/JohnMuirHealth/chef-repo/'
version '0.1.11'

supports 'centos'

depends 'jmh-epic'
depends 'jmh-server'
depends 'jmh-tomcat'
depends 'jmh-utilities'
