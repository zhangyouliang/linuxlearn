Linux 环境变量
===

一. 系统环境变量
---
- /etc/environment 系统在登录时读取的第一个文件，该文件设置的是整个系统的环境，只要启动系统就会读取该文件，用于为所有进程设置环境变量。
- /etc/profile  系统登录时,指定的第二个文件,这个文件预设了几个重要的变量，并从`/etc/profile.d`目录的配置文件中搜集shell的设置。例如PATH, USER, LOGNAME, MAIL, INPUTRC, HOSTNAME, HISTSIZE, umask等等。
- /etc/bash.bashrc   每次打开shell时执行一次, 这个文件主要预设umask以及PS1。这个PS1就是我们在敲命令时，前面那串字符了，例如 `[root@localhost ~]#`


二. 用户环境变量
---
- ~/.profile 对应当前登录用户的profile文件，用于定制当前用户的个人工作环境(变量是永久性)，每个用户都可使用该文件输入专用于自己使用的shell信息,当用户登录时,该文件仅仅执行一次! 默认情况下,他设置一些环境变量,执行用户的.bashrc文件 (**这里是推荐放置个人设置的地方**)
- .bashrc 该文件包含专用于你的bash shell的bash信息，当登录时以及每次打开新的shell时，该文件被读取。(`~/.bashrc`只针对当前用户，变量的生命周期是永久的) **不推荐放到这儿，因为每开一个shell，这个文件会读取一次，效率肯定有影响。**
- `~/.bash_profile or ~./bash_login` 当用户登录时，该文件仅仅执行一次。默认情况下，他设置一些环境变量，执行用户的.bashrc文件。`~/.bash_profile`是交互式login 方式进入 bash 运行的，~/.bashrc 是交互式 non-login 方式进入 bash 运行的通常二者设置大致相同，所以通常前者会调用后者。 如果~/目录下没有.bash_profile则新建立一个）**这里是推荐放置个人设置的地方**  当一个shell关闭时，在bash_profile中定义的系统变量则会失效。因此，每打开一个新的shell时都要运行一次 `source ~/.bash_profile`.而且针对当前用户。
- .bash_history  记录命令历史用的
- .bash_logout 当退出shell时，会执行该文件。可以把一些清理的工作放到这个文件中 


执行顺序:  `~/.bash_profile -> ~/.bash_login -> ~/.profile`
 
如果 `~/.bash_profile`文件存在的话，一般还会执行 `~/.bashrc`文件。

执行顺序为： `/etc/profile -> (~/.bash_profile | ~/.bash_login | ~/.profile) -> ~/.bashrc -> /etc/bashrc -> ~/.bash_logout`


### # /etc/profile 和 /etc/environment 等各种环境变量设置文件的用处

- 1）先将`export LANG=zh_CN`加入`/etc/profile`，退出系统重新登录，登录提示显示英文。

- 2）先将`/etc/profile` 中的`export LANG=zh_CN`删除，将LNAG=zh_CN加入`/etc/environment`，退出系统重新登录，登录提示显示中文。

用户环境建立的过程中总是先执行`/etc/profile`，然后再读取`/etc/environment`。

**为什么会有如上所叙的不同呢？而不是先执行/etc/environment，后执行/etc/profile呢？**

这是因为： `/etc/environment`是设置整个系统的环境，而`/etc/profile`是设置所有用户的环境，前者与登录用户无关，后者与登录用户有关。

系统应用程序的执行与用户环境可以是无关的，但与系统环境是相关的，所以当你登录时，你看到的提示信息，如日期、时间信息的显示格式与系统环境的LANG是相关的，缺省LANG=en_US，如果系统环境LANG=zh_CN，则提示信息是中文的，否则是英文的。

对于用户的shell初始化而言是先执行`/etc/profile`，再读取文件`/etc/environment`；对整个系统而言是先执行`/etc/environment`。这样理解正确吗？

1.登陆系统时的顺序应该是：

- `/etc/enviroment --> /etc/profile -->HOME/.profile−−>HOME/.env` (如果存在)
- `/etc/profile` 是所有用户的环境变量
- `/etc/enviroment`是系统的环境变量

2.登陆系统时shell读取的顺序应该是：

- `/etc/profile ->/etc/enviroment -->HOME/.profile−−>HOME/.env`

原因应该是用户环境和系统环境的区别了，如果同一个变量在用户环境(`/etc/profile`)和系统环境(`/etc/environment`)有不同的值，那应该是以用户环境为准了。



参考
====
- [linux中环境变量和系统加载环境变量的顺序](https://www.cnblogs.com/tiandi/p/11317083.html)
- [Linux 常用环境变量及作用和环境变量文件的详细介绍及其加载执行顺序](https://blog.csdn.net/u010533843/article/details/54986646)
