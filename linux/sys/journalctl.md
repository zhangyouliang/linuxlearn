> journalctl: Systemd 统一管理所有 Unit 的启动日志。带来的好处就是 ，可以只用journalctl一个命令，查看所有日志（内核日志和 应用日志）。日志的配置文件/etc/systemd/journald.conf 

#### # 基本用法

    # 按照应用查询
    journalctl -u nginx
    # 按照进程
    journalctl _PID=8088
    # 查看所有日志（默认情况下 ，只保存本次启动的日志）
    journalctl 
    # 查看内核日志（不显示应用日志）
    journalctl -k 
    # 查看系统本次启动的日志
    journalctl -b
    # journal 引导
    journalctl --list-boots 
    # .... 按照时间查询
    journalctl –since yesterday


#### # journal 显示
    
    # 分页显示，其中插入省略号以代表被移除的信息
    journalctl --no-full
    # 显示全部信息
    journalctl -a
    # 不分页
    journalctl --no-pager
    # json 形式输出
    journalctl -b -u httpd -o json
    journalctl -u httpd -o  json-pretty

#### # 活动进程监控

    # 近期日志查看
    journalctl -n20
    # 追踪日志
    journalctl -u kubelet -f

#### # Journal 维护

    # 查看当前日志占用磁盘的空间的总大小
    journal --disk-usage
    # 指定日志文件最大空间
    journalctl --vacuum-size=1G
    # 指定日志文件保存多久
    journalctl --vacuum-time=1years