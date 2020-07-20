#!/bin/bash

# export DEBUG=true
# 如果 DEBUG 存在,则设置 -x
[ -n "$DEBUG" ] && set -x

PROXY=''
NEW_VER=''
VDIS=''
CUR_VER=''

CMD_INSTALL=""
CMD_UPDATE=""
SOFTWARE_UPDATED=0

# 将执行结果设置为一个变量
SYSTEMCTL_CMD=$(command -v systemctl 2>/dev/null)
SERVICE_CMD=$(command -v service 2>/dev/null)

# 一行代码判断 systemctl 命令是否存在
# command -v systemctl 2>/dev/null || { echo "systemctl 命令不存在"; }





########## color code ########
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message

#########################

while [[ $# > 0 ]];do
    case "$1" in
        -p|--proxy)
        shift
        ;;
        -h|--help)
        HELP="1"
        ;;
        -f|--force)
        FORCE="1"
        ;;
        -c|--check)
        CHECK="1"
        ;;
        --remove)
        REMOVE="1"
        ;;
        --version)
        VERSION="$2"
        shift
        ;;
        *)
        # unknow option
        ;;
    esac
    shift
done


###############################

colorEcho(){
    # ${@:2} 参数截取,从 $2 开始 
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}

# arch 获取

archAffix(){
    case "${1:-"$(uname -m)"}" in
        i686|i386)
            echo '386'
        ;;
        x86_64|amd64)
            echo 'amd64'
        ;;
        *armv7*|armv6l)
            echo 'arm'
        ;;
        *armv8*|aarch64)
            echo 'arm64'
        ;;
        *mips64le*)
            echo 'mips64le'
        ;;
        *mips64*)
            echo 'mips64'
        ;;
        *mipsle*)
            echo 'mipsle'
        ;;
        *mips*)
            echo 'mips'
        ;;
        *s390x*)
            echo 's390x'
        ;;
        ppc64le)
            echo 'ppc64le'
        ;;
        ppc64)
            echo 'ppc64'
        ;;
        *)
            return 1
        ;;
    esac
    return 0
}

download_gonelist(){
    rm -rf /tmp/gonelist
    mkdir -p /tmp/gonelist
    if [[ "${DIST_SRC}" ]];then
        DOWNLOAD_LINK="https://gonelist.cugxuan.cn/d/gonelist-release/gonelist_linux_${VDIS}.tar.gz"
    else 
        DOWNLOAD_LINK="https://github.com/cugxuan/gonelist/releases/download/${NEW_VER}/gonelist_linux_${VDIS}.tar.gz"
    fi
    colorEcho ${BLUE} "Downloading Gonelist: ${DOWNLOAD_LINK}"
    curl ${PROXY} -L -H "Cache-Control: no-cache" -o ${TARFILE} ${DOWNLOAD_LINK}
    if [ $? -ne 0 ];then
        colorEcho ${RED} "Failed to download! Please check your network or try again."
        return 3
    fi
    return 0
}

installSoftware(){
    COMPONENT=$1
    if [[ -n `command -v $COMPONENT` ]];then
        return 0
    fi
    getPMT
    if [[ $? -eq 1 ]];then
        colorEcho ${RED} "The system package manager tool isn't APT or YUM, please install ${COMPONENT} manually."
        return 1
    fi
    if [[ $SOFTWARE_UPDATED -eq 0 ]];then
        colorEcho ${BLUE} "Updating software repo"
        $CMD_UPDATE
        SOFTWARE_UPDATED=1
    fi

    colorEcho ${BLUE} "Installing ${COMPONENT}"
    $CMD_INSTALL $COMPONENT
    if [[ $? -ne 0 ]];then
        colorEcho ${RED} "Failed to install ${COMPONENT}. Please install it manually."
        return 1
    fi
    return 0
}

# return 1: not apt,yum, or zypper
getPMT(){
    if [[ -n `command -v apt-get` ]];then
        CMD_INSTALL="apt-get -y -qq install"
        CMD_UPDATE="apt-get -qq update"
    elif [[ -n `command -v yum`]];then
        CMD_INSTALL="yum -y -q install"
        CMD_UPDATE="yum -q makecache"
    elif [[ -n `command -v zypper`]];then
        CMD_INSTALL="zypper -y install"
        CMD_UPDATE="zypper ref"
    else
        return 1
    fi
    return 0
}

normalizeVersion(){
    if [ -n "$1" ];then
        case "$1" in
        v*)
            echo "$1"
        ;;
        *)
            echo "v$1"
        ;;
        esac
    else
        echo ""
    fi
}

getVersion(){
    if [[ -n "$VERSION" ]];then
        NEW_VER="$(normalizeVersion "$VERSION")"
        return 4
    else
        # get the latest release
        TAG_URL="https://api.github.com/repos/cugxuan/gonelist/releases/latest"
        NEW_VER="$(normalizeVersion "$(curl ${PROXY} --retry 6 \
            -H "Accept: application/json" \
            -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:74.0) Gecko/20100101 Firefox/74.0" \
            -s "${TAG_URL}" --connect-timeout 20 | awk -F'[ "]+' '$0!"tag_name"{print $4;exit}' )")"
        [ ! -f /usr/bin/gonelist/gonelist ] && return 2
        VER="$(/usr/bin/gonelist/gonelist --version | awk '/Version/{print $NF;exit}')"
        RETVAL=$?
        CUR_VER="$(normalizeVersion "$VER")"

        if [[ $? -ne 0 ]] || [[ $NEW_VER == "" ]];then
            colorEcho ${RED} "Failed to fetch release information. Please check your network or try again."
            return 3
        elif [[ $RETVAL -ne 0 ]];then
            return 2
        elif [[ $NEW_VER != $CUR_VER ]];then
            return 1
        fi
        return 0
    fi
}

stop_gonelist(){
    # 如果 SYSTEMCTL_CMD 不存在,说明 systemctl 命令不存在 , 后继 -f xxx 命令不在判断
    if [[ -n "$SYSTEMCTL_CMD" ]] || [[ -f "/lib/systemd/system/gonelist.service" ]];then
        echo ${SYSTEMCTL_CMD} stop gonelist
    elif [[ -n ${SERVICE_CMD} ]] || [[ -f "/etc/init.d/gonelist" ]] ;then
        echo ${SERVICE_CMD} gonelist stop
    fi

    if [[ $? -ne 0 ]];then
        return 2
    fi
    return 0
}

# https://github.com/zhangguanzhang/gonelist/blob/master/scripts/install-release.sh