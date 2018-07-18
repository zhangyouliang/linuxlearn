> ntpdate 时间同步

以其中一台最接近当前网络时间的服务器作为时间服务器，然后其他机器将时间同步到与该机器一致。

    # 作为时间服务器的那台机器需要开启ntpd服务，其他机器不用开启，命令如下
    service ntpd start
    # 其它机器依次执行同步命令
    
    ntpdate <时间服务器的ip>
    执行完上述步骤便完成时间同步了。

    
    # 系统时间同步到硬件，防止系统重启后时间呗还原
    hwclock --systohc


使用阿里云的机器同步


    0 3 * * * /usr/sbin/ntpdate -u ntp1.aliyun.com 