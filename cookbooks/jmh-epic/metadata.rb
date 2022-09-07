name 'jmh-epic'
maintainer 'Scott Marshall'
maintainer_email 'scott.marshall@johmuirhealth.com'
license 'All Rights Reserved'
description 'This cookbook is used to control all things Epic for JMH'
long_description 'This cookbook is used to control all things Epic for JMH.  If you need to know something about an epic product, (i.e. the context of the mychart instance or its ip address) this cookbook will be the controller of this information.'
version '0.1.10'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'jmh-server'