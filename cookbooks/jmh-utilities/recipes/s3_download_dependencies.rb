
node['jmh_utilities']['s3_download_deps'].each do |p|
  d = package p do
    action :nothing
  end
  d.run_action(:install)
end

node['jmh_utilities']['s3_gem_deps'].each do |p|
  chef_gem p['gem'] do
    version p['version'] if p['version']
    action :install
  end
end
