use_inline_resources

action :install do
  asset_name = new_resource.asset_name
  username = new_resource.username
  password = new_resource.password
  local_asset_path = ::File.join(new_resource.local_package_location, asset_name)

  if CQ.uploaded?(asset_name,
                  new_resource.port,
                  username, password,
                  new_resource.package_location)
    Chef::Log.info "AEM asset is already uploaded (#{asset_name}). Skipping."
  else
    ruby_block "Uploading common asset #{asset_name} into AEM" do
      block do
        path = CQ.upload_and_install(local_asset_path,
                         new_resource.port,
                         username, password)
        Chef::Log.warn "AEM asset installed (#{asset_name}). Will now wait #{new_resource.delay} seconds."
        Chef::Log.warn "And Restart" if new_resource.restart_aem
        sleep(new_resource.delay)
      end
      notifies new_resource.restart_aem ? :restart : :nothing, "service[cq-#{new_resource.key}]", :immediately
      notifies new_resource.restart_aem ? :run : :nothing, 'execute[Fresh_AEM_JAR_Wait_300]', :immediately
    end
  end
end
