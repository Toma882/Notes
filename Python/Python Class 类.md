## 模块 Module/Package

### 定义 Module/Package
* 一个`.py`文件就称之为一个模块 `Module`
* 为了避免模块名冲突，Python又引入了按目录来组织模块的方法，称为包 `Package`
* 每一个包目录下面都会有一个 `__init__.py` 的文件，这个文件是必须存在的，否则，Python就把这个目录当成普通目录，而不是一个包
* 方法是选择一个顶层包名，比如 `mycompany`，现在，`abc.py` 模块的名字就变成了 `mycompany.abc`，类似的，`xyz.py`的模块名变成了 `mycompany.xyz`

### Import
[Import in Python](Python import *.md)

### 模块搜索路径
默认情况下，Python解释器会搜索当前目录、所有已安装的内置模块和第三方模块，搜索路径存放在`sys`模块的`path`变量中：

```python
>>> import sys
>>> sys.path
['', '/usr/local/Cellar/python3/3.5.1/Frameworks/Python.framework/Versions/3.5/lib/python35.zip', '/usr/local/Cellar/python3/3.5.1/Frameworks/Python.framework/Versions/3.5/lib/python3.5', '/usr/local/Cellar/python3/3.5.1/Frameworks/Python.framework/Versions/3.5/lib/python3.5/plat-darwin', '/usr/local/Cellar/python3/3.5.1/Frameworks/Python.framework/Versions/3.5/lib/python3.5/lib-dynload', '/usr/local/lib/python3.5/site-packages']
```

如果我们要添加自己的搜索目录，有两种方法：

一是直接修改`sys.path`，添加要搜索的目录：

```python
>>> import sys
>>> sys.path.append('/Users/michael/my_py_scripts')
```

第二种方法是设置环境变量`PYTHONPATH`

该环境变量的内容会被自动添加到模块搜索路径中。设置方式与设置`Path`环境变量类似。注意只需要添加你自己的搜索路径，Python自己本身的搜索路径不受影响。

## 模块 Module

### 内置方法
#### `__name__`
`__name__` 是模块内置的一个属性, 一般如果模块是被引用的时候, 它的值是模块名, 如果这个 python 文件被直接运行, 那么它的值是`__main__`

```python
>>> __name__
'__main__'
>>> import os
>>> os.__name__
'os'
```

所以我们写一个脚本的时候,通过判断 `__name__` 来确定脚本是被引用, 还是被直接运行

```python
if __name__ == `__main__`:
    main()
```

#### `__doc__`
模块的注释文档

```python
class MyClass:
    """这是MyClass的注释, 
    调用下面myClass.__doc__的时候会返回这段内容"""

    def funcA(self):
        """这是funcA的注释文档"""
        return "hello"

myClass = MyClass()
```

调用 `myClass.__doc__` 会返回 `MyClass`的注释文档, `myClass.funcA.__doc__` 会返回 `funcA` 的注释文档

#### `__file__`
被引用模块文件的路径

```python
>>> import os
>>> os.__file__
'/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/os.pyc'
```

#### `__package__`
`__package__` 主要是为了相对引用而设置的一个属性, 如果所在的文件是一个 `package` 的话, 它和 `__name__` 的值是一样的, 如果是子模块的话, 它的值就跟父模块一致

比如 `modA/modB/aa.py` 中 `__name__` 的值是 `modA.modB.aa __package__` 是 `modA.modB`
`modA/modB/__init__.py` 中 `__name__` 和 `__package__` 的值都是 `modA.modB`

## 类 Class

### 限制实例的属性`__slots__`

比如，只允许对Student实例添加name和age属性。

```python
class Student(object):
    __slots__ = ('name', 'age') # 用tuple定义允许绑定的属性名称

>>> s = Student() # 创建新的实例
>>> s.name = 'Michael' # 绑定属性'name'
>>> s.age = 25 # 绑定属性'age'
>>> s.score = 99 # 绑定属性'score'
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Student' object has no attribute 'score'

# 使用__slots__要注意，__slots__定义的属性仅对当前类实例起作用，对继承的子类是不起作用的：
>>> class GraduateStudent(Student):
...     pass
...
>>> g = GraduateStudent()
>>> g.score = 9999
```

### 构造函数 `__init__`

构造函数 `__init__` 同时有对应的解析函数 `__del__`  

`self` 类似 `this`，而 `self.name = name` 竟然可以直接使用并且赋值，  
和其他语言不通，竟然不需要额外定义 name score ...

```python
# object是Student的父类
class Student(object):

    def __init__(self, name, score):
        self.name = name
        self.score = score

>>> bart = Student('Bart Simpson', 59)
>>> bart.name
'Bart Simpson'
>>> bart.score
59
```

### 使用`@property` 控制属性化的 `getter setter`



```python
class Student(object):

    def get_score(self):
         return self._score

    def set_score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value
        
>>> s = Student()
>>> s.set_score(60) # ok!
>>> s.get_score()
60
>>> s.set_score(9999)
Traceback (most recent call last):
  ...
ValueError: score must between 0 ~ 100!


class Student(object):

    @property
    def score(self):
        return self._score

    @score.setter
    def score(self, value):
        if not isinstance(value, int):
            raise ValueError('score must be an integer!')
        if value < 0 or value > 100:
            raise ValueError('score must between 0 ~ 100!')
        self._score = value

>>> s = Student()
>>> s.score = 60 # OK，实际转化为s.set_score(60)
>>> s.score # OK，实际转化为s.get_score()
60
>>> s.score = 9999
Traceback (most recent call last):
  ...
ValueError: score must between 0 ~ 100!

#创建只读属性 age
class Student(object):

    @property
    def birth(self):
        return self._birth

    @birth.setter
    def birth(self, value):
        self._birth = value

    @property
    def age(self):
        return 2015 - self._birth


```

### 多重继承

```python
class Runnable(object):
    def run(self):
        print('Running...')

class Flyable(object):
    def fly(self):
        print('Flying...')
        
#对于需要Runnable功能的动物，就多继承一个Runnable，例如Dog：
class Dog(Mammal, Runnable):
    pass
#对于需要Flyable功能的动物，就多继承一个Flyable，例如Bat：
class Bat(Mammal, Flyable):
    pass
```

### `__iter__` Iterable 可迭代对象

如果一个类想被用于`for ... in`循环，类似list或tuple那样，就必须实现一个`__iter__()`方法，该方法返回一个迭代对象，然后，Python的`for`循环就会不断调用该迭代对象的`__iter__()`方法拿到循环的下一个值，直到遇到`StopIteration`错误时退出循环。

我们以斐波那契数列为例，写一个`Fib`类，可以作用于`for`循环：

```python
class Fib(object):
    def __init__(self):
        self.a, self.b = 0, 1 # 初始化两个计数器a，b

    def __iter__(self):
        return self # 实例本身就是迭代对象，故返回自己

    def __next__(self):
        self.a, self.b = self.b, self.a + self.b # 计算下一个值
        if self.a > 100000: # 退出循环的条件
            raise StopIteration();
        return self.a # 返回下一个值
        
>>> for n in Fib():
...     print(n)
...
1
1
2
3
5
...
46368
75025
```

### `__getitem__`获得 Object[?] 的值

```python
# Fib实例虽然能作用于for循环，看起来和list有点像，但是，把它当成list来使用还是不行，比如，取第5个元素：
>>> Fib()[5]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'Fib' object does not support indexing

# 要表现得像list那样按照下标取出元素，需要实现__getitem__()方法：
class Fib(object):
    def __getitem__(self, n):
        a, b = 1, 1
        for x in range(n):
            a, b = b, a + b
        return a

# 现在，就可以按下标访问数列的任意一项了：
>>> f = Fib()
>>> f[0]
1
>>> f[1]
1
>>> f[2]
2
>>> f[3]
3
>>> f[10]
89
>>> f[100]
573147844013817084101

# 但是list有个神奇的切片方法：
>>> list(range(100))[5:10]
[5, 6, 7, 8, 9]

# 对于Fib却报错。原因是__getitem__()传入的参数可能是一个int，也可能是一个切片对象slice，所以要做判断：
class Fib(object):
    def __getitem__(self, n):
        if isinstance(n, int): # n是索引
            a, b = 1, 1
            for x in range(n):
                a, b = b, a + b
            return a
        if isinstance(n, slice): # n是切片
            start = n.start
            stop = n.stop
            if start is None:
                start = 0
            a, b = 1, 1
            L = []
            for x in range(stop):
                if x >= start:
                    L.append(a)
                a, b = b, a + b
            return L
            
#现在试试Fib的切片：
>>> f = Fib()
>>> f[0:5]
[1, 1, 2, 3, 5]
>>> f[:10]
[1, 1, 2, 3, 5, 8, 13, 21, 34, 55]


```

### Chain

现在很多网站都搞REST API，比如新浪微博、豆瓣啥的，调用API的URL类似：

`http://api.server/user/friends`

`http://api.server/user/timeline/list`


如果要写SDK，给每个URL对应的API都写一个方法，那得累死，而且，API一旦改动，SDK也要改。


```python
class Chain(object):

    def __init__(self, path=''):
        self._path = path

    def __getattr__(self, path):
        return Chain('%s/%s' % (self._path, path))

    def __str__(self):
        return self._path

    __repr__ = __str__
    
>>> Chain().status.user.timeline.list
'/status/user/timeline/list'

#这样，无论API怎么变，SDK都可以根据URL实现完全动态的调用，而且，不随API的增加而改变！
#还有些REST API会把参数放到URL中，比如GitHub的API：
GET /users/:user/repos

#调用时，需要把:user替换为实际用户名。如果我们能写出这样的链式调用：
Chain().users('michael').repos

```

### `__call__`

一个对象实例可以有自己的属性和方法，当我们调用实例方法时，我们用`instance.method()`来调用。能不能直接在实例本身上调用呢？在Python中，答案是肯定的。

任何类，只需要定义一个`__call__()`方法，就可以直接对实例进行调用。请看示例：

```python

class Student(object):
    def __init__(self, name):
        self.name = name

    def __call__(self):
        print('My name is %s.' % self.name)
        
>>> s = Student('Michael')
>>> s() # self参数不要传入
My name is Michael.

#通过callable()函数，我们就可以判断一个对象是否是“可调用”对象。
>>> callable(Student())
True
>>> callable(max)
True
>>> callable([1, 2, 3])
False
>>> callable(None)
False
>>> callable('str')
False
```

### type

```python
>>> from hello import Hello
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class 'hello.Hello'>
```

`type()`函数既可以返回一个对象的类型，又可以创建出新的类型，比如，我们可以通过`type()`函数创建出Hello类，而无需通过`class Hello(object)...`的定义

要创建一个class对象，`type()`函数依次传入3个参数：

* class的名称；
* 继承的父类集合，注意Python支持多重继承，如果只有一个父类，别忘了`tuple`的单元素写法；
* class的方法名称与函数绑定，这里我们把函数fn绑定到方法名hello上。

```python
>>> def fn(self, name='world'): # 先定义函数
...     print('Hello, %s.' % name)
...
>>> Hello = type('Hello', (object,), dict(hello=fn)) # 创建Hello class
>>> h = Hello()
>>> h.hello()
Hello, world.
>>> print(type(Hello))
<class 'type'>
>>> print(type(h))
<class '__main__.Hello'>
```

### metaclass

除了使用`type()`动态创建类以外，要控制类的创建行为，还可以使用`metaclass`。

先定义`metaclass`，就可以创建类，最后创建实例。

当用户定义一个`class User(Model)`时，Python解释器首先在当前类User的定义中查找`metaclass`，如果没有找到，就继续在父类`Model`中查找`metaclass`，找到了，就使用`Model`中定义的`metaclass`的`ModelMetaclass`来创建`User`类，也就是说，`metaclass`可以隐式地继承到子类，但子类自己却感觉不到。

在`ModelMetaclass`中，一共做了几件事情：

* 排除掉对Model类的修改；
* 在当前类（比如User）中查找定义的类的所有属性，如果找到一个Field属性，就把它保存到一个`__mappings__`的`dict`中，同时从类属性中删除该`Field`属性，否则，容易造成运行时错误（实例的属性会遮盖类的同名属性）；
* 把表名保存到`__table__`中，这里简化为表名默认为类名。

在`Model`类中，就可以定义各种操作数据库的方法，比如`save()`，`delete()`，`find()`，`update`等等。

我们实现了`save()`方法，把一个实例保存到数据库中。因为有表名，属性到字段的映射和属性值的集合，就可以构造出`INSERT`语句。

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
class Field(object):

    def __init__(self, name, column_type):
        self.name = name
        self.column_type = column_type

    def __str__(self):
        return '<%s:%s>' % (self.__class__.__name__, self.name)

class StringField(Field):

    def __init__(self, name):
        super(StringField, self).__init__(name, 'varchar(100)')

class IntegerField(Field):

    def __init__(self, name):
        super(IntegerField, self).__init__(name, 'bigint')

class ModelMetaclass(type):

    def __new__(cls, name, bases, attrs):
        if name=='Model':
            return type.__new__(cls, name, bases, attrs)
        print('Found model: %s' % name)
        mappings = dict()
        for k, v in attrs.items():
            if isinstance(v, Field):
                print('Found mapping: %s ==> %s' % (k, v))
                mappings[k] = v
        for k in mappings.keys():
            attrs.pop(k)
        attrs['__mappings__'] = mappings # 保存属性和列的映射关系
        attrs['__table__'] = name # 假设表名和类名一致
        return type.__new__(cls, name, bases, attrs)

class Model(dict, metaclass=ModelMetaclass):

    def __init__(self, **kw):
        super(Model, self).__init__(**kw)

    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(r"'Model' object has no attribute '%s'" % key)

    def __setattr__(self, key, value):
        self[key] = value

    def save(self):
        fields = []
        params = []
        args = []
        for k, v in self.__mappings__.items():
            fields.append(v.name)
            params.append('?')
            args.append(getattr(self, k, None))
        sql = 'insert into %s (%s) values (%s)' % (self.__table__, ','.join(fields), ','.join(params))
        print('SQL: %s' % sql)
        print('ARGS: %s' % str(args))

class User(Model):
    # 定义类的属性到列的映射：
    id = IntegerField('id')
    name = StringField('username')
    email = StringField('email')
    password = StringField('password')

# 创建一个实例：
u = User(id=12345, name='Michael', email='test@orm.org', password='my-pwd')
# 保存到数据库：
u.save()
```
