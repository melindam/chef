default['jmh_myjmh']['myjmh_command']['ac_emails'] = 'cindy.chen@johnmuirhealth.com,tamara.shanker@johnmuirhealth.com,melinda.moran@johnmuirhealth.com'
default['jmh_myjmh']['myjmh_command']['java_version'] = '11'
default['jmh_myjmh']['myjmh_command']['properties_file'] = 'myjmh-command.properties'
default['jmh_myjmh']['myjmh_command']['install_dir'] = '/home/jmhbackup/bin'

# Takes the latest successful build from bamboo.
# *Need to make sure bamboo allows view rights to anonymous for the job*
default['jmh_myjmh']['myjmh_command']['download_url'] = "http://172.23.203.207:8085/bamboo/browse/JARS-MYJ/latestSuccessful/artifact/shared/myjmh-command/myjmh-command.jar"
# http://172.23.203.207:8085/bamboo/browse/JARS-MYJ-3/artifact/shared/myjmh-command/myjmh-command.jar
default['jmh_myjmh']['myjmh_command']['db_user'] = 'myjmhcommand_user'
default['jmh_myjmh']['myjmh_command']['db_hostname'] = '127.0.0.1'
default['jmh_myjmh']['myjmh_command']['db_connect_over_ssl'] = true
default['jmh_myjmh']['myjmh_command']['additional_properties'] = Array.new