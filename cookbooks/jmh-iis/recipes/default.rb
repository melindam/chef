#
# Cookbook Name:: jmh-iis
# Recipe:: default
#
# Copyright (C) 2013 Scott Marshall
#
# All rights reserved - Do Not Redistribute
#
include_recipe "iis"
#include_recipe "iis::mod_security"
include_recipe "iis::mod_auth_basic"
include_recipe "iis_urlrewrite::default"

app_cmd = "#{node['iis']['home']}\\appcmd.exe"
netsh_cmd = "#{node[:jmh_iis][:system32_dir]}\\netsh.exe"

batch "set basic authentication" do
  code <<-EOH
  #{app_cmd} set config /section:basicAuthentication /enabled:true
  #{app_cmd} set config /section:anonymousAuthentication /enabled:false
  EOH
end


firewall_ports = [ {'port' => 80, 'description' => "Open Port 80"},{'port' => 443, 'description' => "Open Port 443"} ]

firewall_ports.each do |portdef|
  batch "Configure Firewall Rule: #{portdef['description']}" do
     code <<-EOH
     #{netsh_cmd} advfirewall firewall add rule name="#{portdef['description']}" dir=in action=allow protocol=TCP localport=#{portdef['port']}
     EOH
     not_if do
       %x(#{netsh_cmd} advfirewall firewall show rule name="#{portdef['description']}").include?('Rule Name:')
     end
  end
end

# iis_site 'FooBar Site' do
#   # bindings "http/10.12.0.136:80:www.domain.com,https/*:443:www.domain.com"
#   bindings "http/*,"
#   path "#{node['iis']['docroot']}/testfu"
#   action [:add,:start]
# end

# user "test" do
#   password "tester"
#   action :create
# end
#
# group "Administrators" do
#   action :modify
#   members "test"
#   append true
# end
