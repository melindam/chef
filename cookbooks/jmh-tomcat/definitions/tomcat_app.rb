# Definition for mutiple tomcat applications
# jmh_tomcat_app Definition
define :tomcat_app, :config => {} do
  Chef::Log.warn('**Deprecated Call: tomcat_app.  Use jmh_tomcat instead!')
  jmh_tomcat params[:name] do
    name params[:name]
    # remove_dirs params[:config]['remove_dirs'] if params[:config]['remove_dirs']
    java_version params[:config]['java_version'] if params[:config]['java_version']
    java_options [params[:config]['java_options']] if params[:config]['java_options']
    max_heap_size params[:config]['max_heap_size'] if params[:config]['max_heap_size']
    max_permgen params[:config]['max_permgen'] if params[:config]['max_permgen']
    thread_stack_size params[:config]['thread_stack_size'] if params[:config]['thread_stack_size']
    newrelic params[:config]['newrelic'] if params[:config]['newrelic']
    jmx_port params[:config]['jmx_port'] if params[:config]['jmx_port']
    catalina_opts [params[:config]['catalina_opts']] if params[:config]['catalina_opts']
    enable_http params[:config]['enable_http'] if params[:config]['enable_http']
    enable_ssl params[:config]['enable_ssl'] if params[:config]['enable_ssl']
    iptables params[:config]['iptables'] if params[:config]['iptables']
    shutdown_port params[:config]['shutdown_port'] if params[:config]['shutdown_port']
    port params[:config]['port'] if params[:config]['port']
    ssl_port params[:config]['ssl_port'] if params[:config]['ssl_port']
    app_properties params[:config]['app_properties'] if params[:config]['app_properties']
    catalina_properties params[:config]['catalina_properties'] if params[:config]['catalina_properties']
    newrelic params[:config]['newrelic'] if params[:config]['newrelic']
    directories params[:config]['directories'] if params[:config]['directories']
    # config params[:config]
  end
end
