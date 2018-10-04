
安装 brew 前

        # 首先执行
        xcode-select --install

其他命令:

        # 更新本地已安装的软件包
        brew update
        brew upgrade --all
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
        # 查看已安装的无依赖包
        brew leaves

        # 完全卸载
        cd `brew –prefix`
        rm -rf Cellar
        brew prune
        rm -rf Library .git .gitignore bin/brew *.md share/man/man1/brew.1
        rm -rf ~/Library/Caches/Homebrew ~/Library/Logs/Homebrew /Library/Caches/Homebrew

