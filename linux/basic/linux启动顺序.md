文件初始化流程
````
1. 通过/boot/vm进行启动 vmlinuz
2. init /etc/inittab
3. 启动相关脚本
rcx.d # 例如 rc0.d/     rc1.d/     rc2.d/     rc3.d/     rc4.d/     rc5.d/     rc6.d/     rc.local*  rcS.d/
rc.local
4. 启动 login 登录页面
5. 用户登录时执行 sh 脚本的顺序,每次登陆的时候都会完全执行的
/etc/profile
/etc/profile.d/xxx 文件 # 例如: 01-locale-fix.sh       bash_completion.sh   
/etc/bashrc
~/.bashrc
~/.bash_profile
````
