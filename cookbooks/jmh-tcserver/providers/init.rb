def load_current_resource
  unless(new_resource.path)
    new_resource.path ::File.join('/etc/init.d', new_resource.name)
  end
end

action :create do
  
  unless(node[:jmh_tcserver][:enabled_apps].include?(new_resource.name))
    node[:jmh_tcserver][:enabled_apps].push(new_resource.name)
  end

  template new_resource.path do
    source 'single.init.erb'
    cookbook 'jmh-tcserver'
    variables(
      :app => new_resource.name,
      :app_dir => node[:jmh_tcserver][:install_dir],
      :user => node[:jmh_tcserver][:user],
      :base_script => ::File.join(node[:jmh_tcserver][:install_dir], 'tcruntime-ctl.sh'),
      :el => node.platform_family == 'rhel'
    )
    mode 0755
  end

  service new_resource.name do
    action [:enable, :start]
  end
end

action :delete do
  service new_resource.name do
    [:stop, :disable]
  end
  file new_resource.path do
    action :delete
  end
end
