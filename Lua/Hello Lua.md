#Lua
Lua脚本是一个很轻量级的脚本，也是号称性能最高的脚本，用在很多需要性能的地方，比如：游戏脚本，nginx，wireshark的脚本

>Lua 5.3
>
>新增加的 `int64` 支持，以及 `string pack 、utf8` 库对开发帮助很大，所以学习时建议直接从 `version 5.3` 开始

### 注意事项
* Lua 索引值是以 1 为起始
* repeat end
* do end 可以理解为 {}
* ^ 用于幂次方 2^3结果是8
* string 类型连接，用`a=' hello' b=' world' c=a..b -- c contains 'hello world'`
* 计算长度用`#`，`stringLength=#'hello world'
tableSize=#{1,2,3,4,5}`


```lua
--单行注释
--[[
多行注释
]]
```

##数据类型 
Lua是动态类型语言，变量不要类型定义,只需要为变量赋值。 值可以存储在变量中，作为参数传递或结果返回。
Lua中有8个基本类型分别为：nil、boolean、number、string、userdata、function、thread和table。

| 数据类型 | 描述 |
| ------------ | ------------- |
| nil | 这个最简单，只有值nil属于该类，表示一个无效值（在条件表达式中相当于false）。  |
| boolean | Lua 把 false 和 nil 看作是"假"，其他的都为"真" |
| number | 数字只有double型，64bits |
| string |  字符串由一对双引号或单引号来表示 |
| function | 由 C 或 Lua 编写的函数 |
| userdata | 表示任意存储在变量中的C数据结构 |
| thread | 表示执行的独立线路，用于执行协同程序 |
| table |  Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字或者是字符串。在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。 |


##常量 变量

应该尽可能的使用局部变量，有两个好处：

1. 避免命名冲突。
2. 访问局部变量的速度比全局变量更快。

### 关于命名
最好不要使用下划线加大写字母的标示符，因为Lua的保留字也是这样的。

### Nil NULL
C语言中的NULL在Lua中是nil，比如你访问一个没有声明过的变量，就是nil，比如下面的v的值就是nil<br>
`v = UndefinedVariable`

### 全局变量和局部变量
默认情况下，给一个变量赋值后即创建了这个**全局变量**。
访问一个没有初始化的全局变量也不会出错，只不过得到的结果是：`nil`。
如果你想删除一个全局变量，只需要将变量负值为`nil`。

```lua
> print(b)
nil
> b=10
> print(b)
10
```

如果你想删除一个全局变量，只需要将变量负值为nil。

```lua
b = nil
print(b)      --> nil
```

函数外的变量默认为全局变量，除非用 `local` 显示声明。<br>
函数内变量与函数的参数默认为局部变量。<br>
局部变量的作用域为从声明位置开始到所在语句块结束（或者是直到下一个同名局部变量的声明）。<br>
变量的默认值均为 nil。

```lua
-- test.lua 文件脚本
a = 5               -- 全局变量
local b = 5     -- 局部变量

function joke()
    c = 5           -- 局部变量
    local d = 6 -- 局部变量
end

print(a,b,c,d)      --> 5 5 nil nil

do 
    local a = 6 -- 局部变量
    b = 6           -- 全局变量
    print(a,b); --> 6 6
end

print(a,b,c,d)     --> 5 6 nil nil    
```

### 赋值

```lua
a = "hello" .. "world"
t.n = t.n + 1
```

Lua可以对多个变量同时赋值，变量列表和值列表的各个元素用逗号分开，赋值语句右边的值会依次赋给左边的变量。

```lua
a, b = 10, 2*x       <-->       a=10; b=2*x
```

遇到赋值语句Lua会先计算右边所有的值然后再执行赋值操作，所以我们可以这样进行交换变量的值：

```lua
x, y = y, x                     -- swap 'x' for 'y'
a[i], a[j] = a[j], a[i]         -- swap 'a[i]' for 'a[i]'
```

当变量个数和值的个数不一致时，Lua会一直以变量个数为基础采取以下策略：

```lua
a. 变量个数 > 值的个数             按变量个数补足nil
b. 变量个数 < 值的个数             多余的值会被忽略
```
例如：

```lua
a, b, c = 0, 1
print(a,b,c)             --> 0   1   nil
 
a, b = a+1, b+1, b+2     -- value of b+2 is ignored
print(a,b)               --> 1   2
 
a, b, c = 0
print(a,b,c)             --> 0   nil   nil
```
	
若右边为函数

```lua
a, b = f()
```

    
`f()`返回两个值，第一个赋给a，第二个赋给b。

### 对table的索引
对 table 的索引使用方括号 []。Lua 也提供了 . 操作。

```lua
t[i]
t.i                 -- 当索引为字符串类型时的一种简化写法
gettable_event(t,i) -- 采用索引访问本质上是一个类似这样的函数调用
```  

## 运算符和表达式

### `~=` 不等于

```lua
a={1,2}
b=a
print(a==b, a~=b)  --输出 true, false
a={1,2}
b={1,2}
print(a==b, a~=b)  --输出 false, true
```


### `#` 返回字符串或表的长度。

```lua
a = "Hello "
b = "World"
print("连接字符串 a 和 b ", a..b )
print("a 字符串长度 ",#a )
print("字符串 Test 长度 ",#"Test" )

# result:
连接字符串 a 和 b 	Hello World
b 字符串长度 	6
字符串 Test 长度 	4
```

## 条件语句
### if

```lua
--[ 0 为 true ]
if(0) then
    print("0 为 true")
end
if value1==value2 then
    print('value1 and value2 are same!')
end
```

### for

```lua
for i=1,4,1 do -- count from 1 to 4 with increments of 1
    print(i)
end
```

i是数组索引值，v是对应索引的数组元素值。ipairs是Lua提供的一个迭代器函数，用来迭代数组。

```lua
days = {"Suanday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}  
for i,v in ipairs(days) do
    print(v)
end
```

### while

```lua
a = 10;
while(a < 20)
do
    print("a: " + a);
    a = a + 1;
end

i=0
while i~=4 do
    i=i+1
end
```
 
### repeat
```lua
i=0
repeat
    i=i+1
until i==4
```




## 函数
Lua 编程语言函数定义格式如下：

```lua
--optional_function_scope 可以使用local
optional_function_scope function function_name( argument1, argument2,     argument3..., argumentn)
	function_body
	return result_params_comma_separated
end
```


## 构造类型 数组 结构体 枚举
Lua 索引值默认是以 1 为起始，但你也可以指定 0 开始。

```lua
array = {"Lua", "Tutorial"}
for i= 0, 2 do
   print(array[i])
end
--[[
nil
Lua
Tutorial
]]
```

##Lua table
table 是 Lua 的一种数据结构用来帮助我们创建不同的数据类型，如：数字、字典等。<br>
Lua table 使用关联型数组，你可以用任意类型的值来作数组的索引，但这个值不能是 nil。<br>
Lua table 是不固定大小的，你可以根据自己需要进行扩容。<br>
Lua也是通过table来解决模块（module）、包（package）和对象（Object）的。 例如string.format表示使用"format"来索引table string。<br>

```lua
-- 初始化表
mytable = {}

-- 指定值
mytable[1]= "Lua"

-- 移除引用
mytable = nil
-- lua 垃圾回收会释放内存
```
	
举例

```lua
-- 简单的 table
mytable = {}
print("mytable 的类型是 ",type(mytable))
--mytable 的类型是 	table

mytable[1]= "Lua"
mytable["wow"] = "修改前"
print("mytable 索引为 1 的元素是 ", mytable[1])
--mytable 索引为 1 的元素是 	Lua
print("mytable 索引为 wow 的元素是 ", mytable["wow"])
--mytable 索引为 wow 的元素是 	修改前

-- alternatetable和mytable的是指同一个 table
alternatetable = mytable

print("alternatetable 索引为 1 的元素是 ", alternatetable[1])
--alternatetable 索引为 1 的元素是 	Lua
print("mytable 索引为 wow 的元素是 ", alternatetable["wow"])
--mytable 索引为 wow 的元素是 	修改前

alternatetable["wow"] = "修改后"

print("mytable 索引为 wow 的元素是 ", mytable["wow"])
--mytable 索引为 wow 的元素是 	修改后

-- 释放变量
alternatetable = nil
print("alternatetable 是 ", alternatetable)
--alternatetable 是 	nil

-- mytable 仍然可以访问
print("mytable 索引为 wow 的元素是 ", mytable["wow"])
--mytable 索引为 wow 的元素是 	修改后

mytable = nil
print("mytable 是 ", mytable)
--mytable 是 	nil
```

##Lua 迭代器

泛型 for 迭代器

```lua
array = {"Lua", "Tutorial"}

for key,value in ipairs(array) 
do
   print(key, value)
end
```

无状态的迭代器

```lua
function square(iteratorMaxCount,currentNumber)
   if currentNumber<iteratorMaxCount
   then
      currentNumber = currentNumber+1
   return currentNumber, currentNumber*currentNumber
   end
end

for i,n in square,3,0
do
   print(i,n)
end
```
	
多状态的迭代器

```lua
array = {"Lua", "Tutorial"}

function elementIterator (collection)
   local index = 0
   local count = #collection
   -- 闭包函数
   return function ()
      index = index + 1
      if index <= count
      then
         --  返回迭代器的当前元素
         return collection[index]
      end
   end
end

for element in elementIterator(array)
do
   print(element)
end
```

##Lua 模块与包

[Lua Module](Lua Module.lua)


## C 包

Lua和C是很容易结合的，使用C为Lua写包。

与Lua中写包不同，C包在使用以前必须首先加载并连接，在大多数系统中最容易的实现方式是通过动态连接库机制。

Lua在一个叫`loadlib`的函数内提供了所有的动态连接的功能。这个函数有两个参数:库的绝对路径和初始化函数。

创建一个测试C文件, 函数`display`

```c
[root@db-172-16-3-150 ~]# vi a.c
#include <stdio.h>
#include "a.h"

void display() {
  fprintf(stdout, "this is display function in a.c\n");
}
```

头文件

```sh
[root@db-172-16-3-150 ~]# vi a.h
void display();
```

生成动态链接库.

```sh
[root@db-172-16-3-150 ~]# gcc -O3 -Wall -Wextra -Werror -g -fPIC -c ./a.c -o a.o
[root@db-172-16-3-150 ~]# gcc -O3 -Wall -Wextra -Werror -g -shared a.o -o liba.so
```

在lua中加载这个动态链接库文件, display函数.

```lua
[root@db-172-16-3-150 ~]# lua
> file = "/root/liba.so"
> f = package.loadlib(file, "display")  -- 加载动态链接库中的C函数到lua函数
> print(f)
function: 0x7f593eb625b0
> f()  -- 直接调用这个lua函数.
this is display function in a.c
```


##Lua 元表Metatable(todo)

**在 Lua table 中我们可以访问对应的key来得到value值，但是却无法对两个 table 进行操作。<br>
因此 Lua 提供了元表(Metatable)，允许我们改变table的行为，每个行为关联了对应的元方法。<br>
因此 Lua 中的面向对象操作 a + b 这种行为每次定义的时候就要定义 一个 table 和 对应的 metatable。
具体参考 Lua 面向对象**


Lua 中的每个值都可以用一个 metatable。 这个 metatable 就是一个原始的 Lua table ， 它用来定义原始值在特定操作下的行为。 你可以通过在 metatable 中的特定域设一些值来改变拥有这个 metatable 的值 的指定操作之行为。 举例来说，当一个非数字的值作加法操作的时候， Lua 会检查它的 metatable 中 "__add" 域中的是否有一个函数。 如果有这么一个函数的话，Lua 调用这个函数来执行一次加法。

我们叫 metatable 中的键名为 事件 (event) ，把其中的值叫作 元方法 (metamethod)。 在上个例子中，事件是 "add" 而元方法就是那个执行加法操作的函数。

你可以通过 getmetatable 函数来查询到任何一个值的 metatable。

你可以通过 setmetatable 函数来替换掉 table 的 metatable 。 你不能从 Lua 中改变其它任何类型的值的 metatable （使用 debug 库例外）； 要这样做的话必须使用 C API 。

每个 table 和 userdata 拥有独立的 metatable （当然多个 table 和 userdata 可以共享一个相同的表作它们的 metatable）； 其它所有类型的值，每种类型都分别共享唯一的一个 metatable。 因此，所有的数字一起只有一个 metatable ，所有的字符串也是，等等。

一个 metatable 可以控制一个对象做数学运算操作、比较操作、连接操作、取长度操作、取下标操作时的行为， metatable 中还可以定义一个函数，让 userdata 作垃圾收集时调用它。 对于这些操作，Lua 都将其关联上一个被称作事件的指定健。 当 Lua 需要对一个值发起这些操作中的一个时， 它会去检查值中 metatable 中是否有对应事件。 如果有的话，键名对应的值（元方法）将控制 Lua 怎样做这个操作。

metatable 可以控制的操作已在下面列出来。 每个操作都用相应的名字区分。 每个操作的键名都是用操作名字加上两个下划线 __  前缀的字符串； 举例来说，"add" 操作的键名就是字符串 "__add"。 这些操作的语义用一个 Lua 函数来描述解释器如何执行更为恰当。

这里展示的用 Lua 写的代码仅作解说用； 实际的行为已经硬编码在解释器中，其执行效率要远高于这些模拟代码。 这些用于描述的的代码中用到的函数 （ rawget ， tonumber ，等等。） 都可以在 §5.1 中找到。 特别注意，我们使用这样一个表达式来从给定对象中提取元方法

```lua
metatable(obj)[event]
```
这个应该被解读作

```lua
rawget(getmetatable(obj) or {}, event)
```
 
这就是说，访问一个元方法不再会触发任何的元方法， 而且访问一个没有 metatable 的对象也不会失败（而只是简单返回 nil）。

`"add": +` 操作。

下面这个 getbinhandler 函数定义了 Lua 怎样选择一个处理器来作二元操作。 首先，Lua 尝试第一个操作数。 如果这个东西的类型没有定义这个操作的处理器，然后 Lua 会尝试第二个操作数。

```lua
function getbinhandler (op1, op2, event)
	return metatable(op1)[event] or metatable(op2)[event]
end
```
通过这个函数， op1 + op2 的行为就是

```lua
function add_event (op1, op2)
	local o1, o2 = tonumber(op1), tonumber(op2)
	if o1 and o2 then  -- 两个操作数都是数字？
		return o1 + o2   -- 这里的 '+' 是原生的 'add'
	else  -- 至少一个操作数不是数字时
		local h = getbinhandler(op1, op2, "__add")
		if h then
			-- 以两个操作数来调用处理器
			return h(op1, op2)
		else  -- 没有处理器：缺省行为
			error(···)
		end
	end
end
```

##Lua 协同程序(coroutine)

Lua 协同程序(coroutine)与线程比较类似：拥有独立的堆栈，独立的局部变量，独立的指令指针，同时又与其它协同程序共享全局变量和其它大部分东西。

coroutine创建的所谓的“线程”都不是真正的操作系统的线程，实际上是通过保存stack状态来模拟的。<br>
由于是假的线程，所以切换线程的开销极小，同时创建线程也是轻量级的，new_thread只是在内存新建了一个stack用于存放新coroutine的变量，也称作lua_State

**Why coroutine**

* 每个coroutine有自己私有的stack及局部变量。
* 同一时间只有一个coroutine在执行，无需对全局变量加锁。
* 顺序可控，完全由程序控制执行的顺序。而通常的多线程一旦启动，它的运行时序是没法预测的，因此通常会给测试所有的情况带来困难。所以能用coroutine解决的场合应当优先使用coroutine。

**线程和协同程序区别**

线程与协同程序的主要区别在于，一个具有多个线程的程序可以同时运行几个线程，而协同程序却需要彼此协作的运行。

在任一指定时刻只有一个协同程序在运行，并且这个正在运行的协同程序只有在明确的被要求挂起的时候才会被挂起。

协同程序有点类似同步的多线程，在等待同一个线程锁的几个线程有点类似协同。

| 方法	| 描述 |
| ------------ | ------------- |
| coroutine.create() | 创建coroutine，返回thread， 参数是一个函数，当和resume配合使用的时候就唤醒函数调用 |
| coroutine.resume() | 重启coroutine，和create配合使用 |
|coroutine.yield() | 挂起coroutine，将coroutine设置为挂起状态，这个和resume配合使用能有很多有用的效果 |
| coroutine.status() | 查看coroutine的状态<br>注：coroutine的状态有三种：dead，suspend，running，具体什么时候有这样的状态请参考下面的程序 |
| coroutine.wrap（） | 创建coroutine，返回一个函数，一旦你调用这个函数，就进入coroutine，和create功能重复 |
| coroutine.running() | 返回正在跑的coroutine，一个coroutine就是一个线程，当使用running的时候，就是返回一个corouting的线程号 |

在create 完成后，该coroutine 并没有立即运行。我们可以用函数status 来查看该coroutine 的状态：

```lua
co = coroutine.create(function() print("hi") end);
print(coroutine.status(co)); -- suspended
```

函数coroutine.resume （恢复）运行该coroutine，将其状态从suspended变为running：
在该示例中，该coroutine运行，简单地输出一个“hi”就结束了，该coroutine变为dead状态：

```lua
co = coroutine.create(function() print("hi") end);
print(coroutine.status(co)); -- suspended
coroutine.resume(co); --running
print(coroutine.status(co)); -- dead
```

当你第一次调用 coroutine.resume 时， 所需传入的第一个参数就是 coroutine.create 的返回值。 这时，coroutine 从主函数的第一行开始运行。 接下来传入 coroutine.resume 的参数将被传进 coroutine 的主函数。 在 coroutine 开始运行后，它讲运行到自身终止或是遇到一个 yields 。

```lua
function foo (a)
    print("foo 函数输出", a)
    return coroutine.yield(2 * a) -- 返回  2*a 的值
end
 
co = coroutine.create(function (a , b)
    print("第一次协同程序执行输出", a, b) -- co-body 1 10
    local r = foo(a + 1)
     
    print("第二次协同程序执行输出", r)
    local r, s = coroutine.yield(a + b, a - b)  -- a，b的值为第一次调用协同程序时传入
     
    print("第三次协同程序执行输出", r, s)
    return b, "结束协同程序"                   -- b的值为第二次调用协同程序时传入
end)
        
--调用resume，将协同程序唤醒,resume操作成功返回true，否则返回false；
--协同程序运行；
--运行到yield语句；
--yield挂起协同程序，第一次resume返回；（注意：此处yield返回，参数是resume的参数）
print("main", coroutine.resume(co, 1, 10))
--第一次协同程序执行输出	1	10
--foo 函数输出	2
--main	true	4

print("--分割线----")

--第二次resume，再次唤醒协同程序；（注意：此处resume的参数中，除了第一个参数，剩下的参数将作为yield的参数）
--yield返回；
	
print("main", coroutine.resume(co, "r"))
print("---分割线---")
--第二次协同程序执行输出	r
--main	true	11	-9

--分割线程序继续运行；
print("main", coroutine.resume(co, "x", "y"))
--第三次协同程序执行输出	x	y
--main	true	10	结束协同程序

print("---分割线---")

--如果使用的协同程序继续运行完成后继续调用 resume方法则输出：cannot resume dead coroutine
print("main", coroutine.resume(co, "x", "y"))
--main	false	cannot resume dead coroutine

print("---分割线---")

	
--分割线----
第二次协同程序执行输出	r
main	true	11	-9
---分割线---
第三次协同程序执行输出	x	y
main	true	10	结束协同程序
---分割线---
main	false	cannot resume dead coroutine
---分割线---
```

**了解resume yield的返回值概念**

```lua
co = coroutine.create(function (a, b)
	--第一次resume，主函数带入的是resume里面的参数
	print("parmeters", a, b);
	--coroutine.yield停止的是该行语句上面的，不包括这行本身，但是返回的内容为yield()里面的参数
	print("yield", coroutine.yield(a+b, "yieldPrameters"));
	--yield之后，第二次resume，开始执行该行语句，yield的返回值为第二次resume带入的参数1,2,4
	--resume的返回值值为return的结果，若没return值，返回 resume 的true/false
	return "result"
end)
print("resume", coroutine.resume(co, 1, 2, 4))
print("resume", coroutine.resume(co, 1, 2, 4))

--[[
执行结果
parmeters	1	2
resume	true	3	yieldPrameters
yield	1	2	4
resume	true	result
]]
```

##错误处理

**assert**

实例中assert首先检查第一个参数，若没问题，assert不做任何事情；否则，assert以第二个参数作为错误信息抛出。

```lua
assert(type(a) == "number", "a 不是一个数字")
```

**error**

```lua
error (message [, level])
```

Level参数指示获得错误的位置:

* Level=1[默认]：为调用error位置(文件+行号)
* Level=2：指出哪个调用error的函数的函数
* Level=0:不添加错误位置信息
    

**pcall 和 xpcall**

pcall接收一个函数和要传递个后者的参数，并执行，执行结果：有错误、无错误；返回值true或者或false, errorinfo。
语法格式如下<br>

```lua
if pcall(function_name, ….) then
-- 没有错误
else
-- 一些错误
end
```

Lua提供了xpcall函数，xpcall接收第二个参数——一个错误处理函数，当错误发生时，Lua会在调用桟展看（unwind）前调用错误处理函数，于是就可以在这个函数中使用debug库来获取关于错误的额外信息了。
debug库提供了两个通用的错误处理函数:

* debug.debug：提供一个Lua提示符，让用户来价差错误的原因
* debug.traceback：根据调用桟来构建一个扩展的错误消息


例：

```lua
function myfunction ()
   n = n/nil
end

function myerrorhandler( err )
   print( "ERROR:", err )
end

status = xpcall( myfunction, myerrorhandler )
print( status)

--ERROR:	test2.lua:2: attempt to perform arithmetic on global 'n' (a nil value)
--false
```

**debug**

...

##Lua面向对象

```lua
-- Meta class
Shape = {area = 0}
-- 基础类方法 new
function Shape:new (o,side)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  side = side or 0
  self.area = side*side;
  return o
end
-- 基础类方法 printArea
function Shape:printArea ()
  print("面积为 ",self.area)
end

-- 创建对象
myshape = Shape:new(nil,10)
myshape:printArea()

Square = Shape:new()
-- 派生类方法 new
function Square:new (o,side)
  o = o or Shape:new(o,side)
  setmetatable(o, self)
  self.__index = self
  return o
end

-- 派生类方法 printArea
function Square:printArea ()
  print("正方形面积为 ",self.area)
end

-- 创建对象
mysquare = Square:new(nil,10)
mysquare:printArea()

Rectangle = Shape:new()
-- 派生类方法 new
function Rectangle:new (o,length,breadth)
  o = o or Shape:new(o)
  setmetatable(o, self)
  self.__index = self
  self.area = length * breadth
  return o
end

-- 派生类方法 printArea
function Rectangle:printArea ()
  print("矩形面积为 ",self.area)
end

-- 创建对象
myrectangle = Rectangle:new(nil,10,20)
myrectangle:printArea()

-- 面积为 	100
-- 正方形面积为 	100
-- 矩形面积为 	200
```