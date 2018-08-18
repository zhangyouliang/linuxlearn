> linux inode 节点先关只是

> [参考:阮一峰网络日志-理解inode](http://www.ruanyifeng.com/blog/2011/12/inode.html)

inode 基本信息
----

    * 文件的字节数
    * 文件拥有者的User ID
    * 文件的Group ID
    * 文件的读、写、执行权限
    * 文件的时间戳，共有三个：ctime指inode上一次变动的时间，mtime指文件内容上一次变动的时间，atime指文件上一次打开的时间。
    * 链接数，即有多少文件名指向这个inode
    * 文件数据block的位置

基本操作
------

    # stat 命令查看 inode 信息
    stat example.txt
    
    # 查看每个硬盘分区的inode总数和已经使用的数量，可以使用df命令。
    df -i   
    # 查看每个inode节点的大小，可以用如下命令：
    sudo dumpe2fs -h /dev/hda | grep "Inode size"

    # 使用ls -i命令，可以看到文件名对应的inode号码：
    ls -i example.txt


linux下利用inode(i节点号)删除指定文件
----
    

    # 利用find命令来删除(直接删除，不会询问你确认删除。)
    find ./* -inum 1049741 -delete
    # 利用find命令的-exec参数来调用rm命令来删除
    find ./* -inum 1049741 -exec rm -i {} \;
    # 使用xargs配合find的结果进行删除
    find ./* -inum 1049741 |xargs rm -f


find会调用rm命令，此时，==rm会询问是否确认删除==。
如果对rm命令添加-f参数，则强制删除，rm命令不会询问确认删除。
