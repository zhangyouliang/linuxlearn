> Systemd 并不是一个命令，而是一组命令，涉及到系统管理的方方面面。

- systemctl
- systemd-analyze
- hostnamectl
- localectl
- timedatectl
- loginctl
- unit

systemctl
===

systemctl是 Systemd 的主命令，用于管理系统。

````
# 重启系统
$ sudo systemctl reboot

# 关闭系统，切断电源
$ sudo systemctl poweroff

# CPU停止工作
$ sudo systemctl halt

# 暂停系统
$ sudo systemctl suspend

# 让系统进入冬眠状态
$ sudo systemctl hibernate

# 让系统进入交互式休眠状态
$ sudo systemctl hybrid-sleep

# 启动进入救援状态（单用户状态）
$ sudo systemctl rescue


````

systemd-analyze
===

systemd-analyze 命令用于查看启动耗时

````
# 查看启动耗时
$ systemd-analyze

# 查看每个服务的启动耗时
$ systemd-analyze blame

# 显示瀑布状的启动过程流
$ systemd-analyze critical-chain

# 显示指定服务的启动流
$ systemd-analyze critical-chain atd.service

````



参考
====
- [Systemd 应用](https://dunwu.github.io/linux-tutorial/linux/ops/systemd.html#_3-1-systemctl)