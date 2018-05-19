> locate/slocate :  命令都用来查找文件或目录。


locate命令其实是`find -name `的另一种写法，但是要比后者快得多，原因在于它不搜索具体目录，而是搜索一个数据库`/var/lib/locatedb`，这个数据库中含有本地所有文件信息。Linux系统自动创建这个数据库，并且每天自动更新一次，所以使用`locate`命令查不到最新变动过的文件。为了避免这种情况，可以在使用 `locate`之前，先使用 `updatedb`命令，手动更新数据库。

```
locate ~/m
# 忽略大小写
locate -i ~/m
# 更新数据库信息
updatedb
```

