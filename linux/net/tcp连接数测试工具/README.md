

````
g++ -o test_epoll ./test_epoll.c
# 修改里面的 ip 地址
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o dist/app client.go


# 查看监听中的端口数量
netstat -antp | grep 8080 | grep ESTABLISHED | wc -l

````

参考
====
- [测试Linux下tcp最大连接数限制](https://www.cnblogs.com/lit10050528/p/8148723.html)
