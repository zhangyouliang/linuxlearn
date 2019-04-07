> /proc/sys/vm/drop_caches  系统文件

默认是0，

1表示清空页缓存，

2表示清空inode和目录树缓存，

3清空所有的缓存

测试
---

    ## 写入 1G
    dd if=/dev/zero of=./1 bs=1024k count=1024
    ## 读取文件,会自动放入内存当中
    dd if=./1 bs=1024 of=/dev/null  

内存低于 4G 自动释放 cache/buffer

    #! /bin/sh
    used=`free -m | awk 'NR==2' | awk '{print $3}'`
    free=`free -m | awk 'NR==2' | awk '{print $4}'`
    echo "===========================" >> /var/log/mem.log
    date >> /var/log/mem.log
    echo "Memory usage before | [Use：${used}MB][Free：${free}MB]" >> /var/log/mem.log
    if [ $free -le 4000 ] ; then
                    sync && echo 1 > /proc/sys/vm/drop_caches
                    sync && echo 2 > /proc/sys/vm/drop_caches
                    sync && echo 3 > /proc/sys/vm/drop_caches
    				used_ok=`free -m | awk 'NR==2' | awk '{print $3}'`
    				free_ok=`free -m | awk 'NR==2' | awk '{print $4}'`
    				echo "Memory usage after | [Use：${used_ok}MB][Free：${free_ok}MB]" >> /var/log/mem.log
                    echo "OK" >> /var/log/mem.log
    else
                    echo "Not required" >> /var/log/mem.log
    fi
    exit 1


输出结果

    ===========================
    Sun Apr  7 18:47:04 CST 2019
    Memory usage before | [Use：1182MB][Free：1170MB]
    Memory usage after | [Use：1184MB][Free：2211MB]
    OK