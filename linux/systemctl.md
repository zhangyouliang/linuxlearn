> 从fedora15开始，系统对于daemon的启动管理方法不再采用SystemV形式，而是使用了sytemd的架构来管理daemon的启动。

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

- [Unit] 表示这是基础信息 
    - Description 是描述
    - After 是在那个服务后面启动，一般是网络服务启动后启动
- [Service] 表示这里是服务信息 
    - ExecStart 是启动服务的命令
    - ExecStop 是停止服务的指令
- [Install] 表示这是是安装相关信息 
    - WantedBy 是以哪种方式启动：multi-user.target表明当系统以多用户方式（默认的运行级别）启动时，这个服务需要被自动运行。




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

    systemctl enable httpd.service
关闭自动启动

    systemctl disable httpd.service


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