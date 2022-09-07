# Installs required dependencies for CQ instances to run
jmh_java_install 'install java' do
  version node['cq']['java_version']
  action :install
end

node['cq']['default_packages'].each do |pre_pkg|
  pkg = package pre_pkg do
    action :nothing
  end
  pkg.run_action(:install)
end

# TODO: would be go to put this into the default attributes
chef_gem 'multipart-post' do
  compile_time false
  action :install
end
