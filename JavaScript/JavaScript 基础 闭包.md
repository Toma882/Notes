# JavaScript 基础 闭包 Closures

## 词法作用域

```js
function init() {
    var name = "Mozilla"; // name 是一个被 init 创建的局部变量
    function displayName() { // displayName() 是内部函数,一个闭包
        alert(name); // 使用了父函数中声明的变量
    }
    displayName();
}
init();
```

`init()` 创建了一个局部变量 `name` 和一个名为 `displayName()` 的函数。`displayName()` 是定义在 `init()` 里的内部函数，仅在该函数体内可用。`displayName()` 内没有自己的局部变量，然而它可以访问到外部函数的变量，所以 `displayName()` 可以使用父函数 `init()` 中声明的变量 `name` 。但是，如果有同名变量 `name` 在 `displayName()` 中被定义，则会使用 `displayName()` 中定义的 `name` 。

运行代码可以发现 `displayName()` 内的 `alert()` 语句成功的显示了在其父函数中声明的 `name` 变量的值。这个 **词法作用域** 的例子介绍了引擎是如何解析函数嵌套中的变量的。**词法作用域**中使用的域，是变量在代码中声明的位置所决定的。嵌套的函数可以访问在其外部声明的变量。

## 闭包

### 例子1

```js
function makeFunc() {
    var name = "Mozilla";
    function displayName() {
        alert(name);
    }
    return displayName;
}

var myFunc = makeFunc();
myFunc();
```


运行这段代码和之前的 `init()` 示例的效果完全一样。其中的不同 — 也是有意思的地方 — 在于内部函数 `displayName()` 在执行前，被外部函数返回。

第一眼看上去，也许不能直观的看出这段代码能够正常运行。在一些编程语言中，函数中的**局部变量**仅在函数的执行期间可用。一旦 `makeFunc()` 执行完毕，我们会认为 `name` 变量将不能被访问。然而，因为代码运行得没问题，所以很显然在 JavaScript 中并不是这样的。

这个谜题的答案是，JavaScript中的函数会形成闭包。 **闭包是由函数以及创建该函数的词法环境组合而成**。**这个环境包含了这个闭包创建时所能访问的所有局部变量**。在我们的例子中，`myFunc` 是执行 `makeFunc` 时创建的 `displayName` 函数实例的引用，而 `displayName` 实例仍可访问其词法作用域中的变量，即可以访问到 **`name`** 。由此，当 `myFunc` 被调用时，**`name`** 仍可被访问，其值 `Mozilla` 就被传递到`alert`中。

### 例子2
```
'use strict';

function create_counter(initial) {
    var x = initial || 0;
    return {
        inc: function () {
            x += 1;
            return x;
        }
    }
}
```

它用起来像这样：

```js
var c1 = create_counter();
c1.inc(); // 1
c1.inc(); // 2
c1.inc(); // 3

var c2 = create_counter(10);
c2.inc(); // 11
c2.inc(); // 12
c2.inc(); // 13
```

在返回的对象中，实现了一个闭包，该闭包携带了局部变量`x`，并且，从外部代码根本无法访问到变量`x`。换句话说，闭包就是**携带状态**的函数，并且它的状态可以完全对外隐藏起来。




词法环境包含了这个闭包创建时能访问的所有局部变量，并使其状态能够一致携带



### 例子3

```js
function count() {
    var arr = [];
    for (var i=1; i<=3; i++) {
        arr.push(function () {
            return i * i;
        });
    }
    return arr;
}

var results = count();
var f1 = results[0];
var f2 = results[1];
var f3 = results[2];
```

```js
// 你可能认为调用f1()，f2()和f3()结果应该是1，4，9，但实际结果是：

f1(); // 16
f2(); // 16
f3(); // 16
```

## 自己的理解

```
var f0 = null;
function f1()
{
    var n = 2;
    function f2()
    {
        n = n*n
        return n;
    }
    return f2;
}
f0 = f1()
f0(); // 4
f0(); // 16

f00 = f1()
f00(); //4
```

通过 `f1` 的作用域环境（作用域环境其实就是 `f1` 的局部变量）和 `f2` 函数，返回对象为 `f2` 函数 来行程一个闭包。外部代码 `f0` 通过返回对象函数，来获取 `f1` 局部变量 `n`，`n` 若值发生变化则一直保存。

其实在 `f0 = f1()` 的时候为 `f1` 开辟了新的内存地址，因为 `f0` 的存在，并未垃圾回收。 `f0()` 使用的时候， `f0` 里面的局部变量 `n` 指向同一个地址，状态得以保存。 `f00 = f1()` 的时候则又开辟新地址。

## 闭包的应用场景

### 数据关联

闭包很有用，因为它允许将函数与其所操作的某些**数据（环境）关联**起来。这显然类似于面向对象编程。在面向对象编程中，对象允许我们将某些数据（对象的属性）与一个或者多个方法相关联。

```js
function makeSizer(size) {
  return function() {
    document.body.style.fontSize = size + 'px';
  };
}

var size12 = makeSizer(12);
var size14 = makeSizer(14);
var size16 = makeSizer(16);
```

```html
<a href="#" id="size-12">12</a>
<a href="#" id="size-14">14</a>
<a href="#" id="size-16">16</a>
```

```js
document.getElementById('size-12').onclick = size12;
document.getElementById('size-14').onclick = size14;
document.getElementById('size-16').onclick = size16;
```

### 模块化

```js
(function () {
    var a = 10;
    var b = 20;

    function add(num1, num2) {
        var num1 = !!num1 ? num1 : a;
        var num2 = !!num2 ? num2 : b;

        return num1 + num2;
    }

    window.add = add;
})();

add(10, 20);
```
`add`是模块对外暴露的一个公共方法。而变量`a，b`被作为私有变量。在面向对象的开发中，我们常常需要考虑是将变量作为私有变量，还是放在构造函数中的`this`中，因此理解闭包，以及原型链是一个非常重要的事情

## 性能考量
如果不是某些特定任务需要使用闭包，在其它函数中创建函数是不明智的，因为闭包在处理速度和内存消耗方面对脚本性能具有负面影响。

例如，在创建新的对象或者类时，方法通常应该关联于对象的原型，而不是定义到对象的构造器中。原因是这将导致每次构造器被调用时，方法都会被重新赋值一次（也就是，每个对象的创建）。

## 参考
* [MDN-闭包](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Closures)
* [详细图解作用域链与闭包](https://www.jianshu.com/p/21a16d44f150)
