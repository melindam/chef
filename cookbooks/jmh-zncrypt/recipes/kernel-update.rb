# If the kernel needs upgrading after initial install, update in default attributes  
# assemble the packages 
execute 'reboot' do
   action :nothing
end

needed_packages = %w{kernel-devel kernel-headers dkms}

needed_packages.each do |need_pack|
  yum_package need_pack do
    action :install
  end
end

update_package1 =  %w{kernel-devel kernel-headers}

update_package1.each do |update_pack|
  package update_pack do
    version node[:zncrypt][:kernel_version]
    action :upgrade
  end
end  
  
# ensure all kernels packages are at same level
update_package2 =  'kernel'

package update_package2 do
  version node[:zncrypt][:kernel_version]
  action :upgrade
  notifies :run, "execute[reboot]", :immediately
end 