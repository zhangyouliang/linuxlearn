> iptables 防火墙

> [参考](https://www.cnblogs.com/bethal/p/5806525.html)

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
    

