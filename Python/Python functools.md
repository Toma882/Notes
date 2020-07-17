# functools

functools 模块用于高阶函数：作用于或返回其他函数的函数。 一般来说，任何可调用对象都可以被视为用于此模块的函数。


* [Python3 functools doc](https://docs.python.org/3/library/functools.html)
* [Python2 functolls doc](https://docs.python.org/2/library/functools.html)



以下为 Python2 例子，介绍常用的几个函数

### `functools.partial(func[,*args][, **keywords])`

偏函数是将所要承载的函数作为 `partial()` 函数的第一个参数，原函数的各个参数依次作为 `partial()` 函数后续的参数，除非使用关键字参数。 

```python
# 可以理解为 一个常用的函数 int 的 参数 base 设定 一个常用的特定函数常量 2 取一个 函数名称 int2”
int2 = functools.partial(int, base=2)
int2('1000000')
# 64
```

```
def partial(func, *args, **keywords):
    def newfunc(*fargs, **fkeywords):
        newkeywords = keywords.copy()
        newkeywords.update(fkeywords)
        return func(*(args + fargs), **newkeywords)
    newfunc.func = func
    newfunc.args = args
    newfunc.keywords = keywords
    return newfunc
```

```python
from functools import partial

def mod( n, m ):
  return n % m

mod_by_100 = partial( mod, 100 )

print mod( 100, 7 )  # 2
print mod_by_100( 7 )  # 2

def int2(x, base=2):
    return int(x, base)
>>> int2('1000000')
64
>>> int2('1010101')
85

>>> import functools
>>> int2 = functools.partial(int, base=2)
>>> int2('1000000')
64
>>> int2('1010101')
85

```

### `functools.update_wrapper(wrapper, wrapped[, assigned][, updated])`

> 先了解 [模块内置方法 `__name__` 和 `__doc__` 等](Python Class 类.md)。

默认 `partial` 对象没有 [`__name__` 和 `__doc__`](Python Class 类.md) 等, 这种情况下，对于装饰器函数非常难以 `debug`。使用 `update_wrapper()`,从原始对象拷贝或加入现有 `partial` 对象。可选参数是元组，用于指定原始函数的哪些属性直接分配给包装器函数上的匹配属性，以及包装器函数的哪些属性使用原始函数的相应属性更新。这些参数的默认值是模块级别常量 `WRAPPER_ASSIGNMENTS`（分配给包装函数的`__name__，__module__和__doc__`，文档字符串）和 `WRAPPER_UPDATES`（更新包装函数的 `__dict__`，即实例字典）

```python
#!/usr/bin/env python
# encoding: utf-8

def wrap(func):
    def call_it(*args, **kwargs):
        """wrap func: call_it"""
        print 'before call'
        return func(*args, **kwargs)
    return call_it

@wrap
def hello():
    """say hello"""
    print 'hello world'

from functools import update_wrapper
def wrap2(func):
    def call_it(*args, **kwargs):
        """wrap func: call_it2"""
        print 'before call'
        return func(*args, **kwargs)
    return update_wrapper(call_it, func)

@wrap2
def hello2():
    """test hello"""
    print 'hello world2'

if __name__ == '__main__':
    hello()
    print hello.__name__
    print hello.__doc__

    hello2()
    print hello2.__name__
    print hello2.__doc__

得到结果：

before call
hello world
call_it
wrap func: call_it

before call
hello world2
hello2
test hello
```

### `functools.wraps(wrapped[, assigned][, updated])`

作为一个函数装饰器，用于方便在定义包装器函数时调用`update_wrapper（）`。

这个函数相当于 `partial(update_wrapper, wrapped=wrapped, assigned=assigned, updated=updated)`。

```python
>>>
>>> from functools import wraps
>>> def my_decorator(f):
...     @wraps(f)
...     def wrapper(*args, **kwds):
...         print 'Calling decorated function'
...         return f(*args, **kwds)
...     return wrapper
...
>>> @my_decorator
... def example():
...     """Docstring"""
...     print 'Called example function'
...
>>> example()
Calling decorated function
Called example function
>>> example.__name__
'example'
>>> example.__doc__
'Docstring'
Without the use of this decorator factory, the name of the example function would have been 'wrapper', and the docstring of the original example() would have been lost.
```


```python
from functools import wraps
def wrap3(func):
    @wraps(func)
    def call_it(*args, **kwargs):
        """wrap func: call_it2"""
        print 'before call'
        return func(*args, **kwargs)
    return call_it

@wrap3
def hello3():
    """test hello 3"""
    print 'hello world3'

if __name__ == '__main__':
    hello3()
    print hello3.__name__
    print hello3.__doc__
    
结果

before call
hello world3
hello3
test hello 3
```



### `functools.reduce(function, iterable[, initializer])`

等同于 `reduce` 函数

```python
def reduce(function, iterable, initializer=None):
    it = iter(iterable)
    if initializer is None:
        try:
            initializer = next(it)
        except StopIteration:
            raise TypeError('reduce() of empty sequence with no initial value')
    accum_value = initializer
    for x in it:
        accum_value = function(accum_value, x)
    return accum_value
```
注意第二个参数 `iterable ` 就能理解了

```python
#reduce
>>> from functools import reduce
>>> def fn(x, y):
...     return x * 10 + y
...
>>> reduce(fn, [1, 3, 5, 7, 9])
13579

#可以接受一个list并利用reduce()求积：
from functools import reduce
def prod(L):
    return reduce(jj, L)
    
def jj(x, y):
    return x*y;
print('3 * 5 * 7 * 9 =', prod([3, 5, 7, 9]))

```

### `functools.total_ordering(cls)`

```
x<y calls x.__lt__(y),              less than
x<=y calls x.__le__(y),             less than && equal
x==y calls x.__eq__(y),             equal
x!=y and x<>y call x.__ne__(y),     not equeal
x>y calls x.__gt__(y),              greater than
x>=y calls x.__ge__(y)              greater than && equal
```

若 class 函数有 `__eq__()` 方法，并且还有 `__lt__(), __le__(), __gt__(), __ge__()` 其中的一个方法，则 `functools.total_ordering` 会补充没有定义的其他函数。

```python
@total_ordering
class Student:
    def __eq__(self, other):
        return ((self.lastname.lower(), self.firstname.lower()) ==
                (other.lastname.lower(), other.firstname.lower()))
    def __lt__(self, other):
        return ((self.lastname.lower(), self.firstname.lower()) <
                (other.lastname.lower(), other.firstname.lower()))
print dir(Student)

# result:
# ['__doc__', '__eq__', '__ge__', '__gt__', '__le__', '__lt__', '__module__']
```

其他：
### `functools.cmp_to_key(func)`

## 参考

* [Python2 functolls doc](https://docs.python.org/2/library/functools.html)
* [Python教程 - 廖雪峰](http://www.liaoxuefeng.com/)