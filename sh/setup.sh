#!/usr/bin/expect

spawn psm setup
expect {
        "Username:" {send "cloud.admin\r"; exp_continue}
		"Password:" {send "gReEDy@1Blow\r"; exp_continue}
		"Retype Password:" {send "gReEDy@1Blow\r"; exp_continue}
		"Identity domain:" {send "gse00002265\r"; exp_continue}
        "Region" {send "emea\r"; exp_continue}
		"Output format:" {send "\r"}
}
expect eof
echo ">>>End psm setup...<<<"
