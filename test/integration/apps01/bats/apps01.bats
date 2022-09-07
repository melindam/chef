
@test "Tomcat Events is running" {
	run bash -c "curl -s -I http://localhost:8080/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL Events is running" {
	run bash -c "curl -s -k -I https://localhost:8443/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Myjmh Events db connection is there" {
	run bash -c "mysql -h 127.0.0.1 --password=eventer -u events -D events -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "Tomcat Prereg is running" {
	run bash -c "curl -s -I http://localhost:8081/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL Prereg is running" {
	run bash -c "curl -s -k -I https://localhost:8444/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "MySQL Events database was created" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D events -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "MySQL Prereg database was created" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D preregistration -e 'show tables;'"
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