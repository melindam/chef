
@test "Tomcat Profile Client is running" {
	run bash -c "curl -s -I http://localhost:8097/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL Profile Client  is running" {
	run bash -c "curl -s -k -I https://localhost:8466/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "MySQL profile database was created" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D profile -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "MySQL mrn_user was created" {
	run bash -c "mysql -h 127.0.0.1 -umrn_user -pmrnpass -D profile -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "Profile API private cert created" {
 	run bash -c "test -s /usr/local/nodeapp/certs/jmh_private_key.cert"
 	[ "$status" -eq 0 ]
 }

 @test "Profile API public cert created" {
 	run bash -c "test -s /usr/local/nodeapp/certs/jmh_public_key.cert"
 	[ "$status" -eq 0 ]
 }

 @test "Profile newrelic file exixts" {
    run bash -c "test -a /home/nodejs/profile-api-newrelic.js"
 	[ "$status" -eq 0 ]
 }