
@test "Mount is live" {
	run bash -c "df | grep '/encrypted'"
	[ "$status" -eq 0 ]
}

@test "Write to File successfull" {
	run bash -c "echo 'Hello Scott' > /encrypted/hello.txt"
	[ "$status" -eq 0 ]
}

@test "Umount is successful" {
	run bash -c "umount /encrypted"
	[ "$status" -eq 0 ]
}

@test "File Not there after unmount" {
	run bash -c "cat /encrypted/hello.txt"
	[ "$status" -ne 0 ]
}

@test "Mount is successful" {
	run bash -c "mount /dev/mapper/encrypted /encrypted"
	[ "$status" -eq 0 ]
}