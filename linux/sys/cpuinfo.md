> /proc/cpuinfo 文件解析

逻辑 cpu 数
    
    cat /proc/cpuinfo | grep "processor" | wc -l
    4

cpu 核心数
    
    cat /proc/cpuinfo |grep "cores"|uniq 
    cpu cores	: 2

物理cpu 个数
    
    cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l 
    
一般 逻辑 `cpu 数= 物理cpu个数 x 每颗核数`,如果不相等的话，则表示服务器的CPU支持超线程技术

这样一来，操作系统可使用的执行资源扩大了一倍，大幅提高了系统的整体性能，此时逻辑cpu=物理CPU个数×每颗核数x2）


siblings  列出了位于相同物理封装中的逻辑处理器的数量。

注: 不能看出逻辑 cpu 数, 除非只有一个物理cpu
 