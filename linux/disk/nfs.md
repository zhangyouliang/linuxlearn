ubuntu 使用 nfs
====


设置主机服务器
====

了设置主机系统以共享目录，我们需要在其上安装NFS内核服务器，然后创建并导出我们希望客户端系统访问的目录。请按照以下步骤顺利设置主机端：

**第1步：安装NFS服务器**

在安装NFS内核服务器之前，我们需要通过以下apt命令以sudo的形式将系统的存储库索引更新为Internet的存储库索引：

```
sudo apt-get update
```

上面的命令允许我们通过Ubuntu存储库安装最新的软件版本。


现在，运行以下命令以在系统上安装NFS内核服务器：


```
sudo apt install nfs-kernel-server
```


系统将提示您使用Y/n选项确认是否要继续安装。 请输入Y然后按Enter继续，之后软件将成功安装在您的系统上。

第2步：创建导出目录

我们要与客户端系统共享的目录称为导出目录。 你可以根据自己的选择来命名; 在这里，我们在系统的mnt（mount）目录中创建一个名为“linuxidc”的导出目录。

使用以下命令，根据需要通过以下命令指定安装文件夹名称：

```
sudo mkdir -p /mnt/linuxidc
```

因为我们希望所有客户端都能访问该目录，我们将通过以下命令删除文件夹的限制权限：

```
sudo chown nobody:nogroup /mnt/linuxidc
```

现在，客户端系统上所有组的所有用户都可以访问我们的“共享文件夹”。

您可以根据需要在导出文件夹中创建任意数量的子文件夹，供客户端访问。


**步骤3：通过NFS导出文件为客户端分配服务器访问权限**

创建导出文件夹后，我们需要为客户端提供访问主机服务器计算机的权限。 此权限是通过位于系统的/etc文件夹中的exports文件定义的。 请使用以下命令通过Nano编辑器打开此文件：

```
sudo nano /etc/exports
```

编辑此文件需要root访问权限; 因此，您需要在命令中使用sudo。 您也可以在任何您喜欢的个人文本编辑器中打开该文件。

打开文件后，您可以允许访问：

单个客户端通过在文件中添加以下行：

- /mnt/linuxidc clientIP(rw,sync,no_subtree_check)

通过在文件中添加以下行来多个客户端：

- /mnt/linuxidc client1IP(rw,sync,no_subtree_check)

- /mnt/linuxidc client2IP(rw,sync,no_subtree_check)

多个客户端，通过指定客户端所属的整个子网：

- /mnt/linuxidc 192.168.182.0/24(rw,sync,no_subtree_check)
- /mnt/linuxidc 192.168.182.0/24(rw,sync,no_subtree_check)


在此示例中，我们指定了要为我们的主目录文件夹（linuxidc）授予访问权限的所有客户端的整个子网：

将所需的行添加到导出文件中，然后按Ctrl + X，输入Y，然后按Enter键保存。

此文件中定义的权限“rw，sync，no_subtree_check”表示客户端可以执行以下操作：

- rw：读写操作
- sync: 在应用之前将任何更改写入光盘
- no_subtree_check：阻止子树检查

**第4步：导出共享目录**

在主机系统中完成上述所有配置后，现在可以通过以下命令将共享目录导出：

```
sudo exportfs -a
```

最后，为了使所有配置生效，请按如下方式重新启动NFS服务器：

```
sudo systemctl restart nfs-kernel-server
```

**第5步：为客户端打开防火墙**

重要的一步是验证服务器的防火墙是否对客户端开放，以便他们可以访问共享内容。 以下命令将配置防火墙以通过NFS授予客户端访问权限：

```
sudo ufw allow from [clientIP or clientSubnetIP] to any port nfs
```

在我们的示例中，我们通过以下命令访问客户端计算机的整个子网：

```
sudo ufw allow from 192.168.182.0/24 to any port nfs
```

现在，当您通过以下命令检查Ubuntu防火墙的状态时，您将能够将操作状态视为客户端IP的“允许”。

```
sudo ufw status
```

您的主机服务器现在已准备好通过NFS服务器将共享文件夹导出到指定的客户端。

配置客户端计算机
====
现在是时候对客户机进行一些简单的配置，这样主机的共享文件夹就可以挂载到客户端，然后顺利访问。

测试的客户端服务器是Ubuntu 18.10

**第1步：安装NFS Common**

在安装NFS Common应用程序之前，我们需要通过以下apt命令以sudo的形式更新我们系统的存储库索引和Internet的索引：

```
sudo apt-get update
```

上面的命令允许我们通过Ubuntu存储库安装最新的软件版本。

现在，运行以下命令以在系统上安装NFS Common客户端：

```
sudo apt-get install nfs-common
```

系统将提示您使用Y/n选项确认是否要继续安装。 请输入Y然后按Enter继续，之后软件将成功安装在您的系统上。

**第2步：为NFS主机的共享文件夹创建安装点**

您的客户端系统需要一个目录，可以访问导出文件夹中主机服务器共享的所有内容。 您可以在系统的任何位置创建此文件夹。 我们在客户端机器的mnt目录中创建一个mount文件夹：

```
sudo mkdir -p /mnt/linuxidc_client
```

在Ubuntu 18.04 LTS上安装NFS服务器和客户端

**第3步：在客户端上挂载共享目录**

您在上述步骤中创建的文件夹与系统上的任何其他文件夹类似，除非您将共享目录从主机安装到此新创建的文件夹。

使用以下命令将共享文件夹从主机安装到客户端上的装入文件夹：

```
sudo mount serverIP:/shareFolder_server /mnt/mountfolder_client
```

在我们的示例中，我们运行以下命令将“linuxidc”从服务器导出到客户端计算机上的mount文件夹“linuxidc_client”：

```
sudo mount 192.168.182.172:/mnt/linuxidc /mnt/linuxidc_client
```

**第4步：测试连接**

请在NFS主机服务器的导出文件夹中创建或保存文件。 现在，打开客户端计算机上的mount文件夹; 您应该能够在此文件夹中查看共享和访问的同一文件。


**清理工作**

```
# 服务端: 10.0.0.148, 客户端: 10.0.0.149
# 客户端
sudo umount 10.0.0.148:/mnt/linuxidc
# 查看是否已经卸载
mount  | grep linuxidc

# 客户端查看服务端
showmount -e 10.0.0.148
Export list for 10.0.0.148:
/mnt/linuxidc 10.0.0.0/24

# 清除  /etc/exports 中的挂载内容
.....
# reload 配置
exportfs -a
# 重启服务
sudo systemctl restart nfs-server.service 
# 查看服务端已经没有导出列表了
showmount -e 10.0.0.148
Export list for 10.0.0.148:
```


**其他**

```
一、 Exports配置文件格式
NFS服务的配置文件为 /etc/exports

/data 192.168.80.0/24(rw)
<输出目录> [客户端1 选项（访问权限,用户映射,其他）] [客户端2 选项（访问权限,用户映射,其他）]
a. 输出目录：
输出目录是指NFS系统中需要共享给客户机使用的目录；
b. 客户端：
客户端是指网络中可以访问这个NFS输出目录的计算机
客户端常用的指定方式
- 指定ip地址的主机：192.168.0.200
- 指定子网中的所有主机：192.168.0.0/24 192.168.0.0/255.255.255.0
- 指定域名的主机：david.bsmart.cn
- 指定域中的所有主机：.bsmart.cn
- 所有主机：*

c. 选项：
选项用来设置输出目录的访问权限、用户映射等。
NFS主要有3类选项：
访问权限选项
- 设置输出目录只读：ro
- 设置输出目录读写：rw
用户映射选项
- root_squash：将root用户及所属组都映射为匿名用户或用户组（默认设置）；
- no_root_squash：与rootsquash取反；

- all_squash：将远程访问的所有普通用户及所属组都映射为匿名用户或用户组（nfsnobody），这是默认选项；
- no_all_squash：与all_squash取反（默认设置）；

- anonuid=xxx：将远程访问的所有用户都映射为匿名用户，并指定该用户为本地用户（UID=xxx）；
- anongid=xxx：将远程访问的所有用户组都映射为匿名用户组账户，并指定该匿名用户组账户为本地用户组账户（GID=xxx）；
其它选项

- secure：限制客户端只能从小于1024的tcp/ip端口连接nfs服务器（默认设置）；
- insecure：允许客户端从大于1024的tcp/ip端口连接服务器；
- sync：将数据同步写入内存缓冲区与磁盘中，效率低，但可以保证数据的一致性；
- async：将数据先保存在内存缓冲区中，必要时才写入磁盘；
- wdelay：检查是否有相关的写操作，如果有则将这些写操作一起执行，这样可以提高效率（默认设置）；
- no_wdelay：若有写操作则立即执行，应与sync配合使用；
- subtree：若输出目录是一个子目录，则nfs服务器将检查其父目录的权限(默认设置)；
- no_subtree：即使输出目录是一个子目录，nfs服务器也不检查其父目录的权限，这样可以提高效率；


二、 关于权限的分析
客户端连接时候，对普通用户的检查
- 如果明确设定了普通用户被映射的身份，那么此时客户端用户的身份转换为指定用户；
- 如果NFS server上面有同名用户，那么此时客户端登录账户的身份转换为NFS server上面的同名用户；
- 如果没有明确指定，也没有同名用户，那么此时用户身份被映射成nfsnobody；

客户端连接的时候，对root的检查
- 如果设置no_root_squash，那么此时root用户的身份被映射为NFS server上面的root；
- 如果设置了all_squash、anonuid、anongid，此时root 身份被映射为指定用户；
- 如果没有明确指定，此时root用户被映射为nfsnobody；
- 如果同时指定no_root_squash与all_squash 用户将被映射为 nfsnobody，如果设置了anonuid、anongid将被映射到所指定的用户与组；

```

总结
===
在Ubuntu系统上设置NFS客户端 - 服务器环境是一项简单的任务。 通过本文，您学习了如何在服务器和客户端上安装所需的NFS包。 您还学习了如何配置NFS服务器和客户端计算机，以便可以共享文件夹，然后在没有任何防火墙或权限相关故障的情况下顺利访问文件夹。 现在，您可以使用NFS协议轻松地将内容从一个Ubuntu系统共享到另一个系统。

参考
====
- [10分钟学会在Ubuntu 18.04 LTS上安装NFS服务器和客户端](https://www.linuxidc.com/Linux/2018-11/155331.htm)