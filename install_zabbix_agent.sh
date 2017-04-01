#!/bin/bash
#create by jxl
#Date: 2017-03-31
#set password
set timeout=-1
password=1qazcde3!@#

for i in 172.16.101.{207..209}
do
	/usr/bin/expect<<EOF
	spawn ssh root@$i
	expect {
	"*yes/no" { send "yes\r"; exp_continue}
	"*password:" { send "$password\r" }
}
expect "#"
send "hostname\r"
#send "echo 'nameserver 202.101.172.35' >> /etc/resolv.conf\r"
send "echo 'nameserver 202.101.172.35' > /etc/resolv.conf\r"
send "echo '172.16.101.140   zabbix140' >> /etc/hosts\r"
send "rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-agent-3.0.4-1.el6.x86_64.rpm\r"
#send "yum -y install zabbix-agent\r"
#send "sleep 10\r"
send "sed -i 's/Server=127.0.0.1/Server=172.16.101.140/g' /etc/zabbix/zabbix_agentd.conf\r"
send "sed -i 's/ServerActive=127.0.0.1/ServerActive=172.16.101.140/g' /etc/zabbix/zabbix_agentd.conf\r"
send "sed -i 's/Hostname=Zabbix server/Hostname=zabbix140/g' /etc/zabbix/zabbix_agentd.conf\r"
send "chkconfig zabbix-agent on\r"
send "/etc/init.d/zabbix-agent start\r"
send "exit\r"
expect eof
EOF
done
