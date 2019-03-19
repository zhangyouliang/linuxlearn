#### Ubuntu16.04 开启 iptables的日志调试

* 日志输出配置

1、问题描述

今天需要查看Ubuntu系统的日志文件，但却没有找到`/var/log/messages`这个文件。网上搜素资料，说是要配置 `/etc/syslog.conf`。syslog采用可配置的、统一的系统登记程序，随时从系统各处接受log请求，然后根据 `/etc/syslog.conf` 中的预先设定把log信息写入相应文件中、邮寄给特 定用户或者直接以消息的方式发往控制台。

好吧，问题又来了。系统中依然没有 `/etc/syslog.conf`，经过一番搜素，最后得到的结论是：在Ubuntu下对应的应该是/etc/rsyslog.conf和rsyslogd。

2、问题解决

打开 `/etc/rsyslog.d/50-default.conf` 删除下面这几条注释

        38 *.=info;*.=notice;*.=warn;\
        39         auth,authpriv.none;\
        40         cron,daemon.none;\
        41         mail,news.none          -/var/log/messages
        42 
        43 #

运行下面命令重启rsyslog服务

    sudo service rsyslog restart  

* 配置加载的模块

> 可能Debian默认不开启iptables的raw表，所以无法通过其实现日志跟踪。

日志跟踪：http://www.cnblogs.com/EasonJim/p/8413563.html

查看日志：`/var/log/syslog`或者`/var/log/kern.log`或者`/var/log/messages`

    modprobe ipt_LOG
    modprobe nf_log_ipv4
    sysctl net.netfilter.nf_log.2=nf_log_ipv4

* 配置日志打点

参考: http://www.cnblogs.com/EasonJim/p/8413563.html
