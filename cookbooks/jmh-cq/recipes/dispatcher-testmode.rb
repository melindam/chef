
# Set the cache to not cache any pages
node.default['cq']['dispatcher']['any']['farms']['website']['cache']['rules']['0000']['type'] = 'deny'

# Point to the developer instance of publisher
node.default['cq']['dispatcher']['publisher_list'] = [{ 'name' => 'poc_instance',
                                                        'ipaddress' => 'ec2-13-56-168-21.us-west-1.compute.amazonaws.com',
                                                        'port' => '4503' }]

# Make the name of the server 'test-' plus the ip of the box
node.default['cq']['dispatcher']['www']['server_name'] = 'test-www.' + node['cq']['dispatcher']['domain_maps']['base_domain']
node.default['cq']['dispatcher']['prc']['common_http']['server_name'] = 'test-prc.' + node['cq']['dispatcher']['domain_maps']['base_domain']

include_recipe 'jmh-cq::dispatcher'
include_recipe 'jmh-cq::dispatcher-prc'
