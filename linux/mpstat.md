> mpstat命令指令主要用于多CPU环境下，它显示各个可用CPU的状态系你想。这些信息存放在/proc/stat文件中。在多CPUs系统里，其不但能查看所有CPU的平均状况信息，而且能够查看特定CPU的信息。


语法
--
    mpstat(选项)(参数)
选项
--
-P：指定CPU编号。

参数
--
间隔时间：每次报告的间隔时间（秒）；
次数：显示报告的次数。

实例
---
当mpstat不带参数时，输出为从系统启动以来的平均值。

    mpstat
    Linux 2.6.9-5.31AXsmp (builder.redflag-linux.com) 12/16/2005
    09:38:46 AM CPU %user %nice %system %iowait %irq %soft %idle intr/s
    09:38:48 AM all 23.28 0.00 1.75     0.50 0.00 0.00 74.47 1018.59

**每2秒产生了2个处理器的统计数据报告：**

下面的命令可以每2秒产生了2个处理器的统计数据报告，一共产生三个interval 的信息，然后再给出这三个interval的平均信息。默认时，输出是按照CPU 号排序。第一个行给出了从系统引导以来的所有活跃数据。接下来每行对应一个处理器的活跃状态。。

    ➜  ~ mpstat -P ALL 2 3
    Linux 4.4.0-105-generic (iZbp1irx58yxevjbcslavlZ) 	07/08/2018 	_x86_64_	(2 CPU)
    
    08:39:37 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
    08:39:39 PM  all    1.00    0.00    0.25    0.00    0.00    0.00    0.00    0.00    0.00   98.75
    08:39:39 PM    0    0.00    0.00    0.50    0.50    0.00    0.00    0.00    0.00    0.00   99.00
    08:39:39 PM    1    1.49    0.00    0.50    0.00    0.00    0.00    0.00    0.00    0.00   98.02