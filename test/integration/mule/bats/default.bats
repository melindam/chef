
@test "MySQL Canopy database was created" {
	run bash -c "mysql -h 127.0.0.1 -uroot -ppassword -D canopyfad -e 'show tables;'"
	[ "$status" -eq 0 ] 
}


@test "Mule is running" {
	run bash -c "netstat -an | grep 7777"
	[ "$status" -eq 0 ] 
}

@test "Mule process running" {
	run bash -c "ps -ef | grep mule"
	[ "$status" -eq 0 ] 
}