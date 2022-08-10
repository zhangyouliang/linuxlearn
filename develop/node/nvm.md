

安装
````bash
brew install nvm
````

单独将配置放到一个文件里面,使用的时候在 `source ~/.nvmrc`
````bash
cat>>~/.nvmrc<<EOF
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
EOF 

````

常用命令
````
nvm ls ：列出所有已安装的 node 版本

nvm ls-remote ：列出所有远程服务器的版本（官方node version list）

nvm list ：列出所有已安装的 node 版本

nvm list available ：显示所有可下载的版本

nvm install stable ：安装最新版 node

nvm install [node版本号] ：安装指定版本 node

nvm uninstall [node版本号] ：删除已安装的指定版本

nvm use [node版本号] ：切换到指定版本 node

nvm current ：当前 node 版本

nvm alias [别名] [node版本号] ：给不同的版本号添加别名

nvm unalias [别名] ：删除已定义的别名

nvm alias default [node版本号] ：设置默认版本
````