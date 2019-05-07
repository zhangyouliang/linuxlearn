虚拟机 qemu-kvm 安装
---
> 参考: https://www.cnblogs.com/marvin-ma/p/7407509.html

> http://blog.51cto.com/zhongle21/2090767


    yum install -y qemu-kvm libvirt   ###qemu-kvm用来创建虚拟机硬盘,libvirt用来管理虚拟机
    yum install -y virt-install    ###用来创建虚拟机

    # 启动libvirtd,并将它设为开机启动,启动后使用ifconfig查看,发现会多出来一块virbr0的网卡,ip默认为192.168.122.1/24,说明libvirtd启动成功,如果默认没有ifconfig命令,使用yum install -y net-tools安装
    systemctl start libvirtd && systemctl enable libvirtd
    # 创建一个10G的硬盘
    qemu-img create -f raw /opt/CentOS-7-x86_64.raw 10G
    
    # 下载惊醒
    wget http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
    virt-install --virt-type kvm --name CentOS-7-x86_64 --ram 1024 --cdrom=CentOS-7-x86_64-Minimal-1804.iso --disk path=/opt/CentOS-7-x86_64.raw --network network=default --graphics vnc,listen=0.0.0.0 --noautoconsole
    # 查看虚拟机
    virsh list --all
    启动虚拟机
    virsh start CentOS-7-x86_64

#### 问题
 

    # ERROR    Host does not support domain type kvm for virtualization type 'hvm' arch 'x86_64'
    # 主机未开始起虚拟机化
    egrep -E '(vmx|svm)' /proc/cpuinfo
