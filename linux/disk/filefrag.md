> filefrag: 报告特定文件的碎片程度。它允许ext2和ext3文件系统使用间接块，但可以在任何文件系统的文件上使用。


一. 参数
-----

```
-B 出于测试目的，强制使用较旧的FIBMAP ioctl代替FIEMAP ioctl。
-b 使用1024字节的块大小作为输出。
-s 在请求映射之前同步文件。
-v 检查文件碎片时要冗长。
-X 显示扩展属性的映射。
```
二.  应用:
-----
```
filefrag -v exec.sh 
Filesystem type is: ef53
File size of exec.sh is 147 (1 block of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:    4850463..   4850463:      1:             last,eof
exec.sh: 1 extent found
```