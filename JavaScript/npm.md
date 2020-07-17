# npm

> nmp [[package manager for JavaScript](https://www.npmjs.com/)]
>
> cnpm[ [Company npm](https://cnpmjs.org/) ]For developers in China, please visit the [China mirror](https://npm.taobao.org/)

## npm registry

npm 模块仓库提供了一个查询服务，叫做 `registry` 。

以 npmjs.org 为例，它的查询服务网址是 `https://registry.npmjs.org/`

### 模块名
这个网址后面跟上模块名，就会得到一个 JSON 对象，里面是该模块所有版本的信息。比如，访问 `https://registry.npmjs.org/react`，就会看到 `react` 模块所有版本的信息

```sh
$ npm view react

# npm view 的别名
$ npm info react
$ npm show react
$ npm v react
```

### 模块名+版本号
registry 网址的模块名后面，还可以跟上版本号或者标签，用来查询某个具体版本的信息。比如， 访问 `https://registry.npmjs.org/react/v0.14.6` ，就可以看到 `React` 的 `0.14.6` 版。
返回的 JSON 对象里面，有一个dist.tarball属性，是该版本压缩包的网址。

```json
dist: {
  shasum: '2a57c2cf8747b483759ad8de0fa47fb0c5cf5c6a',
  tarball: 'http://registry.npmjs.org/react/-/react-0.14.6.tgz' 
},
```
到这个网址下载压缩包，在本地解压，就得到了模块的源码。`npm install`和`npm update`命令，都是通过这种方式安装模块的。

## cnpm

使用国内镜像时候，用 `cnpm` 命令 代替 `npm`

你可以使用我们定制的 cnpm (gzip 压缩支持) 命令行工具代替默认的 npm:

```sh
$ npm install -g cnpm --registry=https://registry.npm.taobao.org
```

或者你直接通过添加 npm 参数 alias 一个新命令:

```sh
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"

# Or alias it in .bashrc or .zshrc
$ echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"' >> ~/.zshrc && source ~/.zshrc
```
也可以直接设置

```sh
npm config set registry https://registry.npm.taobao.org/
```


## npm use

### 缓存

```sh
# 可以查看当前的目录设置
$ npm config ls -l

# 针对某一项设置，可以通过
$ npm config set 属性名 属性值
# npm config set prefix "C:\123\"

# 读取某一项配置
$ npm config get prefix
```

```sh
# 清理缓存
# npm install或npm update命令，从 registry 下载压缩包之后，都存放在本地的缓存目录
# 在 Linux 或 Mac 默认是用户主目录下的.npm目录
$ npm cache clean
# 查看这个目录的具体位置
$ npm config get cache
# 浏览一下这个目录
$ ls ~/.npm 
# 或者
$ npm cache ls
# 会看到里面存放着大量的模块，储存结构是{cache}/{name}/{version}
$ npm cache ls react
~/.npm/react/react/0.14.6/
~/.npm/react/react/0.14.6/package.tgz
~/.npm/react/react/0.14.6/package/
~/.npm/react/react/0.14.6/package/package.json
# 每个模块的每个版本，都有一个自己的子目录，里面是代码的压缩包package.tgz文件，
# 以及一个描述文件package/package.json
```

### 模块安装与卸载
Node模块的安装过程

1. 发出`npm install`命令
1. `npm` 向 `registry` 查询模块压缩包的网址
1. 下载压缩包，存放在`~/.npm`目录
1. 解压压缩包到当前项目的`node_modules`目录


```sh
# 安装模块
$ npm install <packageName>
$ npm install <packageName>@1.1.1   #安装1.1.1版本的xxx
$ npm install <packageName> -g #将模块安装到全局环境中。
# 如果你希望，一个模块不管是否安装过，npm 都要强制重新安装，可以使用-f或--force参数。
$ npm install <packageName> --force

# 卸载模块
# -S, --save: Package will be removed from your dependencies.
# -D, --save-dev: Package will be removed from your devDependencies.
# -O, --save-optional: Package will be removed from your optionalDependencies.
# --no-save: Package will not be removed from your package.json file.
$ npm uninstall <packageName>  (-g) (-S/-D/-O) 
```

```sh
# 查看安装的模块及依赖
$ npm ls 
$ npm ls -g #查看全局

# 检查包是否已经过时，此命令会列出所有已经过时的包，可以及时进行包的更新
$ npm outdated
# 用于更改包内容后进行重建
$ npm rebuild <packageName>
# 更新node模块
$ npm update <packageName>
# 查看包的依赖关系
$ npm view moudleName dependencies
# 查看node模块的package.json文件夹
$ npm view <packageName>s
# 查看package.json文件夹下某个标签的内容
$ npm view <packageName> labelName
# 查看包的源文件地址
$ npm view <packageName> repository.url
# 查看包所依赖的Node的版本
$ npm view <packageName> engines



# 查看帮助
$ npm help xxx
# 查看npm使用的所有文件夹
$ npm help folders
```


## npm scripts
npm 允许在`package.json`文件里面，使用`scripts`字段定义脚本命令。

```js
{
  // ...
  "scripts": {
    "build": "node build.js"
  }
}
```

上面代码是`package.json`文件的一个片段，里面的`scripts`字段是一个对象。它的每一个属性，对应一段脚本。比如，`build`命令对应的脚本是`node build.js`。
命令行下使用`npm run`命令，就可以执行这段脚本。

```sh
$ npm run build
# 等同于执行
$ node build.js
```

这些定义在`package.json`里面的脚本，就称为 npm 脚本。它的优点很多。

* 项目的相关脚本，可以集中在一个地方。
* 不同项目的脚本命令，只要功能相同，就可以有同样的对外接口。用户不需要知道怎么测试你的项目，只要运行`npm run test`即可。
* 可以利用 npm 提供的很多辅助功能。

查看当前项目的所有 npm 脚本命令，可以使用不带任何参数的`npm run`命令

```
npm run
```

### 原理

npm 脚本的原理非常简单。每当执行`npm run`，就会自动新建一个 `Shell`，在这个 `Shell` 里面执行指定的脚本命令。因此，只要是 `Shell（一般是 Bash）`可以运行的命令，就可以写在 npm 脚本里面。

比较特别的是，`npm run`新建的这个 `Shell`，会将当前目录的n`ode_modules/.bin`子目录加入`PATH`变量，执行结束后，再将`PATH`变量恢复原样。

这意味着，当前目录的`node_modules/.bin`子目录里面的所有脚本，都可以直接用脚本名调用，而不必加上路径。比如，当前项目的依赖里面有 `Mocha`，只要直接写`mocha test`就可以了。

```js
//"test": "./node_modules/.bin/mocha test"
"test": "mocha test"
```

由于 npm 脚本的唯一要求就是可以在 `Shell` 执行，因此它不一定是 `Node` 脚本，任何可执行文件都可以写在里面。
npm 脚本的退出码，也遵守 `Shell` 脚本规则。如果退出码不是`0`，npm 就认为这个脚本执行失败。


### 通配符

由于 npm 脚本就是 Shell 脚本，因为可以使用 Shell 通配符。

```sh
"lint": "jshint *.js"
"lint": "jshint **/*.js"
```

上面代码中，`*`表示任意文件名，`**`表示任意一层子目录。
如果要将通配符传入原始命令，防止被 `Shell` 转义，要将星号转义

```sh
"test": "tap test/\*.js"
```

## 传参

向 npm 脚本传入参数，要使用`--`标明。

```sh
"lint": "jshint **.js"
```

向上面的`npm run lint`命令传入参数，必须写成下面这样。

```sh
$ npm run lint --  --reporter checkstyle > checkstyle.xml
```

也可以在`package.json`里面再封装一个命令。

```sh
"lint": "jshint **.js",
"lint:checkstyle": "npm run lint -- --reporter checkstyle > checkstyle.xml"
```

### 执行顺序

如果 npm 脚本里面需要执行多个任务，那么需要明确它们的执行顺序。
如果是并行执行（即同时的平行执行），可以使用`&`符号。

```sh
$ npm run script1.js & npm run script2.js
```

如果是继发执行（即只有前一个任务成功，才执行下一个任务），可以使用`&&`符号。

```sh
$ npm run script1.js && npm run script2.js`
```

这两个符号是 `Bash` 的功能。此外，还可以使用 node 的任务管理模块：[script-runner](https://github.com/paulpflug/script-runner)、[npm-run-all](https://github.com/mysticatea/npm-run-all)、[redrun](https://github.com/coderaiser/redrun)


### 默认值

一般来说，npm 脚本由用户提供。但是，npm 对两个脚本提供了默认值。也就是说，这两个脚本不用定义，就可以直接使用。

```sh
"start": "node server.js"，
"install": "node-gyp rebuild"
```

上面代码中，`npm run start`的默认值是`node server.js`，前提是项目根目录下有`server.js`这个脚本；`npm run install`的默认值是`node-gyp rebuild`，前提是项目根目录下有`binding.gyp`文件。

## 钩子
npm 脚本有`pre`和`post`两个钩子。举例来说，`build`脚本命令的钩子就是`prebuild`和`postbuild`。

```sh
"prebuild": "echo I run before the build script",
"build": "cross-env NODE_ENV=production webpack",
"postbuild": "echo I run after the build script"
```

用户执行`npm run build`的时候，会自动按照下面的顺序执行。

```sh
npm run prebuild && npm run build && npm run postbuild
```

因此，可以在这两个钩子里面，完成一些准备工作和清理工作。下面是一个例子。

```sh
"clean": "rimraf ./dist && mkdir dist",
"prebuild": "npm run clean",
"build": "cross-env NODE_ENV=production webpack"
```

npm 默认提供下面这些钩子

```sh
prepublish，postpublish
preinstall，postinstall
preuninstall，postuninstall
preversion，postversion
pretest，posttest
prestop，poststop
prestart，poststart
prerestart，postrestart
```

自定义的脚本命令也可以加上`pre`和`post`钩子。比如，`myscript`这个脚本命令，也有`premyscript`和`postmyscript`钩子。不过，双重的`pre`和`post`无效，比如`prepretest`和`postposttest`是无效的。

npm 提供一个`npm_lifecycle_event`变量，返回当前正在运行的脚本名称，比如`pretest、test、posttest`等等。所以，可以利用这个变量，在同一个脚本文件里面，为不同的npm scripts命令编写代码。请看下面的例子。

```sh
const TARGET = process.env.npm_lifecycle_event;

if (TARGET === 'test') {
  console.log(`Running the test task!`);
}

if (TARGET === 'pretest') {
  console.log(`Running the pretest task!`);
}

if (TARGET === 'posttest') {
  console.log(`Running the posttest task!`);
}
```

注意，`prepublish`这个钩子不仅会在`npm publish`命令之前运行，还会在`npm install`（不带任何参数）命令之前运行。这种行为很容易让用户感到困惑，所以 `npm 4` 引入了一个新的钩子`prepare`，行为等同于`prepublish`，而从 `npm 5` 开始，`prepublish`将只在`npm publish`命令之前运行。

### 简写形式

四个常用的 npm 脚本有简写形式。

```sh
npm start是npm run start
npm stop是npm run stop的简写
npm test是npm run test的简写
npm restart是npm run stop && npm run restart && npm run start的简写
```

`npm start、npm stop和npm restart`都比较好理解，而`npm restart`是一个复合命令，实际上会执行三个脚本命令：`stop、restart、start`。具体的执行顺序如下。

```sh
prerestart
prestop
stop
poststop
restart
prestart
start
poststart
postrestart
```

### 变量

npm 脚本有一个非常强大的功能，就是可以使用 npm 的内部变量。
首先，通过`npm_package_前缀`，npm 脚本可以拿到`package.json`里面的字段。比如，下面是一个`package.json`

```sh
{
  "name": "foo", 
  "version": "1.2.5",
  "scripts": {
    "view": "node view.js"
  }
}
```

那么，变量`npm_package_name`返回`foo`，变量`npm_package_version`返回`1.2.5`

```js
// view.js
console.log(process.env.npm_package_name); // foo
console.log(process.env.npm_package_version); // 1.2.5
```

上面代码中，我们通过环境变量`process.env`对象，拿到`package.json`的字段值。如果是 Bash 脚本，可以用`$npm_package_name`和`$npm_package_version`取到这两个值。

`npm_package_前缀`也支持嵌套的`package.json`字段。

```sh
"repository": {
    "type": "git",
    "url": "xxx"
  },
  scripts: {
    "view": "echo $npm_package_repository_type"
  }
```

上面代码中，`repository`字段的`type`属性，可以通过`npm_package_repository_type`取到。

下面是另外一个例子。

```sh
"scripts": {
  "install": "foo.js"
}
```

上面代码中，`npm_package_scripts_install`变量的值等于`foo.js`。
然后，npm 脚本还可以通过`npm_config_前缀`，拿到 npm 的配置变量，即`npm config get xxx`命令返回的值。比如，当前模块的发行标签，可以通过`npm_config_tag`取到。

```sh
"view": "echo $npm_config_tag",
```

注意，package.json里面的config对象，可以被环境变量覆盖。

```sh
{ 
  "name" : "foo",
  "config" : { "port" : "8080" },
  "scripts" : { "start" : "node server.js" }
}
```

上面代码中，`npm_package_config_port`变量返回的是`8080`。这个值可以用下面的方法覆盖。

```sh
$ npm config set foo:port 80
```

最后，env命令可以列出所有环境变量。

```sh
"env": "env"
```

### 常用脚本示例

```sh
// 删除目录
"clean": "rimraf dist/*",

// 本地搭建一个 HTTP 服务
"serve": "http-server -p 9090 dist/",

// 打开浏览器
"open:dev": "opener http://localhost:9090",

// 实时刷新
"livereload": "live-reload --port 9091 dist/",

// 构建 HTML 文件
"build:html": "jade index.jade > dist/index.html",

// 只要 CSS 文件有变动，就重新执行构建
"watch:css": "watch 'npm run build:css' assets/styles/",

// 只要 HTML 文件有变动，就重新执行构建
"watch:html": "watch 'npm run build:html' assets/html",

// 部署到 Amazon S3
"deploy:prod": "s3-cli sync ./dist/ s3://example-com/prod-site/",

// 构建 favicon
"build:favicon": "node scripts/favicon.js",
```

## 参考
* [npm scripts 使用指南](http://www.ruanyifeng.com/blog/2016/10/npm_scripts.html)
* [npm 模块安装机制简介](http://www.ruanyifeng.com/blog/2016/01/npm-install.html)