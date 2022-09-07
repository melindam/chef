@test "Pingfed is running" {
	run bash -c "sleep 30; curl -s -I -k https://localhost:9999/pingfederate/app | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "Pingfed Console java directory exists" {
  	run bash -c "ls /usr/local/pingfederate-console/pingfederate/sdk/plugin-src/pf-pcv-rest/java"
  	[ "$status" -eq 0 ]
}

@test "Pingfed Console Rest JAR exists" {
  	run bash -c "ls /usr/local/pingfederate-console/pingfederate//server/default/deploy/pf.plugins.pf-pcv-rest.jar"
  	[ "$status" -eq 0 ]
}

@test "Pingfed Console SetCookie JAR exists" {
  	run bash -c "ls /usr/local/pingfederate-console/pingfederate//server/default/deploy/pf.plugin.set-cookie-authentication-selector.jar"
  	[ "$status" -eq 0 ]
}

@test "Pingfed Engine java directory exists" {
  	run bash -c "ls /usr/local/pingfederate-engine/pingfederate/sdk/plugin-src/pf-pcv-rest/java"
  	[ "$status" -eq 0 ]
}

@test "Pingfed Engine Rest JAR exists" {
  	run bash -c "ls /usr/local/pingfederate-engine/pingfederate//server/default/deploy/pf.plugins.pf-pcv-rest.jar"
  	[ "$status" -eq 0 ]
}

@test "Pingfed Engine SetCookie JAR exists" {
  	run bash -c "ls /usr/local/pingfederate-engine/pingfederate//server/default/deploy/pf.plugin.set-cookie-authentication-selector.jar"
  	[ "$status" -eq 0 ]
}


@test "Pingfed check user in jmhbackup group" {
  	run bash -c "grep pingfed /etc/group | grep jmhbackup"
  	[ "$status" -eq 0 ]
}

