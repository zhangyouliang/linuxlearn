> rsync (remote synchronize) 是一个远程数据同步工具，可通过LAN/WAN快速同步多台主机间的文件

> Rsync使用所谓的“Rsync算法”来使本地和远 程两个主机之间的文件达到同步，***这个算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快***

> [参考](https://www.cnblogs.com/george-guo/p/7718515.html)

### 特点
-----

    1、可以镜像保存整个目录树和文件系统；
    2、可以很容易做到保持原来文件的权限、时间、软硬链接等；
    3、无须特殊权限即可安装；
    4、优化的流程，文件传输效率高；
    5、可以使用rsh、ssh等方式来传输文件，当然也可以通过直接的socket连接；
    6、支持匿名传输
    
    
### ssh 模式
----


本地间同步: 环境 172.16.22.12

    mkdir src
    touch src/{1,2,3}
    mkdir dest
    # 将 src 目录里的所有的文件同步至 dest 目录（不包含src本身）
    rsync -av src/ dest/  
    # 将 src 目录包括自己整个同步至 dest 目录
    rsync -av src dest/
    # 即使 src 后面接有 / ，效果同上
    rsync -avR src/ dest/   

局域网间同步: 环境： 172.16.22.11

    mkdir src
    touch src/{a,b,c,d}
    mkdir dest
    # --远程同步至本地，需输入root密码
    rsync -av 172.16.22.12:/data/test/src/ dest/
    # 本地文件同步至远程
    rsync -av src/ 172.16.22.12:/data/test/dest/ 
    # --整个目录同步过去
    rsync -av src 172.16.22.12:/data/test/dest/
    # 删除一个文件 d
    rm -rf src/d
    # 从目标目录里面删除无关的文件
    rsync -av --delete src/ 172.16.22.12:/data/test/dest/ --delete





#### # 参数

    -v, --verbose 详细模式输出
    -q, --quiet 精简输出模式
    -c, --checksum 打开校验开关，强制对文件传输进行校验
    -a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
    -r, --recursive 对子目录以递归模式处理
    -R, --relative 使用相对路径信息
    -b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。
    --backup-dir 将备份文件(如~filename)存放在在目录下。
    -suffix=SUFFIX 定义备份文件前缀
    -u, --update 仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件。(不覆盖更新的文件)
    -l, --links 保留软链结
    -L, --copy-links 想对待常规文件一样处理软链结
    --copy-unsafe-links 仅仅拷贝指向SRC路径目录树以外的链结
    --safe-links 忽略指向SRC路径目录树以外的链结
    -H, --hard-links 保留硬链结
    -p, --perms 保持文件权限
    -o, --owner 保持文件属主信息
    -g, --group 保持文件属组信息
    -D, --devices 保持设备文件信息
    -t, --times 保持文件时间信息
    -S, --sparse 对稀疏文件进行特殊处理以节省DST的空间
    -n, --dry-run现实哪些文件将被传输
    -W, --whole-file 拷贝文件，不进行增量检测
    -x, --one-file-system 不要跨越文件系统边界
    -B, --block-size=SIZE 检验算法使用的块尺寸，默认是700字节
    -e, --rsh=COMMAND 指定使用rsh、ssh方式进行数据同步
    --rsync-path=PATH 指定远程服务器上的rsync命令所在路径信息
    -C, --cvs-exclude 使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件
    --existing 仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件
    --delete 删除那些DST中SRC没有的文件
    --delete-excluded 同样删除接收端那些被该选项指定排除的文件
    --delete-after 传输结束以后再删除
    --ignore-errors 及时出现IO错误也进行删除
    --max-delete=NUM 最多删除NUM个文件
    --partial 保留那些因故没有完全传输的文件，以是加快随后的再次传输
    --force 强制删除目录，即使不为空
    --numeric-ids 不将数字的用户和组ID匹配为用户名和组名
    --timeout=TIME IP超时时间，单位为秒
    -I, --ignore-times 不跳过那些有同样的时间和长度的文件
    --size-only 当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间
    --modify-window=NUM 决定文件是否时间相同时使用的时间戳窗口，默认为0
    -T --temp-dir=DIR 在DIR中创建临时文件
    --compare-dest=DIR 同样比较DIR中的文件来决定是否需要备份
    -P 等同于 --partial
    --progress 显示备份过程
    -z, --compress 对备份的文件在传输时进行压缩处理
    --exclude=PATTERN 指定排除不需要传输的文件模式
    --include=PATTERN 指定不排除而需要传输的文件模式
    --exclude-from=FILE 排除FILE中指定模式的文件
    --include-from=FILE 不排除FILE指定模式匹配的文件
    --version 打印版本信息
    --address 绑定到特定的地址
    --config=FILE 指定其他的配置文件，不使用默认的rsyncd.conf文件
    --port=PORT 指定其他的rsync服务端口
    --blocking-io 对远程shell使用阻塞IO
    -stats 给出某些文件的传输状态
    --progress 在传输时现实传输过程
    --log-format=formAT 指定日志文件格式
    --password-file=FILE 从FILE中得到密码
    --bwlimit=KBPS 限制I/O带宽，KBytes per second
    -h, --help 显示帮助信息

