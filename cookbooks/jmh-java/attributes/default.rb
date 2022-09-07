default['jmh_java']['arch'] = 'x86_64'
default['jmh_java']['install_dir'] = '/usr/lib/jvm'

default['jmh_java']['java_hash']['jdk1.7.0_75']['x86_64']['url'] = 'https://s3-us-west-1.amazonaws.com/jmhpublic/java/jdk-7u75-linux-x64.tar.gz'
default['jmh_java']['java_hash']['jdk1.7.0_75']['x86_64']['checksum'] = '460959219b534dc23e34d77abc306e180b364069b9fc2b2265d964fa2c281610'

# still used by bamboo server 
default['jmh_java']['java_hash']['jdk1.8.0_241']['x86_64']['url'] = 'https://s3-us-west-1.amazonaws.com/jmhpublic/java/jdk-8u241-linux-x64.tar.gz'
default['jmh_java']['java_hash']['jdk1.8.0_241']['x86_64']['checksum'] = '419d32677855f676076a25aed58e79432969142bbd778ff8eb57cb618c69e8cb'

default['jmh_java']['java_hash']['jdk1.8.0_281']['x86_64']['url'] = 'https://s3-us-west-1.amazonaws.com/jmhpublic/java/jdk-8u281-linux-x64.tar.gz'
default['jmh_java']['java_hash']['jdk1.8.0_281']['x86_64']['checksum'] = '85e8c7da7248c7450fb105567a78841d0973597850776c24a527feb02ef3e586'

default['jmh_java']['java_hash']['jdk-11.0.10']['x86_64']['url'] = 'https://jmhpublic.s3-us-west-1.amazonaws.com/java/jdk-11.0.10_linux-x64_bin.tar.gz'
default['jmh_java']['java_hash']['jdk-11.0.10']['x86_64']['checksum'] = '94bd34f85ee38d3ef59e5289ec7450b9443b924c55625661fffe66b03f2c8de2'

default['jmh_java']['java_hash']['jdk-15.0.2']['x86_64']['url'] = 'https://s3-us-west-1.amazonaws.com/jmhpublic/java/jdk-15.0.2_linux-x64_bin.tar.gz'
default['jmh_java']['java_hash']['jdk-15.0.2']['x86_64']['checksum'] = '54b29a3756671fcb4b6116931e03e86645632ec39361bc16ad1aaa67332c7c61'

# openssl dgst -sha256 /full/path/to/file

default['jmh_java']['jdk']['7']['version'] = 'jdk1.7.0_75'
default['jmh_java']['jdk']['8']['version'] = 'jdk1.8.0_281'
default['jmh_java']['jdk']['11']['version'] = 'jdk-11.0.10'
default['jmh_java']['jdk']['15']['version'] = 'jdk-15.0.2'

# Default java home.
default['java']['java_home'] = File.join( node['jmh_java']['install_dir'],node['jmh_java']['jdk']['8']['version'])

default['jmh_java']['java_security']['databag'] = 'java_security'
default['jmh_java']['java_security']['jmh_cert_databag_item'] = 'jmh_certs'
default['jmh_java']['java_security']['jdk_cert_databag_item'] = 'jdk'

default['jmh_java']['java_security']['certs'] = [{ 'name' => 'johnmuirhealth-com',
                                                   'type' => 'databag',
                                                   'databag_folder' => 'apache_ssl',
                                                   'databag_file' => 'johnmuirhealth_com_cert',
                                                   'databag_item' => 'pem' },
                                                 { 'name' => 'jmh_internal',
                                                   'type' => 'databag',
                                                   'databag_folder' => 'apache_ssl',
                                                   'databag_file' => 'jmh_internal_cert',
                                                   'databag_item' => 'pem'
                                                 }]
default['jmh_java']['java_security']['storepass'] = 'changeit'