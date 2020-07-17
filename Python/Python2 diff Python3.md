# Key Differences between Python2 & Python3

## 前言
虽然开始就学Python3，并且也想一直用Python3，但实际用到项目中，很多类库和支持都只支持Python2，或者正在开发Python3的版本，而且相对来说支持Python2的更加稳定。

## future 模块
Python 3.x 介绍的 一些Python 2 不兼容的关键字和特性可以通过在 Python 2 的内置 `__future__` 模块导入。如果你计划让你的代码支持 Python 3.x，建议你使用 `__future__` 模块导入。例如，如果我想要 在Python 2 中表现 Python 3.x 中的整除，我们可以通过如下导入

`from __future__ import division`

更多的 `__future__` 模块可被导入的特性被列在下表中：

feature |	optional in | mandatory in | effect
--- | --- | --- | ---
nested_scopes |	2.1.0b1 |	2.2 |	PEP 227: Statically Nested Scopes
generators |	2.2.0a1 |	2.3	 |	PEP 255: Simple Generators
division |	2.2.0a2 |	3.0	 |	PEP 238: Changing the Division Operator
absolute_import | 2.5.0a1 |	3.0	 |	PEP 328: Imports: Multi-Line and Absolute/Relative
with_statement |	2.5.0a1 |	2.6	 |	PEP 343: The “with” Statement
print_function |	2.6.0a2 |	3.0	 |	PEP 3105: Make print a function
unicode_literals | 2.6.0a2 |	3.0	 |	PEP 3112: Bytes literals in Python 3000

## import
一般情况情况下，import时没什么烦恼，只要正确的导入就行，但在下面代码中，我们想导入urlopen()函数，在Python2中，他同时存在与urllib2和urllib2中（我们使用后者），在Python3中，他被集成到了urllib.request中，而你的方案是要既能在2.x和3.x中正常工作：

```python
try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen
```

出于对内存的保护，也许你对iterator(Python3)版本的zip()更加有兴趣，在Python2中，iterator版本是itertools.izip()。这个函数在Python3中被重命名替换成了zip()。如果你使用迭代版本，导入语句也非常直白：

```python
try:
    from itertools import izip as zip
except ImportError:
    pass
```

另一个列子是看来来并不怎么优雅的StringIO类，在Python2中，纯Python版本是StringIO模块，意味着访问的时候是通过StringIO.StringIO，同样还有一个更为快速的C语言版本，位于cStringIO.StringIO，不过这取决你的Python安装版本，你可以优先使用cStringIO然后是StringIO（如果cStringIO不能用的话)。在Python3中，Unicode是默认的string类型，但是如果你做任何和网络相关的操作，很有可能你不得不用ASCII/字节字符串来操作，所以代替StringIO，你要io.BytesIO，为了达到你想要的，这个导入看起来有点丑：

```python
try:
    from io import BytesIO as StringIO
except ImportError:
    try:
        from cStringIO import StringIO
    except ImportError:
        from StringIO import StringIO
```
## print
python2

```python
print 'Python', python_version()
print 'Hello, World!'
print('Hello, World!')
print "text", ; print 'print more text on the same line'

//result
Python 2.7.6
Hello, World!
Hello, World!
text print more text on the same line
```

python3

```python
print('Python', python_version())
print('Hello, World!')
print("some text,", end="") 
print(' print more text on the same line')

//result
Python 3.4.1
Hello, World!
some text, print more text on the same line
```

推荐方式：
`print` 在 Python 2 中是一个声明，而不是一个函数调用

```python
from __future__ import print_function
print('Hello, World!')
```

## Division

使用一个 `float(3)/2` 或 `3/2.0` 代替在我的 Python 3 脚本保存在 Python 2 中的 `3/2` 的一些麻烦

Python 2

```python
print 'Python', python_version()
print '3 / 2 =', 3 / 2
print '3 // 2 =', 3 // 2
print '3 / 2.0 =', 3 / 2.0
print '3 // 2.0 =', 3 // 2.0

# result:
Python 2.7.6
3 / 2 = 1
3 // 2 = 1
3 / 2.0 = 1.5
3 // 2.0 = 1.0
```

Python 3

```python
print('Python', python_version())
print('3 / 2 =', 3 / 2)
print('3 // 2 =', 3 // 2)
print('3 / 2.0 =', 3 / 2.0)
print('3 // 2.0 =', 3 // 2.0)

# result:
3 / 2 = 1.5
3 // 2 = 1
3 / 2.0 = 1.5
3 // 2.0 = 1.0
```

推荐方式：

```python
# 引入新规则
from __future__ import division
# 改变写法
float(3)/2
```

## Unicode
Python 2 有 `ASCII str()` 类型，`unicode()` 是单独的，不是 `byte` 类型。
Python2的 unicode 类型前面为 `u""`。

现在， 在 Python 3，我们最终有了 `Unicode (utf-8)` 字符串，以及一个字节类：`byte` 和 `bytearrays`。

Python 2

```python
print 'Python', python_version()
# Python 2.7.6

print type(unicode('this is like a python3 str type'))
# <type 'unicode'>

print type(b'byte type does not exist')
# <type 'str'>

print 'they are really' + b' the same'
# they are really the same

print type(bytearray(b'bytearray oddly does exist though'))
#<type 'bytearray'>
```

Python 3

```python
print('Python', python_version())
print('strings are now utf-8 \u03BCnico\u0394é!')
#Python 3.4.1
#strings are now utf-8 μnicoΔé!

print('Python', python_version(), end="")
print(' has', type(b' bytes for storing data'))
#Python 3.4.1 has <class 'bytes'>

print('and Python', python_version(), end="")
print(' also has', type(bytearray(b'bytearrays')))
#and Python 3.4.1 also has <class 'bytearray'>

'note that we cannot add a string' + b'bytes for data'

---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-13-d3e8942ccf81> in <module>()
----> 1 'note that we cannot add a string' + b'bytes for data'

TypeError: Can't convert 'bytes' object to str implicitly
```

推荐方式：

```python
from __future__ import unicode_literals
```

## xrange
在 Python 2 中 `xrange()` 创建迭代对象的用法是非常流行的。比如： `for 循环或者是列表/集合/字典推导式`。

这个表现十分像生成器（比如。“惰性求值”）。但是这个 `xrange-iterable` 是无穷的，意味着你可以无限遍历。

由于它的惰性求值，如果你不得仅仅不遍历它一次，`xrange()` 函数 比 `range()` 更快（比如 for 循环）。尽管如此，对比迭代一次，不建议你重复迭代多次，因为生成器每次都从头开始。

在 Python 3 中，`range()` 是像 `xrange()` 那样实现以至于一个专门的 `xrange()` 函数都不再存在（在 Python 3 中 `xrange()` 会抛出命名异常）。

```python
import timeit
n = 10000
def test_range(n):
    return for i in range(n):
        pass

def test_xrange(n):
    for i in xrange(n):
        pass   
```

Python 2

```python
print 'Python', python_version()

print '\ntiming range()' 
%timeit test_range(n)

print '\n\ntiming xrange()' 
%timeit test_xrange(n)

Python 2.7.6

timing range()
1000 loops, best of 3: 433 µs per loop

timing xrange()
1000 loops, best of 3: 350 µs per loop
```

Python 3

```python
print('Python', python_version())

print('\ntiming range()')
%timeit test_range(n)

Python 3.4.1

timing range()
1000 loops, best of 3: 520 µs per loop
```

```python
print(xrange(10))
---------------------------------------------------------------------------
NameError                                 Traceback (most recent call last)
<ipython-input-5-5d8f9b79ea70> in <module>()
----> 1 print(xrange(10))

NameError: name 'xrange' is not defined
```

Python 3 中的 `range` 对象的 `__contains__` 方法

另外一件值得一提的事情就是在 Python 3 中 range 有一个新的 `__contains__` 方法，`__contains__` 方法可以加速 "查找" 在 Python 3.x 中显著的整数和布尔类型。

```python
x = 10000000

def val_in_range(x, val):
    return val in range(x)

def val_in_xrange(x, val):
    return val in xrange(x)

print('Python', python_version())
assert(val_in_range(x, x/2) == True)
assert(val_in_range(x, x//2) == True)
%timeit val_in_range(x, x/2)
%timeit val_in_range(x, x//2)

Python 3.4.1
1 loops, best of 3: 742 ms per loop
1000000 loops, best of 3: 1.19 µs per loop
```

基于以上的 `timeit` 的结果，当它使一个整数类型，而不是浮点类型的时候，你可以看到执行查找的速度是 60000 倍快。尽管如此，因为 Python 2.x 的 `range` 或者是 `xrange` 没有一个 `__contains__` 方法，这个整数类型或者是浮点类型的查询速度不会相差太大。


```python
print 'Python', python_version()
assert(val_in_xrange(x, x/2.0) == True)
assert(val_in_xrange(x, x/2) == True)
assert(val_in_range(x, x/2) == True)
assert(val_in_range(x, x//2) == True)
%timeit val_in_xrange(x, x/2.0)
%timeit val_in_xrange(x, x/2)
%timeit val_in_range(x, x/2.0)
%timeit val_in_range(x, x/2)

Python 2.7.7
1 loops, best of 3: 285 ms per loop
1 loops, best of 3: 179 ms per loop
1 loops, best of 3: 658 ms per loop
1 loops, best of 3: 556 ms per loop
```

下面说下 __contain__ 方法并没有加入到 Python 2.x 中的证据：

```python
print('Python', python_version())
range.__contains__

Python 3.4.1

<slot wrapper '__contains__' of 'range' objects>


print 'Python', python_version()
range.__contains__

Python 2.7.7
---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)
<ipython-input-7-05327350dafb> in <module>()
      1 print 'Python', python_version()
----> 2 range.__contains__

AttributeError: 'builtin_function_or_method' object has no attribute '__contains__'


print 'Python', python_version()
xrange.__contains__

Python 2.7.7
---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)
<ipython-input-8-7d1a71bfee8e> in <module>()
      1 print 'Python', python_version()
----> 2 xrange.__contains__

AttributeError: type object 'xrange' has no attribute '__contains__'
```

**注意在 Python 2 和 Python 3 中速度的不同**

有些猿类指出了 Python 3 的 `range()` 和 Python 2 的 `xrange()` 之间的速度不同。因为他们是用相同的方法实现的，因此期望相同的速度。尽管如此，这事实在于 Python 3 倾向于比 Python 2 运行的慢一点。

```python
def test_while():
    i = 0
    while i < 20000:
        i += 1
    return
print('Python', python_version())
%timeit test_while()

Python 3.4.1
100 loops, best of 3: 2.68 ms per loop
print 'Python', python_version()
%timeit test_while()

Python 2.7.6
1000 loops, best of 3: 1.72 ms per loop
```

## Raising exceptions
Python 2

```python
print 'Python', python_version()

Python 2.7.6

raise IOError, "file error"

---------------------------------------------------------------------------
IOError                                   Traceback (most recent call last)
<ipython-input-8-25f049caebb0> in <module>()
----> 1 raise IOError, "file error"

IOError: file error
raise IOError("file error")

---------------------------------------------------------------------------
IOError                                   Traceback (most recent call last)
<ipython-input-9-6f1c43f525b2> in <module>()
----> 1 raise IOError("file error")

IOError: file error
```

```python
Python 3

print('Python', python_version())

Python 3.4.1
raise IOError, "file error"
  File "<ipython-input-10-25f049caebb0>", line 1
    raise IOError, "file error"
                 ^
SyntaxError: invalid syntax
The proper way to raise an exception in Python 3:

print('Python', python_version())
raise IOError("file error")

Python 3.4.1
---------------------------------------------------------------------------
OSError                                   Traceback (most recent call last)
<ipython-input-11-c350544d15da> in <module>()
      1 print('Python', python_version())
----> 2 raise IOError("file error")

OSError: file error
```

推荐方式：

```python
raise IOError("file error")
```

## Handling exceptions
在 Python 3 中处理异常也轻微的改变了，在 Python 3 中我们现在使用 `as` 作为关键词。

Python 2

```python
print 'Python', python_version()
try:
    let_us_cause_a_NameError
except NameError, err:
    print err, '--> our error message'

Python 2.7.6
name 'let_us_cause_a_NameError' is not defined --> our error message
```

Python 3

```python
print('Python', python_version())
try:
    let_us_cause_a_NameError
except NameError as err:
    print(err, '--> our error message')

Python 3.4.1
name 'let_us_cause_a_NameError' is not defined --> our error message
```

## next() 函数 and .next() 方法

因为 `next() (.next())` 是一个如此普通的使用函数（方法），这里有另外一个语法改变（或者是实现上改变了），值得一提的是：在 Python 2.7.5 中函数和方法你都可以使用，`next()` 函数在 Python 3 中一直保留着（调用 `.next()` 抛出属性异常）。

Python 2

```python
print 'Python', python_version()

my_generator = (letter for letter in 'abcdefg')

next(my_generator)
my_generator.next()

# result
Python 2.7.6
'b'
```

Python 3

```python
print('Python', python_version())

my_generator = (letter for letter in 'abcdefg')

next(my_generator)

# result
Python 3.4.1
'a'

my_generator.next()

---------------------------------------------------------------------------
AttributeError                            Traceback (most recent call last)
<ipython-input-14-125f388bb61b> in <module>()
----> 1 my_generator.next()

AttributeError: 'generator' object has no attribute 'next'
```

## For 循环变量和全局命名空间泄漏

好消息：在 Python 3.x 中 for 循环变量不会再导致命名空间泄漏。

```
"列表推导不再支持 [... for var in item1, item2, ...] 这样的语法。
使用 [... for var in (item1, item2, ...)] 代替。
也需要提醒的是列表推导有不同的语义：  他们关闭了在 `list()` 构造器中的生成器表达式的语法糖,
并且特别是循环控制变量不再泄漏进周围的作用范围域."
```

Python 2

```python
print 'Python', python_version()

i = 1
print 'before: i =', i
print 'comprehension: ', [i for i in range(5)]
print 'after: i =', i

# result
Python 2.7.6
before: i = 1
comprehension:  [0, 1, 2, 3, 4]
after: i = 4
```

Python 3

```python
print('Python', python_version())

i = 1
print('before: i =', i)
print('comprehension:', [i for i in range(5)])
print('after: i =', i)

# result
Python 3.4.1
before: i = 1
comprehension: [0, 1, 2, 3, 4]
after: i = 1
```

## 比较不可排序类型

在 Python 3 中的另外一个变化就是当对不可排序类型做比较的时候，会抛出一个类型错误。

Python 2

```python
print 'Python', python_version()
print "[1, 2] > 'foo' = ", [1, 2] > 'foo'
print "(1, 2) > 'foo' = ", (1, 2) > 'foo'
print "[1, 2] > (1, 2) = ", [1, 2] > (1, 2)

# result
Python 2.7.6
[1, 2] > 'foo' =  False
(1, 2) > 'foo' =  True
[1, 2] > (1, 2) =  False
```

Python 3

```python
print('Python', python_version())
print("[1, 2] > 'foo' = ", [1, 2] > 'foo')
print("(1, 2) > 'foo' = ", (1, 2) > 'foo')
print("[1, 2] > (1, 2) = ", [1, 2] > (1, 2))

# result
Python 3.4.1
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-16-a9031729f4a0> in <module>()
      1 print('Python', python_version())
----> 2 print("[1, 2] > 'foo' = ", [1, 2] > 'foo')
      3 print("(1, 2) > 'foo' = ", (1, 2) > 'foo')
      4 print("[1, 2] > (1, 2) = ", [1, 2] > (1, 2))

TypeError: unorderable types: list() > str()
```

## 通过 input() 解析用户的输入

Python 2

```python
Python 2.7.6 
[GCC 4.0.1 (Apple Inc. build 5493)] on darwin
Type "help", "copyright", "credits" or "license" for more information.

>>> my_input = input('enter a number: ')

enter a number: 123

>>> type(my_input)
<type 'int'>

>>> my_input = raw_input('enter a number: ')

enter a number: 123

>>> type(my_input)
<type 'str'>
```

Python 3

```python
Python 3.4.1 
[GCC 4.2.1 (Apple Inc. build 5577)] on darwin
Type "help", "copyright", "credits" or "license" for more information.

>>> my_input = input('enter a number: ')


enter a number: 123


>>> type(my_input)
<class 'str'>
```

## 返回可迭代对象，而不是列表

如果在 xrange 章节看到的，现在在 Python 3 中一些方法和函数返回迭代对象 -- 代替 Python 2 中的列表

因为我们通常那些遍历只有一次，我认为这个改变对节约内存很有意义。尽管如此，它也是可能的，相对于生成器 --- 如需要遍历多次。它是不那么高效的。

而对于那些情况下，我们真正需要的是列表对象，我们可以通过 `list()` 函数简单的把迭代对象转换成一个列表。

Python 2

```python
print 'Python', python_version() 

print range(3) 
print type(range(3))


Python 2.7.6
[0, 1, 2]
<type 'list'>
```

Python 3

```python
print('Python', python_version())

print(range(3))
print(type(range(3)))
print(list(range(3)))


Python 3.4.1
range(0, 3)
<class 'range'>
[0, 1, 2]
```

在 Python 3 中一些经常使用到的不再返回列表的函数和方法：

```
zip()
map()
filter()
dictionary's .keys() method
dictionary's .values() method
dictionary's .items() method
```

## 参考
[Python 2.7.x 和 Python 3.x 的主要区别](https://segmentfault.com/a/1190000000618286)

移植到 Python 3

* [Should I use Python 2 or Python 3 for my development activity?](https://wiki.python.org/moin/Python2orPython3)
* [What’s New In Python 3.0](https://docs.python.org/3.0/whatsnew/3.0.html)
* [Porting to Python 3](http://python3porting.com/differences.html)
* [Porting Python 2 Code to Python 3](https://docs.python.org/3/howto/pyporting.html)
* [How keep Python 3 moving forward](http://nothingbutsnark.svbtle.com/my-view-on-the-current-state-of-python-3)

Python 3 的拥护者和反对者

* [10 awesome features of Python that you can't use because you refuse to upgrade to Python 3](http://asmeurer.github.io/python3-presentation/slides.html#1)
* [Everything you did not want to know about Unicode in Python 3](http://lucumr.pocoo.org/2014/5/12/everything-about-unicode/)
* [Python 3 is killing Python](https://medium.com/@deliciousrobots/5d2ad703365d/)
* [Python 3 can revive Python](https://medium.com/p/2a7af4788b10)
* [Python 3 is fine](http://sealedabstract.com/rants/python-3-is-fine/)




