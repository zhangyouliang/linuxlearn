Gatling
===

Gatling是一款基于Scala 开发的高性能服务器性能测试工具，它主要用于对服务器进行负载等测试，并分析和测量服务器的各种性能指标。目前仅支持http协议，可以用来测试web应用程序和RESTful服务。

除此之外它拥有以下特点：

* 支持Akka Actors 和 Async IO，从而能达到很高的性能
* 支持实时生成Html动态轻量报表，从而使报表更易阅读和进行数据分析
* 支持DSL脚本，从而使测试脚本更易开发与维护
* 支持录制并生成测试脚本，从而可以方便的生成测试脚本
* 支持导入HAR（Http Archive）并生成测试脚本
* 支持Maven，Eclipse，IntelliJ等，以便于开发
* 支持Jenkins，以便于进行持续集成
* 支持插件，从而可以扩展其功能，比如可以扩展对其他协议的支持
* 开源免费



2. 使用
下载解压即可使用：[http://gatling.io/#/download](http://gatling.io/#/download)



参考
===
- [Gatling 基本使用教程](https://xiuxiuing.gitee.io/blog/2018/09/18/gatlinguse/)