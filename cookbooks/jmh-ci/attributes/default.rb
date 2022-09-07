default['chefdk']['version'] = '4.7.113'

default['jmh-ci']['chefdk_path'] = '/opt/chefdk'
default['jmh-ci']['chrome_path'] = '/opt/google/chrome'
default['jmh-ci']['jenkins']['credentials_data_bag'] = ['credentials', 'bamboo']
default['jmh-ci']['jenkins']['ebusiness_data_bag'] = ['credentials','ebusiness']
default['jmh-ci']['jenkins']['aws_data_bag'] = ['credentials','aws']
default['jmh-ci']['jenkins']['secret_file'] = node['test_run'] ? '/tmp/kitchen/encrypted_data_bag_secret' : '/etc/chef/encrypted_data_bag_secret'
default['jmh-ci']['jenkins']['java_version'] = '8'
# TODO figure out how to install once credentials are in place
default['jmh-ci']['jenkins']['plugins'] = []
# These plugins need to be installed, but manually
# licon-shim periodicbackup build-timeout dap pipeline credentials post+build+task email-ext role-strategy git naginator powershell

default['jenkins']['master']['jenkins_args']= ' --prefix=/jenkins '
default['jenkins']['master']['port'] = '8080'
default['jenkins']['master']['endpoint'] = 'http://localhost:8080/jenkins'
