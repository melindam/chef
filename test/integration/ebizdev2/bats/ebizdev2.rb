@test "Tomcat MD Suspension is running" {
    run bash -c "curl -s -I http://localhost:8105/ | head -1 | grep \"HTTP/1.1 200\""
[ "$status" -eq 0 ]
}

@test "MySQL mdsuspension database was created" {
    run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D mdsuspension -e 'show tables;'"
[ "$status" -eq 0 ]
}

@test "MdSuspension MySQL db connection is there" {
    run bash -c "mysql -h 127.0.0.1 --password=mdsuspensionpassword -u mdsuspension -D mdsuspension -e 'show tables;'"
[ "$status" -eq 0 ]
}

@test "Backup MySQL script is there" {
    run bash -c "ls /root/bin/backup_mysql.sh"
[ "$status" -eq 0 ]
}