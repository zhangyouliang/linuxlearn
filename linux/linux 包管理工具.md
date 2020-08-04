> Linux 包管理工具

> [可供参考地址](https://linux.cn/article-8782-1.html)


查看软件包的信息

```bash
- Debian/Ubuntu    
# 显示包的本地缓存信息
apt-cache show package 
apt show package
# 显示包的当前安装状态 
dpkg -s package 
# 显示包含此软件包的所有位置
dpkg -L package

- Centos
yum info package 显示包的信息
yum deplist package 显示包的依赖信息
- Fedora 
dnf info package 显示包的信息
dnf repoquery --requires package 列出包的依赖
```




本地安装一个包

```bash
- Debian / Ubuntu
dpkg -i package.deb
apt-get install -y gdebi && sudo gdebi package.deb  安装 gdebi，然后使用 gdebi 安装 package.deb 并处理缺失的依赖
- Centos
sudo yum install package.rpm
```

dpkg 列出已安装的软件
===
```bash
# 列出已安装的软件
dpkg -l
```

可以使用 `dpkg -l` 命令列出当前系统中已经安装的软件以及软件包的状态。如：

```
$ dkpg -l

期望状态=未知(u)/安装(i)/删除(r)/清除(p)/保持(h)
| 状态=未安装(n)/已安装(i)/仅存配置(c)/仅解压缩(U)/配置失败(F)/不完全安装(H)/触发器等待(W)/触发器未决(T)
|/ 错误?=(无)/须重装(R) (状态，错误：大写=故障)
||/ 名称                                          版本                                体系结构     描述
+++-=============================================-===================================-============-===============================================================================
ii  2048-qt                                       0.1.6-1build1                       amd64        mathematics based puzzle game
ii  accountsservice                               0.6.50-0ubuntu1                     amd64        query and manipulate user account information
ii  acl                                           2.2.53-4                            amd64        access control list - utilities
ii  acpi-support                                  0.143                               amd64        scripts for handling many ACPI events
ii  acpid                                         1:2.0.31-1ubuntu2                   amd64        Advanced Configuration and Power Interface event daemon
ii  adduser                                       3.118ubuntu1                        all          add and remove users and groups
ii  adwaita-icon-theme                            3.32.0-1ubuntu1                     all          default icon theme of GNOME (small subset)
ii  alsa-base                                     1.0.25+dfsg-0ubuntu5                all          ALSA driver configuration files
ii  alsa-utils                                    1.1.8-1ubuntu1                      amd64        Utilities for configuring and using ALSA

```


该命令每行输出中的第一列 `ii` 表示软件包的安装和配置状态，其格式如下： `期望状态|当前状态|错误`

其中**期望状态**有以下几种

- u：即 unknown，软件包未安装且用户未请求安装
- i：即 install，用户请求安装该软件包
- r：即 remove，用户请求卸载该软件包
- p：即 purge，用户请求卸载该软件包并清理配置文件
- h：即 hold，用户请求保持续当前软件包版本

**当前状态** 有以下几种：

- n：即 not-installed，软件包未安装
- i：即 installed，软件包已安装并完成配置
- c：即 config-files，软件包已经被卸载，但是其配置文件未清理
- u：即 unpacked，软件包已经被解压缩，但还未配置
- f：即 half-configured，配置软件包时出现错误
- w：即 triggers-awaited，触发器等待
- t：即 triggers-pending，触发器未决

**错误状态** 有以下几种：

- h：软件包被强制保持
- r：即 reinstall-required，需要卸载并重新安装
- x：软件包被破坏
因此 `ii` 表示该软件需要安装且已经安装，没有出现错误；
- iu 表示已经安装该软件，但未正确配置；
- rc 表示该软件已经被删除，但配置文件未清理。

````bash
# 查看安装列表
# rc 开头
dpkg -l | grep ^rc
# 带有 nginx 字样
dpkg -l "nginx*"
# 软件卸载,只会移除指定的软件包而不对其配置文件产生影响，
# 可以使用 -P 选项在删除软件包的同时清理配置文件
dpkg -r package
# 查看包的内容
dpkg -c package_file_path
# 查看软件包（已安装）的详细信息
dpkg -s package 
or
dpkg --status package
# 软件安装位置查看
dpkg -L package

````

