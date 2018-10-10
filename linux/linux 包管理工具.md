> Linux 包管理工具

> [可供参考地址](https://linux.cn/article-8782-1.html)


查看软件包的信息

    - Debian/Ubuntu    
    apt-cache show package 显示包的本地缓存信息
    apt show package 
    dpkg -s package 显示包的当前安装状态

    - Centos
    yum info package 显示包的信息
    yum deplist package 显示包的依赖信息
    - Fedora 
    dnf info package 显示包的信息
    dnf repoquery --requires package 列出包的依赖

本地安装一个包

    - Debian / Ubuntu
    dpkg -i package.deb
    apt-get install -y gdebi && sudo gdebi package.deb  安装 gdebi，然后使用 gdebi 安装 package.deb 并处理缺失的依赖
    - Centos
    sudo yum install package.rpm

