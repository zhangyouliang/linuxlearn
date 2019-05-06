> ssh登陆不能在命令行中指定密码。sshpass的出现，解决了这一问题。sshpass用于非交互SSH的密码验证，一般用在sh脚本中，无须再次输入密码。它允许你用 -p 参数指定明文密码，然后直接登录远程服务器，它支持密码从命令行、文件、环境变量中读取


安装
---

    # centos 
    yum install sshpass

用法
---

    sshpass -p 123456 ssh root@192.168.56.102
    sshpass -p '123456' scp root@host_ip:/home/test/t ./tmp/
    
