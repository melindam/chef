
@test "Tomcat FAD is running" {
	run bash -c "curl -s -I http://localhost:8085/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL FAD is running" {
	run bash -c "curl -s -k -I https://localhost:8449/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat Scheduling is running" {
	run bash -c "curl -s -I http://localhost:8094/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL Scheduling is running" {
	run bash -c "curl -s -k -I https://localhost:8464/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "MySQL FAD database was created" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D fad -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "Backup MySQL script is there" {
	run bash -c "ls /root/bin/backup_mysql.sh"
	[ "$status" -eq 0 ]
}

@test "Backup MySQL CronJob is there" {
	run bash -c "crontab -uroot -l | grep backup_mysql.sh"
	[ "$status" -eq 0 ]
}

@test "FAD image directory permissions are correct" {
	run bash -c "ls -lda /usr/local/webapps/fad/images/ | grep rwxrwxr-x"
	[ "$status" -eq 0 ]
}

