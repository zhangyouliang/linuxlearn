 > 日志管理系统 rsyslogd
rsyslog是一个开源的软件程序，它负责写入日志。 它记录绝大部分的日志记录，和系统有关的、安全、认证ssh,su、计划任务at,cron等日志。
rsyslogd是一个进程，是一个日志服务，我们可以通过rpm -qc查询软件包的方式来查看


````bash
# 例如开启 cron 的日志
# cron.* 去除 # 即可
vim /etc/rsyslog.d/50-default.conf
service rsyslog restart

````
 