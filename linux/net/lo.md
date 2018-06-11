> [参考地址](https://blog.csdn.net/Hai__Yun/article/details/77478866)

### linux 回环地址测试

主机IP| lo 
---|---
192.168.8.128 | 6.6.6.6 
192.168.8.129 | 6.6.6.7

**回环网卡:**

> 回环网卡（Looback adaptor），是一种特殊的网络接口，不与任何实际设备连接，而是完全由软件实现。与回环地址（127.0.0.0/8 或 ::1/128）不同，回环网卡对系统“显示”为一块硬件。任何发送到该网卡上的数据都将立刻被同一网卡接收到。例子有 Linux 下的 lo 接口和 Windows 下的 Microsoft Loopback Interface 网卡。


主要步骤：
--
- 配置回环网卡IP地址
- 配置R1路由，并测试
- 配置R2路由，并测试

网络拓扑：
--

![image](http://oj74t8laa.bkt.clouddn.com/image/markdown/net/20170822131738953.png)


1.配置回环网卡IP地址
----

R1 IP

1.配置回环网卡IP地址
---
R1 IP

    [root@R1 ~]# ifconfig lo 6.6.6.6/32
    [root@R1 ~]# ifconfig 
    eth1      Link encap:Ethernet  HWaddr 00:0C:29:DE:D2:8C  
              inet addr:192.168.8.128  Bcast:192.168.8.255  Mask:255.255.255.0
              inet6 addr: fe80::20c:29ff:fede:d28c/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:1984 errors:0 dropped:0 overruns:0 frame:0
              TX packets:746 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:205781 (200.9 KiB)  TX bytes:93530 (91.3 KiB)
    
    lo        Link encap:Local Loopback  
              inet addr:6.6.6.6  Mask:0.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:65536  Metric:1
              RX packets:20 errors:0 dropped:0 overruns:0 frame:0
              TX packets:20 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:1680 (1.6 KiB)  TX bytes:1680 (1.6 KiB)
R2 IP
---

    [root@R2 ~]# ifconfig lo 6.6.6.7/32 
    [root@R2 ~]# ifconfig 
    eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.8.129  netmask 255.255.255.0  broadcast 192.168.8.255
            inet6 fe80::9a60:de90:dbbb:6adb  prefixlen 64  scopeid 0x20<link>
            ether 00:0c:29:57:4a:72  txqueuelen 1000  (Ethernet)
            RX packets 1161  bytes 106219 (103.7 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 797  bytes 120074 (117.2 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    
    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 6.6.6.7  netmask 0.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1  (Local Loopback)
            RX packets 85  bytes 7252 (7.0 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 85  bytes 7252 (7.0 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

注意：将lo设置成32位掩码，标记了它在这个网段是唯一的IP

2.配置R1路由，并测试
---
在我们配置路由前先ping一下R2

    [root@R1 ~]# ping -c 1  6.6.6.7                 <==ping不通
    PING 6.6.6.7 (6.6.6.7) 56(84) bytes of data.
    
    --- 6.6.6.7 ping statistics ---
    1 packets transmitted, 0 received, 100% packet loss, time 10006ms

为R1配置路由后，再来ping

    [root@R1 ~]# route add -host 6.6.6.7 gw 192.168.8.128   <==添加路由指向本地IP 192.168.8.128 
    [root@R1 ~]# ping -c 1  6.6.6.7         <==已经ping通
    PING 6.6.6.7 (6.6.6.7) 56(84) bytes of data.
    64 bytes from 6.6.6.7: icmp_seq=1 ttl=64 time=2.91 ms
    
    --- 6.6.6.7 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 3ms
    rtt min/avg/max/mdev = 2.916/2.916/2.916/0.000 ms

在R1上面指定用6.6.6.6这个IP去ping6.6.6.7

    [root@R1 ~]# ping -I 6.6.6.6 -c 1 6.6.6.7       <==可以看到是ping不同的
    PING 6.6.6.7 (6.6.6.7) from 6.6.6.6 : 56(84) bytes of data.
    
    --- 6.6.6.7 ping statistics ---
    1 packets transmitted, 0 received, 100% packet loss, time 10002ms

在R2上面的eth1抓包

    [root@R2 ~]# tcpdump -i eth1 icmp                <==在eth1收到了ping包，可以看到回应的IP并不是6.6.6.6而是eth1的IP
    tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
    listening on eth1, link-type EN10MB (Ethernet), capture size 65535 bytes
    11:02:45.108977 IP 192.168.8.128 > 6.6.6.7: ICMP echo request, id 59146, seq 1, length 64
    11:02:45.109004 IP 6.6.6.7 > 192.168.8.128: ICMP echo reply, id 59146, seq 1, length 64
    ^C
    2 packets captured
    2 packets received by filter
    0 packets dropped by kernel

注意：使用R1 eth1 是可以ping通的。

3.配置R2路由，并测试
--
    [root@R2 ~]# route add -host 6.6.6.6 gw 192.168.8.129       <==添加路由指向本地IP 192.168.8.129
    [root@R2 ~]# ping -c 1 6.6.6.6                          <==可以ping通
    PING 6.6.6.6 (6.6.6.6) 56(84) bytes of data.
    64 bytes from 6.6.6.6: icmp_seq=1 ttl=64 time=0.236 ms
    
    --- 6.6.6.6 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.236/0.236/0.236/0.000 ms

此时，我们再次在R2上面的eth1抓包

在R1上面指定用6.6.6.6这个IP去ping6.6.6.7

    [root@R2 ~]# tcpdump -i eth1 -n icmp            <==回应的IP已变为6.6.6.7
    [root@R1 ~]# ping -I 6.6.6.6 -c 1 6.6.6.7       <==在R1指定6.6.6.6 去ping 6.6.6.7
    PING 6.6.6.7 (6.6.6.7) from 6.6.6.6 : 56(84) bytes of data.
    64 bytes from 6.6.6.7: icmp_seq=1 ttl=64 time=0.186 ms
    
    --- 6.6.6.7 ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 0.186/0.186/0.186/0.000 ms
    [root@R2 ~]# tcpdump -i eth1 -n icmp        <==可以看到6.6.6.6和6.6.6.7 已经正常通信了
    tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
    listening on eth1, link-type EN10MB (Ethernet), capture size 65535 bytes
    11:06:05.367837 IP 6.6.6.6 > 6.6.6.7: ICMP echo request, id 61194, seq 1, length 64
    11:06:05.367892 IP 6.6.6.7 > 6.6.6.6: ICMP echo reply, id 61194, seq 1, length 64
    ^C
    2 packets captured
    2 packets received by filter
    0 packets dropped by kernel

知识点：
---
**为什么配置路由后就可以ping了呢？**

因为：IP地址是工作在内核级别的，是全局有效的，所以说当R1发广播寻找6.6.6.7时，那么R2会收到R1的广播，发现自己有6.6.6.7的IP就回应了。

**为什么R1发广播R2回收到呢？**

因为：R2的eth1网卡和R1的eth1网卡是同一个网段的并且还是同一个交换机，相互能够通信。

**为什么配置路由就可以通信了呢？**

因为：当我们指令发送到内核后，内核会判断如果是同一网段，那么就发ARP广播，如果不是就送给网关。因为我们直接定义了路由：如果要找6.6.6.7这个IP那么就发给192.168.8.128这个IP，而且R1和R2的eth1网卡还能通信所以，R1和R2的lo网卡也就能够通信了。



