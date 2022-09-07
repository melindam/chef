r = rpm_package 'Mysql Community' do
  source node['jmh_db']['mysql_7_repo']
  action :nothing
  only_if { node['platform_version'].start_with?('7.') }
end
r.run_action(:install)

node['jmh_db']['dependencies'].each do |pack|
  p = package "Install #{pack} for jmh-db" do
    package_name pack
    action :nothing
  end
  p.run_action(:install)
end

g = chef_gem 'mysql2' do
      action :nothing
end
g.run_action(:install)
