ubuntu 常用安装包[[官方包搜索地址]](https://packages.ubuntu.com/)
=====

* iputils-ping: 安装 ping 相关命令
* net-tools:
    Linux平台NET-3网络分发包，包括arp、hostname、ifconfig、netstat、rarp、route、plipconfig、slattach、mii-tool、iptunnel和ipmaddr工具。
* apache2-utils: apache 工具安装
* rinetd/xenial: 端口转发工具
* openssl, libssl-dev : ssl 相关库
* glances: 流量监控工具
* [linux-tools-generic](https://packages.ubuntu.com/cosmic/amd64/linux-tools-4.18.0-10-generic/filelist): 
    * perf
    * cpupower
    * acpidbg
    * turbostat
    * .....
* ncdu: 磁盘占用分析工具 (平时使用: du -ah --max-depth=1 /)
   - 排除 nas 目录,扫描 / 根目录: ncdu --exclude=/root/nas /
* [其他工具](./tools/README.md)

ubuntu 更换阿里数据源
------

备份系统默认的源（没有root权限的前面加sudo）

````
cp /etc/apt/sources.list /etc/apt/sources.list.bak
````


修改/etc/apt/sources.list



***Ubuntu 14.04.5***


```

cat << EOF >/etc/apt/sources.list

deb https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse

## Not recommended
# deb https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
EOF
```

**ubuntu 16.04**

**/etc/apt/sources.list**

````
cat >>/etc/apt/sources.list<<EOF
# deb cdrom:[Ubuntu 16.04 LTS _Xenial Xerus_ - Release amd64 (20160420.1)]/ xenial main restricted
deb-src http://archive.ubuntu.com/ubuntu bionic main restricted #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ bionic universe
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates universe
deb http://mirrors.aliyun.com/ubuntu/ bionic multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse #Added by software-properties
deb http://archive.canonical.com/ubuntu bionic partner
deb-src http://archive.canonical.com/ubuntu bionic partner
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ bionic-security universe
deb http://mirrors.aliyun.com/ubuntu/ bionic-security multiverse
EOF
````


ubuntu 18.04(bionic) 配置如下

````
cat << EOF >/etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
EOF
````

ubuntu 20.04(focal) 配置如下
```
cat << EOF >/etc/apt/sources.list
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
EOF
```
    
最后更新

````
apt-get update
````
# deb 安装缺少依赖?
------

使用dpkg -i *.deb 的时候出现依赖没有安装

````
apt-get -f -y install 
dpkg -i   *.deb
````

# 时区设置
-------
````
# 设置时区为上海(+8) 时区
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
````

# systemctl 无法使用的问题
> systemctl无法连接到总线 – docker ubuntu:16.04容器

````
docker run -ti -d --privileged=true ubuntu:16.06  "/sbin/init"
````
`docker run -t -i ubuntu:16.04 /bin/bash`  现在的问题是你的init进程 PID 1是`/bin/bash`，而不是 `systemd`
除此之外，您将缺少dbus，这将是沟通的方式。这是您的错误消息来自的地方。但是由于PID 1没有系统化，因此无法安装dbus



参考
====
- [阿里云-开发者社区-镜像站-ubuntu](https://developer.aliyun.com/mirror/ubuntu?spm=a2c6h.13651102.0.0.3e221b11aU6qiM)