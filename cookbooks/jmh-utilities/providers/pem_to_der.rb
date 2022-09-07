
action :create do
  key_value = ''
  if new_resource.secure_databag
    secure_databag_item = Chef::EncryptedDataBagItem.load(new_resource.databag_name, new_resource.databag_item)
    key_value = secure_databag_item[new_resource.databag_key_name]
  else
    db_item = data_bag_item(new_resource.databag_name, new_resource.databag_item)
    key_value = db_item[new_resource.databag_key_name]
  end

  Chef::Log.info("***** Path is #{new_resource.path}/#{new_resource.cert_name}.der*****")

  execute "Remove #{new_resource.cert_name}" do
    command "rm -f #{new_resource.cert_name}.pem"
    cwd new_resource.cache_path
    action :run
    not_if { ::File.exist?(::File.join(new_resource.path, "#{new_resource.cert_name}.der")) }
  end

  file ::File.join(new_resource.cache_path, "#{new_resource.cert_name}.pem") do
    content key_value
    owner new_resource.owner
    group new_resource.group
    mode 0600
    action :create
    notifies :run, "execute[convert_#{new_resource.cert_name}_to_der]", :immediately
  end

  pubin = new_resource.public_key ? '-pubin' : ''

  execute "convert_#{new_resource.cert_name}_to_der" do
    command "openssl rsa -in #{new_resource.cache_path}/#{new_resource.cert_name}.pem -inform pem #{pubin} -out #{new_resource.cert_name}.der -outform der"
    cwd new_resource.path
    action :nothing
  end

  execute "permissions_update_for_#{new_resource.cert_name}" do
    command "chown #{new_resource.owner}.#{new_resource.group} #{new_resource.cert_name}.der; chmod 600 #{new_resource.cert_name}.der"
    cwd new_resource.path
    action :run
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  file ::File.join(new_resource.path, "#{new_resource.cert_name}.der") do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end

action :update do
  jmh_utilities_pem_to_der new_resource.cert_name do
    path new_resource.path
    action :remove
  end

  jmh_utilities_pem_to_der new_resource.cert_name do
    path new_resource.path
    databag_name new_resource.databag_name
    databag_item new_resource.databag_item
    databag_key_name new_resource.databag_key_name
    secure_databag new_resource.secure_databag
    path new_resource.path
    public_key new_resource.public_key
    owner new_resource.owner
    group new_resource.group
    cache_path new_resource.cache_path
    action :remove
  end
  new_resource.updated_by_last_action(true)
end
