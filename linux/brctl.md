> brctl 管理桥接网络 

安装网桥管理工具包：bridge-utile

```
# yum install bridge-utils -y
```

命令参数
---
```
Usage: brctl [commands]
commands:
        addbr           <bridge>                add bridge
        delbr           <bridge>                delete bridge
        addif           <bridge> <device>       add interface to bridge
        delif           <bridge> <device>       delete interface from bridge
        setageing       <bridge> <time>         set ageing time
        setbridgeprio   <bridge> <prio>         set bridge priority
        setfd           <bridge> <time>         set bridge forward delay
        sethello        <bridge> <time>         set hello time
        setmaxage       <bridge> <time>         set max message age
        sethashel       <bridge> <int>          set hash elasticity
        sethashmax      <bridge> <int>          set hash max
        setmclmc        <bridge> <int>          set multicast last member count
        setmcrouter     <bridge> <int>          set multicast router
        setmcsnoop      <bridge> <int>          set multicast snooping
        setmcsqc        <bridge> <int>          set multicast startup query count
        setmclmi        <bridge> <time>         set multicast last member interval
        setmcmi         <bridge> <time>         set multicast membership interval
        setmcqpi        <bridge> <time>         set multicast querier interval
        setmcqi         <bridge> <time>         set multicast query interval
        setmcqri        <bridge> <time>         set multicast query response interval
        setmcqri        <bridge> <time>         set multicast startup query interval
        setpathcost     <bridge> <port> <cost>  set path cost
        setportprio     <bridge> <port> <prio>  set port priority
        setportmcrouter <bridge> <port> <int>   set port multicast router
        show            [ <bridge> ]            show a list of bridges
        showmacs        <bridge>                show a list of mac addrs
        showstp         <bridge>                show bridge stp info
        B
        stp             <bridge> {on|off}       turn stp on/off
```

案例
---
```
# 使用brctl命令创建网桥br1
brctl addbr br1
# 删除网桥br1
brctl delbr br1
# 将eth0端口加入网桥br1
brctl addif br1 eth0
# 删除eth0端口加入网桥br1
brctl delif br1 eth0
# 查询网桥信息
brctl show
brctl show br1
```


参考
---










