## DEPRECIATED ##

# Deploys a JMH java application

# define :jmh_app_java, :database => nil, :web_app => nil, :config => {} do
# 
  # # Configure java attributes before including so we get the proper
  # # java installed
#   
  # params[:config] = {} unless params[:config]
#   
  # Chef::Log.info("database is #{params[:database]}")
  # Chef::Log.info("webapp is #{params[:web_app]}")
  # Chef::Log.info("config is #{params[:config]}")
#   
  # web_app_hash = 
    # if(params[:config])
      # params[:config].to_hash
    # else 
      # {}
  # end
# 
#   
  # # Need to know if TCServer or Tomcat, or none. No default behavior should be defined
  # app_server_type =  
    # if(web_app_hash['app_server_type'])
      # web_app_hash['app_server_type']
    # end
#     
    # log "#{app_server_type} is App Server Type" do
      # message "#{app_server_type} is the AppServerType in jmh_app_java"
      # level :info
    # end
#   
  # case app_server_type
   # when 'tcserver'
     # Chef::Application.fatal("Sorry, but we do not use tcserver anymore")
   # when 'tomcat'       
     # tomcat_app params[:name] do 
       # config web_app_hash
     # end
   # else
     # #  Only need java for app not a TC Server nor Tomcat
     # include_recipe 'jmh-java'
  # end
# 
  # # end changes
#   
#     
  # unless(params[:database].nil? || params[:database].empty?)
    # db = params[:database]
# 
    # # If the application has a database defined, we take the database
    # # configuration defined and send it to the jmh_app_db definition
    # # defined in this cookbook to do the proper database setup
#     
    # jmh_app_db params[:name] do
      # db.each do |k,v|
        # self.send(k, v)
      # end
    # end
  # end
#   
#    
  # if(params[:config][:directories])
    # # If the application has directories defined, create them and set
    # # the proper ownership
#     
    # Array(params[:config][:directories]).each do |dir|
      # directory dir do
        # recursive true
        # owner params[:config][:owner] || node[:jmh_tomcat][:user]
        # group params[:config][:group] || node[:jmh_tomcat][:group]
      # end
    # end
  # end
#     
  # unless(params[:web_app].nil? || params[:web_app].empty?)
    # config = params[:web_app].to_hash
# 
    # # If this is a web application with apache in front, send the
    # # parameters to the jmh_app definition defined in this cookbook to
    # # properly setup apache
#     
    # jmh_webserver params[:name] do
      # apache_config config
    # end
  # end
#   
# end
