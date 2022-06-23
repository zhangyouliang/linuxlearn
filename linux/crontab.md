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
# 格式如下：
*    *    *    *    *
-    -    -    -    -
|    |    |    |    |
|    |    |    |    +----- 星期中星期几 (0 - 7) (星期天 为0)
|    |    |    +---------- 月份 (1 - 12) 
|    |    +--------------- 一个月中的第几天 (1 - 31)
|    +-------------------- 小时 (0 - 23)
+------------------------- 分钟 (0 - 59)
 
* * * * *    每分钟执行
*/5 * * * *  每5分钟执行
0 * * * *    每小时执行
0 0 * * *    每天执行
0 0 * * 0    每周执行
0 0 1 * *    每月执行
0 0 1 1 *    每年执行
5 * * * *    每小时的第5分钟执行

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

