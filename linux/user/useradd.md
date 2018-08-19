> 用户管理命令

> [参考](https://linuxtools-rst.readthedocs.io/zh_CN/latest/base/08_user_manage.html)

用户
---

添加用户
    
    useradd -m username
    该命令为用户创建相应的帐号和用户目录/home/username；

用户添加之后，设置密码： 密码以交互方式创建:

    $passwd username 
    

删除用户

    $userdel -r username
    
不带选项使用 userdel，只会删除用户。用户的家目录将仍会在/home目录下。要完全的删除用户信息，使用 `-r` 选项；

帐号切换 登录帐号为userA用户状态下，切换到userB用户帐号工作:

    $su userB

进入交互模型，输入密码授权进入；

用户的组
----

将用户加入到组中

默认情况下，添加用户操作也会相应的增加一个同名的组，用户属于同名组； 查看当前用户所属的组:

    $groups
    
一个用户可以属于多个组，将用户加入到组:

    $usermod -G groupNmame username
    
变更用户所属的根组(将用加入到新的组，并从原有的组中除去）:

    $usermod -g groupName username
    
查看系统所有组

系统的所有用户及所有组信息分别记录在两个文件中：`/etc/passwd` , `/etc/group` 默认情况下这两个文件对所有用户可读：

查看所有用户及权限:

    $more /etc/passwd
    
查看所有的用户组及权限:

    $more /etc/group