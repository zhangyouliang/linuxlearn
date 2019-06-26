#!/bin/bash

####
#
#  获取redis中没有过期时间的key
#
####


db_ip=127.0.0.1
db_port=6379
password="''"
cursor=0
cnt=100
new_cursor=0


redis-cli -h $db_ip -p $db_port -a $password scan $cursor count $cnt > scan_tmp_result
new_cursor=`sed -n '1p' scan_tmp_result`
sed -n '2,$p' scan_tmp_result > scan_result
cat scan_result |while read line
do
    ttl_result=`redis-cli -h $db_ip -p $db_port -a $password ttl $line`
    # if [[ $ttl_result > 500000000  ]];then
    if [[ $ttl_result == -1 ]];then
        echo $line >> no_ttl.log
    fi
done


while [ $cursor -ne $new_cursor ]
do
    redis-cli -h $db_ip -p $db_port -a $password scan $new_cursor count $cnt > scan_tmp_result
    new_cursor=`sed -n '1p' scan_tmp_result`
    sed -n '2,$p' scan_tmp_result > scan_result
    cat scan_result |while read line
    do
        ttl_result=`redis-cli -h $db_ip -p $db_port -a $password ttl $line`
        if [[ $ttl_result == -1 ]];then
            echo $line >> no_ttl.log
        fi
    done
done
rm -rf scan_tmp_result
rm -rf scan_result