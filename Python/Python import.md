## Python import

Python import 的定义和可能碰到的问题

```python
<module> import * 
from <package> import *
```

下面以 `something.py` 为例子:

```python
# something.py

public_variable = 42
_private_variable = 141

def public_function():
    print("I'm a public function! yay!")

def _private_function():
    print("Ain't nobody accessing me from another module...usually")

class PublicClass(object):
    pass

class _WeirdClass(object):
    pass
In the Python Interpreter, we can execute from something import * and see the following:

>>> from something import *
>>> public_variable
42
>>> _private_variable
...
NameError: name '_private_variable' is not defined
>>> public_function()
"I'm a public function! yay!"
>>> _private_function()
...
NameError: name '_private_function' is not defined
>>> c = PublicClass()
>>> c
<something.PublicClass object at ...>
>>> c = _WeirdClass()
...
NameError: name '_WeirdClass' is not defined
So, from something import * imports all the names from something other than the names that start with an _; because they are conventionally meant to be private.
```

可以看出 `import` 的默认定义会把 `_` 下划线开头的变量，方法，类等看成是 `private`。
这里我们会我们先看一下 `__slots__`

### `__all__`显式列表

`__all__` 是模块的显示列表，他非常具体清晰的表明该模块可以适用哪些变量，方法，类。

```python
# something.py

__all__ = ['_private_variable', 'PublicClass']

# The rest is the same as before

public_variable = 42
_private_variable = 141

def public_function():
    print("I'm a public function! yay!")

def _private_function():
    print("Ain't nobody accessing me from another module...usually")

class PublicClass(object):
    pass

class _WeirdClass(object):
    pass
Now, we expect from something import * to only import the _private_variable and PublicClass names:

>>> from something import *
>>> public_variable
...
NameError: name 'public_variable' is not defined
>>> _private_variable
0
>>> public_function()
...
NameError: name 'public_function' is not defined
>>> _private_function()
...
NameError: name '_private_function' is not defined
>>> c = PublicClass()
>>> c
<something.PublicClass object at ...>
>>> c = _WeirdClass()
...
NameError: name '_WeirdClass' is not defined
```

但这也可能产生不必要的麻烦：

假设 `something ` 为 John 写的代码，以前我们按照上面的例子适用 `'_private_variable', 'PublicClass'` ，但这时候 John 在没有通知我们的情况下，删除了 `__all__` 的代码，那么我们的 `'_private_variable'` 肯定会报错。

所以平常情况下不建议适用 `__all__` 。

## 参考
[importing-star-in-python](https://shahriar.svbtle.com/importing-star-in-python)
