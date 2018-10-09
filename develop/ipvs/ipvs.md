
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

