> dd:  用指定大小的块拷贝一个文件，并在拷贝的同时进行指定的转换。



一. 参数
-----


    if=文件名：输入文件名，缺省为标准输入。即指定源文件。< if=input file > 
    of=文件名：输出文件名，缺省为标准输出。即指定目的文件。< of=output file > 
    ibs=bytes：一次读入bytes个字节，即指定一个块大小为bytes个字节。 
    obs=bytes：一次输出bytes个字节，即指定一个块大小为bytes个字节。 
    bs=bytes：同时设置读入/输出的块大小为bytes个字节。 
    cbs=bytes：一次转换bytes个字节，即指定转换缓冲区大小。 
    skip=blocks：从输入文件开头跳过blocks个块后再开始复制。 
    seek=blocks：从输出文件开头跳过blocks个块后再开始复制。 
    注意：通常只用当输出文件是磁盘或磁带时才有效，即备份到磁盘或磁带时才有效。 
    count=blocks：仅拷贝blocks个块，块大小等于ibs指定的字节数。 
    conv=conversion：用指定的参数转换文件。 
    ascii：转换ebcdic为ascii 
    ebcdic：转换ascii为ebcdic 
    ibm：转换ascii为alternate ebcdic 
    block：把每一行转换为长度为cbs，不足部分用空格填充 
    unblock：使每一行的长度都为cbs，不足部分用空格填充 
    lcase：把大写字符转换为小写字符 
    ucase：把小写字符转换为大写字符 
    swab：交换输入的每对字节 
    noerror：出错时不停止 
    notrunc：不截短输出文件 
    sync：将每个输入块填充到ibs个字节，不足部分用空（NUL）字符补齐。 


二.  应用:
-----


1.将本地的/dev/hdb整盘备份到/dev/hdd

    dd if=/dev/hdb of=/dev/hdd
 
2.将/dev/hdb全盘数据备份到指定路径的image文件

    dd if=/dev/hdb of=/root/image
 
3.将备份文件恢复到指定盘

    dd if=/root/image of=/dev/hdb
 
4.备份/dev/hdb全盘数据，并利用gzip工具进行压缩，保存到指定路径

    dd if=/dev/hdb | gzip > /root/image.gz
    
5.将压缩的备份文件恢复到指定盘

    gzip -dc /root/image.gz | dd of=/dev/hdb
 
6.备份与恢复MBR

    备份磁盘开始的512个字节大小的MBR信息到指定文件：
    dd if=/dev/hda of=/root/image count=1 bs=512
    count=1指仅拷贝一个块；bs=512指块大小为512个字节。

    恢复：
    dd if=/root/image of=/dev/had
    将备份的MBR信息写到磁盘开始部分

7.备份软盘

     dd if=/dev/fd0 of=disk.img count=1 bs=1440k (即块大小为1.44M)
     
8.拷贝内存内容到硬盘

    dd if=/dev/mem of=/root/mem.bin bs=1024 (指定块大小为1k)

9.拷贝光盘内容到指定文件夹，并保存为cd.iso文件

     dd if=/dev/cdrom(hdc) of=/root/cd.iso

10.增加swap分区文件大小

    第一步：创建一个大小为256M的文件：
    dd if=/dev/zero of=/swapfile bs=1024 count=262144
    第二步：把这个文件变成swap文件：
    mkswap /swapfile
    第三步：启用这个swap文件：
    swapon /swapfile
    第四步：编辑/etc/fstab文件，使在每次开机时自动加载swap文件：
    /swapfile swap swap default 0 0
    
11.销毁磁盘数据

     dd if=/dev/urandom of=/dev/hda1

注意：利用随机的数据填充硬盘，在某些必要的场合可以用来销毁数据。

12.测试硬盘的读写速度

    # 写入速度
    dd if=/dev/zero bs=1024k count=1024 of=/root/1Gb.file
    # 读取速度
    # 首先清除内存的缓存，以确保这个文件确实是从驱动盘读取的
    sync && echo 3 > /proc/sys/vm/drop_caches
    dd if=/root/1Gb.file bs=1024k of=/dev/null
    
通过以上两个命令输出的命令执行时间，可以计算出硬盘的读、写速度。

13.确定硬盘的最佳块大小：

    dd if=/dev/zero bs=1024 count=1000000 of=/root/1Gb.file
    dd if=/dev/zero bs=2048 count=500000 of=/root/1Gb.file
    dd if=/dev/zero bs=4096 count=250000 of=/root/1Gb.file
    dd if=/dev/zero bs=8192 count=125000 of=/root/1Gb.file
 
通过比较以上命令输出中所显示的命令执行时间，即可确定系统最佳的块大小。

14.修复硬盘：

 dd if=/dev/sda of=/dev/sda 或dd if=/dev/hda of=/dev/hda
 
当硬盘较长时间(一年以上)放置不使用后，磁盘上会产生magnetic flux point，当磁头读到这些区域时会遇到困难，并可能导致I/O错误。当这种情况影响到硬盘的第一个扇区时，可能导致硬盘报废。上边的命令有可能使这些数 据起死回生。并且这个过程是安全、高效的。

15.利用netcat远程备份

    dd if=/dev/hda bs=16065b | netcat < targethost-IP > 1234
    
在源主机上执行此命令备份/dev/hda

    netcat -l -p 1234 | dd of=/dev/hdc bs=16065b
    
在目的主机上执行此命令来接收数据并写入/dev/hdc

    netcat -l -p 1234 | bzip2 > partition.img
    netcat -l -p 1234 | gzip > partition.img

以上两条指令是目的主机指令的变化分别采用bzip2、gzip对数据进行压缩，并将备份文件保存在当前目录。

16.将一个很大的视频文件中的第i个字节的值改成0x41（也就是大写字母A的ASCII值）

    echo A | dd of=bigfile seek=$i bs=1 count=1 conv=notrunc
    
17.测试文件系统 inode 耗尽但仍有磁盘空间的情景

    # dd if=/dev/zero of=mo.img bs=5120k count=1 
    # ls -lh mo.img 
    -rw-r--r-- 1 root root 5.0M Sep  1 17:54 mo.img 
    # mkfs -t ext4  -F ./mo.img 
    ... 
    OS type: Linux 
    Block size=1024 (log=0) 
    Fragment size=1024 (log=0) 
    Stride=0 blocks, Stripe width=0 blocks 
    1280 inodes, 5120 blocks 
    256 blocks (5.00%) reserved for the super user 
    ... 
    ... 
    Writing superblocks and filesystem accounting information: done 
     
    # mount -o loop ./mo.img /mnt 
    # cat /mnt/inode_test.sh 
    #!/bin/bash 
     
    for ((i = 1; ; i++)) 
    do 
       if [ $? -eq 0 ]; then 
           echo  "This is file_$i" > file_$i 
       else 
           exit 0 
       fi 
    done 
     
    # ./inode_test.sh 
    ./inode_test.sh: line 6: file_1269: No space left on device 
     
    # df -iT /mnt/; du -sh /mnt/ 
    Filesystem     Type Inodes IUsed IFree IUse% Mounted on 
    /dev/loop0     ext4   1280  1280     0  100% /mnt 
    1.3M    /mnt/


    
三、/dev/null和/dev/zero的区别
-----

`/dev/null`，外号叫无底洞，你可以向它输出任何数据，它通吃，并且不会撑着！

`/dev/zero`，是一个输入设备，你可你用它来初始化文件。该设备无穷尽地提供0，可以使用任何你需要的数目——设备提供的要多的多。他可以用于向设备或文件写入字符串0。

/dev/null——它是空设备，也称为位桶（bit bucket）。任何写入它的输出都会被抛弃。如果不想让消息以标准输出显示或写入文件，那么可以将消息重定向到位桶。

    if=/dev/zero of=./test.txt bs=1k count=1
    ls –l
    total 4
    -rw-r--r-- 1 oracle dba 1024 Jul 15 16:56 test.txt
    find / -name access_log 2>/dev/null
    
3.1 使用/dev/null

把/dev/null看作”黑洞”， 它等价于一个只写文件，所有写入它的内容都会永远丢失.，而尝试从它那儿读取内容则什么也读不到。然而， /dev/null对命令行和脚本都非常的有用

禁止标准输出

    cat $filename >/dev/null #文件内容丢失，而不会输出到标准输出.

禁止标准错误

    rm $badname 2>/dev/null #这样错误信息[标准错误]就被丢到太平洋去了

禁止标准输出和标准错误的输出

    cat $filename 2>/dev/null >/dev/null

如果”filename”不存在，将不会有任何错误信息提示；如果”filename”存在， 文件的内容不会打印到标准输出。因此，上面的代码根本不会输出任何信息。当只想测试命令的退出码而不想有任何输出时非常有用。

3.2 使用/dev/zero

像/dev/null一样， /dev/zero也是一个伪文件， 但它实际上产生连续不断的null的流（二进制的零流，而不是ASCII型的）。 写入它的输出会丢失不见， 而从/dev/zero读出一连串的null也比较困难， 虽然这也能通过od或一个十六进制编辑器来做到。

`/dev/zero`主要的用处是用来创建一个指定长度用于初始化的空文件，就像临时交换文件。

用`/dev/zero` 创建一个交换临时文件

    #!/bin/bash
    # 创建一个交换文件.
    ROOT_UID=0 # Root 用户的 $UID 是 0.
    E_WRONG_USER=65 # 不是 root?
    FILE=/swap
    BLOCKSIZE=1024
    MINBLOCKS=40
    SUCCESS=0
    # 这个脚本必须用root来运行.
    if [ "$UID" -ne "$ROOT_UID" ]
    then
    echo; echo "You must be root to run this script."; echo
    exit $E_WRONG_USER
    fi
    blocks=${1:-$MINBLOCKS} # 如果命令行没有指定，
    #+ 则设置为默认的40块.
    # 上面这句等同如：
    # --------------------------------------------------
    # if [ -n "$1" ]
    # then
    # blocks=$1
    # else
    # blocks=$MINBLOCKS
    # fi
    # --------------------------------------------------
    if [ "$blocks" -lt $MINBLOCKS ]
    then
    blocks=$MINBLOCKS # 最少要有 40 个块长.
    fi
    echo "Creating swap file of size $blocks blocks (KB)."
    dd if=/dev/zero of=$FILE bs=$BLOCKSIZE count=$blocks # 把零写入文件.
    mkswap $FILE $blocks # 将此文件建为交换文件（或称交换分区）.
    swapon $FILE # 激活交换文件.
    echo "Swap file created and activated."
    exit $SUCCESS

关于 /dev/zero 的另一个应用是为特定的目的而用零去填充一个指定大小的文件， 如挂载一个文件系统到环回设备 （loopback device）或"安全地" 删除一个文件。

例子创建ramdisk

    #!/bin/bash
    # ramdisk.sh
    # "ramdisk"是系统RAM内存的一段，
    #+ 它可以被当成是一个文件系统来操作.
    # 它的优点是存取速度非常快 (包括读和写).
    # 缺点: 易失性, 当计算机重启或关机时会丢失数据.
    #+ 会减少系统可用的RAM.
    # 10 # 那么ramdisk有什么作用呢?
    # 保存一个较大的数据集在ramdisk, 比如一张表或字典,
    #+ 这样可以加速数据查询, 因为在内存里查找比在磁盘里查找快得多.
    E_NON_ROOT_USER=70 # 必须用root来运行.
    ROOTUSER_NAME=root
    MOUNTPT=/mnt/ramdisk
    SIZE=2000 # 2K 个块 (可以合适的做修改)
    BLOCKSIZE=1024 # 每块有1K (1024 byte) 的大小
    DEVICE=/dev/ram0 # 第一个 ram 设备
    username=`id -nu`
    if [ "$username" != "$ROOTUSER_NAME" ]
    then
    echo "Must be root to run "`basename $0`"."
    exit $E_NON_ROOT_USER
    fi
    if [ ! -d "$MOUNTPT" ] # 测试挂载点是否已经存在了,
    then  + 如果这个脚本已经运行了好几次了就不会再建这个目录了
    mkdir $MOUNTPT  + 因为前面已经建立了.
    fi
    dd if=/dev/zero of=$DEVICE count=$SIZE bs=$BLOCKSIZE

    把RAM设备的内容用零填充.
    为何需要这么做?
    mke2fs $DEVICE 在RAM设备上创建一个ext2文件系统.
    mount $DEVICE $MOUNTPT  挂载设备.
    chmod 777 $MOUNTPT # 使普通用户也可以存取这个ramdisk.
    但是, 只能由root来缷载它.
    echo ""$MOUNTPT" now available for use."
    现在 ramdisk 即使普通用户也可以用来存取文件了.
    注意, ramdisk是易失的, 所以当计算机系统重启或关机时ramdisk里的内容会消失.
    拷贝所有你想保存文件到一个常规的磁盘目录下.
    重启之后, 运行这个脚本再次建立起一个 ramdisk.
    仅重新加载 /mnt/ramdisk 而没有其他的步骤将不会正确工作.
    如果加以改进, 这个脚本可以放在 /etc/rc.d/rc.local,
    + 以使系统启动时能自动设立一个ramdisk.
    这样很合适速度要求高的数据库服务器.
    exit 0



