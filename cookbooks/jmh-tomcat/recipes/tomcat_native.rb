%w(apr tomcat-native).each do |pn|
  package pn do
    action :install
  end
end
