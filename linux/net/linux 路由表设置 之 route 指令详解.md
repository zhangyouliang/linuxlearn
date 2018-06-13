> [转载自:linux 路由表设置 之 route 指令详解](http://blog.csdn.net/chenlycly/article/details/52141854)

语法
---
    route [-CFvnee]
    route  [-v]  [-A family] add [-net|-host] target [netmask Nm] [gw Gw] [metric N]
          [mss M] [window W] [irtt I] [reject] [mod] [dyn] [reinstate] [[dev] If]
    
    route  [-v] [-A family] del [-net|-host] target [gw Gw] [netmask Nm] [metric  N]
          [[dev] If]
    
    route  [-V] [--version] [-h] [--help]
    

选项
---

    -A：设置地址类型；
    -C：打印将Linux核心的路由缓存；
    -v：详细信息模式；
    -n：不执行DNS反向查找，直接显示数字形式的IP地址；
    -e：netstat格式显示路由表；
    -net：到一个网络的路由表；
    -host：到一个主机的路由表。
    
参数
---

- add：增加指定的路由记录；
- del：删除指定的路由记录；
- target：目的网络或目的主机；
- gw：设置默认网关；
- mss：设置TCP的最大区块长度（MSS），单位MB；
- window：指定通过路由表的TCP连接的TCP窗口大小；
- dev：路由记录所表示的网络接口。
- -net: 目标是一个网络
- -host: 目标是一个主机


    ➜  ~ route -n                 
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         10.0.2.2        0.0.0.0         UG    100    0        0 enp0s3
    0.0.0.0         192.168.0.1     0.0.0.0         UG    101    0        0 enp0s9
    10.0.2.0        0.0.0.0         255.255.255.0   U     100    0        0 enp0s3
    169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 enp0s8
    172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
    172.17.8.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s8
    192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s9


> 192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s9

这条表示如果数据包目的地是 `192.168.0/24`范围内,就不需要静态路由了，直接通过上联交换机转发就OK了。因为目的地址和`enp0s9`在同一个网段中，直接通过ARP协议获取目的机器物理地址，直接发送就OK了，不需要路由器或网关的转发。其中 `Gateway=0.0.0.0`就表示不需要指定网关，直接发送就OK了


> 169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 enp0s8
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0

如果目的地址是私网网段，如果目标为 `169.254.0/24` 网段内,数据通过arp协议,直接走 `enp0s8` 网卡,

如果是`172.17.0/24`网段,全部走 `docker0` 网卡,也就是 `docker` 内部网络

> 0.0.0.0         10.0.2.2        0.0.0.0         UG    100    0        0 enp0s3
0.0.0.0         192.168.0.1     0.0.0.0         UG    101    0        0 enp0s9

表示当目的地址没有匹配到任何一条路由规则时，就会被发送到缺省路由。这里表示发送到公网的默认网关地址，且数据包从 enp0s3 发送出去(注意,优先级比第二条高)。

> 备注：我们可以使用traceroute命令，来验证上述的路由规则哦







route 命令的输出项说明
----
输出项 说明

Destination	| 目标网段或者主机 最长匹配192.168.161.0 > 192.168.0.0 > 0.0.0.0，(0.0.0.0可匹配任意数值)
---|---
Gateway | 	网关地址，”*” 表示目标是本主机所属的网络，不需要路由
Genmask| 	网络掩码
Flags| 	标记。一些可能的标记如下：
 -	| U — 路由是活动的
 -	| H — 目标是一个主机
 -	| G — 路由指向网关
 -	| R — 恢复动态路由产生的表项
 -	| D — 由路由的后台程序动态地安装
 -	| M — 由路由的后台程序修改
 -	| ! — 拒绝路由
Metric	| 路由距离，到达指定网络所需的中转数（linux 内核中没有使用）(越小越优先)
Ref	| 路由项引用次数（linux 内核中没有使用）
Use	| 此路由项被路由软件查找的次数
Iface	| 该路由表项对应的输出接口

匹配规则
----
[参考](https://www.jianshu.com/p/a1ab0b30f42b)

 

三种路由类型
---

主机路由: (H): 主机路由是路由选择表中指向单个IP地址或主机名的路由记录。
在下面的示例中，本地主机通过IP地址 `192.168.1.1` 的路由器到达IP地址为 `10.0.0.10` 的主机。

    Destination    Gateway       Genmask Flags     Metric    Ref    Use    Iface
    -----------    -------     -------            -----     ------    ---    ---    -----
    10.0.0.10     192.168.1.1    255.255.255.255   UH       0    0      0    eth0

网络路由: (N): 网络路由是代表主机可以到达的网络

本地主机将发送到网络`192.19.12` 的数据包转发到IP地址为`192.168.1.1`的路由器。

    Destination    Gateway       Genmask Flags    Metric    Ref     Use    Iface
    -----------    -------     -------         -----    -----   ---    ---    -----
    192.19.12     192.168.1.1    255.255.255.0      UN      0       0     0    eth0

默认路由: (G)
例如，在下面的示例中，默认路由是IP地址为 192.168.1.1 的路由器。
    
    Destination    Gateway       Genmask Flags     Metric    Ref    Use    Iface
    -----------    -------     ------- -----      ------    ---    ---    -----
    default       192.168.1.1     0.0.0.0    UG       0        0     0    eth0

使用例子
---

添加主机到路由
    
    route add -host 192.168.1.2 dev eth0 
    # 添加到  192.168.0.1 网关
    route add -host 192.168.0.111 gw 192.168.0.1

添加网络到路由
    
    # 添加一个网络路由:127.0.0.0 子网掩码: 255.0.0.0 ,网卡为 lo
    route add -net 127.0.0.0 netmask 255.0.0.0 dev lo
    route add -net 10.20.30.40 netmask 255.255.255.248 eth0   #添加10.20.30.40的网络
    route add -net 10.20.30.48 netmask 255.255.255.248 gw 10.20.30.41 #添加 10.20.30.48 的网络
    route add -net 192.168.1.0/24 eth1
    
添加默认路由
    
    route add default gw 192.168.1.1

删除
 
    route del -net 127.0.0.0 netmask 255.0.0.0 dev lo
    route del -host 192.168.1.2 dev eth0:0
    route del -host 10.20.30.148 gw 10.20.30.40
    route del -net 10.20.30.40 netmask 255.255.255.248 eth0
    route del -net 10.20.30.48 netmask 255.255.255.248 gw 10.20.30.41
    route del -net 192.168.1.0/24 eth1
    route del default gw 192.168.1.1
   
linux 下面永久添加路由
    
       1.在/etc/rc.local里添加    
        
       方法：
    　　route add -net 192.168.3.0/24 dev eth0    
    
    　　route add -net 192.168.2.0/24 gw 192.168.3.254    
    
    　　2.在/etc/sysconfig/network里添加到末尾    
    
    　　方法：GATEWAY=gw-ip 或者 GATEWAY=gw-dev    
    
    　　3./etc/sysconfig/static-router :    
    
    　　any net x.x.x.x/24 gw y.y.y.y    

拓展
---

ip 命令

arp 命令
