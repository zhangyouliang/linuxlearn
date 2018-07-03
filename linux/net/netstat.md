> netstat命令用来打印Linux中网络系统的状态信息，可让你得知整个Linux系统的网络情况。
> [参考1](http://man.linuxde.net/netstat),[参考2]()
  
语法
---

    netstat(选项)

选项
--

    -a或--all：显示所有连线中的Socket；
    -A<网络类型>或--<网络类型>：列出该网络类型连线中的相关地址；
    -c或--continuous：持续列出网络状态；
    -C或--cache：显示路由器配置的快取信息；
    -e或--extend：显示网络其他相关信息；
    -F或--fib：显示FIB；
    -g或--groups：显示多重广播功能群组组员名单；
    -h或--help：在线帮助；
    -i或--interfaces：显示网络界面信息表单；
    -l或--listening：显示监控中的服务器的Socket；
    -M或--masquerade：显示伪装的网络连线；
    -n或--numeric：直接使用ip地址，而不通过域名服务器；
    -N或--netlink或--symbolic：显示网络硬件外围设备的符号连接名称；
    -o或--timers：显示计时器；
    -p或--programs：显示正在使用Socket的程序识别码和程序名称；
    -r或--route：显示Routing Table；
    -s或--statistice：显示网络工作信息统计表；
    -t或--tcp：显示TCP传输协议的连线状况；
    -u或--udp：显示UDP传输协议的连线状况；
    -v或--verbose：显示指令执行过程；
    -V或--version：显示版本信息；
    -w或--raw：显示RAW传输协议的连线状况；
    -x或--unix：此参数的效果和指定"-A unix"参数相同；
    --ip或--inet：此参数的效果和指定"-A inet"参数相同。

实例
---
    
    # 根据链接状态查看连接
    netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
    
    # 查看access.log 当中的ip数量,并且统计出来
    cat access.log| awk -F \" '{print $7}' | awk -F \| '{++S[$2]} END {for(a in S) print a, S[a]}'
    

实时查看连接数
    
    # 查看 443 端口 
    netstat -ant | grep -i '443' | wc -l
    
    # 实时检测httpd连接数
    watch -n 1 -d "pgrep httpd|wc -l"