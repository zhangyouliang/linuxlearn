> dmesg 输出内核相关日志

dmesg 命令在多数基于Linux和Unix的操作系统中都可以使用。

    # 列出加载到内核中的所有驱动
    # 我们可以使用如‘more’。 ‘tail’, ‘less ’或者‘grep’文字处理工具来处理‘dmesg’命令的输出。
    dmesg | more
    dmesg | less
    # 列出所有被检测到的硬件
    dmesg | grep sda
    # 只列出 dmesg 命令的前 20行日志
     dmesg | head  -20
    # 只输出dmesg命令最后20行日志
    dmesg | tail -20
    # 搜索包含特定字符串的被检测到的硬件
    dmesg | grep -i usb
    dmesg | grep -i dma
    dmesg | grep -i tty
    dmesg | grep -i memory
    # 清空dmesg缓冲区日志
    dmesg -c 
    # 实时监控dmesg日志输出
    watch "dmesg | tail -20"
    