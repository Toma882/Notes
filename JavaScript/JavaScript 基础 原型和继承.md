# JavaScript 基础 原型和继承

## 基础知识 之 面向对象
### Object 对象

```js
// 这里的person就是一个对象
var person = {
    name: 'Tom',
    age: 18,
    getName: function() {},
    parent: {}
}

var obj = new Object(); //var obj = {};

// 可以这样
var person = {};
person.name = "TOM";
person.getName = function() {
    return this.name;
}

// 也可以这样
var person = {
    name: "TOM",
    getName: function() {
        return this.name;
    }
}

// 访问对象属性
['name', 'age'].forEach(function(item){
    consol.log(person[item]);
})
```

### 工厂模式

```js
var createPerson = function(name, age) {

    // 声明一个中间对象，该对象就是工厂模式的模子
    var o = new Object();

    // 依次添加我们需要的属性与方法
    o.name = name;
    o.age = age;
    o.getName = function() {
        return this.name;
    }

    return o;
}

// 创建两个实例
var perTom = createPerson('TOM', 20);
var perJake = createPerson('Jake', 22);
console.log(perTom.getName());
```

## 原型 prototype

> 没有"子类"和"父类"的概念，也没有"类"（class）和"实例"（instance）的区分，全靠一种很奇特的"原型链"（prototype chain）模式，来实现继承

`C++`和`Java`语言都使用`new`命令，生成实例

```c++
ClassName *object = new ClassName(param);
```

```java
Foo foo = new Foo();
```

Brendan Eich 想到`C++`和`Java`使用`new`命令时，都会调用"类"的构造函数（`constructor`）。他就做了一个简化的设计，在Javascript语言中，`new`命令后面跟的不是类，而是构造函数。

```js
function DOG(name){
    this.name = name;
}

var dogA = new DOG('大毛');
alert(dogA.constructor == DOG); //true
```
对这个构造函数使用`new`，就会生成一个狗对象的实例。

```js
var dogA = new DOG('大毛');
alert(dogA.name); // 大毛

var dogB = new DOG('二毛');
alert(dogB.name); // 二毛

dogA.species = '猫科';
alert(dogB.species); // 显示"犬科"，不受dogA的影响
```

每一个实例对象，都有自己的属性和方法的副本。这不仅无法做到数据共享，也是极大的资源浪费。
考虑到这一点，Brendan Eich决定为构造函数设置一个`prototype`属性。
这个属性包含一个对象（以下简称"`prototype`对象"），**所有实例对象需要共享的属性和方法，都放在这个对象里面**；那些不需要共享的属性和方法，就放在构造函数里面。

实例对象一旦创建，将自动引用`prototype`对象的属性和方法。也就是说，实例对象的属性和方法，分成两种，一种是本地的，另一种是引用的。

还是以`DOG`构造函数为例，现在用`prototype`属性进行改写：

```js
function DOG(name){
    this.name = name;
}
DOG.prototype = { species : '犬科' };

var dogA = new DOG('大毛');
var dogB = new DOG('二毛');

alert(dogA.species); // 犬科
alert(dogB.species); // 犬科
```

## Prototype模式的验证方法
```js
function Cat(name,color){
    this.name = name;
    this.color = color;
}
Cat.prototype.type = "猫科动物";
Cat.prototype.eat = function(){alert("吃老鼠")};

// 这个方法用来判断，某个proptotype对象和某个实例之间的关系。
alert(Cat.prototype.isPrototypeOf(cat1)); //true

// 每个实例对象都有一个hasOwnProperty()方法，用来判断某一个属性到底是本地属性，还是继承自prototype对象的属性
alert(cat1.hasOwnProperty("name")); // true
alert(cat1.hasOwnProperty("type")); // false

//in运算符可以用来判断，某个实例是否含有某个属性，不管是不是本地属性。
alert("name" in cat1); // true
alert("type" in cat1); // true

//in运算符还可以用来遍历某个对象的所有属性。
for(var prop in cat1) { alert("cat1["+prop+"]="+cat1[prop]); }
```

## 继承 之 使用构造函数

比如，现在有一个"动物"对象的构造函数。

```js
function Animal()
{
    this.species = "动物";
}
```

还有一个"猫"对象的构造函数。

```js
function Cat(name,color)
{
    this.name = name;
    this.color = color;
}
```
### 方式一：构造函数绑定

使用`call`或`apply`方法，将父对象的构造函数绑定在子对象上

```js
function Cat(name,color)
{
    Animal.apply(this, arguments);
    this.name = name;
    this.color = color;
}
var cat1 = new Cat("大毛","黄色");
alert(cat1.species); // 动物
```

### 方式二：prototype 模式

第二种方法更常见，使用`prototype`属性。

如果"猫"的`prototype`对象，指向一个`Animal`的实例，那么所有"猫"的实例，就能继承`Animal`了。

```js
> Cat.prototype
Cat {}
> Cat.prototype.constructor
[Function: Cat]

// 完全删除了 prototype 对象原先的值，然后赋予一个新值
> Cat.prototype = new Animal();
> Cat.prototype
Animal { species: '动物' }
> Cat.prototype.constructor
[Function: Animal]

> var cat1 = new Cat("大毛","黄色");
> cat1.constructor
[Function: Animal]
> cat1.species
'动物'
> cat1.color
'黄色'
> cat1.name
'大毛'

// 为防止继承链紊乱，重新设置 Cat.prototype.constructor = Cat
// 本质原因还不是很明白，难道就是维护 prototype.constructor 指向正确的值？
> Cat.prototype.constructor = Cat;
[Function: Cat]

> Cat.prototype
Cat { species: '动物', constructor: [Function: Cat] }
> Cat.prototype.constructor
[Function: Cat]

> var cat2 = new Cat("二毛","黑色");
> cat2.constructor
[Function: Cat]
> cat2.species
'动物'
> cat2.color
'黑色'
> cat2.name
'二毛'

```

所以编程时务必要遵守

```js
Child.prototype = Super;
Child.prototype.constructor = Child;
```

### 方式三：直接继承 prototype
我们先将Animal对象改写：

```js
function Animal(){ }
Animal.prototype.species = "动物";
```

然后，将`Cat`的`prototype`对象，然后指向`Animal`的`prototype`对象，这样就完成了继承。

```js
Cat.prototype = Animal.prototype;
Cat.prototype.constructor = Cat;
var cat1 = new Cat("大毛","黄色");
alert(cat1.species); // 动物
```

上面这一段代码其实是有问题的。请看第二行

```js
Cat.prototype.constructor = Cat;
```

这一句实际上把`Animal.prototype`对象的`constructor`属性也改掉了！

### 方式四：利用空对象作为中介
由于"方式三：直接继承 prototype"存在上述的缺点，所以就有第四种方法，利用一个空对象作为中介。

```js
var F = function(){};
F.prototype = Animal.prototype;
Cat.prototype = new F();
Cat.prototype.constructor = Cat;
```
`F`是空对象，所以几乎不占内存。这时，修改`Cat`的`prototype`对象，就不会影响到`Animal`的`prototype`对象。

```js
alert(Animal.prototype.constructor); // Animal
```

我们将上面的方法，封装成一个函数，便于使用。

```js
function extend(Child, Parent)
{
    var F = function(){};
    F.prototype = Parent.prototype;
    Child.prototype = new F();
    Child.prototype.constructor = Child;
    Child.uber = Parent.prototype;
}
```
使用的时候，方法如下

```js
extend(Cat,Animal);
var cat1 = new Cat("大毛","黄色");
alert(cat1.species); // 动物
```
这个k函数，就是YUI库如何实现继承的方法。

另外，说明一点，函数体最后一行

```js
Child.uber = Parent.prototype;
```

意思是为子对象设一个`uber`属性，这个属性直接指向父对象的`prototype`属性。（`uber`是一个德语词，意思是"向上"、"上一层"。）这等于在子对象上打开一条通道，可以直接调用父对象的方法。这一行放在这里，只是为了实现继承的完备性，纯属备用性质。

### 方式五：拷贝继承

上面是采用 `prototype` 对象，实现继承。我们也可以换一种思路，纯粹采用"拷贝"方法实现继承。简单说，如果把父对象的所有属性和方法，拷贝进子对象，不也能够实现继承吗？这样我们就有了第五种方法。

首先，还是把`Animal`的所有不变属性，都放到它的`prototype`对象上。

```js
function Animal(){}
Animal.prototype.species = "动物";
```

然后，再写一个函数，实现属性拷贝的目的。

```js
function extend2(Child, Parent) {
    var p = Parent.prototype;
    var c = Child.prototype;
    for (var i in p) {
        c[i] = p[i];
    }
    c.uber = p;
}
```

这个函数的作用，就是将父对象的`prototype`对象中的属性，一一拷贝给`Child`对象的`prototype`对象。
使用的时候，这样写：

```js
extend2(Cat, Animal);
var cat1 = new Cat("大毛","黄色");
alert(cat1.species); // 动物
```

## 继承 之 非构造函数


```js
var Chinese = {
    nation:'中国'
};
var Doctor ={
    career:'医生'
}
```

请问怎样才能让"医生"去继承"中国人"，也就是说，我怎样才能生成一个"中国医生"的对象？
这里要注意，这两个对象都是普通对象，不是构造函数，无法使用构造函数方法实现"继承"。

### object()方法

json格式的发明人Douglas Crockford，提出了一个`object()`函数，可以做到这一点。


```js
function object(o) {
    function F() {}
    F.prototype = o;
    return new F();
}
```

```js
var Doctor = object(Chinese);
Doctor.career = '医生';
alert(Doctor.nation); //中国
```

### 浅拷贝

```js
function extendCopy(p) {
    var c = {};
    for (var i in p) {
        c[i] = p[i];
    }
    c.uber = p;
    return c;
}
```

```js
var Doctor = extendCopy(Chinese);
Doctor.career = '医生';
alert(Doctor.nation); // 中国
```

如果父对象的属性等于数组或另一个对象，那么实际上，子对象获得的只是一个内存地址，而不是真正拷贝，因此存在父对象被篡改的可能。`extendCopy()`只是拷贝基本类型的数据，我们把这种拷贝叫做"浅拷贝"。


### 深拷贝
```js
function deepCopy(p, c) {
    var c = c || {};
    for (var i in p) {
        if (typeof p[i] === 'object') {
            c[i] = (p[i].constructor === Array) ? [] : {};
            deepCopy(p[i], c[i]);
        } else {
            c[i] = p[i];
        }
    }
    return c;
}
```

```js
var Doctor = deepCopy(Chinese);
```


## 参考
* [Javascript继承机制的设计思想](http://www.ruanyifeng.com/blog/2011/06/designing_ideas_of_inheritance_mechanism_in_javascript.html)
* [详解面向对象、构造函数、原型与原型链](https://www.jianshu.com/p/15ac7393bc1f)
* [Javascript 面向对象编程（一）：封装](http://www.ruanyifeng.com/blog/2010/05/object-oriented_javascript_encapsulation.html)