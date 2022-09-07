default['mysql']['binlog_format'] = 'row'
default['mysql']['bind_address'] = '0.0.0.0'
default['jmh_db']['default_storage_engine'] = 'InnoDB'

default['jmh_crowd']['scratch_dir'] = '/usr/src/crowd'
default['jmh_crowd']['base_url'] = 'https://www.atlassian.com/software/crowd/downloads/binary'
default['jmh_crowd']['version'] = '4.0.2'
# default['jmh_crowd']['version'] = '3.2.5'
default['jmh_crowd']['flavor'] = :standalone # or :war or :jmh_crowdid
default['jmh_crowd']['names']['jmh_crowdid'] = 'atlassian-crowd-openid'
default['jmh_crowd']['names']['standalone'] = 'atlassian-crowd'
default['jmh_crowd']['names']['war'] = 'atlassian-crowd'
default['jmh_crowd']['java']['version'] = '11'
# default['jmh_crowd']['java']['version'] = '8'
default['jmh_crowd']['java_opts'] = '-Xms128m -Xmx1024m'
# default['jmh_crowd']['java_opts'] = "-Xms256m -Xmx2048m -Xloggc:/usr/local/crowd/atlassian-crowd-#{node['jmh_crowd']['version']}/logs/`date +%F_%H-%M-%S`-gc.log \
                                    # -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:-PrintTenuringDistribution -XX:+PrintGCCause \
                                    # -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=2M"
default['jmh_crowd']['port'] = '8095'
default['jmh_crowd']['ssl_port'] = '8495'
default['jmh_crowd']['enable_ssl'] = true
default['jmh_crowd']['extensions']['standalone'] = '.tar.gz'
default['jmh_crowd']['extensions']['war'] = '-war.zip'
default['jmh_crowd']['extensions']['jmh_crowdid'] = '-war.zip'
default['jmh_crowd']['datastore'] = :mysql

default['jmh_crowd']['mysql']['username'] = 'crowduser'
default['jmh_crowd']['mysql']['dbname'] = 'crowd'
default['jmh_crowd']['mysql']['privileges'] = [:all]
default['jmh_crowd']['mysql']['connect_over_ssl'] = false

default['jmh_crowd']['install']['dir'] = '/usr/local/crowd'
default['jmh_crowd']['run_as'] = 'crowd'
default['jmh_crowd']['iptables'] = true
default['jmh_crowd']['databag']['name'] = 'crowd'
default['jmh_crowd']['databag']['databag_item'] = 'secure'
default['jmh_crowd']['databag']['password_field'] = case node['jmh_server']['environment']
                                                    when 'prod'
                                                      'prod_password'
                                                    when 'stage'
                                                      'stage_password'
                                                    when 'dev', 'sbx'
                                                      'dev_password'
                                                    else
                                                      'default_password'
                                                    end

# 10 year self signed cert to expire Feb 12 14:48:48 PST 2027  - [@melindam]
default['jmh_crowd']['ssl']['cert_folder'] = File.join(node['jmh_crowd']['install']['dir'], 'ssl')
default['jmh_crowd']['ssl']['keystore'] = '.keystore'
default['jmh_crowd']['ssl']['keystore_alias'] = 'crowd2027'
default['jmh_crowd']['protocol'] = node['jmh_crowd']['enable_ssl'] ? 'https' : 'http'
default['jmh_crowd']['url_port'] = node['jmh_crowd']['enable_ssl'] ? node['jmh_crowd']['ssl_port'] : node['jmh_crowd']['port']

default['jmh_crowd']['config']['setup_variables_list'] = %w(setupStep setupType buildNumber)


default['jmh_crowd']['url'] = "http://localhost:#{node['jmh_crowd']['port']}/crowd/services"
default['jmh_crowd']['application']['url'] =
  case node['jmh_server']['environment']
  when 'prod'
    "#{node['jmh_crowd']['protocol']}://crowd.johnmuirhealth.com:#{node['jmh_crowd']['url_port']}/crowd"
  when 'stage'
    "#{node['jmh_crowd']['protocol']}://crowd-stage.johnmuirhealth.com:#{node['jmh_crowd']['url_port']}/crowd"
  when 'dev','sbx'
    "#{node['jmh_crowd']['protocol']}://crowd-tst.johnmuirhealth.com:#{node['jmh_crowd']['url_port']}/crowd"
  else
    "#{node['jmh_crowd']['protocol']}://localhost:#{node['jmh_crowd']['url_port']}/crowd"
  end

default['jmh_crowd']['watch_script']['email'] = 'melinda.moran@johnmuirhealth.com'
default['jmh_crowd']['watch_script']['check_page'] = '/crowd/console/login.action'
default['jmh_crowd']['watch_script']['restart_script'] = '/usr/sbin/service crowd'
default['jmh_crowd']['watch_script']['enable'] = false
