fzf 模糊查询
====
> 可以用来查找任何 列表 内容，文件、Git 分支、进程等。所有的命令行工具可以生成列表输出的都可以再通过管道 pipe 到 fzf 上进行搜索和查找

````
brew install fzf
# 如果要使用内置的快捷键绑定和命令行自动完成功能的话可以按需安装
$(brew --prefix)/opt/fzf/install
````

[fzf-tab](https://github.com/Aloxaf/fzf-tab)
> fzf 加持 on-my-zsh 的 tab 提示
````
# 这里只介绍  on-my-zsh
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
````

比较常用的用法

````
# 比如我们用 vim 组合 fzf 来查找并打开目录下的文件：
vim $(fzf)
# 切换当前工作目录
cd $(find * -type d | fzf)
# 切换 git 分支
git checkout $(git branch -a | fzf)

````