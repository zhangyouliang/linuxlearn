docker 磁盘空间处理
===

````
# 查看日志文件存储文件大小
logs=$(find /var/lib/docker/containers/ -name *-json.log)  
for log in $logs  
do  
    ls -lh $log   
done


# 查看 containers 占用空间比较大的目录
du -s /var/lib/docker/containers/* | sort -rn | head -n1 | awk '{print $2}' | xargs du -h

# docker 查看磁盘空间
docker system df -v

# 空间清理
# 该指令默认会清除所有如下资源：
# 已停止的容器（container）
# 未被任何容器所使用的卷（volume）
# 未被任何容器所关联的网络（network）
# 所有悬空镜像（image）。
docker system prune
````

限制日志文件大小

````
# vim /etc/docker/daemon.json

{
  "log-driver":"json-file",
  "log-opts": {"max-size":"500m", "max-file":"3"}
}

# 重启
systemctl daemon-reload && systemctl restart docker
````


Linux上配置文件的默认位置是 `/etc/docker/daemon.json`。该`--config-file`标志可用于指定非默认位置。

````
{
    "authorization-plugins": [],
    "data-root": "", 
     #Docker运行时使用的根路径,根路径下的内容稍后介绍，默认/var/lib/docker
    "dns": [],  
     #设定容器DNS的地址，在容器的 /etc/resolv.conf文件中可查看
    "dns-opts": [],
     #容器 /etc/resolv.conf 文件，其他设置
    "dns-search": [],
     #设定容器的搜索域，当设定搜索域为 .example.com 时，在搜索一个名为 host 的 主机时，DNS不仅搜索host，还会搜索host.example.com。注意：如果不设置，Docker 会默认用主机上的 /etc/resolv.conf来配置容器。
    "exec-opts": [],
    "exec-root": "",
    "experimental": false,
    "features": {},
    "storage-driver": "",
    "storage-opts": [],
    "labels": [],
     #docker主机的标签，很实用的功能,例如定义：–label nodeName=host-121
    "live-restore": true,
    "log-driver": "",
    "log-opts": {},
    "mtu": 0,
    "pidfile": "",
     #Docker守护进程的PID文件
    "cluster-store": "",
    "cluster-store-opts": {},
    "cluster-advertise": "",
    "max-concurrent-downloads": 3,
    "max-concurrent-uploads": 5,
    "default-shm-size": "64M",
    "shutdown-timeout": 15,
    "debug": true, 
     #启用debug的模式，启用后，可以看到很多的启动信息。默认false
    "hosts": [],
    #设置容器hosts
    "log-level": "",
    "tls": true,  
     #默认 false, 启动TLS认证开关
    "tlscacert": "", 
     #默认 ~/.docker/ca.pem，通过CA认证过的的certificate文件路径
    "tlscert": "", 
     #默认 ~/.docker/cert.pem ，TLS的certificate文件路径
    "tlskey": "",
     #默认~/.docker/key.pem，TLS的key文件路径
    "tlsverify": true,
     #默认false，使用TLS并做后台进程与客户端通讯的验证
    "tls": true,
    "tlsverify": true,
    "tlscacert": "",
    "tlscert": "",
    "tlskey": "",
    "swarm-default-advertise-addr": "",
    "api-cors-header": "",
    "selinux-enabled": false, 
     #默认 false，启用selinux支持
    "userns-remap": "",
    "group": "",
     #Unix套接字的属组,仅指/var/run/docker.sock
    "cgroup-parent": "",
    "default-ulimits": {
        "nofile": {
            "Name": "nofile",
            "Hard": 64000,
            "Soft": 64000
        }
    },
    "init": false,
    "init-path": "/usr/libexec/docker-init",
    "ipv6": false,
    "iptables": false,
    "ip-forward": false,
    #默认true, 启用 net.ipv4.ip_forward ,进入容器后使用sysctl -a|grepnet.ipv4.ip_forward查看
    "ip-masq": false,
    "userland-proxy": false,
    "userland-proxy-path": "/usr/libexec/docker-proxy",
    "ip": "0.0.0.0",
    "bridge": "",
    "bip": "",
    "fixed-cidr": "",
    "fixed-cidr-v6": "",
    "default-gateway": "",
    "default-gateway-v6": "",
    "icc": false,
    "raw-logs": false,
    "allow-nondistributable-artifacts": [],
    "registry-mirrors": [],
     #镜像加速的地址，增加后在 docker info中可查看。
    "seccomp-profile": "",
    "insecure-registries": [],
     #配置docker的私库地址
    "no-new-privileges": false,
    "default-runtime": "runc",
    "oom-score-adjust": -500,
    "node-generic-resources": ["NVIDIA-GPU=UUID1", "NVIDIA-GPU=UUID2"],
    "runtimes": {
        "cc-runtime": {
            "path": "/usr/bin/cc-runtime"
        },
        "custom": {
            "path": "/usr/local/bin/my-runc-replacement",
            "runtimeArgs": [
                "--debug"
            ]
        }
    },
    "default-address-pools":[{"base":"172.80.0.0/16","size":24},
    {"base":"172.90.0.0/16","size":24}]
}
````

> 注意：您不能将`daemon.json`已在守护程序启动时设置的选项设置为标志。在`systemd`用于启动`Docker`守护程序的系统上-H已设置，因此您无法使用该hosts键daemon.json来添加侦听地址。有关如何使用`systemd drop-in`文件完成此任务，请参阅 [https://docs.docker.com/engine/admin/systemd/#custom-docker-daemon-options](https://docs.docker.com/engine/admin/systemd/#custom-docker-daemon-options)。



参考
===
- [Docker配置文件daemon.json解析](https://www.jianshu.com/p/c7c7dc24b9e3)
- [daemon-configuration-file](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file)