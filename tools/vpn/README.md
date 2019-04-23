
## 1. 安装服务端
> python 安装客户端

登录服务器, 执行以下命令


    # 安装pip
    yum install python-pip

    # 使用pip安装shadowsocks
    pip install shadowsocks

> docker 方式搭建

Ubuntu:

    curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
    apt install docker.io
    # 映射1984 到宿主机443 端口
    docker run -d -p 443:1984 oddrationale/docker-shadowsocks -s 0.0.0.0 -p 1984 -k <密码> -m aes-256-cfb


## 2. 配置Shdowsocks服务,并启动

新建 `/etc/shadowsocks.json` 文件, 并写入以下内容
```
{
	"server":"remote-server-ip-addr",
	"server_port":443,
	"local_address":"0.0.0.0",
	"local_port":1080,
	"password":"your-passwd",
	"timeout":300,
	"method":"aes-256-cfb",
	"fast_open":false,
	"workers":5
}
```
注意修改 `server` 和 `password`, `workers` 表示启动的进程数量。

`server_port` 强烈建议使用443端口。

然后使用以下命令启动: `ssserver -c /etc/shadowsocks.json -d start`

如果出现报错: `Cannot assign requested address`, 请将 `server` 换成 `0.0.0.0`, 然后重新启动上面的命令。


我们就可以利用 `Shadowsocks  iOS/OX/windows/android` 等版本进行登录了

    账号: xx.xx.xx.xx
    端口: 443
    加密方式: aes-256-cfb
    密码: <密码>


## 附录

### # 解决部分宽带不可访问**服务器问题
> 利用 frp 做一个端口转发操作,需要国内一台主机(A),目标主机B

流程:

国外 -> B(443) -----frp 转发-----> A (8000) ---> client

我们只需要将本地客户端端口改为 8000 即可

具体配置:

A 主机:

    wget https://github.com/fatedier/frp/releases/download/v0.26.0/frp_0.26.0_linux_amd64.tar.gz
    mkdir /opt/frp
    tar -C /opt/frp -xvf frp_0.26.0_linux_amd64.tar.gz  --strip-components 1
    # 修改 frps.ini 对应路径
    cp /opt/frp/systemd/frps.service /lib/systemd/system/frps.service
    systemctl start frps
    

frps.ini

    [common]
    bind_addr = 0.0.0.0
    bind_port = 7000

B 主机:

    # 修改 frps.ini 对应路径
    cp /opt/frp/systemd/frpc.service /lib/systemd/system/frpc.service
    systemctl start frpc

frpc.ini

    [common]
    server_addr = <A 主机IP>
    server_port = 7000

    [ssh]
    type = tcp
    local_ip = 127.0.0.1
    local_port = 22
    remote_port = 6000

    [ssh]
    type = tcp
    local_ip = 127.0.0.1
    local_port = 443
    remote_port = 8000


上述操作,将会 B 主机的 443,22 端口映射到`目标主机A`上面,剩下的只需要按照正常连接服务端的操作即可


参考
---
- [ShadowsocksX-Mac](https://github.com/shadowsocks/ShadowsocksX-NG/releases)
- [shadowsocks-android](https://github.com/shadowsocks/shadowsocks-android)
- [frp](https://github.com/fatedier/frp)

