> lastb命令用于显示用户错误的登录列表，此指令可以发现系统的登录异常。单独执行lastb命令，它会读取位于`/var/log`目录下，名称为btmp的文件，并把该文件内容记录的登入失败的用户名单，全部显示出来。

语法
--
    lastb(选项)(参数)
选项
--
    -a：把从何处登入系统的主机名称或ip地址显示在最后一行；
    -d：将IP地址转换成主机名称；
    -f<记录文件>：指定记录文件；
    -n<显示列数>或-<显示列数>：设置列出名单的显示列数；
    -R：不显示登入系统的主机名称或IP地址；
    -x：显示系统关机，重新开机，以及执行等级的改变等信息。
参数
--
- 用户名：显示中的用户的登录列表；
- 终端：显示从指定终端的登录列表。

实例
--
首次运行lastb命令会报下的错误：

    lastb: /var/log/btmp: No such file or directory
    Perhaps this file was removed by the operator to prevent logging lastb info.
只需建立这个不存在的文件即可。

    touch /var/log/btmp
    
使用ssh的登录失败不会记录在btmp文件中。

    ➜  ~ lastb | head
    admin    ssh:notty    197.44.78.92     Tue May 29 05:19 - 05:19  (00:00)
    admin    ssh:notty    190.214.219.208  Tue May 29 05:19 - 05:19  (00:00)
    admin    ssh:notty    62.221.103.166   Tue May 29 05:19 - 05:19  (00:00)
    admin    ssh:notty    114.217.54.10    Mon May 28 04:33 - 04:33  (00:00)
    admin    ssh:notty    138.118.7.2      Mon May 28 04:33 - 04:33  (00:00)
    admin    ssh:notty    14.186.197.254   Mon May 28 04:33 - 04:33  (00:00)
    admin    ssh:notty    82.212.83.154    Sun May 27 16:11 - 16:11  (00:00)
    admin    ssh:notty    117.1.159.124    Sun May 27 16:11 - 16:11  (00:00)
    admin    ssh:notty    31.23.141.58     Sun May 27 16:11 - 16:11  (00:00)
    admin    ssh:notty    195.9.0.74       Sun May 27 03:50 - 03:50  (00:00)