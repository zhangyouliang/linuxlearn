> getopts: 命令选项

命令参数
---


案例
---
```bash
# 简单例子
echo $*
while getopts ":a:bc:" opt
do
    case $opt in
    a)
    echo $OPTARG $OPTIND;;
    b)
    echo "b $OPTIND";;
    c)
    echo "c $OPTIND";;
    ?)
    echo "error"
    exit 1;;
    esac
done

# ./test.sh -a 111 -b -c 5
```



