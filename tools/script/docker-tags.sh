#!/usr/bin/env bash

API="https://registry.hub.docker.com/v1/repositories"
DEFAULT_NAME="nginx"
DEFAULT_TIMEOUT=3

function Usage(){
cat << HELP

Usage: docker-tags NAME[:TAG]

docker-tags list all tags for docker image on a remote registry.

Example:
    docker-tags (default nginx)
    docker-tags nginx
    docker-tags nginx:1.15.8
    docker search nginx | docker-tags
    docker search nginx | docker-tags :1.15.8
    echo nginx | docker-tags
    echo nginx | docker-tags :1.15.8
HELP
}

ARG=$1
if [[ "$ARG" =~ "-h" ]];then
    Usage
    exit 0
fi

function ParseJson(){
    tr -d '[\[\]" ]' | tr '}' '\n' | awk -F: -v image=$1 '{if(NR!=NF && $3 != ""){printf("%s:%s\n",image,$3)}}'
}

function GetTags(){
    image=$1
    tag=$2
    ret=`curl -s ${API}/${image}/tags`
    tag_list=`echo $ret | ParseJson ${image}`
    if [ -z "$tag" ];then
        echo -e "$tag_list"
    else
        echo -e "$tag_list" | grep -w "$tag"
    fi
}

if [ -z $ARG ] || [[ ${ARG:0:1} == ":" ]];then
    if [ -x /usr/bin/timeout ];then
        images=`timeout $DEFAULT_TIMEOUT` awk '{print $1}' | grep -v "NAME" || echo $DEFAULT_NAME
    else
        images=`awk '{print $1}' | grep -v "NAME"`
    fi
else
    images=`echo $ARG | awk -F: '{print $1}'`
fi
tag=`echo $ARG | awk -F: '{print $2}'`

for i in ${images}
do
    tags=`GetTags $i $tag`
    count=`echo $tags | wc -w`
    if [[ $count -gt 0 ]];then
        echo -e "IMAGE [$i:$tag]:"
        echo -e "$tags"
        echo
    fi
done
