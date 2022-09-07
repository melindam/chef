# Creates the custom phone book for testing
phonebook_list = Hash.new
# env_list = Array.new

if node['jmh_webserver']['customphonebook']['install']
  search(:node, "recipes:jmh-webserver\\:\\:mychart_proxy") do |n|
    next unless !phonebook_list.keys.include?(n.environment)
    phonebook_list[n.environment] =  { "env": n['jmh_epic']['environment'],
                                       "mcminterconnect_context": JmhEpic.get_specific_epic_config(n['jmh_epic']['environment'],node)['mychart']['mcm_context'],
                                       "webserver": n['jmh_server']['global']['apache']['www']['server_name'],
                                       "apiserver": n['jmh_server']['global']['apache']['api']['server_name'],
                                       "idpserver": n['jmh_server']['global']['apache']['idp']['server_name']
                                        }
  end
end

template File.join(Chef::Config[:file_cache_path], node['jmh_webserver']['customphonebook']['filename'] ) do
  source 'customphonebook_xml.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode '0755'
  action node['jmh_webserver']['customphonebook']['install'] ? :create : :delete
  variables(
    phonebook_hash: phonebook_list
  )
  action node['jmh_webserver']['customphonebook']['install'] ? :create : :delete
  notifies :run, "execute[Create UTF-16 file for phone book]", :immediately
end

execute "Create UTF-16 file for phone book" do
  command "iconv -f ASCII -t UTF-16 #{File.join(Chef::Config[:file_cache_path], node['jmh_webserver']['customphonebook']['filename'] )} " +
              " -o #{File.join(node['jmh_webserver']['customphonebook']['directory'],node['jmh_webserver']['customphonebook']['filename'])}"
  action :nothing
  only_if { node['jmh_webserver']['customphonebook']['install'] }
end

file File.join(node['jmh_webserver']['customphonebook']['directory'],node['jmh_webserver']['customphonebook']['filename']) do
  action :delete
  not_if { node['jmh_webserver']['customphonebook']['install'] }
end