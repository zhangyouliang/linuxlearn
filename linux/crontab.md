> crontab

定时执行操作命令，每一个用户拥有自己的crontab，配置文件存在/var下面，不能被直接编辑。

- [图形化工具](https://cron.qqe2.com/)


````bash
# 查看 cron 服务
service cron status
# or
systemctl status cron.service 

````

选项
-----

    -e 设置计时器
    -l 列出当前计时器的设置
    -r 删除计时器的设置
    -i 交互式模式，删除计时器设置时要先询问
    -u 指定要设定计时器的用户名称


1. 说明

````
第1列   第2列    3      4       5      6

第1列表示分钟0～59 每分钟用*或者 */1表示
第2列表示小时1～23（0表示0点）
第3列表示日期1～31
第4列表示月份1～12
第5列标识号星期0～6（0表示星期天）
第6列要运行的命令
````

2. 特殊符号

````
符号	含义
*	    表示任意时间都可以
-	    表示取值范围
````

例子
-----

````
30 21 * * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每晚的21:30重启lighttpd 。

45 4 1,10,22 * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每月1、10、22日的4 : 45重启lighttpd 。

10 1 * * 6,0 /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每周六、周日的1 : 10重启lighttpd 。

0,30 18-23 * * * /usr/local/etc/rc.d/lighttpd restart
上面的例子表示在每天18 : 00至23 : 00之间每隔30分钟重启lighttpd 。

0 23 * * 6 /usr/local/etc/rc.d/lighttpd restart
上面的例子表示每星期六的11 : 00 pm重启lighttpd 。

0 * * * * /usr/local/etc/rc.d/lighttpd restart
每一小时重启lighttpd

0 23-7/1 * * * /usr/local/etc/rc.d/lighttpd restart
晚上11点到早上7点之间，每隔一小时重启lighttpd

0 11 4 * mon-wed /usr/local/etc/rc.d/lighttpd restart
每月的4号与每周一到周三的11点重启lighttpd

0 4 1 jan * /usr/local/etc/rc.d/lighttpd restart
一月一号的4点重启lighttpd


每五分钟执行  */5 * * * *
每小时执行     0 * * * *
每天执行        0 0 * * *
每周执行       0 0 * * 0
每月执行        0 0 1 * *
每年执行       0 0 1 1 *

````

