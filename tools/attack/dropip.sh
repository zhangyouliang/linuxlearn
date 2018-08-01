#!/bin/bash

####
#
#  针对连接数封 ip
#
# chmod +x dropip.sh
#
# crontab -e
# 添加
# */1 * * * * /root/bin/dropip.sh
#
####

# 将连接数超过100的ip封掉
/bin/netstat -na|grep ESTABLISHED|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -rn|head -10|grep -v -E '192.168|127.0'|awk '{if ($2!=null && $1>100) {print $2}}'

for i in $(cat /tmp/dropip)
do
/sbin/iptables -A INPUT -s $i -j DROP
echo "$i kill at `date`">>/var/log/ddos
done

