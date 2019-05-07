> alias命令用来设置指令的别名。我们可以使用该命令可以将一些较长的命令进行简化。使用alias时，用户必须使用单引号''将原来的命令引起来，防止特殊字符导致错误。
  
语法
----

    alias(选项)(参数)
    
选项
---
    -p：打印已经设置的命令别名。
参数
----
命令别名设置：定义命令别名，格式为“命令别名=‘实际命令’”。

实例
----
alias 的基本使用方法为：

    alias 新的命令='原命令 -选项/参数'

例如：alias l=‘ls -lsh'将重新定义ls命令，现在只需输入l就可以列目录了。直接输入 alias 命令会列出当前系统中所有已经定义的命令别名。

要删除一个别名，可以使用 `unalias` 命令，如 `unalias l`。

查看系统已经设置的别名：
    
    alias -p


    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
    # 查看 nginx 日志文件
    alias alg='tail -f /var/log/nginx/access.log'
    # 查看 443 端口连接数
    alias conns='ss -ant sport = :443|wc -l'