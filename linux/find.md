> find : 搜索命令 

> [参考](http://blog.51cto.com/13572810/2065800)

> [参考](http://man.linuxde.net/find)

格式
----

    find path -option [ -print] [-exec -ok command] {}\;
    
- -path：就是文件的路径啦
- -option：就是下面要说明的各个参数，参数后面有的会有操作数，需要注意
- -print：find命令将匹配的文件输出到标准输出。
- -exec ： -ok是-exec的一个选项，加上之后执行command时会询问用户
- {} \：注意是反斜杠，大括号和反斜杠之间有一个空格
- -;：注意！！！！分号必不可少！！！

命令参数
----

    pathname: find命令所查找的目录路径。例如用.来表示当前目录，用/来表示系统根目录。 

    -print： find命令将匹配的文件输出到标准输出。 

    ..

详解
----

`stat filename` 查看文件属性包含 inode,ctime,atime,mtime等

    stat a.log
      File: 'a.log'
      Size: 30        	Blocks: 8          IO Block: 4096   regular file
    Device: fd01h/64769d	Inode: 670307      Links: 1
    Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (    0/    root)
    Access: 2018-08-19 08:05:12.841142621 +0800
    Modify: 2018-08-19 08:05:12.793142414 +0800
    Change: 2018-08-19 08:05:12.793142414 +0800
     Birth: -

- modification time(mtime) : 文件修改的时候会变化,但是 ctime 也会变化
- status time (ctime) 当文件权限被修改的时候改变,不是 `change time`,也不是`create time`,而是 `status time`
- accesstime (atime) 当文件被使用的时候更新




命令选项
----


    -name 按照文件名查询文件
    -perm 按照文件权限来查找文件
    -uer 按照文件属主来查询文件
    -group 按照文件所属的组来查找文件
    -nogroup 查看无效分组的文件
    -nouser 查看无效用户的文件
    -newer f1 !f2 查更改时间比f1新但比f2旧的文件
    -prune 忽律某个目录
    
    
    -mtime -n +n  按照文件的更改时间来查找文件， - n表示文件更改时间距现在n天以内，+ n表示文件更改时间距现在n天以前。find命令还有-atime和-ctime 选项，但它们都和-m time选项。
    atime : 访问时间(access time)
    mtime : 修改时间(modify time)
    ctime: 状态修改时间(change time)

    -type  查找某一类型的文件，诸如：

    b - 块设备文件。
    d - 目录。
    c - 字符设备文件。
    p - 管道文件。
    l - 符号链接文件。
    f - 普通文件。


### # 查看文件属性

    stat filename 

### # 命令参数：

    -a 列出打开文件存在的进程

    -c<进程名> 列出指定进程所打开的文件

    -g  列出GID号进程详情

    -d<文件号> 列出占用该文件号的进程

    +d<目录>  列出目录下被打开的文件

    +D<目录>  递归列出目录下被打开的文件

    -n<目录>  列出使用NFS的文件

    -i<条件>  列出符合条件的进程。（4、6、协议、:端口、 @ip ）

    -p<进程号> 列出指定进程号所打开的文件

    -u  列出UID号进程详情

    -h 显示帮助信息

    -v 显示版本信息



例子
----


    atime n  查找系统中最后N分钟访问的文件
    amin n  查找系统中最后n*24小时访问的文件

    # 查找今天的(24小时内)

    find . -atime -1

    # 查找今天之前的(24小时内)

    find . -atime +1

    # 搜索当前目录的以 .log 结尾,一天内,权限问 600 ,大小大于 1 b 的普通文件,并且按照普通方式输出
    find . -type f -name '*.log' -atime -1 -perm 600 -size +1c -print
    
    # -exec 执行命令
    find . -type f -name '*.log' -exec cat {} \;
    
    
    



exec 解释:
----

-exec 参数后面跟的是 command 命令,它的终止是以`;`为结束标识的

{} 花括号标识前面 find 查找出来的文件名字

    find . -type f -exec ls -l {} \;

