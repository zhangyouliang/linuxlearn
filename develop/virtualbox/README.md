> virtualbox 安装

#### # centos 安装
> [参考地址](https://centos.pkgs.org/7/virtualbox-x86_64/VirtualBox-5.2-5.2.0_118431_el7-1.x86_64.rpm.html)

> [下载地址](https://www.oracle.com/technetwork/server-storage/virtualbox/downloads/index.html)

    Install Howto
    Create the repository config file /etc/yum.repos.d/virtualbox.repo:
    [virtualbox]
    name=VirtualBox
    baseurl=http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch
    enabled=1
    gpgcheck=1
    gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc
    Install VirtualBox-5.2 rpm package:
    # yum install VirtualBox-5.2

#### # ubuntu 安装

    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    sudo apt-get update
    atp install virtualbox-6.0
    apt install atp
    apt-get -f install