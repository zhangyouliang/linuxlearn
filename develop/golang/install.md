ubuntu 快速安装
----
````
apt install golang-1.9
mkdir -p ~/.gopm/{gopath,repos}
ln -s ~/.gopm/repos ~/.gopm/gopath/src
mkdir -p ~/.gopm/gopath/pkg
## .zshrc 中添加如下内容
### golang
export GOROOT=/usr/lib/go-1.9
export GOBIN=$GOROOT/bin
export GOPATH=~/.gopm/gopath
export PATH=$PATH:$GOBIN

# 查看环境
go env
````
