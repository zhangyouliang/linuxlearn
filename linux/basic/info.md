Linux 服务器相关信息查看

````
# 查看版本号
> cat /etc/issue
Ubuntu 18.04.2 LTS \n \l
> lsb_release -a
LSB Version:	core-9.20170808ubuntu1-noarch:security-9.20170808ubuntu1-noarch
Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.2 LTS
Release:	18.04
Codename:	bionic

> cat /proc/version
Linux version 4.15.0-50-generic (buildd@lcy01-amd64-013) (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3)) #54-Ubuntu SMP Mon May 6 18:46:08 UTC 2019
> uname -a
Linux k8s-m01 4.15.0-50-generic #54-Ubuntu SMP Mon May 6 18:46:08 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
# cpu 信息
> cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
2  Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz

````
