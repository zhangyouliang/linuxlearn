#!/usr/bin/env bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cd ~/.oh-my-zsh/plugins/
git clone git://github.com/zsh-users/zsh-autosuggestions



cat>>~/.zshrc1<<EOF
# 防止中文乱码
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# 提示工具
source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# 或者
plugins=(zsh-autosuggestions)
EOF