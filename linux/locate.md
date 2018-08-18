> locate/slocate :  命令都用来查找文件或目录。


locate命令其实是`find -name `的另一种写法，但是要比后者快得多，原因在于它不搜索具体目录，而是搜索一个数据库`/var/lib/locatedb`，这个数据库中含有本地所有文件信息。Linux系统自动创建这个数据库，并且每天自动更新一次，所以使用`locate`命令查不到最新变动过的文件。为了避免这种情况，可以在使用 `locate`之前，先使用 `updatedb`命令，手动更新数据库。

选项
---

    -b, --basename 匹配唯一的路径名称的基本文件名
    -c, --count 只显示找到条目的号码
    -d, --database DBPATH 用 DBPATH 替代默认的数据库(/var/lib/mlocate/mlocate.db)
    -e, --existing 只显示当前存在的文件条目
    -L, --follow 当文件存在时跟随蔓延的符号链接 (默认)
    -h, --help 显示本帮助
    -i, --ignore-case 匹配模式时忽略大小写区别
    -l, --limit, -n LIMIT 限制为 LIMIT项目的输出 (或 计数) 
    -m, --mmap 忽略向后兼容性
    -P, --nofollow, -H 当检查文件时不跟随蔓延的符号
    链接
    -0, --null 输出时以 NUL 分隔项目
    -S, --statistics 不搜索项目,显示有关每个已用数据库的统计信息
    -q, --quiet 不报告关于读取数据库的错误消息
    -r, --regexp REGEXP 搜索基本正则表达式 REGEXP 来代替模式
    --regex 模式是扩展正则表达式
    -s, --stdio 忽略向后兼容性
    -V, --version 显示版本信息
    -w, --wholename 匹配完整路径名 (默认)



实例
---


```
# 快速搜索
locate ~/*.md
# 查找etc目录下所有以sh开头的文件
locate /etc/sh


# 忽略大小写
locate -i ~/m
# 更新数据库信息
updatedb 或者 locate -- u
```

