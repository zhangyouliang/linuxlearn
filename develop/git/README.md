#### # ls-files


```shell script

# 查看被删除的文件
git ls-files -d
# 恢复被删除的多个文件
git ls-files -d | xargs git checkout --
# 恢复被修改的文件
git ls-files -m | xargs git checkout --

# git HEAD 的 hash
git rev-parse HEAD


# worktree
# 当需要在同一个仓库兼顾两个或者多个分支的开发时，可以为每一个分支新建一个 worktree
# 他们彼此之间不会相互影响，其表现相当于在一个其他的目录重新 git clone 了一把这个 git 仓库

# 实践步骤
git branch br1
git worktree add ../br1 br1 # 将分支导出到某新文件夹下, 此处为br1文件夹
# 查看 list
git worktree list
# 移除
git worktree remove br1
```


标签

```shell script
# 列出标签
git tag -l "v1.2.*"
# 新建tag
git tag v1.2.2
git tag -a v1.2.2 -m "发布代码"
# 给指定 commit 添加 tag
git tag -a v1.2.2 9fceb02 -m "发布代码"
# 查看 ref
git show-ref --tag
# 查看 tag 详细信息
git show tagName

# tag 切换
git checkout v1.2.1
# 删除
git tag -d v0.0.1



# 同步到服务器
git push origin v0.0.1
# 全部 tag
git push origin --tags

# 远端删除
git push origin :refs/tags/v0.0.1
```


    
### 参考

- [git 中文文档](https://www.wenjiangs.com/doc/git-update-server-info) 
    
