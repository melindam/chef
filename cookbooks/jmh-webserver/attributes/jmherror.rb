# jmherror page attributes
default['jmh_webserver']['jmherror']['dir'] = '/var/www/html/jmherror'
default['jmh_webserver']['jmherror']['files'] = %w(logo.png baby.jpg JMH_512.gif)
default['jmh_webserver']['jmherror']['css'] = %w(clientlib-all.css footerComponent.css inlineNavComponent.css navigationComponent.css)                                                  
default['jmh_webserver']['jmherror']['fonts'] = %w(OpenSans-Bold.ttf OpenSans-Light.ttf OpenSans-Regular.ttf OpenSans-Semibold.ttf OpenSans-SemiboldItalic.ttf)
default['jmh_webserver']['jmherror']['template_files'] = %w(maintenance myjmh_maintenance pagenotfound unauthorized-ebusiness)
default['jmh_webserver']['jmherror']['default_proxy_maintenance_page'] = '/jmherror/maintenance.html'
default['jmh_webserver']['jmherror']['maintenance_message'] = "<p> Our site is temporarily unavailable<br>due to scheduled system maintenance." +
                                                                  "<br><br>Thank you for your patience. </p>" +
                                                                  "<p>While you wait, feel free to <a href=\"mailto:info@johnmuirhealth.com\">email us</a>.  </p>"
default['jmh_webserver']['jmherror']['myjmh_maintenance_message'] = "MyJohnMuirHealth will be back online soon."

default['jmh_webserver']['jmherror']['force_maintenance'] = false
default['jmh_webserver']['jmherror']['error_message'] = "<p>John Muir Health is experiencing some technical difficulties." \
                                                           '<br/>Please try clicking refresh.' \
                                                           "<br/>If not, we will be back online soon.<p>"
default['jmh_webserver']['jmherror']['error_maintenance_header'] = "We will be back in less than 1 minute!"                                                           
default['jmh_webserver']['jmherror']['maintenance_windows'] = [ ["15:30:00 PDT","16:30:00 PDT"],
                                                                ["20:45:00 PDT","21:30:00 PDT"],
                                                                ["01:00:00 PDT","01:30:00 PDT"]]
