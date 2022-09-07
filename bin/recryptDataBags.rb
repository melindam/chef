#!/usr/bin/env ruby

require 'chef/encrypted_data_bag_item'
require 'json'

old_secret = '.secret'
new_secret_file = '.new_secret'

new_secret = Chef::EncryptedDataBagItem.load_secret(new_secret_file)

Dir.glob('data_bags/**/*.json').each do|f|
  puts f
  file_array = f.to_s.split('/')
  databag = file_array[1]
  databagitem = File.basename(f,File.extname(f))
  if File.readlines(f).grep(/encrypted_data/).size > 0
    puts ("#{databag} #{databagitem}")
    puts "**Encrypted File....Now Recrypting"
    # Decrypt the local databag
    `knife data bag show #{databag} #{databagitem} -z --secret-file #{old_secret} -F json > data_bags/#{databag}/#{databagitem}.tmp `
    plain_data = JSON.parse(File.read("data_bags/#{databag}/#{databagitem}.tmp" ))
    encrypted_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item(plain_data, new_secret)
    # Overwrite the local databag with the new encryption
    File.write "data_bags/#{databag}/#{databagitem}.json", JSON.pretty_generate(encrypted_data)
    # Remove the tmp file
    `rm -f data_bags/#{databag}/#{databagitem}.tmp `
    puts "** done"
  end
end


