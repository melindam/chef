# https://github.com/chef/chef-provisioning-docker

chef_gem "chef-provisioning-docker" do
  compile_time true
  action :install
end

# include_recipe 'docker'
docker_service 'default' do
  action [:create, :start]
end

# curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
# chmod +x /usr/local/bin/docker-machine

require 'chef/provisioning/docker_driver'
with_driver 'docker'

# machine_image 'baseserver' do
  # role 'base'
  # attribute 'fqdn', 'baseserver'
  # machine_options :docker_options => {
      # :base_image => {
          # :name => 'centos',
          # :repository => 'centos',
          # :tag => 'centos6'
      # }
  # }
# end

# machine "base-machine" do
  # role 'base' # Update local apt database
  # recipe 'jmh-myjmh:default'
  # chef_environment '_default_'
    # machine_options :docker_options => {
      # :base_image => {
        # :name => 'centos',
        # :repository => 'centos',
        # :tag => 'centos6'
      # },
      # :command => 'service sshd start'
    # }
 # end
# 

# docker_image 'centos' do
  # repo 'centos'
  # tag 'centos6'
  # action :pull
# end

# machine_image 'centos' do
  # # role 'base'
  # # recipe 'jmh-server::default'
  # # files '/etc/chef/encrypted_data_bag_secret' => '/tmp/kitchen/encrypted_data_bag_secret'
  # attribute 'fqdn', 'base-docker'
  # machine_options :docker_options => {
      # :base_image => {
          # :name => 'centos',
          # :repository => 'centos',
          # :tag => 'centos6'
      # },
      # :command => ["/usr/sbin/sshd", '-D'],
      # :ports => [22]      
    # }
# end
# 
# 
# machine 'basemachine' do
  # from_image 'centos'
  # role 'base'
  # attribute 'fqdn', 'basemachine-docker'
  # machine_options :docker_options => {
      # # :command => ["/usr/sbin/sshd", '-D'],
      # :ports => [22]
    # }
# end

machine_image 'base' do
  recipe 'jmh-server:default'
  # files '/etc/chef/encrypted_data_bag_secret' => '/tmp/kitchen/encrypted_data_bag_secret'
  attribute 'fqdn', 'base'
  machine_options :docker_options => {
      :base_image => {
          :name => 'centos',
          :repository => 'centos',
          :tag => 'centos6'
      }
    }
end


# machine 'basemachine' do
  # from_image 'base'
  # machine_options :docker_options => {
      # :command => ["/usr/sbin/sshd", '-D'],
      # :ports => [22]
    # }
# end
