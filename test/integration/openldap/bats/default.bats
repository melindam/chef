@test "slapd is up" {
	run bash -c "ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts"
	[ "$status" -eq 0 ]
}

@test "Admin User Works" {
	run bash -c "ldapsearch -x -D 'cn=admin,dc=canopyhealth,dc=com' -w secret -s base '(objectclass=*)' "
	[ "$status" -eq 0 ]
}

@test "canopyhealth LDAP is up" {
	run bash -c "ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts | grep 'namingContexts: dc=canopyhealth,dc=com' "
	[ "$status" -eq 0 ]
}

@test "canopyhealth LDAPS is up" {
	run bash -c "LDAPTLS_REQCERT=never ldapsearch -x -H 'ldaps://localhost:636' -b '' -s base '(objectclass=*)' namingContexts | grep 'namingContexts: dc=canopyhealth,dc=com' "
	[ "$status" -eq 0 ]
}

@test "Mule User Works" {
	run bash -c "ldapwhoami -x -D 'cn=mule,ou=serviceaccounts,dc=canopyhealth,dc=com' -w password "
	[ "$status" -eq 0 ]
}