#!/usr/bin/env bash

cd ~/.oh-my-zsh/plugins/

git clone https://gitee.com/whatdy/zsh-autosuggestions.git


cat>>~/.zshrc<<EOF
# 防止中文乱码
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# 提示工具
source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# 或者
plugins=(zsh-autosuggestions)
EOF

source ~/.zshrc