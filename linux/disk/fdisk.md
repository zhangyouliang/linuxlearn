> fdisk: 操作磁盘分区表



一. 参数
-----


二.  应用:
---
````
fdisk /dev/vda //对 vda 磁盘进行分区
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel. Changes will remain in memory only,
until you decide to write them. After that, of course, the previous
content won't be recoverable.


The number of cylinders for this disk is set to 2597.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
    (e.g., DOS FDISK, OS/2 FDISK)
Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

Command (m for help): m          //输出帮助信息
 Command action
    a   toggle a bootable flag    //设置启动分区
    b   edit bsd disklabel        //编辑分区标签
    c   toggle the dos compatibility flag
    d   delete a partition        //删除一个分区
    l   list known partition types  //列出分区类型
    m   print this menu           //输出帮助信息
    n   add a new partition       //建立一个新的分区
    o   create a new empty DOS partition table //创建一个新的空白DOS分区表
    p   print the partition table    //打印分区表
    q   quit without saving changes  //退出不保存设置
    s   create a new empty Sun disklabel
    t   change a partition's system id  //改变分区的ID
    u   change display/entry units    //改变显示的单位
    v   verify the partition table    //检查验证分区表
    w   write table to disk and exit  //保存分区表
    x   extra functionality (experts only)
Command (m for help):n     
Command action
   e   extended                 //e是扩展分区
   p   primary partition (1-4)  //p是主分区
p
Partition number (1-4): 1       //定义分区数量   --主分区最多只能有四个
First cylinder (1-2597, default 1): 1
Last cylinder or +size or +sizeM or +sizeK (1-2597, default 2597): +100M

Command (m for help): w          //保存刚才的配置信息。
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 22: 无效的参数.
The kernel still uses the old table.
The new table will be used at the next reboot.
Syncing disks.
````