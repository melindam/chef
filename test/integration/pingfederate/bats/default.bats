@test "Pingfed is running" {
	run bash -c "sleep 30; curl -s -I -k https://localhost:9999/pingfederate/app | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ] 
}

@test "Pingfed java directory exists" {
  	run bash -c "ls /usr/local/pingfederate/sdk/plugin-src/pf-pcv-rest/java"
  	[ "$status" -eq 0 ]
}

@test "Pingfed Rest JAR exists" {
  	run bash -c "ls /usr/local/pingfederate/server/default/deploy/pf.plugins.pf-pcv-rest.jar"
  	[ "$status" -eq 0 ]
}

@test "Pingfed check user in jmhbackup group" {
  	run bash -c "grep pingfed /etc/group | grep jmhbackup"
  	[ "$status" -eq 0 ]
}

@test "Pingfed SetCookie JAR exists" {
  	run bash -c "ls /usr/local/pingfederate/server/default/deploy/pf.plugin.set-cookie-authentication-selector.jar"
  	[ "$status" -eq 0 ]
}
