> iptables 防火墙

> [参考](https://www.cnblogs.com/bethal/p/5806525.html)

iptables 有3个表

- filter 是用来过滤数据包的,有三个链INPUT,OUTPUT,FORWARD
- nat
- managle 

参数
---

    -t 表名 (默认 filter)
    
    管理哦控制选项:

    -A 链名 (追加策略)
    -L 链路名 数字
    -I (insert)插入链，如果不加数字，默认是将写的策略添加到表中所有策略的前面
        例如: iptables -t filter -I INPUT 2 ...... 插入到第二个
    -D 删除指定链里的某条规则
    -R (replace)修改、替换指定链的某条规则，按序号或内容确定要替换的规则
    -F 清空指定链中的所有规则
    -N 新建一条用户自己定义的规则链
    -X（delete-chain）删除指定表中用户自己定义的规则链
    -n 使用数字形式（--number）显示输出结果，如显示主机的ip地址而不是主机名
    --line-number 查看规则列表时，同时显示规则在链中的顺序号
        注意: 添加规则有两个参数：-A和-I。其中-A是添加到规则的末尾；-I可以插入到指定位置，没有指定位置的话默认插入到规则的首部。


    匹配条件:
    -i   网卡    数据包进入的网卡
    -o  网卡   出去的
    -s   ip   源ip
    -d   ip    目的ip
    -p   协议
    --dport  端口号   目的端口号
    --sport   端口号   源端口号
    动作:
    ACCEPT：对满足策略的数据包允许通过
    DROP：丢弃数据包，且不返回任何信息
    REJECT：丢弃数据包，但是会返回拒绝的信息
    LOG：把通过的数据包写到日志中（相当于一个门卫对进去的人进行登记）



常用操作
---

    # 查看当前内存中iptables策略，默认是filter表  
    iptables -L  --line-numbers
    # 显示
    iptables -nvL –line-number
    -L 查看当前表的所有规则，默认查看的是filter表，如果要查看NAT表，可以加上-t NAT参数
    -n 不对ip地址进行反查，加上这个参数显示速度会快很多
    -v 输出详细信息，包含通过该规则的数据包数量，总字节数及相应的网络接口
    –line-number 显示规则的序列号，这个参数在删除或修改规则时会用到

    # 表的每条链后面都有一个默认动作，Chain INPUT (policy ACCEPT)
    # !!! 注意:以下命令将导致,您无法连接服务器
    # 修改 INPUT 不接受任何请求
    iptables -t filter -P INPUT DROP

    # 删除INPUT链的序号为1的策略  
    iptables -D INPUT 1  

    # 自定义链(Chain)
    iptables -N chen #定义一个chen链，相当于多了一扇门  
    iptables -t filter -A INPUT -j chen  #把经过INPUT链的数据引入到chen这个链上  
    iptables -X chen  #删除chen这条链  


实例
----

设置 iptables 开机自动加载


    iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
    iptables -A INPUT -s 106.14.205.100 -p tcp -j DROP
    
    # save
    iptables-save > /etc/iptables.rules
    
    # 开机自动启动
    cat > /etc/network/if-pre-up.d/up_iptables.sh <<EOF
    #!/bin/bash
    iptables-restore < /etc/iptables.rules
    EOF
    
    chmod a+x /etc/network/if-pre-up.d/up_iptables.sh
    

