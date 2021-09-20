#!/usr/bin/env bash



# 变量定义

var=1
# 常量
declare -r var # readonly var
#var=2
echo ${var}

# 整数
declare -i number=1
number=aaaaa
echo ${number} # 0

# 数组
indices=(1 2 3 4 5 "aaa bbbb")
declare -a indices
echo ${indices[@]} # 数组全部元素
echo ${indices[*]} # 数组全部元素
echo ${#indices[@]} # 数组长度
echo ${indices[@]:1:2} # 数组分片访问
unset ${indices[1]} # 删除下标为1的元素
echo ${indices[@]} # 数组全部元素
echo ${!indices[@]} # 获取全部下标
echo '## 数组遍历'
for i in "${!indices[@]}";do
    echo "$i : ${indices[$i]}"
done
echo '## 数组遍历'
# 为啥加双引号,不存在空格时 @ 和 * 都没问题
# 一旦出现空格,将导致不可预料的问题
for i in "${indices[@]}";do
    echo ${i}
done
echo '## 数组遍历 - 元素带有空格,且不使用 " 包裹数组,循环'
for i in ${indices[@]};do
    echo ${i}
done

function test() {
    echo "test"
}
function test2() {
    echo "test2"
}


echo '## 列出当前全部函数'
declare -f
echo '## 列出test函数'
declare -f test

# 导出函数
declare -x var2=100

exit 0
