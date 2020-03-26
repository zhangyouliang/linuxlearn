#!/usr/bin/env bash

###
# Markdown 模板生成工具
# ./make.sh xxx.md
###
if [[ $# -lt 1 ]];then
    echo "Usage: ./$0 <file name>"
    exit 1
fi

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")"/. && pwd -P)

FILE_PATH=${ROOT}/$1.md


function create(){
    cat << EOF | sed "s/COMMAND/$1/g" > ${FILE_PATH}
> COMMAND: <描述..>

命令参数
---


案例
---



参考
---




EOF
    echo "File generated successfully...."
}

if [[ -f "${FILE_PATH}" ]];then
    echo "The file already exists ... ($FILE_PATH)"
    read -p "Override file ? Please Enter [yYnN]" over
    if [[ $over =~ ^[yY]$ ]]; then
        create $1
    fi
    exit 1
fi

create $1
