> find : 搜索命令 

> [参考](http://blog.51cto.com/13572810/2065800)

> [参考](http://man.linuxde.net/find)

格式
----

    find path -option [ -print] [-exec -ok command] {}\;
    
- -path：就是文件的路径啦
- -option：就是下面要说明的各个参数，参数后面有的会有操作数，需要注意
- -print：find命令将匹配的文件输出到标准输出。
- -exec ： -ok 是-exec 的一个选项，加上之后执行command时会询问用户
   -  find . -type f -mtime -1 -exec rm {} \; # 不询问
   -  find . -name "*.log" -type f  -mtime -1 -ok rm {} \; # 询问
- {} \：注意是反斜杠，大括号和反斜杠之间有一个空格 (注意！！！！分号必不可少！！！)
  - find . -type f -exec ls -l {} \;
- -print0 将分隔符 \n 替换为 NULL(可以结合 xargs -0 使用,删除带有空格的文件)

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
    -empty 查询空文件夹
    -perm 按照文件权限来查找文件
    -user 按照文件属主来查询文件
    -group 按照文件所属的组来查找文件
    -nogroup 查看无效分组的文件
    -nouser 查看无效用户的文件
    -newer f1 !f2 查更改时间比f1新但比f2旧的文件
    -prune 忽律某个目录
    
    
    -mtime [-n/+n]  按照文件的更改时间来查找文件， -n 表示文件更改时间距现在n天以内，+n 表示文件更改时间距现在n天以前。find命令还有-atime和-ctime 选项，但它们都和-m time选项。
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
    
    -size 
    # 查找出大于10000000字节的文件(c:字节，w:双字，k:KB，M:MB，G:GB)
    find / -size +10000c 
    # 查找出小于1000KB的文件
    find / -size -1000k 　　


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

选项

    - amin n  查找系统中最后N分钟访问的文件
    - atime n  查找系统中最后n*24小时访问的文件

使用

    # 查找今天的(24小时内)

    find . -atime -1

    # 查找今天之前的(24小时内)

    find . -atime +1

    # 搜索当前目录的以 .log 结尾,一天内,权限 600 ,大小大于 1 b 的普通文件,并且按照普通方式输出
    find . -type f -name '*.log' -atime -1 -perm 600 -size +1c -print
    
    # -exec 执行命令
    # 管道传递给 cat
    find . -type f -name '*.log' -exec cat {} \;
    
    # 删除 .log 文件之前进行询问
    find . -name "[a-zA-Z].log"  -type f -mtime -1 -ok rm {} \;
    
    # 直接删除不询问
    find . -name "[a-zA-Z].log"  -type f -mtime -1 -exec rm {} \;
    



exec 解释:
----

-exec 参数后面跟的是 command 命令,它的终止是以`;`为结束标识的

{} 花括号标识前面 find 查找出来的文件名字

> cd $GOPATH/src/golang.org/x 

    # 列出全部文件,并且执行 ls -l
    find . -type f -exec ls -l {} \;

    # 搜索 .md 文件,并且显示文件名称
    find . -name '*.md' -exec grep -l 'open' {} \; 

    # 搜索 .md 文件当中,包含 'golang.org/x' 的全部文件(缺点:不显示文件名)
    find . -type f -name "*.md" | xargs cat | grep "golang.org/x"
    
    # 替换全部 *.log 里面的字符串
    find . -type f -name "*.log" -exec sed -i "s/2021/2020/g" {} \;
    
    # 搜索文件内容,并且显示文件名称(高亮显示)
    # -r 递归
    # -n 显示行号
    grep "golang.org/x" -rn .  --include='*.go'
    
    # find 结合 xargs,grep 使用(不高亮显示)
    find . -type f -name "*.go" | xargs grep -n windows

    # 搜索排除某个文件
    # 搜索当前目录(深度: 1),排除文件:*.log , *.go
    find . -type f -maxdepth 1 \( ! -name "*.log" ! -name "*.go"  \)
    # 搜索文件并赋值到指定目录
    find . -type f -maxdepth 1 | xargs -I {} mv {} ./bin   
