39 | 案例篇：怎么缓解 DDoS 攻击带来的性能下降问题？
---

从攻击的原理上来看，DDoS 可以分为下面几种类型。

- 第一种，耗尽带宽。无论是服务器还是路由器、交换机等网络设备，带宽都有固定的上限。带宽耗尽后，就会发生网络拥堵，从而无法传输其他正常的网络报文。

- 第二种，耗尽操作系统的资源。网络服务的正常运行，都需要一定的系统资源，像是 CPU、内存等物理资源，以及连接表等软件资源。一旦资源耗尽，系统就不能处理其他正常的网络连接。

- 第三种，消耗应用程序的运行资源。应用程序的运行，通常还需要跟其他的资源或系统交互。如果应用程序一直忙于处理无效请求，也会导致正常请求的处理变慢，甚至得不到响应。


比如，构造大量不同的域名来攻击 DNS 服务器，就会导致 DNS 服务器不停执行迭代查询，并更新缓存。这会极大地消耗 DNS 服务器的资源，使 DNS 的响应变慢。

案例:
----

工具: 

- docker
- sar
- hping3
- tcpdump
- curl 等工具


启动测试服务

    # 运行 Nginx 服务并对外开放 80 端口
    # --network=host 表示使用主机网络（这是为了方便后面排查问题）
    $ docker run -itd --name=nginx --network=host nginx


    # -w 表示只输出 HTTP 状态码及总时间，-o 表示将响应重定向到 /dev/null
    $ curl -s -w 'Http code: %{http_code}\nTotal time:%{time_total}s\n' -o /dev/null http://192.168.0.30/
    ...
    Http code: 200
    Total time:0.002s


从这里可以看到，正常情况下，我们访问 Nginx 只需要 2ms

模拟 ddos

    # -S 参数表示设置 TCP 协议的 SYN（同步序列号），-p 表示目的端口为 80
    # -i u10 表示每隔 10 微秒发送一个网络帧
    $ hping3 -S -p 80 -i u10 192.168.0.30

使用 sar 检测

    sar -n DEV 1
    08:55:49        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
    08:55:50      docker0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    08:55:50         eth0  22274.00    629.00   1174.64     37.78      0.00      0.00      0.00      0.02
    08:55:50           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00


tcpdump 抓包


    # -i eth0 只抓取 eth0 网卡，-n 不解析协议名和主机名
    # tcp port 80 表示只抓取 tcp 协议并且端口号为 80 的网络帧
    $ tcpdump -i eth0 -n tcp port 80
    09:15:48.287047 IP 192.168.0.2.27095 > 192.168.0.30: Flags [S], seq 1288268370, win 512, length 0
    09:15:48.287050 IP 192.168.0.2.27131 > 192.168.0.30: Flags [S], seq 2084255254, win 512, length 0
    09:15:48.287052 IP 192.168.0.2.27116 > 192.168.0.30: Flags [S], seq 677393791, win 512, length 0
    09:15:48.287055 IP 192.168.0.2.27141 > 192.168.0.30: Flags [S], seq 1276451587, win 512, length 0
    09:15:48.287068 IP 192.168.0.2.27154 > 192.168.0.30: Flags [S], seq 1851495339, win 512, length 0
    ...



Flags[S] 表示 SYN 包 ,大量  SYN 包表示,这是一个 SYN Flood 攻击.


![image](../images/f397305c87be6ae43e065d3262ec9113.png)


实际上，SYN Flood 正是互联网中最经典的 DDoS 攻击方式。从上面这个图，你也可以看到它的原理：

- 即客户端构造大量的 SYN 包，请求建立 TCP 连接；

- 而服务器收到包后，会向源 IP 发送 SYN+ACK 报文，并等待三次握手的最后一次 ACK 报文，直到超时。

这种等待状态的 TCP 连接，通常也称为半开连接。由于连接表的大小有限，大量的半开连接就会导致连接表迅速占满，从而无法建立新的 TCP 连接。

![image](../images/86dabf9cc66b29133fa6a239cfee38a2.png)


这其实提示了我们，查看 TCP 半开连接的方法，关键在于 SYN_RECEIVED 状态的连接。我们可以使用 netstat ，来查看所有连接的状态，不过要注意，SYN_REVEIVED 的状态，通常被缩写为 SYN_RECV。


我们继续在终端一中，执行下面的 netstat 命令：


    # -n 表示不解析名字，-p 表示显示连接所属进程
    $ netstat -n -p | grep SYN_REC
    tcp        0      0 192.168.0.30:80          192.168.0.2:12503      SYN_RECV    -
    tcp        0      0 192.168.0.30:80          192.168.0.2:13502      SYN_RECV    -
    tcp        0      0 192.168.0.30:80          192.168.0.2:15256      SYN_RECV    -
    tcp        0      0 192.168.0.30:80          192.168.0.2:18117      SYN_RECV    -
    ...


结局方法:

找出 源 ip 后,要解决 SYN 攻击的问题,只要丢掉相关的包就可以了

    iptables -I INPUT -s 192.168.0.2 -p tcp -j REJECT


如果 你在  hping3 添加 `--rand-source` 选项,来随机化源 IP,上面命令就不适合了.

这里我们采用下面的方式

    # 限制 syn 并发数为每秒 1 次
    $ iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT

    # 限制单个 IP 在 60 秒新建立的连接数为 10
    $ iptables -I INPUT -p tcp --dport 80 --syn -m recent --name SYN_FLOOD --update --seconds 60 --hitcount 10 -j REJECT


上面的优化师远远不够的.我们还需要对 TCP 优化

比如,SYN Flood 会导致 SYN_RECV 转哪个台的连接极剧增加,在上面 netstat 命令中,你可以看出 190多个处于 半开状态的连接.
,半开状态连接个数是有限制的,执行下面命令可以查看


    sysctl net.ipv4.tcp_max_syn_backlog


另外,连接每个 SYN_RECV 时,如果失败,内核会自动重试,默认5次,减小为 1次

    sysctl -w net.ipv4.tcp_synack_retries=1

除此之外, TCP SYN Cookies 也是一种专门防御 SYN Flood 攻击的方法,SYN Cookies 基于连接信息(包括源地址,源端口,目的地址,目的端口等),以及一个加密种子,(如系统启动时间),计算出一个哈希值,这个哈希值就是 cookie

然后，这个 cookie 就被用作序列号，来应答 SYN+ACK 包，并释放连接状态。当客户端发送完三次握手的最后一次 ACK 后，服务器就会再次计算这个哈希值，确认是上次返回的 SYN+ACK 的返回包，才会进入 TCP 的连接状态。

因而，开启 SYN Cookies 后，就不需要维护半开连接状态了，进而也就没有了半连接数的限制。

> 注意，开启 TCP syncookies 后，内核选项 net.ipv4.tcp_max_syn_backlog 也就无效了。

    sysctl -w net.ipv4.tcp_syncookies=1


注意，上述 sysctl 命令修改的配置都是临时的，重启后这些配置就会丢失。所以，为了保证配置持久化，你还应该把这些配置，写入 /etc/sysctl.conf 文件中。比如：

    $ cat /etc/sysctl.conf
    net.ipv4.tcp_syncookies = 1
    net.ipv4.tcp_synack_retries = 1
    net.ipv4.tcp_max_syn_backlog = 1024

不过要记得，写入 `/etc/sysctl.conf` 的配置，需要执行 sysctl -p 命令后，才会动态生效。