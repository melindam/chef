
@test "Tomcat Myjmh-admin is running" {
	run bash -c "curl -s -I http://localhost:8098/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL Myjmh-admin is running" {
	run bash -c "curl -s -k -I https://localhost:8467/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Crowd is running" {
	run bash -c "curl -s -I http://localhost:8095/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Crowd database is there" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D crowd -e 'show tables;'"
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