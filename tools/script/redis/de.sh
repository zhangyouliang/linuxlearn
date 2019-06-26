#!/bin/bash

####
#
#  删除指定文件中指定文件的 key
#
####

db_ip=127.0.0.1
db_port=6379
password="''"
cnt=10000
# 需要删除的 key 
file=no_ttl.log

total=`wc -l $file | cut -d' ' -f1`
let f=$total/$cnt+1

if [[ ! -d logs ]];
then
    echo 1
fi

for num in `seq 1 $f`;
do
  
	for i in `head -n $cnt $file`;
	do
   	    redis-cli -h $db_ip -p $db_port -a $password del $i
	done
    # 记录删除记录
    sed -n '1,10000p' no_ttl.log > logs/$num.log
	sed -ie '1,10000d' no_ttl.log
	echo "del group fro $num"
done


