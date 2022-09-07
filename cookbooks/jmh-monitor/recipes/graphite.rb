
#https://www.vultr.com/docs/how-to-install-and-configure-graphite-on-centos-7

node.default['jmh_webserver']['listen'] = [80]
include_recipe 'jmh-webserver'

%w(python-django16-bash-completion python2-django16).each do |pack|
  package pack
end


%w(graphite-web python-carbon).each do |pack|
  package pack
end

service "carbon-cache" do
  action [:enable, :start]
end

template "/etc/carbon/storage-schemas.conf" do
  source 'graphite/storage-schemas_conf.erb'
  action :create
  notifies :restart, "service[carbon-cache]", :delayed
end

execute "Sync the Carbon Database" do
  command "PYTHONPATH=/usr/share/graphite/webapp django-admin syncdb --settings=graphite.settings --noinput"
  action :run
end

execute "Chown the db" do
  command "chown apache:apache /var/lib/graphite-web/graphite.db"
  action :run
end

template '/etc/graphite-web/localsettings.py' do
  source 'graphite/local_settings_py.erb'
  action :create
  variables(
    secret_key: "secret"
  )
end

apache_module 'wsgi' do
  enable true
  cookbook 'jmh-webserver'
  conf false
  notifies :restart, 'service[apache2]', :delayed
end

jmh_webserver 'graphite' do
  doc_root node['jmh_monitor']['graphite']['http']['docroot']
  apache_config node['jmh_monitor']['graphite']['http']
  cookbook 'jmh-monitor'
  additional_modules ['mod_wsgi']
end

iptables_rule "bamboo_graphite" do
  action :enable
end