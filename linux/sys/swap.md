> swap 交换内存相关


* mkswap:  在这是或文件上创建 linux 交换区(swap)
* swapon: 开启用作系统交换区的设备或文件

- mkswap [参数] 设备名 [块数]

设备名，这里的设备通常是一个磁盘分区，如：`/dev/sda6`，或者是一个文件 `/swapfile`

    -c  建立交换空间前，先检查是否有坏道，如果有坏道，将坏道总数目显示出来。
    -f  强行运行mkswap命令
    -p  <页大小>  指定所使用的页大小
    -L  <标签>    指定一个标签，此后swapon可以使用这个标签
    -v0  建立旧式交换区
    -v1  建立新式交换区


创建 swapfile 虚拟文件

        # 创建swapfile文件
        dd if=/dev/zero  of=swapfile  count=2000  bs=1024k
        if 表示输入文件 /dev/zero表示一个空文件，即以null字符写入文件中。
        of 表示输出文件
        bs 每个块多少个字节,可以带单位
        count 表示多少个块

        # 这样就创建2G的一个空文件
        mkswap -f swapfile

- swapon: 开启用作系统交换区的设备或文件

        -a  将/etc/fstab文件中所有设置为swap的设备开启，标记noauto参数的设备除外。
        -e  与-a配合使用，忽略不存在的设备
        -p  指定优先级，0-32767,数值越大，优先级就越高。
        -s  显示交互区使用情况。
        -v  显示详细信息


        # 显示交换区分区信息
        swapon -s
        # 开启所有交换分区
        swapon -av
        # 开启交换分区/dev/sdb1
        swapon  /dev/sdb1
