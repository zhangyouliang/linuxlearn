> [推荐一款很好用的内网穿透工具--FRP](https://mp.weixin.qq.com/s/8HeeDC5x5xozElN8GzQLLw), [Github FRP](https://github.com/fatedier/frp)

对于没有公网 IP 的内网用户来说，远程管理或在外网访问内网机器上的服务是一个问题。通常解决方案就是用内网穿透工具将内网的服务穿透到公网中，便于远程管理和在外部访问。内网穿透的工具很多，之前也介绍过 Ngrok、Localtunnel。

今天给大家介绍另一款好用内网穿透工具 FRP，FRP 全名：Fast Reverse Proxy。FRP 是一个使用 Go 语言开发的高性能的反向代理应用，可以帮助您轻松地进行内网穿透，对外网提供服务。FRP 支持 TCP、UDP、HTTP、HTTPS 等协议类型，并且支持 Web 服务根据域名进行路由转发。

FRP 项目地址：https://github.com/fatedier/frp
