众所周知国内我们使用的 Burp Suite 大多数是大佬们分享出来的专业破解版的 Burp Suite，每次启动的时候都得通过加载器来启动 Burp Suite，那有没有更加优雅的方式呢？下面就开始水这一篇文章了，告诉大家如何在 macOS 下配置基本的渗透测试环境。


然后 vmoptions.txt 追加如下内容：

````
-Dfile.encoding=utf-8
-noverify
-javaagent:burp-loader-x-Ai.jar
 -Xmx2048m
````


带着加载器启动一下 BP：

````
/Applications/Burp\ Suite\ Professional.app/Contents/Resources/jre.bundle/Contents/Home/bin/java -Dfile.encoding=utf-8 -noverify -javaagent:/Applications/Burp\ Suite\ Professional.app/Contents/Resources/app/burp-loader-x-Ai.jar -Xmx2048m --illegal-access=permit -jar /Applications/Burp\ Suite\ Professional.app/Contents/Resources/app/burpsuite_pro.jar
````

弹出提升输入 key，启动注册机走一遍注册流程：

````
/Applications/Burp\ Suite\ Professional.app/Contents/Resources/jre.bundle/Contents/Home/bin/java -jar /Applications/Burp\ Suite\ Professional.app/Contents/Resources/app/burp-keygen-scz.jar
````

以后就像正版用户那样直接在「启动台」启动即可。



新的姿势
====

2020 年12月2日 Burpsuite 专业版和企业版已经开放下载了。

历届 BP 版本的官方下载地址：[https://portswigger.net/burp/releases](https://portswigger.net/burp/releases)

所以之后我们破解的思路就是下载官方包正常安装，然后使用注册机激活就可以拉。

下面就使用官方的 2021.7 版本破解激活为例，首先下载官方官方的 DMG 数据包：



官方的 DMG 包正常安装就可以了，安装完打开应该是需要提示秘钥的，这里需要我们使用注册机来破解一下。

注册机的 Github 项目地址：[TrojanAZhen/BurpSuitePro-2.1](https://github.com/TrojanAZhen/BurpSuitePro-2.1)

下载完成后将 burp-keygen-scz.jar 和 burp-loader-x-Ai.jar 放入到 BP 的如下图的目录下：



参考
===
- [macOS 下如何优雅的使用 Burp Suite](https://www.sqlsec.com/2019/11/macbp.html)
