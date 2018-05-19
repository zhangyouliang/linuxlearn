> mkfs: 命令用于在设备上（通常为硬盘）创建Linux文件系统。mkfs本身并不执行建立文件系统的工作，而是去调用相关的程序来执行


语法
----
    mkfs(选项)(参数)
    
选项
----
    fs：指定建立文件系统时的参数；
    -t<文件系统类型>：指定要建立何种文件系统；
    -v：显示版本信息与详细的使用方法；
    -V：显示简要的使用方法；
    -c：在制做档案系统前，检查该partition是否有坏轨。


应用:
----

 
    # 利用 /dev/zero 创建大小为5M的空文件
    dd if=/dev/zero of=mo.img bs=5120k count=1
    # 格式化为 ext4 格式
    mkfs -t ext4  -F ./mo.img
    # 挂载到/mnt下面
    mount -o loop ./mo.img /mnt  
    # 在/dev/hda5上建一个msdos的档案系统，同时检查是否有坏轨存在，并且将过程详细列出来：
    mkfs -V -t msdos -c /dev/hda5
    mkfs -t ext3 /dev/sda6     //将sda6分区格式化为ext3格式
    mkfs -t ext2 /dev/sda7     //将sda7分区格式化为ext2格式