> rinetd 端口转发工具

安装
---
    apt install rinetd/xenial
    service rinetd start
    service rinetd status
    

配置
---
    vi /etc/rinetd.conf
    0.0.0.0 6379 <私有地址> 6379
    service rinetd restart
    # 开机自启
    echo rinetd >>/etc/rc.local