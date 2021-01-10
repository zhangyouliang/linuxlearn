> ssh登陆不能在命令行中指定密码。sshpass的出现，解决了这一问题。sshpass用于非交互SSH的密码验证，一般用在sh脚本中，无须再次输入密码。它允许你用 -p 参数指定明文密码，然后直接登录远程服务器，它支持密码从命令行、文件、环境变量中读取

参数
---

````
-f filename：从文件中获取密码
-d number：使用数字作为获取密码的文件描述符
-p password：指定明文本密码输入（安全性较差）
-e 从环境变量SSHPASS获取密码
````


安装
---
````
# centos 
yum install sshpass
# mac
wget https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
brew install sshpass.rb
````

用法
---
````
# 登录目标机器
sshpass -p 123456 ssh root@192.168.56.102
# 复制远端文件到本地
sshpass -p '123456' scp root@host_ip:/home/test/t ./tmp/
# 远程连接主机并执行命令
# -o StrictHostKeyChecking=no: 忽律密码提示
sshpass ssh -o StrictHostKeyChecking=no 192.168.1.120 "ls -l"    
````
    
