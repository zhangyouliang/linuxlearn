> nmap 端口扫描工具

> [参考](https://www.whatdy.com/articles/2018/04/linux-internet-security.html)

参数
---

扫描方式选项

    -sS/sT/sA/sW/sM:指定使用 TCP SYN/Connect()/ACK/Window/Maimon scans的方式来对目标主机进行扫描。
    -sU: 指定使用UDP扫描方式确定目标主机的UDP端口状况。
    -sN/sF/sX: 指定使用TCP Null, FIN, and Xmas scans秘密扫描方式来协助探测对方的TCP端口状态。
    --scanflags <flags>: 定制TCP包的flags。
    -sI <zombiehost[:probeport]>: 指定使用idle scan方式来扫描目标主机（前提需要找到合适的zombie host）
    -sY/sZ: 使用SCTP INIT/COOKIE-ECHO来扫描SCTP协议端口的开放的情况。
    -sO: 使用IP protocol 扫描确定目标机支持的协议类型。
    -b <FTP relay host>: 使用FTP bounce scan扫描方式

端口参数与扫描顺序

    -p <port ranges>: 扫描指定的端口

    实例: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9（其中T代表TCP协议、U代表UDP协议、S代表SCTP协议）

    -F: Fast mode – 快速模式，仅扫描TOP 100的端口

    -r: 不进行端口随机打乱的操作（如无该参数，nmap会将要扫描的端口以随机顺序方式扫描，以让nmap的扫描不易被对方防火墙检测到）。

    --top-ports <number>:扫描开放概率最高的number个端口（nmap的作者曾经做过大规模地互联网扫描，以此统计出网络上各种端口可能开放的概率。以此排列出最有可能开放端口的列表，具体可以参见文件：nmap-services。默认情况下，nmap会扫描最有可能的1000个TCP端口）

    --port-ratio <ratio>: 扫描指定频率以上的端口。与上述--top-ports类似，这里以概率作为参数，让概率大于--port-ratio的端口才被扫描。显然参数必须在在0到1之间，具体范围概率情况可以查看nmap-services文件。
    -sV: 指定让Nmap进行版本侦测
    -O: 指定Nmap进行OS侦测。

规避用法

    -f; --mtu <val>: 指定使用分片、指定数据包的MTU.
    -D <decoy1,decoy2[,ME],...>: 用一组IP地址掩盖真实地址，其中ME填入自己的IP地址。
    -S <IP_Address>: 伪装成其他IP地址
    -e <iface>: 使用特定的网络接口
    -g/--source-port <portnum>: 使用指定源端口
    --data-length <num>: 填充随机数据让数据包长度达到Num。
    --ip-options <options>: 使用指定的IP选项来发送数据包。
    --ttl <val>: 设置time-to-live时间。
    --spoof-mac <mac address/prefix/vendor name>: 伪装MAC地址
    --badsum: 使用错误的checksum来发送数据包（正常情况下，该类数据包被抛弃，如果收到回复，说明回复来自防火墙或IDS/IPS）。



例子
---

    # 完整扫描(-T4指定扫描过程使用的时序（Timing），总有6个级别（0-5),-A选项用于使用进攻性（Aggressive）方式扫描；)
    nmap –T4 –A –v targethost
    nmap 118.31.78.77    
    nmap -PS 118.31.78.77
    # 扫描一个ip 多个端口
    nmap 118.31.78.77 -p20-200,7777,8888
    # 扫描多个地址时排除文件里面的ip地址
    nmap 10.0.1.161-163  --excludefile ex.txt
    # 排除分散的,使用逗号分隔
    nmap 10.0.1.161-163 --exclude 10.0.1.161,10.0.1.163
    # 排除连续的，可以使用横线连接起来
    nmap 10.0.1.161-163 --exclude 10.0.1.162-163
    # 扫描文件中的ip
    nmap -iL ip.txt
    # 扫描一个子网网段所有ip
    nmap 10.0.3.0/24
    # 扫描开放ssh的机器
    nmap -sV -p22 -oG ssh 69.163.190.0/24

规避用法

    nmap -v -F -Pn -D192.168.1.100,192.168.1.102,ME -e eth0 -g 3355 192.168.1.1

其中，-F表示快速扫描100个端口；-Pn表示不进行Ping扫描；-D表示使用IP诱骗方式掩盖自己真实IP（其中ME表示自己IP）；-e eth0表示使用eth0网卡发送该数据包；-g 3355表示自己的源端口使用3355；192.168.1.1是被扫描的目标IP地址。


