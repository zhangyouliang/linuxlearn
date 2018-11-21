> sar

http://blog.chinaunix.net/uid-28684368-id-5756349.html

参数
---

    -u 显示先关字段(default)
    sar -P 0 3 5  测试单线程(测试单个cpu 核心)
    -r 查看系统内存和交换空间的使用率
    -d 查看磁盘信息
    -n 显示网络信息
    %user列显示了用户进程消耗的CPU 时间百分比。
    %nice列显示了运行正常进程所消耗的CPU 时间百分比。
    %system列显示了系统进程消耗的CPU时间百分比。
    %iowait列显示了IO等待所占用的CPU时间百分比
    %steal列显示了在内存相对紧张的环境下pagein强制对不同的页面进行的steal操作 。
    %idle列显示了CPU处在空闲状态的时间百分比。

