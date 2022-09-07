
@test "Webserver is running" {
	run bash -c "sleep 5; curl -s -I http://localhost/ | head -1 | egrep \"HTTP/1.1 40|34|\""
	[ "$status" -eq 0 ]
}

@test "Archiva is running" {
	run bash -c "sleep 5; curl -s -I http://localhost:8080/archiva | head -1 | grep \"HTTP/1.1 302 Found\""
	[ "$status" -eq 0 ]
}

@test "Archiva is running in SSL Webserver" {
	run bash -c "sleep 5; curl -s -k -I https://localhost/archiva | head -1 | grep \"HTTP/1.1 302 Found\""
	[ "$status" -eq 0 ]
}

@test "Apache Failover Site is running on 83" {
	run bash -c "curl -s -I http://localhost:83/index.html | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "MySQL Archiva users was created" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D archiva_users -e 'show tables;'"
	[ "$status" -eq 0 ]
}