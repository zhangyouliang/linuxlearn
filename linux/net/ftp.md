> ftp ,sftp , lftp,ssh

ftp
---

ftp/sftp文件传输:

````
sftp ID@host
````
    
登陆服务器host，ID为用户名。sftp登陆后，可以使用下面的命令进一步操作：

````
get filename # 下载文件
put filename # 上传文件
ls # 列出host上当前路径的所有文件
cd # 在host上更改当前路径
lls # 列出本地主机上当前路径的所有文件
lcd # 在本地主机更改当前路径
pwd #显示远程工作目录
lpwd #打印本地工作目录
rmdir 路径 #移除远程目录
lrmdir 路径 #移除本地目录
rm 路径  #删除远程文件
lrm 路径 #删除本地文件
mkdir 路径     #创建远程目录
lmkdir 路径    #创建本地目录
````

lftp同步文件夹(类似rsync工具):

````
lftp -u user:pass host
lftp user@host:~> mirror -n
````

网络复制
---
将本地localpath指向的文件上传到远程主机的path路径:

````
scp localpath ID@host:path
````
    
以ssh协议，遍历下载path路径下的整个文件系统，到本地的localpath:

````
scp -r ID@site:path localpath
````