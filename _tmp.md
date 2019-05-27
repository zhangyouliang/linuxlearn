运维笔记
====

端口相关
```
#查看 pid
pidof name
#查看端口
lsof -i :port
#查看某个pid的占用端口
netstat -anp | grep pid
```

流量监控命令
```
glances
```

网络命令
```
# 多线程下载
axel -n 10 -o /tmp/ http://www.linuxde.net/lnmp.tar.gz
# ssh-copy-id命令也会给远程主机的用户主目录（home）和~/.ssh, 和~/.ssh/authorized_keys设置合适的权限。
ssh-copy-id -i ~/.ssh/id_rsa.pub user@server
# 网上测试工具 http://man.linuxde.net/iperf
iperf 

traceroute

# 分析域名查询工具，可以用来测试域名系统工作是否正常
host
# ss命令用来显示处于活动状态的套接字信息。ss命令可以用来获取socket统计信息，
ss

# 
ip命令用来显示或操纵Linux主机的路由、网络设备、策略路由和隧道，是Linux下较新的功能强大的网络配置工具。
ip 
# 显示更加详细的设备信息
ip -s link list

# 显示核心路由表
ip route list  
# 显示邻居表
ip neigh list
# 用ip命令显示网络设备的运行状态
ip link list
```


### 常用命令

- diff
- find
- awk
- cut
- tr
- fmt
- nl
- grep
- sed
- seq
- xargs
- split
- sort
- uniq
- wc
- date
- du
- scp
- curl
- wget
- journalctl
- ip
- route
- netstat
- tee
- watch
