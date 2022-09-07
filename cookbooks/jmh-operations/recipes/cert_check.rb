include_recipe 'jmh-utilities::hostsfile_epic_servers'


hostitem = data_bag_item(node['jmh_utilities']['hostsfiles']['databag'],
                         node['jmh_utilities']['hostsfiles']['databag_item_epic'])

java_versions = node['jmh_java']['jdk'].keys
java_bins = Array.new

node['jmh_operations']['cert_check']['jdk_ignore_list'].each do |jv|
  java_versions.delete(jv)
end

java_versions.each do |jvm_version|
  jmh_java_install "install java #{jvm_version} for cert test" do
    version jvm_version
    action :install
  end
  java_bins.push(JmhJavaUtil.get_java_home(jvm_version,node))
end

sslpoke = File.join(node['jmh_server']['backup']['home'],'bin','SSLPoke.class')

cookbook_file sslpoke do
  source 'java/SSLPoke.class'
  owner node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode 0755
end

host_checklist = Array.new
hostitem['hosts'].each_key do | host|
  host_checklist.push(host)
  host_checklist.push(hostitem['hosts'][host]['ip'])
  if hostitem['hosts'][host]['alias']
    hostitem['hosts'][host]['alias'].each do |aliases|
      host_checklist.push(aliases)
    end
  end
end

template File.join(node['jmh_server']['backup']['home'],'bin', 'check_certs.sh') do
  source 'check_cert_sh.erb'
  owner node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode 0755
  variables(
    epic_hosts: host_checklist,
    bin_dir: File.join(node['jmh_server']['backup']['home'],'bin'),
    sslpoke_classfile: 'SSLPoke',
    java_bins: java_bins
  )
end