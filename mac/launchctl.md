1、配置好plist之后：

#加载一个服务到启动列表

```bash
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist 
#卸载一个服务
sudo launchctl unload  /System/Library/LaunchDaemons/ssh.plist 
```

2、查看所有服务：

```bash
sudo launchctl list
```
3、查看服务状态

```bash
sudo launchctl list | grep <<Service Name>>
```

输出具有以下含义：

- 第一个数字是进程的PID，如果它正在运行，如果它不运行，它显示一个' - '。
- 第二个数字是进程的退出代码，如果它已经完成。如果是负数，则是杀死信号的数量。
- 第三列是进程名称。


4、服务操作

````bash

#停止
sudo launchctl stop <<Service Name>>
#开始
sudo launchctl start <<Service Name>>
#kill
sudo launchctl kill <<Service Name>> 
````
5、更多的用法直接输入：launchctl help进行查看。

 