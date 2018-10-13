keepalived 
====
> 参考:[keepalived实现服务高可用](https://www.cnblogs.com/clsn/p/8052649.html)

> 参考: [https://blog.csdn.net/u010066807/article/details/50659714](https://blog.csdn.net/u010066807/article/details/50659714)

> 注意需要四台机器:而不是两台机器上面分别安装 keepalived + nginx 测试(被坑了老半天)

hostname |  ip | 备注
---|---|---
LVSMaster  |  eth0:192.168.31.198    eth1:10.10.100.100 |
LVSBackup |  eth0:192.168.31.197  eth1:10.10.100.101 |  LVS 备机 
RealserverNet1 |  eth0:10.10.100.53  |  真实机器 lvs net模式
RealserverNet2  | eth0:10.10.100.54 | 真实机器 lvs net模式

DR模式需要的VIP： 192.168.31.200 

NET模式需要的VIP： 10.10.100.200


安装
-----

    apt-get install keepalived
    apt-get install ipvsadm
    # 安装测试的 nginx

调度服务器配置
-----
开启路由转发功能

    vim /etc/sysctl.conf
    net.ipv4.ip_forward=1
    //让参数生效
    sysctl -p

网关配置
-----
> 在2台真实的服务器配置网关，是把真实服务器处理的结果交给调度服务器去响应给用户
	
	cat lvs.txt
	root@10.10.100.100
	root@10.10.100.101
	# 分别运行(或者使用pssh,ansible 工具)
	pssh -h lvs.txt -i 'route add default gw gw 10.10.100.100'
	pssh -h lvs.txt -i 'apt-get install nginx'
	# 安装完成查看80端口
	pssh -h lvs.txt -i 'lsof -i:80'
	# 便于测试,为了知道到底是访问到哪台了
	pssh -h lvs.txt -i 'hostname > /usr/share/nginx/html/index.html'

VIP配置
-----

如果需要 keepalived , 真实服务器的路由改成

	route add default gw $vip


lvs配置
----
LVSMaster配置文件

	vim /etc/keepalived/keepalived.conf

	! Configuration File for keepalived
	
	global_defs {
	   router_id LVSMaster
	}
	
	vrrp_instance VI_1 {
	    state MASTER
	    interface eth0 # 对外服务的网卡
	    virtual_router_id 100 #VRRP组名，两个节点的设置必须一样，以指明各个节点属于同一VRRP组
	    priority 100 #主节点的优先级（1-254之间），备用节点必须比主节点优先级低
	    advert_int 1 #设置主备之间同步检查的时间间隔单位秒 
	    authentication { #设置验证信息，两个节点必须一致
	        auth_type PASS
	        auth_pass 123456   
	    } 
	    virtual_ipaddress { #指定虚拟IP, 两个节点设置必须一样
	        192.168.31.200
	    }
	}
	
	#lvs NAT配置
	virtual_server 192.168.31.200 80 {
	    delay_loop 6
	    lb_algo wrr #设置负载高度算法，wrr带权循环
	    lb_kind NAT #设置LVS实现负载均衡的机制，可以为{NAT|TUN|DR}三种
	    #persistence_timeout 50 #会话保持时间，单位为秒。动态网页session共享简单的决解办法。测试的时候注掉，不然看不出效果
	    protocol TCP  #指定转发协议类型可以设置{TCP|UDP}两种
	
	    real_server 10.10.100.53 80 { #真实的主机
	        weight 10 #真实的主机的权重,数字越大，权重越高 
	        TCP_CHECK { #设置检测Realserver的方式
	            connect_timeout 3
	            nb_get_retry 3
	            delay_before_retry 3
	            connect_port 80
	        }
	    }
	
	    real_server 10.10.100.54 80 {
	        weight 10
	        TCP_CHECK {
	            connect_timeout 3
	            nb_get_retry 3
	            delay_before_retry 3
	            connect_port 80
	        }
	    }
	
	}
	
	#lvs DR配置
	virtual_server 192.168.31.200 80 {
	    delay_loop 6
	    lb_algo wrr
	    lb_kind DR
	    persistence_timeout 50
	    protocol TCP
	
	    real_server 192.168.31.186 80 {
	        weight 1
	        TCP_CHECK {
	            connect_timeout 3
	            nb_get_retry 3
	            delay_before_retry 3
	            connect_port 80
	        }
	    }
	
	}

LVSBackup配置文件
	
	scp /etc/keepalived/keepalived.conf 10.10.100.101:/etc/keepalived/keepalived.conf
	vim /etc/keepalived/keepalived.conf

> 修改  state BACKUP  priority 90, router_id 

	! Configuration File for keepalived
	
	global_defs {
	   router_id LVSBackup # 修改
	}
	
	vrrp_instance VI_1 {
	    state BACKUP  # 修改 
	    interface eth0
	    virtual_router_id 100
	    priority 90 # 修改
	    advert_int 1
	    authentication {
	        auth_type PASS
	        auth_pass 123456 
	    } 
	    virtual_ipaddress {
	        192.168.31.200
	    }
	}
	
	virtual_server 192.168.31.200 80 {
	    delay_loop 6
	    lb_algo wrr
	    lb_kind NAT
	    #persistence_timeout 50
	    protocol TCP
	
	    real_server 10.10.100.53 80 {
	        weight 10
	        TCP_CHECK {
	            connect_timeout 3
	            nb_get_retry 3
	            delay_before_retry 3
	            connect_port 80
	        }
	    }
	
	    real_server 10.10.100.54 80 {
	        weight 10
	        TCP_CHECK {
	            connect_timeout 3
	            nb_get_retry 3
	            delay_before_retry 3
	            connect_port 80
	        }
	    }
	
	}
	
	virtual_server 192.168.31.200 80 {
	    delay_loop 6
	    lb_algo wrr
	    lb_kind DR
	    persistence_timeout 50
	    protocol TCP
	
	    real_server 192.168.31.186 80 {
	        weight 1
	        TCP_CHECK {
	            connect_timeout 3
	            nb_get_retry 3
	            delay_before_retry 3
	            connect_port 80
	        }
	    }
	}

RealserverNet1,RealserverNet2 配置
----
> 貌似可以忽律

	echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
	echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
	echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
	echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
	
	ifconfig lo:1 192.168.31.200  broadcast 192.168.31.200  netmask 255.255.255.255 up
	route add -host 192.168.31.200  dev lo:1

	ifconfig lo:1 10.10.100.200  broadcast 10.10.100.200  netmask 255.255.255.255 up
	route add -host 10.10.100.200  dev lo:1


	# 去除网络配置
	route delete -host 192.168.31.200  dev lo:1
	ifconfig lo:1 down

	route delete -host 10.10.100.200  dev lo:1
	ifconfig lo:1 down

启动
-----
master 和backup 启动 keepalived

	service keepalived start

测试
-----

	root@LVSMaster:~# ip a
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	    inet 127.0.0.1/8 scope host lo
	       valid_lft forever preferred_lft forever
	    inet6 ::1/128 scope host 
	       valid_lft forever preferred_lft forever
	2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
	    link/ether 00:0c:29:2b:e9:71 brd ff:ff:ff:ff:ff:ff
	    inet 192.168.31.198/24 brd 192.168.31.255 scope global eth0
	       valid_lft forever preferred_lft forever
	    inet 192.168.31.200/32 scope global eth0 #现在序列IP在LVSMaster上
	       valid_lft forever preferred_lft forever
	    inet6 fe80::20c:29ff:fe2b:e971/64 scope link 
	       valid_lft forever preferred_lft forever
	3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
	    link/ether 00:0c:29:2b:e9:7b brd ff:ff:ff:ff:ff:ff
	    inet 10.10.100.100/24 brd 10.10.100.255 scope global eth1
	       valid_lft forever preferred_lft forever
	    inet6 fe80::20c:29ff:fe2b:e97b/64 scope link 
	       valid_lft forever preferred_lft forever

访问 http://192.168.31.200/

