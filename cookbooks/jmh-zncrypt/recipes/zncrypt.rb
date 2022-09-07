
# zNcrypt requires dkms to dynamically compile the zNcrypt kernel nodule
# in most distributions the package is included in the repo
# on CentOS it may need to be preinstalled, we will use RPM forge
include_recipe "yum::yum"

package 'wget' do
  action :install
end

 # use the yum cookbook to add the RPM-GPG-KEY
yum_key "RPM-GPG-KEY.dag.txt" do
  url "http://apt.sw.be/RPM-GPG-KEY.dag.txt"
  action :add
end
  
 # there may be a better way to install using yum_repository,  but this works

bash "install epel rpm" do
  user "root"
  cwd "/usr/local/src"
  code <<-EOH
    wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    rpm -Uvh --force epel-release-6-8.noarch.rpm
  EOH
  not_if { ::File.exists?("/usr/local/src/epel-release-6-8.noarch.rpm") }
end


# Add the Gazzang GPG key and repo
yum_key "RPM-GPG-KEY-gazzang" do
  url "https://archive.gazzang.com/gpg_gazzang.asc"
  action :add
end
yum_repository "gazzang" do
  repo_name "gazzang"
  description "RHEL or CentOS $releasever - gazzang.com - base"
  url "https://archive.gazzang.com/redhat/stable/$releasever"
  key "RPM-GPG-KEY-gazzang"
  action :add
end
  
# install the packages for Zncrypt
zncrypt_packages = %w{haveged zncrypt}

zncrypt_packages.each do |zncrypt_pack|
  package zncrypt_pack do
    action :install
  end
end  

# service for haveged needs to be started
service "haveged" do
  action [:enable, :start]
end
