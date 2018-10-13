ipvs 模块加载
-------

安装 ipvsadm

    yum install ipvsadm -y
    :> /etc/modules-load.d/ipvs.conf
    module=(
      ip_vs
      ip_vs_lc
      ip_vs_wlc
      ip_vs_rr
      ip_vs_wrr
      ip_vs_lblc
      ip_vs_lblcr
      ip_vs_dh
      ip_vs_sh
      ip_vs_fo
      ip_vs_nq
      ip_vs_sed
      ip_vs_ftp
      )
    for kernel_module in ${module[@]};do
        /sbin/modinfo -F filename $kernel_module |& grep -qv ERROR && echo $kernel_module >> /etc/modules-load.d/ipvs.conf || :
    done
    systemctl enable --now systemd-modules-load.service



#### # 关于keepalived执行后日志狂刷IPVS: Can't initialize ipvs: Protocol not available的问题

    # 加载模块
    modprobe ip_vs，modprobe ip_vs_wrr
    # 查看加载模块
    lsmod | grep ip_vs

    # 网络查看
    nmcli con show