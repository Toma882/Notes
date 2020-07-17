## 名词解释

### AMD
Asynchronous Module Definition 异步模块定义是社区方案的模块规范，异步加载模块，允许指定回调函数，在回调函数中执行操作


### CommonJS
CommonJS 是社区方案的模块规范，加载模块是同步的，只有加载完成，才能执行后面的操作。

* 所有代码都运行在模块作用域，不会污染全局作用域。
* 模块可以多次加载，但是只会在第一次加载时运行一次，然后运行结果就被缓存了，以后再加载，就直接读取缓存结果。要想让模块再次运行，必须清除缓存。
* 模块加载的顺序，按照其在代码中出现的顺序。

**Node** 应用由模块组成，采用 CommonJS 模块规范，无法直接兼容 ES6。所以现阶段 `require/exports` 仍然是必要且实必须的。


### ES6（ES2015）
* 模块自动运行在`strict`严格模式下
* 在模块的顶级作用域创建的变量，不会被自动添加到共享的全局作用域，它们只会在模块顶级作用域的内部存在；
* 模块顶级作用域的 `this` 值为 `undefined`
* 对于需要让模块外部代码访问的内容，模块必须导出它们

## ES6 模块与 CommonJS 模块的差异
* CommonJS 模块输出的是一个值的拷贝，ES6 模块输出的是值的引用。
* CommonJS 模块是运行时加载，ES6 模块是编译时输出接口。

## require / exports
属于 CommonJS 规范

### require / exports 的写法
```js
const fs = require('fs')
exports.fs = fs
module.exports = fs
```

### 运行时加载

```js
// CommonJS模块
let { stat, exists, readFile } = require('fs');

// 等同于
let _fs = require('fs');
let stat = _fs.stat;
let exists = _fs.exists;
let readfile = _fs.readfile;

// 整体加载fs模块（即加载fs所有方法），
// 生成一个对象"_fs"，然后再从这个对象上读取三个方法，
// 这叫“运行时加载”
```


### 浅拷贝
输入的是被输出的值的拷贝。一旦输出一个值，模块内部的变化就影响不到这个值。请看下面这个例子。

```js
# lib.js
var counter = 3;
function incCounter() {
  counter++;
}
module.exports = {
  counter: counter,
  incCounter: incCounter,
};
```

```js
// main.js
var counter = require('./lib').counter;
var incCounter = require('./lib').incCounter;

console.log(counter);  // 3
incCounter();
console.log(counter); // 3
```

### `exports` 命令
每个模块内部，`module` 变量代表当前模块。这个变量是一个对象，它的 `exports` 属性（即`module.exports`）是对外的接口。加载某个模块，其实是加载该模块的 `module.exports` 属性。





### `require` 命令
`require` 命令的基本功能是，读入并执行一个JavaScript文件，然后返回该模块的`exports`对象。如果没有发现指定模块，会报错。

如果想在多个文件分享变量，必须定义为`global`对象的属性

## `import` / `export`
属于 ES6 正式规范
### `import` / `export` 的写法
```js
import fs from 'fs'
import {default as fs} from 'fs'
import * as fs from 'fs'
import {readFile} from 'fs'
import {readFile as read} from 'fs'
import fs, {readFile} from 'fs'

export default fs
export const fs
export function readFile
export {readFile, read}
export * from 'fs'
```

### `babel`

由于有了 `babel` 将还未被宿主环境（各浏览器、Node.js）直接支持的 `ES6 Module` 编译为 `ES5` 的 `CommonJS` —— 也就是 `require/exports` 这种写法 —— Webpack 插上 `babel-loader` 这个翅膀才开始高飞，大家也才可以称 " 我在使用 `ES6`！ "

这也就是为什么前面说 `require/exports` 是必要且必须的。因为事实是，目前你编写的 `import/export` 最终都是编译为 `require/exports` 来执行的。


### 强绑定
ES6 Module 中导入模块的属性或者方法是强绑定的，包括基础类型；而 CommonJS 则是普通的值传递或者引用传递。

```js
// counter.js
exports.count = 0
setTimeout(function () {
  console.log('increase count to', ++exports.count, 'in counter.js after 500ms')
}, 500)

// commonjs.js
const {count} = require('./counter')
setTimeout(function () {
  console.log('read count after 1000ms in commonjs is', count)
}, 1000)

//es6.js
import {count} from './counter'
setTimeout(function () {
  console.log('read count after 1000ms in es6 is', count)
}, 1000)

// 分别运行 commonjs.js 和 es6.js：

➜  test node commonjs.js
increase count to 1 in counter.js after 500ms
read count after 1000ms in commonjs is 0
➜  test babel-node es6.js
increase count to 1 in counter.js after 500ms
read count after 1000ms in es6 is 1
```

### `export` 命令
块是独立的文件，该文件内部的所有的变量外部都无法获取。如果希望获取某个变量，必须通过 `export` 输出

```js
// profile.js
export var firstName = 'Michael';
export var lastName = 'Jackson';
export var year = 1958;

// 或者用更好的方式：用大括号指定要输出的一组变量
// profile.js
var firstName = 'Michael';
var lastName = 'Jackson';
var year = 1958;

export {firstName, lastName, year};

// 除了输出变量，还可以输出函数或者类（class）
export function multiply(x, y) {
  return x * y;
};

// 还可以批量输出，同样是要包含在大括号里，也可以用as重命名
function v1() { ... }
function v2() { ... }

export {
  v1 as streamV1,
  v2 as streamV2,
  v2 as streamLatestVersion
};

// export 命令规定的是对外接口
// 必须与模块内部变量建立一一对应的关系
// 写法一
export var m = 1;
// 写法二
var m = 1;
export {m};
// 写法三
var n = 1;
export {n as m};
// 报错 直接输出1
export 1;
// 报错 虽然有变量m，但还是直接输出1，导致无法解构
var m = 1;
export m;

// 和其对应的值是动态绑定的关系，即通过该接口取到的都是模块内部实时的值。
// 报错 
function f() {}
export f;
// 正确
export function f() {};
// 正确
function f() {}
export {f};

// export模块可以位于模块中的任何位置，但是必须是在模块顶层，如果在其他作用域内，会报错。
function foo() {
  export default 'bar' // SyntaxError
}
foo()

```

`export default` 默认导出

```js
// 用户可能不想阅读源码，只想直接使用接口，
// 就可以用export default命令，为模块指定输出
// export-default.js
export default function () {
  console.log('foo');
}

// 其他模块加载该模块时，import命令可以为该匿名函数指定任意名字。

// import-default.js
import customName from './export-default';
customName(); // 'foo'

// 注意原来应该是 import {customName} from './export-default';

```

### import 命令
重新给导入的变量一个名字，可以用`as`关键字

```js
// ES6模块不是对象，而是通过export命令显示指定输出代码，
// 再通过import输入

import { stat as xx, exists, readFile } from 'fs';

// 从fs加载“stat, exists, readFile” 三个方法
// 其他方法不加载
```

### import()函数

`import()` 返回一个 `Promise` 对象

**按需加载**

只有用户点击了按钮，才会加载这个模块

```js
button.addEventListener('click', event => {
  import('./dialogBox.js')
  .then(dialogBox => {
    dialogBox.open();
  })
  .catch(error => {
    /* Error handling */
  })
});
```


**条件加载：**

`import()`可以放在`if...else`语句中，实现条件加载。

```js
if (condition) {
  import('moduleA').then(...);
} else {
  import('moduleB').then(...);
}
```