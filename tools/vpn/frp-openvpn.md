通过 FRP 内网穿透并实现 VNC 远程访问 Mac 桌面
====

- 10.0.0.148 外网服务器中转(通过 Tunnelblick 隧道工具管理)
    - openvpn 使用 docker 搭建,所以配置好 Tunnelblick 之后,本地网络即可打通与 10.0.0.148 所在的 docker 集群网络
- 192.168.1.122 本地 mac 电脑(即需要操控的电脑)

介绍: 利用现有 Tunnelblick 工具. !!!阿里云ecs,负载均衡不需要开启对应端口

> !!! 这里可以不使用  Tunnelblick ,使用 外网 ip 直接映射也可以,需要打开端口 [tcp  6000/6000 (frp ssh) , 5900/5900 (frp vnc) , 7000/7000 (frp server_port) udp: 7000/7000 (frp kcp) ]

```bash
# 根据平台下载,frp 下载页面 https://github.com/fatedier/frp/releases
# mac 平台
wget https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_darwin_amd64.tar.gz
# linux 平台
wget https://github.com/fatedier/frp/releases/download/v0.33.0/frp_0.33.0_linux_amd64.tar.gz
```


10.0.0.148 

```bash
# 打开 Tunnelblick
# 打通 10.0.0.148 与本地的网络 
sudo route -n add -host 10.0.0.148  10.8.0.1   
# 编辑 frps.ini
cat >> /etc/frp/frps.ini << EOF
[common]
bind_port = 7000
kcp_bind_port = 7000
token=xxxxxx # 自行替换
EOF

cp systemd/frps.service /lib/systemd/system/frps.service
# 重新加载配置
systemctl daemon-reload
# 启动 frps 开机启动
systemctl enable frps.service
# 启动 frps 
systemctl start frps.service
# 实时追踪日志 
journalctl -u frps -f

```

192.168.1.122
```bash

cat >> frpc.ini << EOF
[common]
server_addr = 10.0.0.148
server_port = 7000
protocol = kcp
token = xxxxxx # 自行替换

[vnc]
type = tcp
local_ip = 127.0.0.1
local_port = 5900
remote_port = 5900
use_encryption = true
use_compression = true

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
use_encryption = true
use_compression = true
EOF

# 简单测试 
# ./frpc -c frpc.ini

mkdir -p /usr/local/bin/frpc/ && cp frpc frpc.ini /usr/local/bin/frpc/
cat >>  ~/Library/LaunchAgents/frpc.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC -//Apple Computer//DTD PLIST 1.0//EN
http://www.apple.com/DTDs/PropertyList-1.0.dtd >
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>frpc</string>
    <key>ProgramArguments</key>
    <array>
     <string>/usr/local/bin/frpc/frpc</string>
         <string>-c</string>
     <string>/usr/local/bin/frpc/frpc.ini</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
# 加载并生效
sudo chown root ~/Library/LaunchAgents/frpc.plist
sudo launchctl load -w ~/Library/LaunchAgents/frpc.plist


# 二选一
# 开启远程共享
- 屏幕共享
- 远程登录

# 开启 ssh 登录
- 远程登录
- 远程管理



```


本地机器 vnc 屏幕共享
````bash
# 打开 Tunnelblick 
# 打通 10.0.0.148 与本地的网络
sudo route -n add -host 10.0.0.148  10.8.0.1   
````

mac 电脑打开 finder > 前往 > 连接服务器

```bash
# vnc://10.0.0.148:5900
# 输入用户名 & 密码 即可登录
```

本地机器 vnc ssh 登录
```bash

ssh <用户名>@10.0.0.148 -p 6000
```


解决 本地 mac 无法访问 10.0.0.148,但是可以访问 docker 所在集群问题
====

- 10.0.0.148 外网服务器中转(通过 Tunnelblick 隧道工具管理)
    - openvpn 使用 docker 搭建,所以配置好 Tunnelblick 之后,本地网络即可打通与 10.0.0.148 所在的 docker 集群网络
- 192.168.1.122 本地 mac 电脑(即需要操控的电脑)

````
Last login: Fri Jul 24 14:52:13 from 192.168.1.118
➜  ~ ping 10.0.0.148
PING 10.0.0.148 (10.0.0.148): 56 data bytes
Request timeout for icmp_seq 0
Request timeout for icmp_seq 1
^C
--- 10.0.0.148 ping statistics ---
3 packets transmitted, 0 packets received, 100.0% packet loss
➜  ~ ping 10.42.212.115 # docker 其中一个容器 ip
PING 10.42.212.115 (10.42.212.115): 56 data bytes
64 bytes from 10.42.212.115: icmp_seq=0 ttl=61 time=10.496 ms
64 bytes from 10.42.212.115: icmp_seq=1 ttl=61 time=10.830 ms
^C
--- 10.42.212.115 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 10.496/10.663/10.830/0.167 ms
➜  ~ netstat -nr
Routing tables

Internet:
Destination        Gateway            Flags        Refs      Use   Netif Expire
default            192.168.1.1        UGSc           44        5     en0
10.8.0.1/32        10.8.0.9           UGSc            0        0   utun1
10.8.0.9           10.8.0.10          UH              3        0   utun1
10.42/16           10.8.0.9           UGSc            1        0   utun1
127                127.0.0.1          UCS             0        0     lo0
127.0.0.1          127.0.0.1          UH              5    80277     lo0
169.254            link#5             UCS             1        0     en0
169.254.207.70     54:33:cb:67:33:82  UHLSW           0        2     en0
192.168.1          link#5             UCS             3        0     en0
192.168.1.1/32     link#5             UCS             1        0     en0
192.168.1.1        34:96:72:68:e8:75  UHLWIir         6    12081     en0   1186
192.168.1.103      f0:99:b6:7f:7e:c3  UHLWIi          1       17     en0   1016
192.168.1.114      c0:cc:f8:d1:99:81  UHLWI           0       11     en0    801
192.168.1.118      a8:86:dd:b3:14:a5  UHLWIi          8   796385     en0    801
192.168.1.122/32   link#5             UCS             1        0     en0
192.168.1.122      c:9d:92:78:47:46   UHLWI           0       28     lo0
224.0.0/4          link#5             UmCS            2        0     en0
224.0.0.251        1:0:5e:0:0:fb      UHmLWI          0        0     en0
239.255.255.250    1:0:5e:7f:ff:fa    UHmLWI          0    49648     en0
255.255.255.255/32 link#5             UCS             0        0     en0

Internet6:
Destination                             Gateway                         Flags         Netif Expire
default                                 fe80::%utun0                    UGcI          utun0
::1                                     ::1                             UHL             lo0
fe80::%lo0/64                           fe80::1%lo0                     UcI             lo0
fe80::1%lo0                             link#1                          UHLI            lo0
fe80::%en0/64                           link#5                          UCI             en0
fe80::85c:248d:bc15:df75%en0            10:94:bb:e7:d9:84               UHLWI           en0
fe80::c02:eaa6:5daa:544d%en0            54:33:cb:67:33:82               UHLWI           en0
fe80::c37:a7fc:6397:a015%en0            c0:cc:f8:d1:99:81               UHLWI           en0
fe80::1050:ab36:6c28:e5c4%en0           c:9d:92:78:47:46                UHLI            lo0
fe80::%utun0/64                         fe80::ecfb:1902:3636:fb3a%utun0 UcI           utun0
fe80::ecfb:1902:3636:fb3a%utun0         link#6                          UHLI            lo0
ff01::%lo0/32                           ::1                             UmCI            lo0
ff01::%en0/32                           link#5                          UmCI            en0
ff01::%utun0/32                         fe80::ecfb:1902:3636:fb3a%utun0 UmCI          utun0
ff02::%lo0/32                           ::1                             UmCI            lo0
ff02::%en0/32                           link#5                          UmCI            en0
ff02::%utun0/32                         fe80::ecfb:1902:3636:fb3a%utun0 UmCI          utun0
➜  ~ traceroute 10.42.212.115 # 查看路由表走向
traceroute to 10.42.212.115 (10.42.212.115), 64 hops max, 52 byte packets
 1  10.8.0.1 (10.8.0.1)  10.558 ms  10.597 ms  10.123 ms
 2  10.42.77.57 (10.42.77.57)  10.325 ms  10.634 ms  10.757 ms
 3  10.42.44.58 (10.42.44.58)  10.985 ms  11.016 ms  10.558 ms
 4  10.42.212.115 (10.42.212.115)  10.452 ms  11.051 ms  10.532 ms
➜  ~ sudo route -n add -host 10.0.0.148  10.8.0.1   
add host 10.0.0.148: gateway 10.8.0.1
➜  ~ ping 10.0.0.148
PING 10.0.0.148 (10.0.0.148): 56 data bytes
64 bytes from 10.0.0.148: icmp_seq=0 ttl=62 time=10.597 ms
64 bytes from 10.0.0.148: icmp_seq=1 ttl=62 time=10.799 ms
^C
--- 10.0.0.148 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 10.597/10.698/10.799/0.101 ms 
➜  ~ brew install telnet
Updating Homebrew...
^C==> Downloading https://homebrew.bintray.com/bottles/telnet-60.high_sierra.bottle.tar.gz
######################################################################## 100.0%
==> Pouring telnet-60.high_sierra.bottle.tar.gz
🍺  /usr/local/Cellar/telnet/60: 4 files, 138.2KB
➜  ~ telnet 10.8.0.1 7000
Trying 10.8.0.1...
telnet: connect to address 10.8.0.1: Connection refused
telnet: Unable to connect to remote host
➜  ~ telnet 10.0.0.148 7000
Trying 10.0.0.148...
Connected to 10.0.0.148.
Escape character is '^]'.
^C^C^CConnection closed by foreign host.
````


参考
====
- [通过 FRP 内网穿透并实现 VNC 远程访问 Mac 桌面](https://segmentfault.com/a/1190000021724321)
