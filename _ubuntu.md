ubuntu 常用安装包
=====


    iputils-ping: 安装 ping 相关命令
    net-tools:
    Linux平台NET-3网络分发包，包括arp、hostname、ifconfig、netstat、rarp、route、plipconfig、slattach、mii-tool、iptunnel和ipmaddr工具。
    apache2-utils: apache 工具安装
    rinetd/xenial: 端口转发工具
    openssl, libssl-dev : ssl 相关库
    glances: 流量监控工具


ubuntu 更换阿里数据源
------

备份系统默认的源（没有root权限的前面加sudo）

    cp /etc/apt/sources.list /etc/apt/sources.list.bak
    修改/etc/apt/sources.list

**ubuntu 16.04**

**/etc/apt/sources.list**

    cat >>/etc/apt/sources.list<<EOF
    # deb cdrom:[Ubuntu 16.04 LTS _Xenial Xerus_ - Release amd64 (20160420.1)]/ xenial main restricted
    deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
    deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
    deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
    deb http://mirrors.aliyun.com/ubuntu/ xenial universe
    deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
    deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
    deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
    deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
    deb http://archive.canonical.com/ubuntu xenial partner
    deb-src http://archive.canonical.com/ubuntu xenial partner
    deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
    deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
    deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
    deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse
    EOF
    
最后更新

    apt-get update
    
# deb 安装缺少依赖?
------

使用dpkg -i *.deb 的时候出现依赖没有安装

    apt-get -f -y install 
    dpkg -i   *.deb
