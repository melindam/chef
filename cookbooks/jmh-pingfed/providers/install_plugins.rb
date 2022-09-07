use_inline_resources

action :install do

  # TODO this does not restart pingfed if the jar file is just updated, and not a new file?
  new_resource.plugin_array.each do |jarname|
    # Source for JAR in pingfed-plugins repository
    cookbook_file ::File.join(new_resource.install_path, '/server/default/deploy/', jarname) do
      source "pingfederate/#{jarname}"
      owner node['pingfed']['user']
      group node['pingfed']['user']
      mode '0644'
      action :create
      notifies :restart, "service[#{new_resource.resource_service}]", :delayed
    end
  end

end