#### # ls-files

    # 查看被删除的文件
    git ls-files -d
    # 恢复被删除的多个文件
    git ls-files -d | xargs git checkout --
    # 恢复被修改的文件
    git ls-files -m | xargs git checkout --


