#!/usr/bin/env ruby
require 'json'

username='admin'
admin_password= 'admin2'
new_password= 'admin3'

url='http://localhost:4502'

output = %x(curl -s -u admin:#{admin_password} -X GET "#{url}/bin/querybuilder.json?path=/home/users&1_property=rep:authorizableId&1_property.value=#{username}&p.limit=-1")
puts output

output_hash = JSON.load(output)
hits_hash = output_hash['hits'][0] 

puts hits_hash['path']

change_password_output = %x(curl -s -u admin:#{admin_password} -Fplain=#{new_password} -Fverify=#{new_password} -Fold=#{admin_password} -FPath=#{hits_hash['path']} #{url}/crx/explorer/ui/setpassword.jsp)
# curl -s -u admin:admin -Fplain={NEW_PASSWORD} -Fverify={NEW_PASSWORD}  -Fold={OLD_PASSWORD} -FPath=$USER_PATH http://localhost:4502/crx/explorer/ui/setpassword.jsp
puts change_password_output
