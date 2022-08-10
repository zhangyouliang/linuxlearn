npm	| yarn
---|---
npm install	|yarn install
(N/A)|	yarn install --flat
(N/A)|  yarn install --har
(N/A)|	yarn install --no-lockfile
(N/A)|	yarn install --pure-lockfile
npm install [package] |	(N/A)
npm install --save [package]|	yarn add [package]
npm install --save-dev [package]|	yarn add [package] [--dev/-D]
(N/A)	|yarn add [package] [--peer/-P]
npm install --save-optional [package]|	yarn add [package] [--optional/-O]
npm install --save-exact [package]|	yarn add [package] [--exact/-E]
(N/A)	| yarn add [package] [--tilde/-T]
npm install --global [package] | 	yarn global add [package]
npm rebuild	 | yarn install --force
npm uninstall [package]	| (N/A)
npm uninstall --save [package] |	yarn remove [package]
npm uninstall --save-dev [package]	| yarn remove [package]
npm uninstall --save-optional [package]	| yarn remove [package]
npm cache clean	| yarn cache clean
rm -rf node_modules && npm install |	yarn upgrade


## yarn 基本用法

```
## 创建一个新的工程
yarn init 

## 添加一个依赖
yarn add webpack@2.3.3

yarn add webpack --dev

yarn global webpack

yarn upgrade

yarn remove webpack

## 安装 package.json 中的全部文件

yarn 或者 yarn install

## 运行脚本
yarn run xxx
```

## npm 部分好用的命令

````
# 查看全局包的安装目录
npm root -g           
#  查看全局安装过的包
npm list -g --depth 0 
# 安装包名
npm install -g 包名 
# 或者 
npm install 包名 -g
# 查看缓存目录
npm config get cache
````
