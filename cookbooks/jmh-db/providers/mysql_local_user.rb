# jmh_db_mysql_local_user

action :create do
  require 'mysql2'
  @mysql_client =
    Mysql2::Client.new(
      :host => '127.0.0.1',
      :username => 'root',
      :password => node['mysql']['server_root_password']
    )

  # If your password starts with *, then it is assumed to be a password hash
  password_snippet = ''
  password_snippet_display = ''
  if new_resource.password.start_with?('*')
    password_snippet = "IDENTIFIED BY PASSWORD '#{new_resource.password}'"
    password_snippet_display = "IDENTIFIED BY PASSWORD '#{new_resource.password.slice(0,3)}*********'"
  else
    password_snippet = "IDENTIFIED BY '#{new_resource.password}'"
    password_snippet_display = "IDENTIFIED BY '#{new_resource.password.slice(0,3)}*********'"
  end

  drop_statement = "DROP USER '#{new_resource.username}'@'#{new_resource.host_connection}'"
  grant_statement = "GRANT #{new_resource.privileges.join(',')} " \
                    "ON #{new_resource.database}.* " \
                    "TO '#{new_resource.username}'@'#{new_resource.host_connection}' "
  grant_statement_display = grant_statement.dup.concat(password_snippet_display)
  grant_statement = grant_statement.concat(password_snippet)

  global_grant_statement = nil
  if new_resource.global_privileges
    global_grant_statement = "GRANT #{new_resource.global_privileges.join(',')} " \
                             "ON *.* " \
                             "TO '#{new_resource.username}'@'#{new_resource.host_connection}' "
  end
  Chef::Log.warn("***  #{grant_statement_display} **")
  begin
    @mysql_client.query(drop_statement)
  rescue Mysql2::Error
    Chef::Log.debug('Caught MYSQL2 Exception when dropping user')
  end
  @mysql_client.query(grant_statement)
  @mysql_client.query('FLUSH PRIVILEGES')
  unless global_grant_statement.nil?
    @mysql_client.query(global_grant_statement)
    @mysql_client.query('FLUSH PRIVILEGES')
  end
  @mysql_client.close
end

action :drop do
  require 'mysql2'
  @mysql_client =
    Mysql2::Client.new(
      :host => '127.0.0.1',
      :username => 'root',
      :password => node['mysql']['server_root_password']
    )
  drop_statement = "DROP USER '#{new_resource.username}'@'#{new_resource.host_connection}'"
  begin
    @mysql_client.query(drop_statement)
  rescue Mysql2::Error
    Chef::Log.debug('Caught MYSQL2 Exception when dropping user')
  end
  @mysql_client.query('FLUSH PRIVILEGES')
  @mysql_client.close
end
