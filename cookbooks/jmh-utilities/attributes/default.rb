default['jmh_utilities']['www_prod_ip'] = '74.120.217.11'

default['jmh_utilities']['hostsfile']['front_end_search'] = 'recipes:jmh-cq\:\:dispatcher OR roles:cq-dispatcher'
default['jmh_utilities']['hostsfile']['local_recipe_check'] = 'jmh-cq::dispatcher'

default['jmh_utilities']['hostsfiles']['databag'] = 'hostsfile'
default['jmh_utilities']['hostsfiles']['databag_item_epic'] = 'epic_servers'

default['jmh_utilities']['aws_data_bag'] = ['credentials','aws']
default['jmh_utilities']['s3_download_deps'] = %w(make gcc gcc-c++)
default['jmh_utilities']['s3_gem_deps'] = [{ 'gem': 'mime-types', 'version': '2.99.2' },
                                           { 'gem': 'rest-client'}]

default['jmh_utilities']['crowd']['search_query'] = 'recipes:jmh-crowd\:\:default'
default['jmh_utilities']['crowd']['internal_domain'] = 'crowd.jmh.internal'


default['jmh_utilities']['profile']['search_query'] = 'recipes:jmh-myjmh\:\:profile OR roles:profile'
default['jmh_utilities']['profile']['internal_domain'] = 'profile.jmh.internal'
