#!/bin/bash

####
#
# 根据 连接 80 端口的用户连接数封 ip
#
####

# 将连接数超过 50 的ip封掉
/bin/netstat -ant |grep 80 |awk '{print $5}' |awk -F":" '{print $1}' |sort |uniq -c |sort -rn |grep -v -E '192.168|127.0' |awk '{if ($2!=null && $1>50)}' > /root/drop_ip.txt
for i in `cat /root/drop_ip.txt`
do
/sbin/iptables -I INPUT -s $i -j DROP;
done
