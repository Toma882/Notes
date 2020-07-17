# ArrayBuffer

## 场景
很多浏览器操作的 API，用到了二进制数组操作二进制数据，下面是其中的几个。

* File API
* XMLHttpRequest
* Fetch API
* Canvas
* WebSockets

## 概念
1 byte = 8 bit

WebGL
> 指浏览器与显卡之间的通信接口，为了满足 JavaScript 与显卡之间大量的、实时的数据交换，它们之间的数据通信必须是二进制的，而不能是传统的文本格式。文本格式传递一个 32 位整数，两端的 JavaScript 脚本与显卡都要进行格式转化，将非常耗时。这时要是存在一种机制，可以像 C 语言那样，直接操作字节，将 4 个字节的 32 位整数，以二进制形式原封不动地送入显卡，脚本的性能就会大幅提升。

`ArrayBuffer`
> 对象代表原始的二进制数据，不能直接读写，只能通过视图（`TypedArray`视图和`DataView`视图)来读写
>

“视图”部署了数组接口，这意味着，可以用数组的方法操作内存。

`TypedArray`
> 只是一层视图，本身不储存数据，简单类型的二进制数据，共包括 9 种类型的视图，比如`Uint8Array`（无符号 8 位整数）数组视图, `Int16Array`（16 位整数）数组视图, `Float32Array`（32 位浮点数）数组视图等；`new Uint8Array(10)`返回一个 `TypedArray` 数组，里面 10 个成员都是 0。
> 
> 在设计目的上，ArrayBuffer对象的各种TypedArray视图，是用来向网卡、声卡之类的本机设备传送数据，所以使用本机的字节序就可以了

`DataView`
> 只是一层视图，本身不储存数据，**复杂类型**的二进制数据，可以自定义**复合格式**的视图，比如第一个字节是 `Uint8`（无符号 8 位整数）、第二、三个字节是 `Int16`（16 位整数）、第四个字节开始是 `Float32`（32 位浮点数）等等，此外还可以自定义字节序。
> 
> 而DataView视图的设计目的，是用来处理网络设备传来的数据，所以大端字节序或小端字节序是可以自行设定的。



## 数据类型

`TypedArray`视图支持的数据类型一共有 9 种（`DataView`视图支持除`Uint8C`以外的其他 8 种）。

数据类型 | 字节长度 | 含义 | 	Value Range | 对应的 C 语言类型 | 对应的 TypedArray 视图 | 对应的 DataView 视图
--- | --- | --- | --- | --- | --- | ---
Int8	 | 1	 | 8 位带符号整数	 | -128 to 127	 | signed char | Int8Array | getInt8 setInt8
Uint8	 | 1	 | 8 位不带符号整数	 | 	0 to 255 | unsigned char | Uint8Array | getUint8 setUint8
Uint8C	 | 1	 | 8 位不带符号整数（自动过滤溢出）	 | 	0 to 255 | unsigned char | Uint8ClampedArray | -
Int16	 | 2	 | 16 位带符号整数	 	 | -32768 to 32767 | short | Int16Array | getInt16 setInt16
Uint16	 | 2	 | 16 位不带符号整数		 | 0 to 65535 | unsigned short | Uint16Array | getUint16 setUint16
Int32	 | 4	 | 32 位带符号整数	 	 | -2147483648 to 2147483647 | int | Int32Array | getInt32 setInt32
Uint32	 | 4	 | 32 位不带符号的整数		 | 0 to 4294967295 | unsigned int | Uint32Array | getUint32 setUint32
Float32	 | 4	 | 32 位浮点数		 | 1.2x10\*\*38 to 3.4x10\*\*38 | float | Float32Array | getFloat32 setFloat32
Float64	 | 8	 | 64 位浮点数		 | 5.0x10\*\*324 to 1.8x10\*\*308 | double | Float64Array | getFloat64 setFloat64
注意，二进制数组并不是真正的数组，而是类似数组的对象。

## ArrayBuffer 对象
### ArrayBuffer
`new ArrayBuffer(length)`
` arraybuffer.length`

```js
# A RangeError is thrown if the length is larger than Number.MAX_SAFE_INTEGER (>= 2 ** 53) or negative.
// create an ArrayBuffer with a size in bytes
var buffer = new ArrayBuffer(8);
console.log(buffer.byteLength);// expected output: 8

var view = new Int32Array(buffer);
console.log(view.byteLength);// expected output: 8
console.log(view.length);// expected output: 2
```
`ArrayBuffer.isView()`

```js
const buffer = new ArrayBuffer(8);
console.log(ArrayBuffer.isView(buffer)) // false

const v = new Int32Array(buffer);
console.log(ArrayBuffer.isView(v)) // true

const dv = new DataView(buffer);
console.log(ArrayBuffer.isView(v)) // true
```

`arraybuffer.slice(begin[, end])`

```js
# slice方法其实包含两步，第一步是先分配一段新内存，第二步是将原来那个ArrayBuffer对象拷贝过去。
// create an ArrayBuffer with a size in bytes
var buffer = new ArrayBuffer(16);
var int32View = new Int32Array(buffer);
// produces Int32Array [0, 0, 0, 0]
int32View[0] = 40;
int32View[1] = 41;
int32View[2] = 42;
int32View[3] = 43;
// 拷贝buffer对象的 8 个字节（从 4 开始，到第 12 个字节前面结束，也就是实际是 4 - 11，0是最小的）
var sliced = new Int32Array(buffer.slice(4,12));
// produces Int32Array [42, 0]
console.log(sliced.length); // 2
console.log(sliced[0]); // 41
console.log(sliced[1]); // 42
```



### DataView

`DataView(buffer [, byteOffset [, length]])` `dataView.buffer` `dataView.byteOffset` `dataView.byteLength`

```js
# 生成了一段 32 字节的内存区域，每个字节的值默认都是 0
const buf = new ArrayBuffer(32);

# DataView
const dataView = new DataView(buf);
# dataview.setUint8(byteOffset, value)
dataview.setUint8(0,1)
dataView.getUint8(0) // 1
```

### TypedArray

`new TypedArray(buffer [, byteOffset [, length]])`

```js
new TypedArray(); // new in ES2017

// new TypedArray(typedArray);
const x = new Int8Array(new Int32Array([1,1]));

//new TypedArray(object);
const x = new Int8Array([1, 1]);

// new TypedArray(length); 创建一个8字节的ArrayBuffer
const b = new ArrayBuffer(8);

// new TypedArray(buffer [, byteOffset [, length]])
// 创建一个指向b的Int32视图，开始于字节0，直到缓冲区的末尾
const v1 = new Int32Array(b);
// 创建一个指向b的Uint8视图，开始于字节2，直到缓冲区的末尾
const v2 = new Uint8Array(b, 2);
// 创建一个指向b的Int16视图，开始于字节2，长度为3
const v3 = new Int16Array(b, 2, 3);

```

`typedArray.byteLength`

```js
const x = new Int8Array(new Int32Array([1,1]));
console.log(x.length); // 2
console.log(x.byteLength); // 2 

const y = new Int32Array(new Int8Array([1,1]));
console.log(y.length); // 2
console.log(y.byteLength); // 8
```

`typedArray.BYTES_PER_ELEMENT`

```js
const x = new Int8Array([1,1]);
console.log(x.BYTES_PER_ELEMENT); // 1 

const y = new Int32Array([1,1]);
console.log(y.BYTES_PER_ELEMENT); // 4
```

`TypedArray.name`

```js
console.log(Int8Array.name); // "Int8Array" 
```

`TypedArray.from()`
`TypedArray.of()`

```js
// Set (iterable object)
var s = new Set([1, 2, 3]);
Uint8Array.from(s);
// Uint8Array [ 1, 2, 3 ]

// String
Int16Array.from('123');
// Int16Array [ 1, 2, 3 ]

// Using an arrow function as the map function to
// manipulate the elements
Float32Array.from([1, 2, 3], x => x + x);
// Float32Array [ 2, 4, 6 ]

// Generate a sequence of numbers
Uint8Array.from({length: 5}, (v, k) => k);
// Uint8Array [ 0, 1, 2, 3, 4 ]

Uint8Array.of(1);            // Uint8Array [ 1 ]
Int8Array.of('1', '2', '3'); // Int8Array [ 1, 2, 3 ]
Float32Array.of(1, 2, 3);    // Float32Array [ 1, 2, 3 ]
Int16Array.of(undefined);    // IntArray [ 0 ]
```


```js
# TypedArray
const buffer = new ArrayBuffer(12);

# 分别建立两种视图：32 位带符号整数（Int32Array构造函数）和 8 位不带符号整数（Uint8Array构造函数）
const x1 = new Int32Array(buffer);
x1[0] = 1;
const x2 = new Uint8Array(buffer);
x2[0]  = 2;
# 由于两个视图对应的是同一段内存，一个视图修改底层内存，会影响到另一个视图。
x1[0] // 2

# 生成的新数组，只是复制了参数数组的值，对应的底层内存是不一样的。新数组会开辟一段新的内存储存数据
const x = new Int8Array([1, 1]);
const y = new Int8Array(x);
x[0] // 1
y[0] // 1
x[0] = 2;
y[0] // 1

# TypedArray视图的构造函数，除了接受ArrayBuffer实例作为参数，
# 还可以接受普通数组作为参数，直接分配内存生成底层的ArrayBuffer实例，并同时完成对这段内存的赋值。
# 1
const typedArray = new Uint8Array([0,1,2]);
# 2
let typedArray = Uint8Array.of(0,1,2);
# 3
let typedArray = new Uint8Array(3);
typedArray[0] = 0;
typedArray[1] = 1;
typedArray[2] = 2;
typedArray.length // 3

typedArray[0] = 5;
typedArray // [5, 1, 2]

# TypedArray 数组也可以转换回普通数组。
const normalArray = [...typedArray];
// or
const normalArray = Array.from(typedArray);
// or
const normalArray = Array.prototype.slice.call(typedArray);
```

**下面部分与`Array`相同**

`typedarray.copyWithin(target, start[, end = this.length])`

```js
const uint8 = new Uint8Array([ 1, 2, 3, 4, 5, 6, 7, 8 ]);

// (insert position, start position, end position)
uint8.copyWithin(3, 1, 3);

console.log(uint8); // Uint8Array [1, 2, 3, 2, 3, 6, 7, 8]

```

`typedarray.entries()`  
`typedarray.keys()`  
`typedarray.values()`

```js
const uint8 = new Uint8Array([10, 20, 30, 40, 50]);
eArr = uint8.entries();
eArr.next();
eArr.next();
console.log(eArr.next().value); // Array [2, 30]

const keys = uint8.keys();
keys.next();
keys.next();
console.log(keys.next().value); // 2

const array1 = uint8.values();
array1.next();
array1.next();
console.log(array1.next().value); // 30
```

`typedarray.every(callback[, thisArg])`

```js
function isNegative(element, index, array) {
  return element < 0;
}

const int8 = new Int8Array([-10, -20, -30, -40, -50]);

console.log(int8.every(isNegative)); // true
```

`typedarray.fill(value[, start = 0[, end = this.length]])`

```js
const uint8 = new Uint8Array([0, 0, 0, 0]);
// (value, start position, end position);
uint8.fill(4, 1, 3);

console.log(uint8); // Uint8Array [0, 4, 4, 0]
```

`typedarray.filter(callback[, thisArg])`

```js
function isNegative(element, index, array) {
  return element < 0;
}

const int8 = new Int8Array([-10, 20, -30, 40, -50]);
const negInt8 = int8.filter(isNegative);

console.log(negInt8); // Int8Array [-10, -30, -50]

```

`typedarray.find(callback[, thisArg])`  
`typedarray.findIndex(callback[, thisArg])`  
`typedarray.indexOf(searchElement[, fromIndex = 0])`  
`typedarray.join([separator = ','])`  
`typedarray.includes(searchElement[, fromIndex])`  
`typedarray.lastIndexOf(searchElement[, fromIndex = typedarray.length])`

```js
function isNegative(element, index, array) {
  return element < 0;
}

const int8 = new Int8Array([10, 0, -10, 20, -30, 40, -50]);

console.log(int8.find(isNegative)); // -10
console.log(int8.findIndex(isNegative)); // 2
console.log(int8.indexOf(10)); // 0
console.log(int8.indexOf(10, 1)); // -1
console.log(int8.join()); // "10,0,-10,20,-30,40,-50"
console.log(int8.join('')); // "100-1020-3040-50"
console.log(int8.includes(20)); // true
// check from position 2
console.log(int8.includes(20, 4)); // false

const uint8 = new Uint8Array([10, 20, 50, 50, 50, 60]);

console.log(uint8.lastIndexOf(50, 5)); // 4
console.log(uint8.lastIndexOf(50, 3)); // 3
```

`typedarray.forEach(callback[, thisArg])`

```js
function logArrayElements(element, index, array) {
  console.log('a[' + index + '] = ' + element);
}

new Uint8Array([0, 1, 2, 3]).forEach(logArrayElements);
// logs:
// a[0] = 0
// a[1] = 1
// a[2] = 2
// a[3] = 3
```

`typedarray.map(callback[, thisArg])`

```js
const uint8 = new Uint8Array([25, 36, 49]);
const roots = uint8.map(Math.sqrt);

console.log(roots); // Uint8Array [5, 6, 7]
```

`arr.reduce(callback(accumulator, currentValue[, index[, array]])[, initialValue])`  
`typedarray.reduceRight(callback[, initialValue])`

```js
// The reducer function takes four arguments:

// Accumulator (acc)
// Current Value (cur)
// Current Index (idx)
// Source Array (src)

const array1 = [1, 2, 3, 4];
const reducer = (accumulator, currentValue) => accumulator + currentValue;

// 1 + 2 + 3 + 4
console.log(array1.reduce(reducer)); // 10

// 5 + 1 + 2 + 3 + 4
console.log(array1.reduce(reducer, 5)); // 15

var total = new Uint8Array([0, 1, 2, 3]).reduceRight(function(a, b) {
  return a + b;
});
// total == 6
```

`typedarray.reverse();`  
`typedarray.sort([compareFunction])`

```js
const uint8 = new Uint8Array([1, 3, 2]);
uint8.reverse();
console.log(uint8); // Uint8Array [2, 3, 1]
uint8.sort();
console.log(uint8); // Uint8Array [1, 2, 3]
```

`typedarray.set(array[, offset])`  
`typedarray.set(typedarray[, offset])`

```js
// create a SharedArrayBuffer with a size in bytes
const buffer = new ArrayBuffer(8);
const uint8 = new Uint8Array(buffer);

// Copy the values into the array starting at index 3
uint8.set([1, 2, 3], 3);

console.log(uint8); // Uint8Array [0, 0, 0, 1, 2, 3, 0, 0]
```

`typedarray.slice([begin[, end]])`

```js
const uint8 = new Uint8Array([10, 20, 30, 40, 50]);
var array1 = uint8.slice(1, 3);
console.log(uint8); // Uint8Array [10, 20, 30, 40, 50]
console.log(array1); // expected output: Uint8Array [20, 30]
```

`typedarray.some(callback[, thisArg])`

```js
function isNegative(element, index, array) {
  return element < 0;
}

const int8 = new Int8Array([-10, 20, -30, 40, -50]);
const positives = new Int8Array([10, 20, 30, 40, 50]);

console.log(int8.some(isNegative)); // true
console.log(positives.some(isNegative)); // false
```

`typedarray.subarray([begin [,end]])`

```js
const uint8 = new Uint8Array([10, 20, 30, 40, 50]);

console.log(uint8.subarray(1, 3)); // Uint8Array [20, 30]
console.log(uint8.subarray(1)); // Uint8Array [20, 30, 40, 50]

```

`typedarray.toLocaleString([locales [, options]]);`

```js
var uint = new Uint32Array([2000, 500, 8123, 12, 4212]);

uint.toLocaleString(); 
// if run in a de-DE locale
// "2.000,500,8.123,12,4.212"

uint.toLocaleString('en-US');
// "2,000,500,8,123,12,4,212"

uint.toLocaleString('ja-JP', { style: 'currency', currency: 'JPY' });
// "￥2,000,￥500,￥8,123,￥12,￥4,212"
```

`typedarray.toString()`

```js
const uint8 = new Uint8Array([10, 20, 30, 40, 50]);

const uint8String = uint8.toString();
console.log(uint8String); // "10,20,30,40,50"
console.log(uint8String.startsWith('10')); // true
```

`arr[Symbol.iterator]()`

```js
var arr = new Uint8Array([10, 20, 30, 40, 50]);
// your browser must support for..of loop
// and let-scoped variables in for loops
for (let n of arr) {
  console.log(n);
}
// 10
// 20
// 30
// 40
// 50

var arr = new Uint8Array([10, 20, 30, 40, 50]);
var eArr = arr[Symbol.iterator]();
console.log(eArr.next().value); // 10
console.log(eArr.next().value); // 20
console.log(eArr.next().value); // 30
console.log(eArr.next().value); // 40
console.log(eArr.next().value); // 50
```
## 字节序
如果不确定正在使用的计算机的字节序，可以采用下面的判断方式。

```js
const littleEndian = (function() {
  const buffer = new ArrayBuffer(2);
  new DataView(buffer).setInt16(0, 256, true);
  return new Int16Array(buffer)[0] === 256;
})();
```

如果返回`true`，就是小端字节序；如果返回`false`，就是大端字节序。
## 参考
[ArrayBuffer](http://es6.ruanyifeng.com/#docs/arraybuffer)