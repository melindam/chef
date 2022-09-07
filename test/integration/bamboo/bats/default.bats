
@test "Bamboo is running" {
	run bash -c "curl -s -I http://localhost:8085/bamboo | head -1 | grep \"HTTP/1.1 302\""
	[ "$status" -eq 0 ]
}

@test "Webserver is running" {
	run bash -c "curl -s -I http://localhost/bamboo | head -1 | grep \"HTTP/1.1 302\""
	[ "$status" -eq 0 ]
}

@test "bamboo database is there" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D bamboo -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "profile database is there" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D profile -e 'show tables;'"
	[ "$status" -eq 0 ]
}
