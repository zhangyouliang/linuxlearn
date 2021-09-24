> iotop命令是一个用来监视磁盘I/O使用状况的top类工具。iotop具有与top相似的UI，其中包括PID、用户、I/O、进程等相关信息。Linux下的IO统计工具如iostat，nmon等大多数是只能统计到per设备的读写情况，如果你想知道每个进程是如何使用IO的就比较麻烦，使用iotop命令可以很方便的查看。

iotop使用Python语言编写而成，要求Python2.5（及以上版本）和Linux kernel2.6.20（及以上版本）。iotop提供有源代码及[rpm](http://man.linuxde.net/rpm)包，可从其[官方主页](http://guichaz.free.fr/iotop/)下载。

安装
----

    apt install iotop


选项
----

    -d SEC 页面刷新秒数
    -p PID  显示指定 pid 的数据
    -u USER 显示指定用户的数据
    -t 显示当前时间
    -o：只显示有io操作的进程
    -b：批量显示，无交互，主要用作记录到文件。


