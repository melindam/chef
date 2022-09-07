
action :create do
  aws_creds = Chef::EncryptedDataBagItem.load(node['jmh_utilities']['aws_data_bag'][0], node['jmh_utilities']['aws_data_bag'][1])

  @run_context.include_recipe 'jmh-utilities::s3_download_dependencies'

  s3_file new_resource.name do
    remote_path new_resource.remote_path
    bucket new_resource.bucket
    aws_access_key_id aws_creds['iam']['chef']['access_key']
    aws_secret_access_key aws_creds['iam']['chef']['secret_key']
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    decryption_key new_resource.decryption_key
    decrypted_file_checksum new_resource.decrypted_file_checksum

    action :create
    not_if { ::File.exist?(new_resource.name) }
  end
end

action :update do
  aws_creds = Chef::EncryptedDataBagItem.load(node['jmh_utilities']['aws_data_bag'][0], node['jmh_utilities']['aws_data_bag'][1])

  @run_context.include_recipe 'jmh-utilities::s3_download_dependencies'

  s3_file new_resource.name do
    remote_path new_resource.remote_path
    bucket new_resource.bucket
    aws_access_key_id aws_creds['iam']['chef']['access_key']
    aws_secret_access_key aws_creds['iam']['chef']['secret_key']
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    decryption_key new_resource.decryption_key
    decrypted_file_checksum new_resource.decrypted_file_checksum

    action :create
  end
  new_resource.updated_by_last_action(true)
end
