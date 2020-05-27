> 从fedora15开始，系统对于daemon的启动管理方法不再采用SystemV形式，而是使用了sytemd的架构来管理daemon的启动。
> [systemctl 命令完全指南](https://linux.cn/article-5926-1.html)
> [Systemd 入门教程：实战篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)

路径
----
* 个人: /lib/systemd/system/xxx.service
* 系统: /etc/systemd/system/xxx.service


service 案例
---

/lib/systemd/system/etcd.service

    [Unit]
    Description=Etcd Server
    Documentation=https://github.com/coreos/etcd
    After=network.target
    
    
    [Service]
    # User=root
    #Type=simple
    Type=notify
    EnvironmentFile=-/opt/config/etcd.conf
    ExecStart=/opt/bin/etcd
    Restart=on-failure
    RestartSec=10s
    LimitNOFILE=40000
    
    [Install]
    WantedBy=multi-user.target

- [Unit] 表示这是基础信息,文档说明,依赖定义
    - Description 是描述
    - Documentation 一个url 定义服务的具体介绍网址
    - After 是在那个服务后面启动，一般是网络服务启动后启动
    - Before 在什么服务启动之前启动
    - Requires 依赖其他的单元服务， 需要与列出的服务一起激活，若任何服务无法启动，则该单元不会被激活
    - Wants 比Requires依赖性弱，弱其他服务没有启动成功，该服务也不受影响，只是表示一种推荐
- [Service] 表示这里是服务信息 ,运行参数,操作动作
    - Type  
      - simple 默认参数，进程作为主进程
      - forking是后台运行的形式，主进程退出，os接管子进程
      - oneshot 类似simple，在开始后续单元之前，过程退出
      - notify 类似simple，但是随后的单元仅在通过sd_notify()函数发送通知消息之后才启动
      - idle类似simple，服务二进制文件的实际执行被延迟到所有作业完成为止，不与其他服务的输出相混合,如状态输出与服务的shell输出混合
      - DBUS 类似simple，但随后的单元只在主进程获得D总线名称之后才启动
    - ExecStart 是启动服务的命令
    - ExecStop 是停止服务的指令
    - ExecReload 为重启命令，重新加载的动作， 重新加载时执行的命令或者脚本
    - ExecStartPre 启动服务之前执行的命令
    - ExecStartPost 启动服务之后执行的命令
    - ExecStopPost 停止服务之后执行的命令
    - User  设置服务运行的用户
    - Group 设置服务运行的用户组
    - PIDFile 为存放PID的文件路径, 对于type设置为forking建议使用该项
    - Restart:
      - always 总是重启
      - no
      - on-success
      - on-failure
      - on-abnormal
      - on-abort
      - on-watchdog
    - TimeoutStartSec 等待启动的时间。如果守护进程服务没有在配置的时间内发送启动完成的信号，则该服务将被认为失败， 服务将退出
    - TimeoutStopSec 等待关闭的超时时间
    - KillMode
      - control-group（默认值）：当前控制组里面的所有子进程，都会被杀掉
      - process：只杀主进程
      - mixed：主进程将收到 SIGTERM 信号，子进程收到 SIGKILL 信号
      - none：没有进程会被杀掉，只是执行服务的 stop 命令。
    - Environmen 指定环境变量
      - PrivateTmp=True 表示给服务分配独立的临时空间
      - 
- [Install] 表示这是是安装相关信息 
    - WantedBy 是以哪种方式启动：multi-user.target表明当系统以多用户方式（默认的运行级别）启动时，这个服务需要被自动运行。
    - RequiredBy 依赖该服务的服务列表

服务状态:

- loaded 系统服务已经初始化完成，加载过配置
- actvie(running) 正常运行
- actvie(exited) 正常结束的服务，
- active(waitting) 正在执行当中， 等待其他的事件才继续处理
- inactive 服务关闭
- enabled 服务开机启动
- disabled 服务开机不自启
- static 服务开机启动项不可被管理
- falied 系统配置错误



执行 start 会卡住(因为 Type 类型问题)
----
/root/simple.sh 
````
#!/bin/bash

while : 
do
    echo `date` >> /root/log
    sleep 1
done
````

/lib/systemd/system/fork.service

````
[Unit]
Description=sfy fork
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/bin/bash -c "/root/simple.sh"
PrivateTmp=true
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
````

/lib/systemd/system/simple.service
````
[Unit]
Description=sfy test
After=syslog.target network.target

[Service]
Type=simple
ExecStart=/bin/bash -c "/root/simple.sh"

[Install]
WantedBy=multi-user.target
````
测试:

````
systemctl daemon-reload
systemctl start simple.service # 不会卡住
systemctl start fork.service # 会卡住

````


实践案例
----

显示全部 service

    systemctl --all    
查看状态

    systemctl status httpd.service
启动    
    
    systemctl start httpd.service
停止
    systemctl stop httpd.service

开机自动启动

    # 没有 [Install] 模块,将不能设置为开机自动启动
    systemctl enable httpd.service
关闭自动启动

    systemctl disable httpd.service

实时滚动显示某个Unit的最新日志

    journalctl  -u nginx.service  -f


刷新配置

    systemctl daemon-reload

service 存放路径: `/lib/systemd/system/`

系统初始化的时候自动启动: (存放目录: `/etc/systemd/system/multi-user.target.wants/`) 
        
    ln -s /lib/systemd/system/redis.service /etc/systemd/system/multi-user.target.wants/redis.service


命令说明
----

    systemctl [OPTIONS...] {COMMAND} ...
    
    Query or send control commands to the systemd manager.
    
      -h --help           Show this help
         --version        Show package version
         --system         Connect to system manager
         --user           Connect to user service manager
      -H --host=[USER@]HOST
                          Operate on remote host
      -M --machine=CONTAINER
                          Operate on local container
      -t --type=TYPE      List units of a particular type
         --state=STATE    List units with particular LOAD or SUB or ACTIVE state
      -p --property=NAME  Show only properties by this name
      -a --all            Show all loaded units/properties, including dead/empty
                          ones. To list all units installed on the system, use
                          the 'list-unit-files' command instead.
      -l --full           Don't ellipsize unit names on output
      -r --recursive      Show unit list of host and local containers
         --reverse        Show reverse dependencies with 'list-dependencies'
         --job-mode=MODE  Specify how to deal with already queued jobs, when
                          queueing a new job
         --show-types     When showing sockets, explicitly show their type
      -i --ignore-inhibitors
                          When shutting down or sleeping, ignore inhibitors
         --kill-who=WHO   Who to send signal to
      -s --signal=SIGNAL  Which signal to send
         --now            Start or stop unit in addition to enabling or disabling it
      -q --quiet          Suppress output
         --no-block       Do not wait until operation finished
         --no-wall        Don't send wall message before halt/power-off/reboot
         --no-reload      Don't reload daemon after en-/dis-abling unit files
         --no-legend      Do not print a legend (column headers and hints)
         --no-pager       Do not pipe output into a pager
         --no-ask-password
                          Do not ask for system passwords
         --global         Enable/disable unit files globally
         --runtime        Enable unit files only temporarily until next reboot
      -f --force          When enabling unit files, override existing symlinks
                          When shutting down, execute action immediately
         --preset-mode=   Apply only enable, only disable, or all presets
         --root=PATH      Enable unit files in the specified root directory
      -n --lines=INTEGER  Number of journal entries to show
      -o --output=STRING  Change journal output mode (short, short-iso,
                                  short-precise, short-monotonic, verbose,
                                  export, json, json-pretty, json-sse, cat)
         --firmware-setup Tell the firmware to show the setup menu on next boot
         --plain          Print unit dependencies as a list instead of a tree
    
    Unit Commands:
      list-units [PATTERN...]         List loaded units
      list-sockets [PATTERN...]       List loaded sockets ordered by address
      list-timers [PATTERN...]        List loaded timers ordered by next elapse
      start NAME...                   Start (activate) one or more units
      stop NAME...                    Stop (deactivate) one or more units
      reload NAME...                  Reload one or more units
      restart NAME...                 Start or restart one or more units
      try-restart NAME...             Restart one or more units if active
      reload-or-restart NAME...       Reload one or more units if possible,
                                      otherwise start or restart
      try-reload-or-restart NAME...   If active, reload one or more units,
                                      if supported, otherwise restart
      isolate NAME                    Start one unit and stop all others
      kill NAME...                    Send signal to processes of a unit
      is-active PATTERN...            Check whether units are active
      is-failed PATTERN...            Check whether units are failed
      status [PATTERN...|PID...]      Show runtime status of one or more units
      show [PATTERN...|JOB...]        Show properties of one or more
                                      units/jobs or the manager
      cat PATTERN...                  Show files and drop-ins of one or more units
      set-property NAME ASSIGNMENT... Sets one or more properties of a unit
      help PATTERN...|PID...          Show manual for one or more units
      reset-failed [PATTERN...]       Reset failed state for all, one, or more
                                      units
      list-dependencies [NAME]        Recursively show units which are required
                                      or wanted by this unit or by which this
                                      unit is required or wanted
    
    Unit File Commands:
      list-unit-files [PATTERN...]    List installed unit files
      enable NAME...                  Enable one or more unit files
      disable NAME...                 Disable one or more unit files
      reenable NAME...                Reenable one or more unit files
      preset NAME...                  Enable/disable one or more unit files
                                      based on preset configuration
      preset-all                      Enable/disable all unit files based on
                                      preset configuration
      is-enabled NAME...              Check whether unit files are enabled
      mask NAME...                    Mask one or more units
      unmask NAME...                  Unmask one or more units
      link PATH...                    Link one or more units files into
                                      the search path
      add-wants TARGET NAME...        Add 'Wants' dependency for the target
                                      on specified one or more units
      add-requires TARGET NAME...     Add 'Requires' dependency for the target
                                      on specified one or more units
      edit NAME...                    Edit one or more unit files
      get-default                     Get the name of the default target
      set-default NAME                Set the default target
    
    Machine Commands:
      list-machines [PATTERN...]      List local containers and host
    
    Job Commands:
      list-jobs [PATTERN...]          List jobs
      cancel [JOB...]                 Cancel all, one, or more jobs
    
    Environment Commands:
      show-environment                Dump environment
      set-environment NAME=VALUE...   Set one or more environment variables
      unset-environment NAME...       Unset one or more environment variables
      import-environment [NAME...]    Import all or some environment variables
    
    Manager Lifecycle Commands:
      daemon-reload                   Reload systemd manager configuration
      daemon-reexec                   Reexecute systemd manager
    
    System Commands:
      is-system-running               Check whether system is fully running
      default                         Enter system default mode
      rescue                          Enter system rescue mode
      emergency                       Enter system emergency mode
      halt                            Shut down and halt the system
      poweroff                        Shut down and power-off the system
      reboot [ARG]                    Shut down and reboot the system
      kexec                           Shut down and reboot the system with kexec
      exit [EXIT_CODE]                Request user instance or container exit
      switch-root ROOT [INIT]         Change to a different root file system
      suspend                         Suspend the system
      hibernate                       Hibernate the system
      hybrid-sleep                    Hibernate and suspend the system