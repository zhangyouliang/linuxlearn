#!/bin/sh

# do string
# 随机事件
function kubectl(){
    # random=$(( (RANDOM % 10) + 1 ))
    random=$(( RANDOM % 5))

    case $random in
        0 | 1)
        echo 'success'
        return 0
        ;;
        *)
        echo 'failure'
        return 1
        ;;
    esac
}

# Run kubectl and retry upone failure
function kubectl_retry(){
    tries=3
    while ! kubectl "$@";do
        tries=$((tries-1))
        if [[ ${tries} -le 0 ]];then
            echo "('kubectl $@' failed, giving up)" >&2
            return 1   
        fi
        echo "(kubectl failed, will retry ${tries} times)" >&2
        sleep 1
    done
}
# kubectl_retry $@
# output: 
# failure
# (kubectl failed, will retry 2 times)
# success

if ! command -v zgrep &> /dev/null; then
    zgrep(){
        zcat "$2" | grep "$1"
    }
fi


