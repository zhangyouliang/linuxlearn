Ubuntu keepalived 开启日志
----

    # service 位置
    /lib/systemd/system/keepalived.service

    # 修改 /etc/default/keepalived
    DAEMON_ARGS="-D -d -S 0"

    cat <<EOF >> /etc/rsyslog.conf
    # Keepalived log config
    local0.*                           /var/log/keepalived.log
    EOF

    # 重新启动服务
    systemctl daemon-reload && systemctl restart keepalived.service
    systemctl restart rsyslog.service

日志位置: /var/log/keepalived.log
