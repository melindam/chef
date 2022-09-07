#!/usr/bin/env bats

@test "linux: running 64-bit kernel" {
  run bash -c "uname -a | grep -o x86_64 | wc -m"
  echo "output: "$output
  echo "status: "$status
  [ "$status" -eq 0 ]
  [ "$output" -ne 0 ]
}

@test "Postfix is running" {
	run bash -c "ps ax | grep postfix | grep -v grep"
	[ "$status" -eq 0 ]
}

@test "Selinux is permissive" {
  run bash -c "cat /etc/selinux/config | grep ^SELINUX=permissive"
  [ "$status" -eq 0 ]
}

@test "Timezone is correct" {
	run bash -c "date | egrep \"(PST|PDT)\""
	[ "$status" -eq 0 ]
}

@test "Iptables is running" {
	run bash -c "/usr/bin/systemctl status iptables"
	[ "$status" -eq 0 ]
}

@test "chef-client cron is there" {
	run bash -c "crontab -l -u root | grep chef-client"
	[ "$status" -eq 0 ]
}

@test "chef-client logrotate is there " {
	run bash -c "cat /etc/logrotate.d/chef-client | grep /var/log/chef/client.log"
	[ "$status" -eq 0 ]
}

@test "group sysadmin is there " {
	run bash -c "grep sysadmin /etc/group"
	[ "$status" -eq 0 ]
}