### nginx 黑名单

nginx.conf 文件 Http模块当中

    #获取用户真实IP，并赋值给变量$clientRealIP
    map $http_x_forwarded_for  $clientRealIp {
            ""      $remote_addr;
            ~^(?P<firstAddr>[0-9\.]+),?.*$  $firstAddr;
    }
    



```
# 生成配置文件
./deny_ctrl.sh -c
# 添加ip到黑名单
./deny_ctrl.sh -a <ip>
# 在xx.conf 文件当中包含黑名单
include deny_ip.conf ;
# 重启nginx
nginx -s reload
```