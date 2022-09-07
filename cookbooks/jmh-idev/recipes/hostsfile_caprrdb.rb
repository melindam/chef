# For access to MSSQL db
hostsfile_entry '172.23.202.12' do
    hostname 'CAPRRDB'
    aliases ['CAPRRDB.hsys.local', 'caprrdb']
    unique true
    comment 'MSSQL data connection'
    action :create
  end