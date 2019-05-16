> nslookup命令是常用域名查询工具，就是查DNS信息用的命令。

nslookup 有两种工作方式

- 交互模式
- 非交互模式
  
进入交互模式，直接输入 `nslookup` 命令，不加任何参数，则直接进入交互模式，此时nslookup会连接到默认的域名服务器（即`/etc/resolv.conf`的第一个dns地址）。或者输入`nslookup ip `。进入非交互模式，就直接输入nslookup 域名就可以了。