
@test "MySQL NE Profile database was created" {
	run bash -c "/usr/bin/mysql -h 127.0.0.1 -uroot -ppassword -D neprofile -e 'show tables;'"
	[ "$status" -eq 0 ]
}


@test "LDAP Up & Admin User Works" {
	run bash -c "/usr/bin/ldapsearch -x -D 'cn=admin,o=neaccess' -w password -b 'o=neaccess' -s one  '(objectclass=*)' "
	[ "$status" -eq 0 ]
}