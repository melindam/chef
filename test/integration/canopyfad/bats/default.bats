
@test "MySQL CanopyFAD database was created" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D canopyfad -e 'show tables;'"
	[ "$status" -eq 0 ] 
}

@test "Tomcat CanopyFAD is running" {
	run bash -c "curl -s -I http://localhost:8096/ | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}