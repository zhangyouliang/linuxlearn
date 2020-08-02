> apt-get: Ubuntu 命令

命令参数
---


案例
---

```bash
# 包搜索
apt-cache search package
# 获取包的相关信息，如说明、大小、版本等
apt-cache show package
# 安装包
apt-get install package
# 修复安装
apt-get -f install package 
# 删除包
apt-get remove package
# 删除包，包括删除配置文件等
apt-get remove package - - purge 
# 更新已安装的包
apt-get upgrade
# 升级系统
apt-get dist-upgrade
# 了解使用依赖
apt-cache depends package
# 是查看该包被哪些包依赖
apt-cache rdepends package
# 安装相关的编译环境
apt-get build-dep package
# 下载该包的源代码
apt-get source package
# 清理无用的包
apt-get clean && sudo apt-get autoclean
# 检查是否有损坏的依赖
apt-get check    
# 更新源
# 不打印 命中 url 等信息
apt-get update -qq

```



参考
---




