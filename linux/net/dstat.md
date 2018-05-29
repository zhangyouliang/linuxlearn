> dstat命令是一个用来替换vmstat、iostat、netstat、nfsstat和ifstat这些命令的工具，是一个全能系统信息统计工具。与sysstat相比，dstat拥有一个彩色的界面，在手动观察性能状况时，数据比较显眼容易观察；而且dstat支持即时刷新，譬如输入dstat 3即每三秒收集一次，但最新的数据都会每秒刷新显示。和sysstat相同的是，dstat也可以收集指定的性能资源，譬如dstat -c即显示CPU的使用情况。

下载安装
---

方法一

    yum install -y dstat
方法二

    官网下载地址：http://dag.wieers.com/rpm/packages/dstat

    wget http://dag.wieers.com/rpm/packages/dstat/dstat-0.6.7-1.rh7.rf.noarch.rpm
    rpm -ivh dstat-0.6.7-1.rh7.rf.noarch.rpm
使用说明
---

安装完后就可以使用了，dstat非常强大，可以实时的监控cpu、磁盘、网络、IO、内存等使用情况。

直接使用dstat，默认使用的是-cdngy参数，分别显示cpu、disk、net、page、system信息，默认是1s显示一条信息。可以在最后指定显示一条信息的时间间隔，如dstat 5是没5s显示一条，dstat 5 10表示没5s显示一条，一共显示10条。

    # dstat
    ----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
    usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
      0   0  99   0   0   0|7706B  164k|   0     0 |   0     0 | 189   225
      0   0 100   0   0   0|   0     0 |4436B  826B|   0     0 | 195   248
      1   0  99   0   0   0|   0     0 |4744B  346B|   0     0 | 203   242
      0   0 100   0   0   0|   0     0 |5080B  346B|   0     0 | 206   242
      0   1  99   0   0   0|   0     0 |5458B  444B|   0     0 | 214   244
      1   0  99   0   0   0|   0     0 |5080B  346B|   0     0 | 208   242
下面对显示出来的部分信息作一些说明：

- cpu：hiq、siq分别为硬中断和软中断次数。
- system：int、csw分别为系统的中断次数（interrupt）和上下文切换（context switch）。
其他的都很好理解。

语法
--
    dstat [-afv] [options..] [delay [count]]
常用选项
--
    -c：显示CPU系统占用，用户占用，空闲，等待，中断，软件中断等信息。
    -C：当有多个CPU时候，此参数可按需分别显示cpu状态，例：-C 0,1 是显示cpu0和cpu1的信息。
    -d：显示磁盘读写数据大小。
    -D hda,total：include hda and total。
    -n：显示网络状态。
    -N eth1,total：有多块网卡时，指定要显示的网卡。
    -l：显示系统负载情况。
    -m：显示内存使用情况。
    -g：显示页面使用情况。
    -p：显示进程状态。
    -s：显示交换分区使用情况。
    -S：类似D/N。
    -r：I/O请求情况。
    -y：系统状态。
    --ipc：显示ipc消息队列，信号等信息。
    --socket：用来显示tcp udp端口状态。
    -a：此为默认选项，等同于-cdngy。
    -v：等同于 -pmgdsc -D total。
    --output 文件：此选项也比较有用，可以把状态信息以csv的格式重定向到指定的文件中，以便日后查看。例：dstat --output /root/dstat.csv & 此时让程序默默的在后台运行并把结果输出到/root/dstat.csv文件中。
    当然dstat还有很多更高级的用法，常用的基本这些选项，更高级的用法可以结合man文档。