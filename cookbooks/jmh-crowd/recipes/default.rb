directory node['jmh_crowd']['scratch_dir'] do
  action :create
end

jmh_java_install 'install java' do
  version node['jmh_crowd']['java']['version']
  action :install
end

#  Needed to install the nokogiri gem for libraries/crowd_parser.rb
build_essential 'crowd-build-essential' do
  action :install
end

%w(libxml2-devel patch).each do |pre_pkg|
  pkg = package pre_pkg do
    action :nothing
  end
  pkg.run_action(:install)
end
chef_gem 'nokogiri' do
  action :install
end

include_recipe 'jmh-crowd::install'

if node['jmh_crowd']['iptables']
  include_recipe 'iptables'
  iptables_rule 'crowd'
end
