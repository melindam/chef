# https://wiki.centos.org/TipsAndTricks/WindowsShares
# %w(samba-client samba-common cifs-utils davfs2 rsync).each do |w_package|
%w(samba-client samba-common cifs-utils rsync).each do |w_package|
  package w_package do
    action :install
  end
end

archcorp_dir = '/archcorp'
ebizarch_dir = '/ebizarch'

directory archcorp_dir do
  action :create
end

directory ebizarch_dir do
  action :create
end
# \\winbox\getme /mnt/win cifs user,uid=500,rw,suid,username=sushi,password=yummy 0 0

# http://www.rubydoc.info/gems/chef/Chef/Util/FileEdit
ruby_block 'update fstab archcorp' do
  block do
    f=Chef::Util::FileEdit.new("/etc/fstab")
    f.insert_line_if_no_match(/.*ebiz-.*/,
                               "\\\\ebiz-archcorp.hsys.local\\Marketing #{archcorp_dir} cifs user,rw,credentials=/root/secret.txt 0 0")
    f.write_file
  end
end

ruby_block 'update fstab ebizarch' do
  block do
    f=Chef::Util::FileEdit.new("/etc/fstab")
    f.insert_line_if_no_match(/.*hsysnas1.*/,
                              "\\\\hsysnas1\\EBIZARCH #{ebizarch_dir} cifs user,rw,credentials=/root/secret.txt 0 0")
    f.write_file
  end
end

file '/root/secret.txt' do
  content "username=\npassword=\n"
  mode 0600
  action :create_if_missing
end

# rsync -vzr --size-only /archcorp/ /ebizarch/ > rsysnc.log &
# rsync -nvzr --size-only /archcorp/ /box/ebiz-archcorp/marketing/