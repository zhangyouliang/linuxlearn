#### # yarn 常用命令

> 修改日期 2017.12.26

> 最初接触 yarn 还是在 0.17.10 版本，由于各种各样的原因，使用时没 npm 顺手, 目前 yarn 的版本已经升级为 1.3.2 各种之前遇到的问题不复存在，安装、下载速度都比 npm 要快很多，这里对之前记录做一下修改。

> 更多详细内容查看[中文官方文档 ](https://yarnpkg.com/zh-Hans/)
> [npm 常用命令](http://blog.csdn.net/mjzhang1993/article/details/78899414)

#### 版本说明 （当前文档使用版本）

- yarn : v0.17.10
- yarn: v1.3.2 (修改日期 2017.12.26)
- node: v8.9.0
- npm: v5.6.0

#### 安装
```
macOS 通过 homebrew 安装 brew install yarn

Windows 下载安装 下载地址

查看版本 `yarn --version`
```

### 1. 开始一个新工程
```
yarn init 与 npm init 一样通过交互式会话创建一个 package.json

yarn init # yarn 
npm init # npm

# 跳过会话，直接通过默认值生成 package.json
yarn init --yes # 简写 -y
npm init -y
```

### 2. 添加一个依赖

> 通过 `yarn add` 添加依赖会更新 package.json 以及 yarn.lock 文件

> yarn add <packageName> 依赖会记录在 package.json 的 dependencies 下

```
yarn add webpack@2.3.3 # yarn  --save 是 yarn 默认的，默认记录在 package.json 中
npm install webpack@2.3.3 --save # npm
yarn add <packageName> --dev 依赖会记录在 package.json 的 devDependencies 下
yarn add webpack --dev # yarn 简写 -D
npm install webpack --save-dev # npm
yarn global add <packageName> 全局安装依赖
yarn global add webpack # yarn
npm install webpack -g # npm
```
### 3. 更新一个依赖

> yarn upgrade 用于更新包到基于规范范围的最新版本

```
yarn upgrade # 升级所有依赖项，不记录在 package.json 中
npm update # npm 可以通过 ‘--save|--save-dev’ 指定升级哪类依赖

yarn upgrade webpack # 升级指定包
npm update webpack --save-dev # npm

yarn upgrade --latest # 忽略版本规则，升级到最新版本，并且更新 package.json
```
### 4. 移除一个依赖
```
yarn remove <packageName>
yarn remove webpack # yarn
npm uninstall webpack --save # npm 可以指定 --save | --save-dev 
```

### 5. 安装 package.json 中的所有文件
```
yarn 或者 yarn install
yarn install # 或者 yarn 在 node_modules 目录安装 package.json 中列出的所有依赖
npm install # npm

# yarn install 安装时，如果 node_modules 中有相应的包则不会重新下载 --force 可以强制重新下载安装
yarn install --force # 强制下载安装
npm install --force # npm
```

### 6. 运行脚本

> yarn run 用来执行在 package.json 中 scripts 属性下定义的脚本

```
// package.json
{
    "scripts": {
        "dev": "node app.js",
        "start": "node app.js"
    }
}
yarn run dev # yarn 执行 dev 对应的脚本 node app.js
npm run # npm

yarn start # yarn
npm start # npm

```

> 与 npm 一样 可以有 yarn start 和 yarn test 两个简写的运行脚本方式

### 7. 显示某个包信息

> yarn info <packageName> 可以用来查看某个模块的最新版本信息

```
yarn info webpack # yarn 
npm info webpack # npm

yarn info webpack --json # 输出 json 格式
npm info webpack  --json # npm

yarn info webpack readme # 输出 README 部分
npm info webpack readme
```
### 8. 列出项目的所有依赖

> yarn list

```
yarn list # 列出当前项目的依赖
npm list # npm

yarn list --depth=0 # 限制依赖的深度
sudo yarn global list # 列出全局安装的模块
```

### 9. 管理 yarn 配置文件

> yarn coinfig

```
yarn config set key value # 设置
npm config set key value

yarn config get key # 读取值
npm config get key

yarn config delete key # 删除
npm config delete key

yarn config list # 显示当前配置
npm config list 

yarn config set registry https://registry.npm.taobao.org # 设置淘宝镜像
npm config set registry https://registry.npm.taobao.org # npm
```

### 10. 缓存

> yarn cache

```
sudo yarn cache list # 列出已缓存的每个包
sudo yarn cache dir # 返回 全局缓存位置
sudo yarn cache clean # 清除缓存
```

### 11. 问题

1. 通过 yarn run 等运行脚本时，会报错
   更新版本后，这个问题不会再出现

```
yarn run run

yarn run v0.17.10
$ webpack-dev-server --progress --colors --config webpack.dev.config.js 
fs.js:640
  return binding.open(pathModule._makeLong(path), stringToFlags(flags), mode);
                 ^

Error: EACCES: permission denied, open '/Users/zhangmingjia/Desktop/document/ceshi/temp/router4-test/node_modules/arr-flatten/index.js'
```
大概意思是没有权限，然后加上 sudo 又试了一下

```
sudo yarn run run

yarn run v0.17.10
$ webpack-dev-server --progress --colors --config webpack.dev.config.js 
 10% building modules 2/2 modules 0 active                                         
Project is running at http://10.15.32.78:8087/
webpack output is served from /Users/zhangmingjia/Desktop/document/ceshi/temp/router4-test/dev
Content not from webpack is served from /Users/zhangmingjia/Desktop/document/ceshi/temp/router4-test/dev
404s will fallback to /index.html
Hash: d374085597660a7a1085                                                              
Version: webpack 2.3.3
Time: 5083ms
              Asset      Size  Chunks                    Chunk Names
       js/vendor.js   1.31 MB       0  [emitted]  [big]  vendor
       js/bundle.js   44.5 kB       1  [emitted]         app
chunk-manifest.json  43 bytes          [emitted]         
     js/manifest.js   5.88 kB       2  [emitted]         manifest
   js/vendor.js.map   1.56 MB       0  [emitted]         vendor
   js/bundle.js.map   43.3 kB       1  [emitted]         app
 js/manifest.js.map    5.9 kB       2  [emitted]         manifest
         index.html   1.28 kB          [emitted]         
Child html-webpack-plugin for "index.html":
         Asset    Size  Chunks  Chunk Names
    index.html  545 kB       0  
webpack: Compiled successfully.
```

看了别人的博客，貌似没有这个问题啊，而且设置的 webpack devServer.open = true, 可以打开浏览器，但是不会跳转到设定好的页面（用 npm 时 没有这个问题）

2. 安装 package.json 中文件的问题
   正常安装 sudo yarn add react@15.4.2 package.json 中 出现

```
"dependencies": {
    "react": "15.4.2"
}
```
通过终端查看安装版本 yarn list

```
    ├─ react@15.4.2
    │  ├─ fbjs@^0.8.4
    │  ├─ loose-envify@^1.1.0
    │  └─ object-assign@^4.1.0
```

是正确的版本，但是，如果在 package.json 中加上如下依赖，然后通过 sudo yarn install 安装
```

"dependencies": {
    "react": "15.4.2",
    "react-dom": "^15.4.2",
    "jquery": "^3.0.0"
}
```
通过终端查看安装版本 yarn list

```
    ├─ react-dom@15.5.3
    │  ├─ fbjs@^0.8.9
    │  ├─ loose-envify@^1.1.0
    │  ├─ object-assign@^4.1.0
    │  └─ prop-types@~15.5.0
    ├─ react@15.4.2
    │  ├─ fbjs@^0.8.4
    │  ├─ loose-envify@^1.1.0
    │  └─ object-assign@^4.1.0
    ├─ jquery@3.2.1
```

react 还是之前的版本，但是 新安装的 react-dom 和 jquery 都变成了 最新版本

再试试将版本号的写法变一下 去掉 ^
```
    "dependencies": {
        "react": "15.4.2",
        "react-dom": "15.4.2",
        "jquery": "3.0.0"
    }
```

通过 sudo yarn install 安装 查看安装版本 yarn list
```
    ├─ react-dom@15.4.2
    │  ├─ fbjs@^0.8.1
    │  ├─ loose-envify@^1.1.0
    │  └─ object-assign@^4.1.0
    ├─ react@15.4.2
    │  ├─ fbjs@^0.8.4
    │  ├─ loose-envify@^1.1.0
    │  └─ object-assign@^4.1.0
    ├─ jquery@3.0.0
```
安装的是正确的版本了

说明
"react-dom": "^15.4.2"这种写法,加了^，是一般是通过npm install --save安装插件生成版本号的默认格式，表示安装15.x.x的最新版本，安装时不改变大版本号

"react-dom": "15.4.2"这种写法,只有版本号，是 yarn add安转后生成版本号的默认格式，表示必须安装同一个版本号

版本号控制，有一个规范，就是语义化版本号控制，规定了版本号格式为：主版本号.次版本号.修订号；

主版本号：当你做了不兼容的 API 修改
次版本号：当你做了向下兼容的功能性新增
修订号：当你做了向下兼容的问题修正
一般来讲 只要主版本号正确，就可以兼容，但是像 最新版的 react@15.5.3 ,出现了React.createClass与React.PropTypes弃用的警告，控制台一片红，因为引用了第三方组件库，最后选择暂不升级react，类似的情况，个人感觉 yarn 默认的版本号写法(只安装特定版本的文件)，更符合需求，npm 的话，很可能导致两个拥有同样package.json 的应用，安装了不同版本的包，进而导致一些BUG

3. 在 yarn 或者 npm 中设置默认版本规则
   npm set save-exact true 全局设置 package.json 只记录确切版本号 node: 1.1.1,
   npm config set save-prefix '~' 设置安装新模块时，package.json 记录版本号的方式 ~ \ ^ 等
   sudo yarn config set save-prefix '~' 通过 yarn 设置，要有 sudo 权限
   注意： 通过以上设置可以更改package.json 中记录的版本号默认方式，但是 yarn 的设置是带有 sudo 权限的，通过 sudo add <packageName> 的模块才会按照设置的方式更新版本号

12. 总结
    就像官网上说的，yarn 的安装速度快，能并行化操作以最大化资源利用率；安全，Yarn会在每个安装包被执行前校验其完整性。正式版的 yarn 比较与 npm 更高效。



### # 参考


http://blog.csdn.net/mjzhang1993/article/details/70092902