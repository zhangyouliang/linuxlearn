> p命令用来显示或操纵Linux主机的路由、网络设备、策略路由和隧道，是Linux下较新的功能强大的网络配置工具。

语法
---
    ip(选项)(参数)
选项
---
    -V：显示指令版本信息；
    -s：输出更详细的信息；
    -f：强制使用指定的协议族；
    -4：指定使用的网络层协议是IPv4协议；
    -6：指定使用的网络层协议是IPv6协议；
    -0：输出信息每条记录输出一行，即使内容较多也不换行显示；
    -r：显示主机时，不使用IP地址，而使用主机的域名。

参数
---
网络对象：指定要管理的网络对象；

具体操作：对指定的网络对象完成具体操作；

help：显示网络对象支持的操作命令的帮助信息。

实例
---

    # 用ip命令显示网络设备的运行状态
    ip link list
    
    # 显示更加详细的设备信息
    ip -s link list
    
    # 显示核心路由表
    ip route list
    
    # 显示邻居表
    ip neigh list
   
    # 路由查看
    ip route show table main
    ip route show table local
    

--------


详解
=====

1.linux 系统中路由表 table
---

linux 最多可以支持 255 张路由表,每张路由表有一个 `table id` 和 `table name`中有4张表是linux系统内置的：

查看映射关系 

    /etc/iproute2/rt_tables

(1) table id = 0 系统保留
    
(2) table id = 255 (local)

成为本地路由表,表名为 local,像`本地接口地址,广播地址,以及 nat地址`都放在这张表里面,**该路由表由系统自动维护，管理员不能直接修改**。

(3) table id = 254 (main)

称为主路由表，表名为main。如果没有指明路由所属的表，所有的路由都默认都放在这个表里。一般来说，旧的路由工具(如route)所添加的路由都会加到这个表。

main表中路由记录都是普通的路由记录。而且，使用ip route配置路由时，如果不明确制定要操作的路由表，默认情况下也是主路由表（表254）进行操作。

> 备注：我们使用ip route list 或 route -n 或 netstat -rn查看的路由记录，也都是main表中记录。

(4) table id = 253 (default)

一般来说默认的路由都放在这张表。


备注
--- 
    A）系统管理员可以根据需要自己添加路由表，并向路由表中添加路由记录。
    B）可以通过`/etc/iproute2/rt_tables`文件查看 table id 和  table name  的映射关系。
    C）如果管理员新增了一张路由表，需要在  /etc/iproute2/rt_tables  文件中为新路由表添加  table id  和  table name  的映射。


2.路由表配置
    
[参考](./route.md)



    


3.路由策略 rule

    > 一条路由规则主要有: 优先级,条件,路由表 (优先级数字越小,优先级越高)
    










































