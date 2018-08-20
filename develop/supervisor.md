> supervisor  管理后台运行的程序

> 项目中有些脚本需要通过后台进程运行,保证不被异常中断,之前都是通过nohup、&、screen来实现,现在可以直接通过 supervisor 进行管理

> [参考](https://www.cnblogs.com/zhoujinyi/p/6073705.html)

安装
--

    # easy_install install
    easy_install supervisor
    # pip install
    pip install supervisor
    # ubuntu/debian install
    apt install supervisor
    
配置文件
---

***1）通过apt-get install安装后，supervisor的配置文件在：***

    /etc/supervisor/supervisord.conf 

supervisor的配置文件默认是不全的，不过在大部分默认的情况下，上面说的基本功能已经满足。而其管理的子进程配置文件在：

    /etc/supervisor/conf.d/*.conf

然后，开始给自己需要的脚本程序编写一个子进程配置文件，让supervisor来管理它，放在 `/etc/supervisor/conf.d/` 目录下，以.conf作为扩展名（每个进程的配置文件都可以单独分拆也可以把相关的脚本放一起）。如任意定义一个和脚本相关的项目名称的选项组（`/etc/supervisor/conf.d/test.conf`）：

    #项目名
    [program:blog]
    #脚本目录
    directory=/opt/bin
    #脚本执行命令
    command=/usr/bin/python /opt/bin/test.py
    #supervisor启动的时候是否随着同时启动，默认True
    autostart=true
    #当程序exit的时候，这个program不会自动重启,默认unexpected
    #设置子进程挂掉后自动重启的情况，有三个选项，false,unexpected和true。如果为false的时候，无论什么情况下，都不会被重新启动，如果为unexpected，只有当进程的退出码不在下面的exitcodes里面定义的
    autorestart=false
    #这个选项是子进程启动多少秒之后，此时状态如果是running，则我们认为启动成功了。默认值为1
    startsecs=1
    #日志输出 
    stderr_logfile=/tmp/blog_stderr.log 
    stdout_logfile=/tmp/blog_stdout.log 
    #脚本运行的用户身份 
    user = zhoujy 
    #把 stderr 重定向到 stdout，默认 false
    redirect_stderr = true
    #stdout 日志文件大小，默认 50MB
    stdout_logfile_maxbytes = 20M
    #stdout 日志文件备份数
    stdout_logfile_backups = 20
    
    
    [program:zhoujy] #说明同上
    directory=/opt/bin 
    command=/usr/bin/python /opt/bin/zhoujy.py 
    autostart=true 
    autorestart=false 
    stderr_logfile=/tmp/zhoujy_stderr.log 
    stdout_logfile=/tmp/zhoujy_stdout.log 
    #user = zhoujy  

***2）通过easy_install安装后，配置文件不存在，需要自己导入。***

①：运行`echo_supervisord_conf`打印出一个配置文件的样本，样本说明可以看supervisor(一)基础篇的详细说明，要是设置样本为一个配置文件则：

1：运行 `echo_supervisord_conf`，查看配置样本：

    echo_supervisord_conf

2：创建配置文件：

    echo_supervisord_conf > /etc/supervisord.conf

②：配置子进程配置文件，可以直接在supervisor中的;[program:theprogramname]里设置。

详细的子进程配置文件：

样本：

    ;[program:theprogramname]
    ;command=/bin/cat              ; the program (relative uses PATH, can take args)
    ;process_name=%(program_name)s ; process_name expr (default %(program_name)s)
    ;numprocs=1                    ; number of processes copies to start (def 1)
    ;directory=/tmp                ; directory to cwd to before exec (def no cwd)
    ;umask=022                     ; umask for process (default None)
    ;priority=999                  ; the relative start priority (default 999)
    ;autostart=true                ; start at supervisord start (default: true)
    ;startsecs=1                   ; # of secs prog must stay up to be running (def. 1)
    ;startretries=3                ; max # of serial start failures when starting (default 3)
    ;autorestart=unexpected        ; when to restart if exited after running (def: unexpected)
    ;exitcodes=0,2                 ; 'expected' exit codes used with autorestart (default 0,2)
    ;stopsignal=QUIT               ; signal used to kill process (default TERM)
    ;stopwaitsecs=10               ; max num secs to wait b4 SIGKILL (default 10)
    ;stopasgroup=false             ; send stop signal to the UNIX process group (default false)
    ;killasgroup=false             ; SIGKILL the UNIX process group (def false)
    ;user=chrism                   ; setuid to this UNIX account to run the program
    ;redirect_stderr=true          ; redirect proc stderr to stdout (default false)
    ;stdout_logfile=/a/path        ; stdout log path, NONE for none; default AUTO
    ;stdout_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    ;stdout_logfile_backups=10     ; # of stdout logfile backups (default 10)
    ;stdout_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    ;stdout_events_enabled=false   ; emit events on stdout writes (default false)
    ;stderr_logfile=/a/path        ; stderr log path, NONE for none; default AUTO
    ;stderr_logfile_maxbytes=1MB   ; max # logfile bytes b4 rotation (default 50MB)
    ;stderr_logfile_backups=10     ; # of stderr logfile backups (default 10)
    ;stderr_capture_maxbytes=1MB   ; number of bytes in 'capturemode' (default 0)
    ;stderr_events_enabled=false   ; emit events on stderr writes (default false)
    ;environment=A="1",B="2"       ; process environment additions (def no adds)
    ;serverurl=AUTO                ; override serverurl computation (childutils)


说明：


    ;[program:theprogramname]      ;这个就是咱们要管理的子进程了，":"后面的是名字，最好别乱写和实际进程
                                    有点关联最好。这样的program我们可以设置一个或多个，一个program就是
                                    要被管理的一个进程
    ;command=/bin/cat              ; 这个就是我们的要启动进程的命令路径了，可以带参数
                                    例子：/home/test.py -a 'hehe'
                                    有一点需要注意的是，我们的command只能是那种在终端运行的进程，不能是
                                    守护进程。这个想想也知道了，比如说command=service httpd start。
                                    httpd这个进程被linux的service管理了，我们的supervisor再去启动这个命令
                                    这已经不是严格意义的子进程了。
                                    这个是个必须设置的项
    ;process_name=%(program_name)s ; 这个是进程名，如果我们下面的numprocs参数为1的话，就不用管这个参数
                                     了，它默认值%(program_name)s也就是上面的那个program冒号后面的名字，
                                     但是如果numprocs为多个的话，那就不能这么干了。想想也知道，不可能每个
                                     进程都用同一个进程名吧。
    
                                    
    ;numprocs=1                    ; 启动进程的数目。当不为1时，就是进程池的概念，注意process_name的设置
                                     默认为1    。。非必须设置
    ;directory=/tmp                ; 进程运行前，会前切换到这个目录
                                     默认不设置。。。非必须设置
    ;umask=022                     ; 进程掩码，默认none，非必须
    ;priority=999                  ; 子进程启动关闭优先级，优先级低的，最先启动，关闭的时候最后关闭
                                     默认值为999 。。非必须设置
    ;autostart=true                ; 如果是true的话，子进程将在supervisord启动后被自动启动
                                     默认就是true   。。非必须设置
    ;autorestart=unexpected        ; 这个是设置子进程挂掉后自动重启的情况，有三个选项，false,unexpected
                                     和true。如果为false的时候，无论什么情况下，都不会被重新启动，
                                     如果为unexpected，只有当进程的退出码不在下面的exitcodes里面定义的退 
                                     出码的时候，才会被自动重启。当为true的时候，只要子进程挂掉，将会被无
                                     条件的重启
    ;startsecs=1                   ; 这个选项是子进程启动多少秒之后，此时状态如果是running，则我们认为启
                                     动成功了
                                     默认值为1 。。非必须设置
    ;startretries=3                ; 当进程启动失败后，最大尝试启动的次数。。当超过3次后，supervisor将把
                                     此进程的状态置为FAIL
                                     默认值为3 。。非必须设置
    ;exitcodes=0,2                 ; 注意和上面的的autorestart=unexpected对应。。exitcodes里面的定义的
                                     退出码是expected的。
    ;stopsignal=QUIT               ; 进程停止信号，可以为TERM, HUP, INT, QUIT, KILL, USR1, or USR2等信号
                                      默认为TERM 。。当用设定的信号去干掉进程，退出码会被认为是expected
                                      非必须设置
    ;stopwaitsecs=10               ; 这个是当我们向子进程发送stopsignal信号后，到系统返回信息
                                     给supervisord，所等待的最大时间。 超过这个时间，supervisord会向该
                                     子进程发送一个强制kill的信号。
                                     默认为10秒。。非必须设置
    ;stopasgroup=false             ; 这个东西主要用于，supervisord管理的子进程，这个子进程本身还有
                                     子进程。那么我们如果仅仅干掉supervisord的子进程的话，子进程的子进程
                                     有可能会变成孤儿进程。所以咱们可以设置可个选项，把整个该子进程的
                                     整个进程组都干掉。 设置为true的话，一般killasgroup也会被设置为true。
                                     需要注意的是，该选项发送的是stop信号
                                     默认为false。。非必须设置。。
    ;killasgroup=false             ; 这个和上面的stopasgroup类似，不过发送的是kill信号
    ;user=chrism                   ; 如果supervisord是root启动，我们在这里设置这个非root用户，可以用来
                                     管理该program
                                     默认不设置。。。非必须设置项
    ;redirect_stderr=true          ; 如果为true，则stderr的日志会被写入stdout日志文件中
                                     默认为false，非必须设置
    ;stdout_logfile=/a/path        ; 子进程的stdout的日志路径，可以指定路径，AUTO，none等三个选项。
                                     设置为none的话，将没有日志产生。设置为AUTO的话，将随机找一个地方
                                     生成日志文件，而且当supervisord重新启动的时候，以前的日志文件会被
                                     清空。当 redirect_stderr=true的时候，sterr也会写进这个日志文件
    ;stdout_logfile_maxbytes=1MB   ; 日志文件最大大小，和[supervisord]中定义的一样。默认为50
    ;stdout_logfile_backups=10     ; 和[supervisord]定义的一样。默认10
    ;stdout_capture_maxbytes=1MB   ; 这个东西是设定capture管道的大小，当值不为0的时候，子进程可以从stdout
                                     发送信息，而supervisor可以根据信息，发送相应的event。
                                     默认为0，为0的时候表达关闭管道。。。非必须项
    ;stdout_events_enabled=false   ; 当设置为ture的时候，当子进程由stdout向文件描述符中写日志的时候，将
                                     触发supervisord发送PROCESS_LOG_STDOUT类型的event
                                     默认为false。。。非必须设置
    ;stderr_logfile=/a/path        ; 这个东西是设置stderr写的日志路径，当redirect_stderr=true。这个就不用
                                     设置了，设置了也是白搭。因为它会被写入stdout_logfile的同一个文件中
                                     默认为AUTO，也就是随便找个地存，supervisord重启被清空。。非必须设置
    ;stderr_logfile_maxbytes=1MB   ; 这个出现好几次了，就不重复了
    ;stderr_logfile_backups=10     ; 这个也是
    ;stderr_capture_maxbytes=1MB   ; 这个一样，和stdout_capture一样。 默认为0，关闭状态
    ;stderr_events_enabled=false   ; 这个也是一样，默认为false
    ;environment=A="1",B="2"       ; 这个是该子进程的环境变量，和别的子进程是不共享的
    ;serverurl=AUTO                ;


改成自己实际的配置文件：和①上面一样。

***3：运行***

1）apt-get install 安装的supervisor直接可以通过 `/etc/init.d/supervisor` 运行：

    /etc/init.d/supervisor start
2）通过easy_install 安装的supervisor运行supervisord 运行：

    supervisord 

***4：web界面操作***

需要在supervisor的配置文件里添加`[inet_http_server]`选项组：之后可以通过[http://10.211.55.11:9001](http://10.211.55.11:9001) 来访问控制子线程的管理。

    [inet_http_server]
    port=10.211.55.11:9001
    username=user
    password=123

***5：子进程管理(supervisorctl)***

1) 查看所有子进程的状态： 
    
    
    # supervisorctl status
    blog                             RUNNING    pid 2395, uptime 0:08:41
    zhoujy                           RUNNING    pid 2396, uptime 0:08:41
    
    
2）关闭、开启指定的子进程：

    # supervisorctl stop zhoujy
    zhoujy: stopped
    
    # supervisorctl start zhoujy
    zhoujy: started

3）关闭、开启所有的子进程：

    # supervisorctl stop all
    blog: stopped
    zhoujy: stopped
    # supervisorctl start all
    blog: started
    zhoujy: started

4）：其他参数：supervisor开启后子进程自动开启（autostart=true）和子进程退出后自动启动（autorestart=ture）


    supervisordctl status <进程名> 查看进程运行状态 
    supervisordctl start <进程名> 启动进程 
    supervisordctl stop <进程名> 关闭进程 
    supervisordctl restart <进程名> 重启进程 
    supervisordctl update 重新载入配置文件 
    supervisordctl shutdown 关闭supervisord 
    
    supervisordctl clear <进程名> 清空进程日志 
    supervisordctl 进入到交互模式下。使用help查看所有命令。
    
    start stop restart + all 表示启动，关闭，重启所有进程。


更多的参数可以看[官方文档](http://supervisord.org/configuration.html)和[supervisor(一)基础篇](http://lixcto.blog.51cto.com/4834175/1539136)的说明。

issue
----

## 01 解决supervisord进程导致的队列时差问题
---

排查过程:

- 排查代码(代码的时区,系统时间和时区)
- 排查 supervisord 守护京城

经过一系列的排查，以及对比本地与服务器的运行结果，发现不是代码上的问题，也不是服务器上的时区问题，而是之前一个老旧的supervisord进程缓存的配置问题。 

问题发现: 手动运行 `python app.py`,出现下面语句这正常


    Mon, 20 Aug 2018 14:32:27 logger.py[line:25] INFO handleDeleteDirtyJob (trigger: cron[hour='0', minute='5'], pending)

`supervisor restart` 运行则不会出现,说明问题出现在 `supervisor`上面


解决步骤:

通过`ps -ef | grep supervisor`找到关于supervisord的一些进程：

    root     11894     1  0 14:26 ?        00:00:00 /usr/bin/python /usr/local/bin/supervisord -c /etc/supervisord.conf

使用命令`kill -s SIGTERM 11894` 终止pid为 11894 的进程，然后输入命令：

    supervisord -c /etc/supervisord.conf

重新将supervisord指定配置文件，更新新的配置到supervisord

    supervisorctl update

重新启动配置中的所有程序

    supervisorctl reload


最后重启所有进程`supervisorctl restart all`即可

查看日志,正常输出信息    
    
    Mon, 20 Aug 2018 14:32:27 base.py[line:433] INFO Adding job tentatively -- it will be properly scheduled when the scheduler starts
    Mon, 20 Aug 2018 14:32:27 logger.py[line:25] INFO ----- supervisor trigger 输出:  -----
    Mon, 20 Aug 2018 14:32:27 logger.py[line:25] INFO handleDeleteDirtyJob (trigger: cron[hour='0', minute='5'], pending)
    Mon, 20 Aug 2018 14:32:27 base.py[line:867] INFO Added job "handleDeleteDirtyJob" to job store "default"
    Mon, 20 Aug 2018 14:32:27 base.py[line:159] INFO Scheduler started


总结：
---

我们需要的功能在上面介绍的supervisor的基本功能中已经实现，supervisor还有其他的一些功能：如进程组、web页面管理子进程、监控子线程情况等等，更多的信息可以去官网上查看。

参考文档：
---

[Supervisor官方文档](http://supervisord.org/)

[Supervisor(一)基础篇](http://lixcto.blog.51cto.com/4834175/1539136)

[Supervisor(二)event](http://lixcto.blog.51cto.com/4834175/1540169)

[Supervisor(三)xml_rpc](http://lixcto.blog.51cto.com/4834175/1540795)



    
