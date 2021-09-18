pt-online-schema-change
=====

#### # 安装
````
wget percona.com/get/percona-toolkit.tar.gz
tar -zvxf percona-toolkit.tar.gz
cd percona-toolkit-3.3.1
# 安装perl依赖
# apt install perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker
apt-get install libdbd-mysql-perl
perl Makefile.PL


# 编译安装
make
make install 

# 验证
pt-online-schema-change


````

#### # perl 模块安装步骤

````
perl Makefile.PL
make
make install
# .....

````


#### # CPAN在线安装

前提：已连接到internet，并有root权限

进入CPAN shell：

````
perl -MCPAN -e shell
````

初次运行CPAN时需要做一些设置，如果您的机器是直接与internet相联（拨号上网、专线，etc.），那么一路回车就行了，只需要在最后选一个离您最近的CPAN镜像站点。　

````
cpan>h  （获得帮助）　  
cpan>m （列出CPAN上所有模块的列表）　
cpan>install　module_name　（自动完成从下载到安装的全过程。）　  
cpan>q　（安装完，后退出）
````



#### # perl模块安装卸载

````
make uninstall | grep unlink | sh
````