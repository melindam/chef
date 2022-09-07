
include_recipe "iis::default"
include_recipe "iis::mod_aspnet45"
include_recipe "iis::mod_cgi"
include_recipe "iis::mod_isapi"

windows_feature %w(IIS-NetFxExtensibility IIS-ASPNET) do
  all true
  action :install
end

include_recipe "iis_urlrewrite::default"

app_cmd = "#{node['iis']['home']}\\appcmd.exe"
netsh_cmd = "C:\\Windows\\system32\\netsh.exe"


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