> DDOS的全称是Distributed Denial of Service，即"分布式拒绝服务攻击"，是指击者利用大量“肉鸡”对攻击目标发动大量的正常或非正常请求、耗尽目标主机资源或网络资源，从而使被攻击的主机不能为合法用户提供服务。

> [参考](https://www.cnblogs.com/kevingrace/p/6756515.html)

    
`DDOS攻击的本质是`： 利用木桶原理，寻找利用系统应用的瓶颈；阻塞和耗尽；当前问题：用户的带宽小于攻击的规模，噪声访问带宽成为木桶的短板。

`对于DDOS攻击的简单防护措施：`   
   
    1）关闭不必要的服务和端口；
    2）限制同一时间内打开的syn半连接数目；
    3）缩短syn半连接的超时时间；
    4）及时安装系统补丁；
    5）禁止对主机非开放服务的访问；
    6）启用防火墙防DDOS属性。硬件防火墙价格比较昂贵，可以考虑利用Linux系统本身提供的防火墙功能来防御。
    7）另外也可以安装相应的防护软件，这里强烈建议安装安全狗软件,防护性能不错，并且免费。
    8）购买DDOS防御产品，比如阿里云盾的DDOS防御中的高防IP，这个使用起来，效果也很给力。

接下来说下Linux系统下预防DDOS攻击的操作：

    Linux服务器在运行过程中可能会受到黑客攻击，常见的攻击方式有SYN，DDOS等。
    通过更换IP，查找被攻击的站点可能避开攻击，但是中断服务的时间比较长。比较彻底的解决方法是添置硬件防火墙，但是硬件防火墙价格比较昂贵。可以考虑利用Linux系统本身提供的防火墙功能来防御。
    SYN攻击是利用TCP/IP协议3次握手的原理，发送大量的建立连接的网络包，但不实际建立连接，最终导致被攻击服务器的网络队列被占满，无法被正常用户访问。
    Linux内核提供了若干SYN相关的配置，加大SYN队列长度可以容纳更多等待连接的网络连接数，打开SYN Cookie功能可以阻止部分SYN攻击，降低重试次数也有一定效果。
    而DDOS则是通过使网络过载来干扰甚至阻断正常的网络通讯，通过向服务器提交大量请求，使服务器超负荷，阻断某一用户访问服务器阻断某服务与特定系统或个人的通讯。可以通过配置防火墙或者使用脚本工具来防范DDOS攻击；

1）优化几个sysctl内核参数：
---



2）利用linux系统自带iptables防火墙进行预防：
---
    
    # 查看80端口的连接情况
    netstat -an | grep ":80" | grep ESTABLISHED
    
    # 下面的命令表示获取服务器上ESTABLISHED连接数最多的前10个ip，排除了内部ip段192.168|127.0开头的。
    netstat -an | grep ESTABLISHED | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -rn | head -10 | grep -v -E '192.168|127.0'
    
    # 将上面140.205.140.205、124.65.197.154、111.205.224.15的这三个ip的包丢弃
    # <<很好用>>
    iptables -A INPUT -s 140.205.140.205 -p tcp -j DROP
    iptables -A INPUT -s 124.65.197.154 -p tcp -j DROP
    iptables -A INPUT -s 111.205.224.15 -p tcp -j DROP
    # save
    service iptables save
    service iptables restart
    
    -------------------------------------其他预防攻击的设置-------------------------------------
    # 防止同步包洪水（Sync Flood），缩短SYN-Timeout时间：
    iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
    iptables -A INPUT -i eth0 -m limit --limit 1/sec --limit-burst 5 -j ACCEPT
    --limit 1/s 限制syn并发数每秒1次，可以根据自己的需要修改防止各种端口扫描
    
    iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
    
    # Ping洪水攻击（Ping of Death）
    iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
    
    # 控制单个IP的最大并发连接数。
    # 如下设置表示：允许单个IP的最大连接数为 30
    # <<很好用>>
    iptables -I INPUT -p tcp --dport 80 -m connlimit --connlimit-above 30 -j REJECT
    
    # 控制单个IP在一定的时间（比如60秒）内允许新建立的连接数。
    # 如下设置表示：单个IP在60秒内只允许最多新建30个连接
    iptables -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --update --seconds 60 --hitcount 30 -j REJECT
    iptables -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --set -j ACCEPT
    
    ---------------------------------------------------------------------------------------------------
    如果出现报错：
    iptables: Invalid argument. Run `dmesg' for more information.
     
    解决办法：
    增加 xt_recent模块的参数值即可，默认是20
    [root@test3-237 ~]# cat /sys/module/xt_recent/parameters/ip_pkt_list_tot
    20
    [root@test3-237 ~]# echo 50 > /sys/module/xt_recent/parameters/ip_pkt_list_tot
    [root@test3-237 ~]# cat /sys/module/xt_recent/parameters/ip_pkt_list_tot
    50
    ---------------------------------------------------------------------------------------------------
    
    # 禁止ping（即禁止从外部ping这台服务器）：
    # <<很好用>>
    [root@test3-237 ~]# echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
     
    用iptables屏蔽IP（如下禁止213.8.166.237连接本机的80端口）
    [root@test3-237 ~]# iptables -A INPUT -s 213.8.166.227 -p tcp -m tcp -m state --state NEW --dport 80 --syn -j REJECT
     
    允许某ip连接（如下允许13.78.66.27连接本机的80端口）
    [root@test3-237 ~]# iptables -A INPUT -s 13.78.66.27 -p tcp -m tcp -m state --state NEW --dport 80 --syn -j ACCEPT
    
3）使用DDoS deflate脚本自动屏蔽攻击ip  
----

    DDoS deflate是一款免费的用来防御和减轻DDoS攻击的脚本。它通过netstat监测跟踪创建大量网络连接的IP地址，在检测到某个结点超过预设的限制时，该程序会通过APF或IPTABLES禁止或阻挡这些IP.
    DDoS deflate其实是一个Shell脚本，使用netstat和iptables工具，对那些链接数过多的IP进行封锁，能有效防止通用的恶意扫描器，但它并不是真正有效的DDoS防御工具。
     
    DDoS deflate工作过程描述：
    同一个IP链接到服务器的连接数到达设置的伐值后，所有超过伐值的IP将被屏蔽，同时把屏蔽的IP写入ignore.ip.list文件中，与此同时会在tmp中生成一个脚本文件，这个脚本文件马上被执行，但是一
    运行就遇到sleep预设的秒，当睡眠了这么多的时间后，解除被屏蔽的IP，同时把之前写入ignore.ip.list文件中的这个被封锁的IP删除，然后删除临时生成的文件。
    一个事实：如果被屏蔽的IP手工解屏蔽，那么如果这个IP继续产生攻击，那么脚本将不会再次屏蔽它（因为加入到了ignore.ip.list），直到在预设的时间之后才能起作用，加入到了ignore.ip.list中的
    IP是检测的时候忽略的IP。可以把IP写入到这个文件以避免这些IP被堵塞，已经堵塞了的IP也会加入到ignore.ip.list中，但堵塞了预定时间后会从它之中删除。
     
    如何确认是否受到DDOS攻击？
    [root@test3-237 ~]# netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
          1 Address
          1 servers)
          2 103.10.86.5
          4 117.36.231.253
          4 19.62.46.24
          6 29.140.22.18
          8 220.181.161.131   
          2911 167.215.42.88
     
    每个IP几个、十几个或几十个连接数都还算比较正常，如果像上面成百上千肯定就不正常了。比如上面的167.215.42.88，这个ip的连接有2911个！这个看起来就很像是被攻击了！
     
    下面就说下通过DDoS deflate脚本来自动屏蔽DDOS攻击的ip
    1）下载DDoS deflate安装脚本，并执行安装。
    [root@test3-237 ~]# wget http://www.inetbase.com/scripts/ddos/install.sh
    [root@test3-237 ~]# chmod 0700 install.sh
    [root@test3-237 ~]# ./install.sh
     
    --------------------------------------------------------------------------
    卸载DDos default的操作如下：
    # wget http://www.inetbase.com/scripts/ddos/uninstall.ddos
    # chmod 0700 uninstall.ddos
    # ./uninstall.ddos
    --------------------------------------------------------------------------
     
    2）配置DDoS deflate下面是DDoS deflate的默认配置位于/usr/local/ddos/ddos.conf ，内容如下：
    [root@test3-237 ~]# cat /usr/local/ddos/ddos.conf
    ##### Paths of the script and other files
    PROGDIR="/usr/local/ddos"
    PROG="/usr/local/ddos/ddos.sh"
    IGNORE_IP_LIST="/usr/local/ddos/ignore.ip.list"         //IP地址白名单
    CRON="/etc/cron.d/ddos.cron"                            //定时执行程序
    APF="/etc/apf/apf"
    IPT="/sbin/iptables"
     
    ##### frequency in minutes for running the script
    ##### Caution: Every time this setting is changed, run the script with --cron
    #####          option so that the new frequency takes effect
    FREQ=1                        //检查时间间隔，默认1分钟。设置检测时间间隔，默认是分钟，由于系统使用crontab功能，最小单位是分钟
     
    ##### How many connections define a bad IP? Indicate that below.
    NO_OF_CONNECTIONS=150             //最大连接数，超过这个数IP就会被屏蔽，一般默认即可。默认是150，这是一个经验值，如果服务器性能比较高，可以设置200以上，以避免误杀
     
    ##### APF_BAN=1 (Make sure your APF version is atleast 0.96)
    ##### APF_BAN=0 (Uses iptables for banning ips instead of APF)
    APF_BAN=0                      //使用APF还是iptables屏蔽IP。推荐使用iptables,将APF_BAN的值改为0即可。设置为1表示使用APF，如果使用APF则需要先安装，centos中默认就没有安装
     
    ##### KILL=0 (Bad IPs are'nt banned, good for interactive execution of script)
    ##### KILL=1 (Recommended setting)
    KILL=1                        //是否屏蔽IP，默认即可
     
    ##### An email is sent to the following address when an IP is banned.
    ##### Blank would suppress sending of mails
    EMAIL_TO="root"              //当IP被屏蔽时给指定邮箱发送邮件，推荐使用，换成自己的邮箱即可。如果不希望发送邮件，设置为空，即EMAIL_TO=""
     
    ##### Number of seconds the banned ip should remain in blacklist.
    BAN_PERIOD=600              //禁用IP时间（锁定ip的时间），默认600秒，可根据情况调整
     
     
    需要注意的是：
    DDos default安装完成后在/usr/local/ddos目录下产生了ddos.conf、ddos.sh、ignore.ip.list和LICENSE这四个文件，其中：
    ddos.conf是配置文件，ddos.sh是一个Shell文件，ignore.ip.list是存放忽略IP的文件，LICENSE是版权声明文件，安装完成后还在/etc/cron.d/下生产了ddos.cron文件，内容如下：
     
    [root@test3-237 ~]# cat /etc/cron.d/ddos.cron
    SHELL=/bin/sh
    0-59/1 * * * * root /usr/local/ddos/ddos.sh >/dev/null 2>&1
     
    意思是每隔一分钟执行一下/usr/local/ddos/ddos.sh，这个脚本是关键！
    这个cron任务是依赖ddos.conf文件中的NO_OF_CONNECTIONS变量产生的，如果修改了此值，可以通过运行如下命令更新（实际也是在安装是运行了如下命令）：
    [root@test3-237 ~]# /usr/local/ddos/ddos.sh -c
    Stopping crond:                                            [  OK  ]
    Starting crond:                                            [  OK  ]
    Stopping crond:                                            [  OK  ]
    Starting crond:                                            [  OK  ]
     
    或者
    [root@test3-237 ~]# /usr/local/ddos/ddos.sh --cron
    Stopping crond:                                            [  OK  ]
    Starting crond:                                            [  OK  ]
    Stopping crond:                                            [  OK  ]
    Starting crond:                                            [  OK  ]
     
     
    3）DDos default选项
    # /usr/local/ddos/ddos.sh -h       #查看选项
    # /usr/local/ddos/ddos.sh -k n     #杀掉连接数大于n的连接。n默认为配置文件的NO_OF_CONNECTIONS
      比如：
      [root@test3-237 ~]# /usr/local/ddos/ddos.sh -k 150
          2 103.110.186.75
          1 servers)
          1 Address
    # /usr/local/ddos/ddos.sh -c       #按照配置文件创建一个执行计划。使得ddos.conf文件配置后生效

4）分享一个防御DDOS攻击的shell脚本
----
    
    Linux服务器中一旦受到DDOS的攻击（比如IDC机房服务器被攻击了，关机，拔网线，降流量），目前只能通过封IP来源来暂时解决。
    然而IP来源变化多端，光靠手工来添加简直是恶梦，所以还是想办法写个shell脚本来定时处理，这才是比较靠谱的办法。
     
    [root@test3-237 ~]# mkdir /root/bin
    [root@test1-237 ~]# cat /root/bin/dropip.sh    //此脚本自动提取攻击ip，然后自动屏蔽
    #!/bin/bash
    /bin/netstat -na|grep ESTABLISHED|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -rn|head -10|grep -v -E '192.168|127.0'|awk '{if ($2!=null && $1>4) {print $2}}'>/tmp/dropip
    for i in $(cat /tmp/dropip)
    do
    /sbin/iptables -A INPUT -s $i -j DROP
    echo “$i kill at `date`”>>/var/log/ddos
    done
     
    以上脚本中最重要的是第二行，即：
    获取ESTABLISHED连接数最多的前10个ip并写入临时文件/tmp/dropip,排除了内部ip段192.168|127.0开头的.通过for循环将dropip里面的ip通过iptables全部drop掉，然后写到日志文件/var/log/ddos。
     
     
    给脚本添加执行权限
    [root@test1-237 ~]# chmod +x /root/bin/dropip.sh
     
    添加到计划任务，每分钟执行一次
    [root@test1-237 ~]#crontab -e
    */1 * * * * /root/bin/dropip.sh
     
    ----------------------------------------------------------------------------------------
    下面是针对连接数屏蔽IP
    #!/bin/sh 
    /bin/netstat -ant |grep 80 |awk '{print $5}' |awk -F":" '{print $1}' |sort |uniq -c |sort -rn |grep -v -E '192.168|127.0' |awk '{if ($2!=null && $1>50)}' > /root/drop_ip.txt 
    for i in `cat /root/drop_ip.txt` 
    do 
    /sbin/iptables -I INPUT -s $i -j DROP; 

5）Linux下使用safedog（安全狗）软件防御DDOS攻击:
---

    [root@test3-237 ~]# setenforce 0     //关闭selinux，否则不能安装成功
    [root@test3-237 ~]# getenforce       //永久关闭selinux需要配置/etc/sysconfig/selinux文件，并重启机器生效！！
    Permissive
     
    安装（nginx版）安全狗（safedog）
    [root@test3-237 ~]# wget http://safedog.cn/safedogwz_linux_Nginx64.tar.gz
    [root@test3-237 ~]# tar -zvxf safedogwz_linux_Nginx64.tar.gz
    [root@test3-237 ~]# cd safedogwz_linux_Nginx64
    [root@test3-237 safedogwz_linux_Nginx64]# chmod 755 install.py
    [root@bastion-IDC safedogwz_linux_Nginx64]# ls
    install_files  install.py  uninstall.py
    [root@test3-237 safedogwz_linux_Nginx64]# ./install.py -A          //卸载安全狗就用uninstall.py
    .......
      step 3.5, start service...                                                                      [ok]
      step 3.6, save safedog install info...                                                          [ok]
       Tips:
      (1)Run the command to setup Server Defense Module: sdui
      (2)Explore more features by tapping the command to join Cloud Management Center (fuyun.safedog.cn) with your account:  sdcloud -h
     
    If you need any help about installation,please tap the command: ./install.py -h
    Install Completely!
     
     
    温馨提示：
    1）安装完成后，记得一定要重新启动Nginx服务，网站安全狗软件即可生效。
    2）运行时,安装脚本默认将自动获取Nginx服务的安装路径；若自动获取失败则将提示输入Nginx服务的安装路径（绝对路径），需要根据所安装的Nginx的目录，填写真实的安装路径。
    3）当出现提示：Are you sure to uninstall?[y/n]时，输入y