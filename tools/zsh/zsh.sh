#!/usr/bin/env bash

# 插件下载
# 系统插件
# cd ~/.oh-my-zsh/plugins/
# 自定义插件目录
cd ~/.oh-my-zsh/custom/plugins

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/Aloxaf/fzf-tab.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git

# brew 单独安装插件
brew install autojump

cat>>~/.zshrc<<EOF
# 防止中文乱码
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# 提示工具
# source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

plugins=(
  zsh-syntax-highlighting
  fzf-tab
  zsh-autosuggestions
)
EOF

source ~/.zshrc