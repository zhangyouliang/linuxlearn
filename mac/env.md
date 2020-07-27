mac 环境变量
===

Mac系统的环境变量，加载顺序为：

    /etc/profile -> /etc/paths -> /etc/paths.d/文件夹所有内容 -> ~/.bash_profile -> ~/.bash_login -> ~/.profile -> ~/.bashrc


> 安装软件后, 最常更改配置的是/etc/paths.d/, ~/.bashrc, ~/.bash_profile. 可查看这些相关文件.

其中, `/etc/profile`, `/etc/paths`, `/etc/paths.d/`是系统级别的，系统启动就会加载，后面几个是当前用户级的环境变量。

后面3个按照从前往后的顺序读取，如果`~/.bash_profile`文件存在，则后面的几个文件就会被忽略不读了，如果~/.bash_profile文件不存在，才会以此类推读取后面的文件。


`~/.bashrc` 没有上述规则，它是bash shell打开的时候载入的。


参考
====
- [Mac中环境变量加载顺序](https://www.jianshu.com/p/6272cdf2fac9)
