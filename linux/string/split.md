> split 分割合并命令

选项
---

    -b：值为每一输出档案的大小，单位为 byte。
    -C：每一输出档中，单行的最大 byte 数。
    -d：使用数字作为后缀。
    -a: 指定后缀长度
    -l：值为每一输出档的列数大小。按照行数分割

实例
---

生成一个大小为 100kb 的测试文件

    dd if=/dev/zero bs=100k count=1 of=access.log

使用split命令将上面创建的date.file文件分割成大小为10KB的小文件：

    split -b 10k access.log

为分割后的文件指定文件名的后缀

    split -b 10k access.log -d -a 3 split_file
