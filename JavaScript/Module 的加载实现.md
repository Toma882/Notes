> ECMAScript 6

## 浏览器加载


### 传统方法
默认情况下，浏览器是同步加载 JavaScript 脚本，即渲染引擎遇到`<script>`标签就会停下来，等到执行完脚本，再继续向下渲染。如果是外部脚本，还必须加入脚本下载的时间。

如果脚本体积很大，下载和执行的时间就会很长，因此造成浏览器堵塞，用户会感觉到浏览器“卡死”了，没有任何响应。这显然是很不好的体验，所以浏览器允许脚本异步加载，下面就是两种异步加载的语法。

```js
<script src="path/to/myModule.js" defer></script>
<script src="path/to/myModule.js" async></script>
```

`defer`与`async`的区别是：`defer`要等到整个页面在内存中正常渲染结束（DOM 结构完全生成，以及其他脚本执行完成），才会执行；`async`一旦下载完，渲染引擎就会中断渲染，执行这个脚本以后，再继续渲染。一句话，`defer`是“渲染完再执行”，`async`是“下载完就执行”。另外，如果有多个`defer`脚本，会按照它们在页面出现的顺序加载，而多个`async`脚本是不能保证加载顺序的。

### 加载规则

浏览器加载 ES6 模块，也使用`<script>`标签，但是要加入`type="module"`属性。

```js
<script type="module" src="./foo.js"></script>
```
上面代码在网页中插入一个模块`foo.js`，由于`type`属性设为`module`，所以浏览器知道这是一个 ES6 模块。

浏览器对于带有`type="module"`的`<script>`，都是异步加载，不会造成堵塞浏览器，即等到整个页面渲染完，再执行模块脚本，等同于打开了`<script>`标签的`defer`属性。

```js
<script type="module" src="./foo.js"></script>
<!-- 等同于 -->
<script type="module" src="./foo.js" defer></script>
```

如果网页有多个`<script type="module">`，它们会按照在页面出现的顺序依次执行。

`<script>`标签的`async`属性也可以打开，这时只要加载完成，渲染引擎就会中断渲染立即执行。执行完成后，再恢复渲染。

```js
<script type="module" src="./foo.js" async></script>
```

ES6 模块也允许内嵌在网页中，语法行为与加载外部脚本完全一致。

```js
<script type="module">
  import utils from "./utils.js";

  // other code
</script>
```

利用顶层的`this`等于`undefined`这个语法点，可以侦测当前代码是否在 ES6 模块之中。

```js
const isNotModuleScript = this !== undefined;
```


## ES6 模块与 CommonJS 模块的差异

* CommonJS 模块输出的是一个值的拷贝，ES6 模块输出的是值的引用。
* CommonJS 模块是运行时加载，ES6 模块是编译时输出接口。


## Node 加载

Node 要求 ES6 模块采用`.mjs`后缀文件名。也就是说，只要脚本文件里面使用`import`或者`export`命令，那么就必须采用`.mjs`后缀名。`require`命令不能加载`.mjs`文件，会报错，只有`import`命令才可以加载`.mjs`文件。反过来，`.mjs`文件里面也不能使用`require`命令，必须使用`import`。

目前，这项功能还在试验阶段。安装 Node v8.5.0 或以上版本，要用`--experimental-modules`参数才能打开该功能。

```js
node --experimental-modules my-app.mjs
```

为了与浏览器的`import`加载规则相同，Node 的`.mjs`文件支持 URL 路径。

```js
import './foo?query=1'; // 加载 ./foo 传入参数 ?query=1
```


上面代码中，脚本路径带有参数`?query=1`，Node 会按 URL 规则解读。同一个脚本只要参数不同，就会被加载多次，并且保存成不同的缓存。由于这个原因，只要文件名中含有`:、%、#、?`等特殊字符，最好对这些字符进行转义。

目前，Node 的`import`命令只支持加载**本地模块`（file:协议）`**，不支持加载远程模块。

如果模块名不含路径，那么`import`命令会去`node_modules`目录寻找这个模块。

```js
import 'baz';
import 'abc/123';
```
如果模块名包含路径，那么`import`命令会按照路径去寻找这个名字的脚本文件。

```js
import 'file:///etc/config/app.json';
import './foo';
import './foo?search';
import '../bar';
import '/baz';
```

如果脚本文件省略了后缀名，比如`import './foo'`，Node 会依次尝试四个后缀名：`./foo.mjs、./foo.js、./foo.json、./foo.node`。如果这些脚本文件都不存在，Node 就会去加载`./foo/package.json`的main字段指定的脚本。如果`./foo/package.json`不存在或者没有`main`字段，那么就会依次加载`./foo/index.mjs、./foo/index.js、./foo/index.json、./foo/index.node`。如果以上四个文件还是都不存在，就会抛出错误。

最后，Node 的`import`命令是异步加载，这一点与浏览器的处理方法相同。

### 内部变量

首先，就是`this`关键字。ES6 模块之中，顶层的`this`指向`undefined`；CommonJS 模块的顶层`this`指向当前模块，这是两者的一个重大差异。

其次，以下这些顶层变量在 ES6 模块之中都是不存在的。

```js
arguments
require
module
exports
__filename
__dirname
```

### ES6 模块加载 CommonJS 模块

CommonJS 模块的输出都定义在`module.exports`这个属性上面。Node 的`import`命令加载 CommonJS 模块，Node 会自动将`module.exports`属性，当作模块的默认输出，即等同于`export default xxx`。

下面是一个 CommonJS 模块。

```js
// a.js
module.exports = {
  foo: 'hello',
  bar: 'world'
};

// 等同于
export default {
  foo: 'hello',
  bar: 'world'
};
```
`import`命令加载上面的模块，`module.exports`会被视为默认输出，即`import`命令实际上输入的是这样一个对象`{ default: module.exports }`。

所以，一共有三种写法，可以拿到 CommonJS 模块的`module.exports`。

```js
// 写法一
import baz from './a';
// baz = {foo: 'hello', bar: 'world'};

// 写法二
import {default as baz} from './a';
// baz = {foo: 'hello', bar: 'world'};

// 写法三
import * as baz from './a';
// baz = {
//   get default() {return module.exports;},
//   get foo() {return this.default.foo}.bind(baz),
//   get bar() {return this.default.bar}.bind(baz)
// }
```
上面代码的第三种写法，可以通过`baz.default`拿到`module.exports`。`foo`属性和`bar`属性就是可以通过这种方法拿到了`module.exports`。

由于 ES6 模块是编译时确定输出接口，CommonJS 模块是运行时确定输出接口，所以采用`import`命令加载 CommonJS 模块时，不允许采用下面的写法。

```js
// 不正确
import { readFile } from 'fs';
```

上面的写法不正确，因为`fs`是 CommonJS 格式，只有在运行时才能确定readFile接口，而import命令要求编译时就确定这个接口。解决方法就是改为整体输入。

```js
// 正确的写法一
import * as express from 'express';
const app = express.default();

// 正确的写法二
import express from 'express';
const app = express();
```

### CommonJS 模块加载 ES6 模块
CommonJS 模块加载 ES6 模块，不能使用`require`命令，而要使用`import()`函数。ES6 模块的所有输出接口，会成为输入对象的属性。

```js
// es.mjs
let foo = { bar: 'my-default' };
export default foo;

// cjs.js
const es_namespace = await import('./es.mjs');
// es_namespace = {
//   get default() {
//     ...
//   }
// }
console.log(es_namespace.default);
// { bar:'my-default' }
```

上面代码中，`default`接口变成了`es_namespace.default`属性。

下面是另一个例子。

```js
// es.js
export let foo = { bar:'my-default' };
export { foo as bar };
export function f() {};
export class c {};

// cjs.js
const es_namespace = await import('./es');
// es_namespace = {
//   get foo() {return foo;}
//   get bar() {return foo;}
//   get f() {return f;}
//   get c() {return c;}
// }
```

## 循环加载
“循环加载”（circular dependency）指的是，`a`脚本的执行依赖`b`脚本，而`b`脚本的执行又依赖`a`脚本。

```js
// a.js
var b = require('b');

// b.js
var a = require('a');
```
通常，“循环加载”表示存在强耦合，如果处理不好，还可能导致递归加载，使得程序无法执行，因此应该避免出现。

对于 JavaScript 语言来说，目前最常见的两种模块格式 CommonJS 和 ES6，处理“循环加载”的方法是不一样的，返回的结果也不一样。

### CommonJS 模块格式的加载原理
CommonJS 的一个模块，就是一个脚本文件。`require`命令第一次加载该脚本，就会执行整个脚本，然后在内存生成一个对象。

```js
{
  id: '...',
  exports: { ... },
  loaded: true,
  ...
}
```

### CommonJS 模块的循环加载
CommonJS 模块的重要特性是加载时执行，即脚本代码在`require`的时候，就会全部执行。一旦出现某个模块被"循环加载"，就只输出已经执行的部分，还未执行的部分不会输出。

脚本文件`a.js`代码如下。

```js
exports.done = false;
var b = require('./b.js');
console.log('在 a.js 之中，b.done = %j', b.done);
exports.done = true;
console.log('a.js 执行完毕');
```
上面代码之中，`a.js`脚本先输出一个`done`变量，然后加载另一个脚本文件`b.js`。注意，此时`a.js`代码就停在这里，等待`b.js`执行完毕，再往下执行。

再看`b.js`的代码。

```js
exports.done = false;
var a = require('./a.js');
console.log('在 b.js 之中，a.done = %j', a.done);
exports.done = true;
console.log('b.js 执行完毕');
```

上面代码之中，`b.js`执行到第二行，就会去加载`a.js`，这时，就发生了“循环加载”。系统会去`a.js`模块对应对象的`exports`属性取值，可是因为`a.js`还没有执行完，从`exports`属性只能取回已经执行的部分，而不是最后的值。

`a.js`已经执行的部分，只有一行。

```js
exports.done = false;
```

因此，对于`b.js`来说，它从`a.js`只输入一个变量`done`，值为`false`。

然后，`b.js`接着往下执行，等到全部执行完毕，再把执行权交还给`a.js`。于是，`a.js`接着往下执行，直到执行完毕。我们写一个脚本`main.js`，验证这个过程。

```js
var a = require('./a.js');
var b = require('./b.js');
console.log('在 main.js 之中, a.done=%j, b.done=%j', a.done, b.done);
```

执行`main.js`，运行结果如下。

```js
$ node main.js

在 b.js 之中，a.done = false
b.js 执行完毕
在 a.js 之中，b.done = true
a.js 执行完毕
在 main.js 之中, a.done=true, b.done=true
```

上面的代码证明了两件事。一是，在`b.js`之中，`a.js`没有执行完毕，只执行了第一行。二是，`main.js`执行到第二行时，不会再次执行`b.js`，而是输出缓存的`b.js`的执行结果，即它的第四行。

```js
exports.done = true;
```

总之，CommonJS 输入的是被输出值的拷贝，不是引用。

```js
var a = require('a'); // 安全的写法
var foo = require('a').foo; // 危险的写法

exports.good = function (arg) {
  return a.foo('good', arg); // 使用的是 a.foo 的最新值
};

exports.bad = function (arg) {
  return foo('bad', arg); // 使用的是一个部分加载时的值
};
```

### ES6 模块的循环加载
ES6 模块是动态引用，如果使用`import`从一个模块加载变量（即`import foo from 'foo'`），那些变量不会被缓存，而是成为一个指向被加载模块的引用，需要开发者自己保证，真正取值的时候能够取到值。

请看下面这个例子。

```js
// a.mjs
import {bar} from './b';
console.log('a.mjs');
console.log(bar);
export let foo = 'foo';

// b.mjs
import {foo} from './a';
console.log('b.mjs');
console.log(foo);
export let bar = 'bar';
```

`a.mjs`加载`b.mjs`，`b.mjs`又加载`a.mjs`，构成循环加载。执行`a.mjs`，结果如下。

```js
$ node --experimental-modules a.mjs
b.mjs
ReferenceError: foo is not defined
```

解决这个问题的方法，就是让`b.mjs`运行的时候，`foo`已经有定义了。这可以通过将`foo`写成函数来解决。

```js
// a.mjs
import {bar} from './b';
console.log('a.mjs');
console.log(bar());
function foo() { return 'foo' }
export {foo};

// b.mjs
import {foo} from './a';
console.log('b.mjs');
console.log(foo());
function bar() { return 'bar' }
export {bar};
```

这时再执行a.mjs就可以得到预期结果。

```js
$ node --experimental-modules a.mjs
b.mjs
foo
a.mjs
bar
```

这是因为函数具有提升作用，在执行`import {bar} from './b'`时，函数`foo`就已经有定义了，所以`b.mjs`加载的时候不会报错

## ES6 模块的转码

浏览器目前还不支持 ES6 模块，为了现在就能使用，可以将其转为 ES5 的写法。除了 `Babel` 可以用来转码之外，还有以下两个方法，也可以用来转码。

* [ES6 module transpiler](https://github.com/esnext/es6-module-transpiler)是 square 公司开源的一个转码器，可以将 ES6 模块转为 CommonJS 模块或 AMD 模块的写法，从而在浏览器中使用。
* [SystemJS](https://github.com/systemjs/systemjs)是一个垫片库（polyfill），可以在浏览器内加载 ES6 模块、AMD 模块和 CommonJS 模块，将其转为 ES5 格式。它在后台调用的是 Google 的 Traceur 转码器。

## 参考
[ECMAScript 6 入门](http://es6.ruanyifeng.com/#docs/module-loader)