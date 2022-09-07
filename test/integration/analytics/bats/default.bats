@test "MyJMH-Command JAR is there" {
	run bash -c "ls /home/jmhbackup/bin/myjmh-command.jar"
	[ "$status" -eq 0 ]
}

@test "SSLPoke is in place" {
	run bash -c "ls /home/jmhbackup/bin/SSLPoke.class"
	[ "$status" -eq 0 ]
}

@test "Mychart database is there" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D mychart -e 'show tables;'"
	[ "$status" -eq 0 ]
}