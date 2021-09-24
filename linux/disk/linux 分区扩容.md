分区命令
====


* blkid 获取文件类型和 UUID
* parted 查看分区情况
* growpart 扩容格式化工具



#### # 分区扩容

* [参考:阿里云文档](https://help.aliyun.com/document_detail/111738.html?spm=a2c4g.11186623.6.806.7aba7f67yDLZqL)


````
# 根据操作系统安装growpart或者xfsprogs扩容格式化工具
apt install cloud-guest-utils
apt install xfsprogs

# parted -l /dev/vda
Number  Start   End     Size    Type     File system  Flags
 1      1049kB  42.9GB  42.9GB  primary  ext4         boot

# 运行growpart <DeviceName> <PartionNumber>命令调用growpart为需要扩容的云盘和对应的第几个分区扩容。
# 示例命令表示为系统盘的第一个分区（/dev/vda1）扩容。
growpart /dev/vda 1
CHANGED: partition=1 start=2048 old: size=83881984 end=83884032 new: size=209713119,end=209715167
# 查看
parted -l /dev/vda
Number  Start   End    Size   Type     File system  Flags
 1      1049kB  107GB  107GB  primary  ext4         boot

# 但是此时vda1依然为 40G,需要继续扩容文件系统
df -h
/dev/vda1                                         40G   34G  3.3G  92% /
# 运行resize2fs <PartitionName>命令调用resize2fs扩容文件系统。
# 示例命令表示为扩容系统盘的/dev/vda1分区文件系统。
resize2fs /dev/vda1

# 查看,文件系统即可扩容成功
df -h
/dev/vda1                                         99G   34G   60G  37% /

````
