# Chrome repo broken as of 05-2021
# lighthouse might not work if a new server install, as it might rely on chrome being installed first.
# yum_repository 'rhel-7-server-optional-rpms' do
#   metadata_expire "86400"
#   sslclientcert "/etc/pki/entitlement/5474256235863057581.pem"
#   baseurl "https://cdn.redhat.com/content/dist/rhel/server/7/$releasever/$basearch/optional/os"
#   sslverify true
#   sslclientkey "/etc/pki/entitlement/5474256235863057581-key.pem"
#   gpgkey "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release"
#   enabled true
#   sslcacert "/etc/rhsm/ca/redhat-uep.pem"
#   gpgcheck true
# end

# yum_repository 'google-chrome' do
#   description "google-chrome - $basearch"
#   baseurl "http://dl.google.com/linux/chrome/rpm/stable/x86_64"
#   gpgcheck true
#   gpgkey "https://dl-ssl.google.com/linux/linux_signing_key.pub"
#   action :create
# end

# %w(bc cups-client liberation-fonts-common liberation-fonts google-chrome-stable).each do |pkgname|
#     yum_package pkgname do
#       package_name pkgname
#       options "-y --skip-broken"
#       action :install
#     end
# end

include_recipe 'jmh-bamboo::nodejs'

nodejs_path = JmhNodejsUtil.get_nodejs_home(node['jmh_bamboo']['current_nodejs_version'], node)
npm_cmd = File.join(nodejs_path, 'bin/npm')

# now install lighthouse from npm install command
execute 'install lighthouse' do
  command "#{npm_cmd} install -g lighthouse"
  action :run
  not_if { ::File.exist?(File.join(nodejs_path, 'bin/lighthouse')) }
end

# now install lighthouse-graphite from npm install command
execute 'install lighthouse graphite' do
  command "#{npm_cmd} install -g lighthouse-graphite"
  action :run
  not_if { ::File.exist?(File.join(nodejs_path, 'bin/lighthouse-graphite')) }
end

template '/home/bamboo/bin/lighthouse_report.sh' do
  source 'lighthouse_reports.sh.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  variables(
    :lighthouse_paths => node['jmh_bamboo']['lighthouse_paths'],
    :nodejs_path => nodejs_path
  )
  action :create
end

search(:node, node['jmh_bamboo']['graphite_server_query']) do |n|
  node.default['jmh_bamboo']['graphite_srv'] = n['ipaddress']
end

template '/home/bamboo/bin/lighthouse_graphite.sh' do
  source 'lighthouse_graphite.sh.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  variables(
      :graphite_server => node['jmh_bamboo']['graphite_srv'],
      :lighthouse_paths => node['jmh_bamboo']['lighthouse_paths'],
      :lighthouse_report_dir => node['jmh_bamboo']['lighthouse_report_dir'],
      :nodejs_path => nodejs_path
  )
  action :create
end

%w(/var/www /var/www/html).each do |dir|
  directory dir do
    mode 0755
    action :create
  end
end

directory node['jmh_bamboo']['lighthouse_report_dir'] do
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
  action :create
end

# add local IP to /etc/hosts for each AWS dev environment
search(:node, node['jmh_bamboo']['dev_www_search_recipe']) do |n|
  next unless node['jmh_bamboo']['lighthouse_env'].include?(n.environment)
  found_server = {}
  found_server['name'] = n.name
  found_server['ipaddress'] = n['ipaddress']
  found_server['www_hostname'] = found_server['name'].gsub(/^.*-/ , 'www-') + '.johnmuirhealth.com'

  hostsfile_entry found_server['ipaddress'] do
    hostname found_server['www_hostname']
    unique true
    action :create
  end
end

cron 'bamboo_lighthouse' do
  action :create
  minute '15'
  hour '8'
  user 'bamboo'
  command '/home/bamboo/bin/lighthouse_graphite.sh'
end

