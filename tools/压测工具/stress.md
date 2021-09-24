> stress 命令主要用来模拟系统负载较高时的场景

命令参数
---
```
-c, --cpu N              产生 N 个进程，每个进程都反复不停的计算随机数的平方根
-i, --io N                  产生 N 个进程，每个进程反复调用 sync() 将内存上的内容写到硬盘上
-m, --vm N             产生 N 个进程，每个进程不断分配和释放内存
    --vm-bytes B      指定分配内存的大小
    --vm-stride B     不断的给部分内存赋值，让 COW(Copy On Write)发生
    --vm-hang N      指示每个消耗内存的进程在分配到内存后转入睡眠状态 N 秒，然后释放内存，一直重复执行这个过程
    --vm-keep          一直占用内存，区别于不断的释放和重新分配(默认是不断释放并重新分配内存)
-d, --hadd N           产生 N 个不断执行 write 和 unlink 函数的进程(创建文件，写入内容，删除文件)
    --hadd-bytes B  指定文件大小
-t, --timeout N       在 N 秒后结束程序        
--backoff N            等待N微妙后开始运行
-q, --quiet              程序在运行的过程中不输出信息
-n, --dry-run          输出程序会做什么而并不实际执行相关的操作
--version                显示版本号
-v, --verbose          显示详细的信息
```

案例
---

````
# 消耗 cpu 资源
stress -c 4
# 消耗内存资源(CPU 占用高)
stress --vm 2 --vm-bytes 300M --vm-keep

# 每个消耗内存的进程在分配到内存后转入睡眠状态 N 秒,然后释放内存，一直重复执行这个过程
# CPU 占用低
stress --vm 2 --vm-bytes 500M --vm-hang 5

# --vm-stride B 
# 影响 CPU 状态 us 和 sy
# bytes 为消耗的总内存大小，stride 为间隔。
# --vm-stride 值增大就意味着减少赋值和对比操作，这样就增加了内存的释放和分配次数(cpu在内核空间的负载)。
不指定 --vm-stride 选项就使用默认值是 4096，CPU 负载情况居于前两者之间
stress --vm 2 --vm-bytes 500M --vm-stride 64
stress --vm 2 --vm-bytes 500M --vm-stride 1M

# 消耗 IO 资源
# sy 升高，wa(iowait) 非常高。
stress -i 4

# 压测磁盘及 IO
stress -d 1 --hdd-bytes 10M
# iostat 2 查看详情  iowait 为磁盘瓶颈

````



参考
---
