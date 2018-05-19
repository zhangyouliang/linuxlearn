> mount 挂载命令

参考: http://www.linuxidc.com/Linux/2016-08/134666.htm

格式

> mount [-fnrsvw] [-t vfstype] [-o options] device dir

参数
-----

    Options:
     -a, --all               mount all filesystems mentioned in fstab
     -c, --no-canonicalize   don't canonicalize paths
     -f, --fake              dry run; skip the mount(2) syscall
     -F, --fork              fork off for each device (use with -a)
     -T, --fstab <path>      alternative file to /etc/fstab
     -i, --internal-only     don't call the mount.<type> helpers
     -l, --show-labels       show also filesystem labels
     -n, --no-mtab           don't write to /etc/mtab
     -o, --options <list>    comma-separated list of mount options
     -O, --test-opts <list>  limit the set of filesystems (use with -a)
     -r, --read-only         mount the filesystem read-only (same as -o ro)
     -t, --types <list>      limit the set of filesystem types
         --source <src>      explicitly specifies source (path, label, uuid)
         --target <target>   explicitly specifies mountpoint
     -v, --verbose           say what is being done
     -w, --rw, --read-write  mount the filesystem read-write (default)
    

1.-t vfstype  指定文件系统的类型，通常不必指定

    光盘或光盘镜像：iso9660 
    DOS fat16文件系统：msdos 
    Windows 9x fat32文件系统：vfat 
    Windows NT ntfs文件系统：ntfs 
    Mount Windows文件网络共享：smbfs 
    UNIX(LINUX) 文件网络共享：nfs 
    
2.-o options 主要用来描述设备或档案的挂接方式。常用的参数有：
 
    loop：用来把一个文件当成硬盘分区挂接上系统 
    ro：采用只读方式挂接设备 
    rw：采用读写方式挂接设备 
    iocharset：指定访问文件系统所用字符集   

3.device 要挂接(mount)的设备。 

4.dir设备在系统上的挂接点(mount point)。

应用
----

1.从光盘制作光盘镜像文件
```
cp /dev/cdrom /home/root/mydisk.iso Or
dd if=/dev/cdrom of=/home/root/mydisk.iso
```




## 挂载概念

根文件系统之外的其他文件要想能够被访问,都必须通过"关联"之根文件系统上的某个目录来实现,
此关联操作即为"挂载",此目录即为"挂载点",解除次关系的过程被称作"卸载"

1.`挂载` : 根文件系统外通过关联至根文件系统上的某个目录来实现访问
2.`挂载点`: mount_point , 用于作为另外一个文件系统的访问入口

(1) 实现存在

(2) 应该使用违背或不会被其他进程使用到的目录

(3) 挂载点下原有的文件将会被隐藏

## 挂载与卸载
### 挂载方法: mount DECE MOUNT_POINT

mount: 通过查看 /etc/mtab 文件显示当前系统已挂载的所有设备

格式:`mount [-fnrsvw] [-t vfstype] [-o options] device dir`

device：指明要挂载的设备；

(1) 设备文件：例如/dev/sda5

(2) 卷标：-L 'LABEL', 例如 -L 'MYDATA'

(3) UUID, -U 'UUID'：例如 -U '0c50523c-43f1-45e7-85c0-a126711d406e'

(4) 伪文件系统名称：proc, sysfs, devtmpfs, configfs

dir：挂载点

事先存在；建议使用空目录；

    进程正在使用中的设备无法被卸载；

常用命令选项：

    -t vsftype：指定要挂载的设备上的文件系统类型；

    -r: readonly，只读挂载；

    -w: read and write, 读写挂载；

    -n: 不更新/etc/mtab； 

    -a：自动挂载所有支持自动挂载的设备；(定义在了/etc/fstab文件中，且挂载选项中有“自动挂载”功能)

    -L 'LABEL': 以卷标指定挂载设备；

    -U 'UUID': 以UUID指定要挂载的设备；

    -B, --bind: 绑定目录到另一个目录上；

注意：查看内核追踪到的已挂载的所有设备：cat /proc/mounts

………………………………………………………………………………………………………………………

    -o options：(挂载文件系统的选项)

      async：异步模式；

      sync：同步模式；

      atime/noatime：包含目录和文件；

      diratime/nodiratime：目录的访问时间戳

      auto/noauto：是否支持自动挂载

      exec/noexec：是否支持将文件系统上应用程序运行为进程

      dev/nodev：是否支持在此文件系统上使用设备文件；

      suid/nosuid：是否支持在此文件系统上使用特殊权限

      remount：重新挂载

      ro：只读

      rw:读写

      user/nouser：是否允许普通用户挂载此设备

      acl：启用此文件系统上的acl功能

注意：上述选项可多个同时使用，彼此使用逗号分隔；

 默认挂载选项：defaults：rw, suid, dev, exec, auto, nouser, and async

上述信息可以通过查看超级块信息看到，这里不再对其进行演示。

………………………………………………………………………………………………………………………

卸载命令：umount

命令使用格式：

     # umount DEVICE

     # umount MOUNT_POINT

上面已经演示过umount的使用

fuser：查看正在访问指定文件系统的进程：

命令使用格式：

     # fuser -v MOUNT_POINT

终止所有在正访问指定的文件系统的进程：慎用

     # fuser -km MOUNT_POINT
………………………………………………………………………………………………………………………

交换分区 swap

这里介绍下交换分区,通过实现实验延时交换分区的创建于挂载

挂载交换分区:

启用: swapon

swapon [OPTION]... [DEVICE]

	-a : 激活所有的交换分区
	
	-p PRIORITY: 指定优先级
	
禁用: swapoff [OPTION]... [DEVICE]

实验演示:

1.交换分区的创建:1_



	 

## 区别

/etc/mtab  当前系统挂载情况(全部挂载情况)

/etc/fstab 当前系统需要加载的挂载情况


………………………………………………………………………………………………………………………

## 分区步骤:
````
fdisk /dev/sda
//...... 一系列操作

n 创建
d 删除 
w 保存
t 修改类型
v 验证分区列表
q 退出
l 列出已知的分区类型
g 创建一个新的GPT 分区表

// 重启之后才会在 `/dev` 下面创建相应的文件

````


