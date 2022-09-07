
@test "Mount is live" {
	run bash -c "df | grep '/secure_mount'"
	[ "$status" -eq 0 ]
}

@test "Write to File successfull" {
	run bash -c "echo 'Hello Scott' > /secure_mount/hello.txt"
	[ "$status" -eq 0 ]
}

@test "Umount is successful" {
	run bash -c "umount /secure_mount"
	[ "$status" -eq 0 ]
}

@test "File is Unreadable after unmount" {
	run bash -c "strings /secure_mount/hello.txt; grep 'Scott' /secure_mount/hello.txt"
	[ "$status" -ne 0 ]
}

@test "Mount is successful" {
	run bash -c "mount /secure_mount"
	[ "$status" -eq 0 ]
}