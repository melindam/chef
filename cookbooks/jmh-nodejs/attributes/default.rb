default['jmh_nodejs']['default_version'] = '10'
default['jmh_nodejs']['version']['10']['download_url'] = 'https://nodejs.org/dist/v10.24.1/node-v10.24.1-linux-x64.tar.xz'
default['jmh_nodejs']['version']['14']['download_url'] = 'https://nodejs.org/dist/v14.17.6/node-v14.17.6-linux-x64.tar.xz'
default['jmh_nodejs']['version']['15']['download_url'] = 'https://nodejs.org/dist/v15.14.0/node-v15.14.0-linux-x64.tar.xz'

default['jmh_nodejs']['user'] = 'nodejs'
default['jmh_nodejs']['node_base_path'] = '/usr/local/nodejs'
default['jmh_nodejs']['webserver_path'] = '/usr/local/nodeapp'
default['jmh_nodejs']['bamboo_databag'] = ['credentials', 'bamboo']
default['jmh_nodejs']['executable_template_cookbook'] = 'jmh-nodejs'


default['jmh_nodejs']['ssl']['data_bag'] = 'apache_ssl'
default['jmh_nodejs']['ssl']['data_bag_item'] = 'johnmuirhealth_com_cert'
