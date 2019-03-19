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

参考: http://www.cnblogs.com/EasonJim/p/8413715.html?spm=a2c4e.11153940.blogcont587845.9.3d0a324emR7f0U


日志调试的思路：

- 1、先在指定的表和链增加日志的输出。
- 2、指定日志的级别以及日志的前缀，注意，前缀非常重要，可以加快问题的分析。
- 3、最后就是使用ping或者crul进行访问测试，观察日志。
- 4、iptables是按顺序执行的，但是如果在某一处地方跳转了之后以下的规则就不会再执行，这一个可以日志打点后再慢慢观察发现。

日志文件的配置：

1、在rsyslog.conf添加配置

`/etc/rsyslog.conf` 中添加不同的日志级别

    kern.warning     /var/log/iptables.log
    kern.debug       /var/log/iptables.log
    kern.info        /var/log/iptables.log

不过推荐全部日志都记录： 

    kern.*     /var/log/iptables.log
重启日志配置：

    /etc/init.d/rsyslogd restart

如果不进行配置，那么这些日志会记录到`/var/log/messages`中，当然，在`/var/log/kern.log`也可以找得到。

iptables日志打点配置：

比如下面针对`nat`表的 `POSTROUTING`链进行日志打点

    iptables -t nat -A POSTROUTING -d 192.168.0.61 -p tcp --dport 9000 -j LOG --log-prefix "*** nat-POSTROUTING ***" --log-level warning

--log-prefix：日志前缀

--log-level：日志级别