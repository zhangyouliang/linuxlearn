homebrew 
===
> 官方链接:  https://brew.sh/

````
# 首先执行
xcode-select --install
# 官方安装方式
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 一键替换文件地址
# 如果是 bash ,请替换为 ~/.bashrc
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sed 's/BREW_REPO="https:\/\/github.com\/Homebrew\/brew"/BREW_REPO="https:\/\/mirrors.ustc.edu.cn\/brew"/g')"

````

#### # 常用命令

```
# 更新本地已安装的软件包
brew update
brew upgrade --all

brew pin [formula] 固定软件
brew unpin [formula] 解除固定
brew upgrade [formula] 升级某一软件
brew outdated （列出已安装中待升级）


# 默认安装位置 
brew --prefix
# 清理残留的旧版本及相关日志
brew cleanup
# 对系统中各个目录时候有权限等问题，可执行下述命令诊断
brew doctor
# 显示与 Homebrew 相关的系统信息
brew config
# 显示包依赖
brew deps php
# 列出已安装的软件
brew ls
# 主要看具体的信息，比如目前的版本，依赖，安装后注意事项等
brew info [formula] 
# 查看已安装的无依赖包
brew leaves

# 完全卸载
cd `brew –prefix`
rm -rf Cellar
brew prune
rm -rf Library .git .gitignore bin/brew *.md share/man/man1/brew.1
rm -rf ~/Library/Caches/Homebrew ~/Library/Logs/Homebrew /Library/Caches/Homebrew
```

#### # brew 加速


平时我们执行 brew 命令安装软件的时候，跟以下 3 个仓库地址有关：
- brew.git
- homebrew-core.git
- homebrew-bottles


我这里使用的是中科大的源:

````
# brew git
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
# brew core git
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
# brew cask git
cd "$(brew --repo)"/Library/Taps/homebrew/homebrew-cask
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
# brew bottles zshrc
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc
````

阿里源替换方法:

1. 替换 / 还原 brew.git 仓库地址
````
# 替换成阿里巴巴的 brew.git 仓库地址:
cd "$(brew --repo)"
git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git

# 还原为官方提供的 brew.git 仓库地址
cd "$(brew --repo)"
git remote set-url origin https://github.com/Homebrew/brew.git
````

2. 替换 / 还原 homebrew-core.git 仓库地址
````
# 替换成阿里巴巴的 homebrew-core.git 仓库地址:
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git

# 还原为官方提供的 homebrew-core.git 仓库地址
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://github.com/Homebrew/homebrew-core.git
````

3. 替换 / 还原 homebrew-bottles 访问地址

这个步骤跟你的 macOS 系统使用的 shell 版本有关系

所以，先来查看当前使用的 shell 版本

````
echo $SHELL

如果为: /bin/zsh
# 替换成阿里巴巴的 homebrew-bottles 访问地址:
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc



如果为: /bin/bash

# 替换 homebrew-bottles 访问 URL:
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.bash_profile
source ~/.bash_profile

````

#### # 其他

````
# 如何挂代理
export ALL_PROXY=socks5://127.0.0.1:1086
````