include_recipe 'apache2'
# https://bitbucket.org/atlassian/cwdapache
# https://bitbucket.org/adamansky/cwdapache - Used to make 2.4

mod_crowd_so = case
               when node['kernel']['machine'] == 'i686'
                 'mod_authnz_crowd_i686.so'
               when File.exist?('/usr/lib64/libcurl.so.3')
                 'mod_authnz_crowd_x86_64.so'
               else
                 'mod_authnz_crowd_x86_64.RHEL6.so'
end

jmh_utilities_s3_download File.join(node['apache']['lib_dir'], 'modules', 'mod_authnz_crowd.so') do
  remote_path "crowd/#{mod_crowd_so}"
  bucket 'jmhapps'
  owner 'root'
  group 'root'
  mode '0544'
  action :create
  notifies :restart, 'service[apache2]', :delayed
  not_if { node['apache']['version'] == '2.4' }
end

cookbook_file File.join(node['apache']['lib_dir'], 'modules', 'mod_authnz_crowd.so') do
  source "mod_authnz_crowd.so"
  owner "root"
  group "root"
  mode "0544"
  action :create
  notifies :restart, 'service[apache2]', :delayed
  only_if { node['apache']['version'] == '2.4' }
end

apache_module 'authnz_crowd' do
  enable true
  conf false
  notifies :restart, 'service[apache2]', :delayed
end
