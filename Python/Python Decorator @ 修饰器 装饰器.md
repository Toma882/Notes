# Python Decorator @ 修饰器 装饰器

所谓装饰器就是把原函数包装一下，对原函数进行加工，添加一些附加功能，装饰器本身就是一个函数，就是将被装饰的函数当作参数传递给装饰器，返回包装后的函数：

## 装饰函数

```python
def d(fp):
    def _d(*arg, **karg):
        print "do sth before fp.."
        r= fp(*arg, **karg)
        print "do sth after fp.."
        return r
    return _d
 
@d
def f():
    print "call f"

f()

# result    
do sth before fp..
call f
do sth after fp..
```

两个 `@` 装饰符号：

```python
@decorator_one
@decorator_two
def func():
    pass
```

相当于

```python
func = decorator_one(decorator_two(func))
```

注意下面的例子代码没有`main()`调用或者直接的函数调用，结果还是会输出：

```python
#!/usr/bin/python

def test(func):
    func()

@test
def fun():
    print "call fun"
    
# result
call fun
```

`@`修饰符有点像函数指针，python解释器发现执行的时候如果碰到`@`修饰的函数，首先就解析它，找到它对应的函数进行调用，并且会把@修饰下面一行的函数作为一个函数指针传入它对应的函数。有点绕口，这里说的“它对应的函数”就是名字是一样的。下面说下之前代码的解析流程：

1. python解释器发现 `@test`，就去调用 `test` 函数
2. test函数调用预先要指定一个参数，传入的就是@test下面修饰的函数，也就是 `fun()`
3. `test()`函数执行，调用`fun()`，`fun()`打印`“call fun”`


这样调用的话就不会调用test，只有当main函数调用的时候才会进入到main函数，然后调用test:

```python
#!/usr/bin/python

def test(func):
  func()
  print "call test over"

def main():
  @test
  def fun():
    print "call fun"
# main()
```

含参数的装饰器：

```python
import functools
def log(text):
	def decorator(func):
		@funtools.wraps(func)
		def wrapper(*arts, **kw):
			print('%s %s():' % (text, func.__name__))
			return func(*args, **kw)
		return wrapper
	return decorator

@log('execute')
def now():
	print('2015-3-25')

# 执行结果
>>> now();
execute now():
2015-3-25
```

相当于这是对原有装饰器的一个函数封装 `log(text)(function)`

## 装饰类


```python
def decorator(aClass):
    class newClass:
        def __init__(self, age):
            self.total_display   = 0
            self.wrapped         = aClass(age)
        def display(self):
            self.total_display += 1
            print("total display", self.total_display)
            self.wrapped.display()
    return newClass

@decorator
class Bird:
    def __init__(self, age):
        self.age = age
    def display(self):
        print("My age is",self.age)

eagleLord = Bird(5)
for i in range(3):
    eagleLord.display()
    
# result
('total display', 1)
('My age is', 5)
('total display', 2)
('My age is', 5)
('total display', 3)
('My age is', 5)
```

下面这个示例展示了，用类的方式声明一个decorator。我们可以看到这个类中有两个成员：

1. 一个是`__init__()`，这个方法是在我们给某个函数decorator时被调用，所以，需要有一个fn的参数，也就是被decorator的函数。
2. 一个是`__call__()`，这个方法是在我们调用被decorator函数时被调用的。
上面输出可以看到整个程序的执行顺序。

```python
class myDecorator(object):

    def __init__(self, fn):
        print "inside myDecorator.__init__()"
        self.fn = fn

    def __call__(self):
        self.fn()
        print "inside myDecorator.__call__()"

@myDecorator
def aFunction():
    print "inside aFunction()"

print "Finished decorating aFunction()"

aFunction()
```

下面上面这段代码中，我们需要注意这几点：

1. 如果decorator有参数的话，__init__() 成员就不能传入fn了，而fn是在__call__的时候传入的。
2. 这段代码还展示了 wrapped(*args, **kwargs) 这种方式来传递被decorator函数的参数。

```python
class makeHtmlTagClass(object):

    def __init__(self, tag, css_class=""):
        self._tag = tag
        self._css_class = " class='{0}'".format(css_class) \
                                       if css_class !="" else ""

    def __call__(self, fn):
        def wrapped(*args, **kwargs):
            return "<" + self._tag + self._css_class+">"  \
                       + fn(*args, **kwargs) + "</" + self._tag + ">"
        return wrapped

@makeHtmlTagClass(tag="b", css_class="bold_css")
@makeHtmlTagClass(tag="i", css_class="italic_css")
def hello(name):
    return "Hello, {}".format(name)

print hello("Hao Chen")
```

### functool.wrap

相关：[Python functools](Python%20functools.md)

相信你也会发现，被decorator的函数其实已经是另外一个函数了，对于最前面那个hello.py的例子来说，如果你查询一下foo.__name__的话，你会发现其输出的是“wrapper”，而不是我们期望的“foo”，这会给我们的程序埋一些坑。所以，Python的functool包中提供了一个叫wrap的decorator来消除这样的副作用。下面是我们新版本的hello.py。

```python
from functools import wraps
def hello(fn):
    @wraps(fn)
    def wrapper():
        print "hello, %s" % fn.__name__
        fn()
        print "goodby, %s" % fn.__name__
    return wrapper

@hello
def foo():
    '''foo help doc'''
    print "i am foo"
    pass

foo()
print foo.__name__ #输出 foo
print foo.__doc__  #输出 foo help doc
```

## 一些decorator的示例

### 给函数调用做缓存：

```python
from functools import wraps
def memo(fn):
    cache = {}
    miss = object()
    
    @wraps(fn)
    def wrapper(*args):
        result = cache.get(args, miss)
        if result is miss:
            result = fn(*args)
            cache[args] = result
        return result

    return wrapper

@memo
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)
```

上面这个例子中，是一个斐波拉契数例的递归算法。我们知道，这个递归是相当没有效率的，因为会重复调用。比如：我们要计算fib(5)，于是其分解成fib(4) + fib(3)，而fib(4)分解成fib(3)+fib(2)，fib(3)又分解成fib(2)+fib(1)…… 你可看到，基本上来说，fib(3), fib(2), fib(1)在整个递归过程中被调用了两次。

而我们用decorator，在调用函数前查询一下缓存，如果没有才调用了，有了就从缓存中返回值。一下子，这个递归从二叉树式的递归成了线性的递归。


### Profiler的例子

```python
import cProfile, pstats, StringIO

def profiler(func):
    def wrapper(*args, **kwargs):
        datafn = func.__name__ + ".profile" # Name the data file
        prof = cProfile.Profile()
        retval = prof.runcall(func, *args, **kwargs)
        #prof.dump_stats(datafn)
        s = StringIO.StringIO()
        sortby = 'cumulative'
        ps = pstats.Stats(prof, stream=s).sort_stats(sortby)
        ps.print_stats()
        print s.getvalue()
        return retval

    return wrapper
```

### 注册回调函数

通过URL的路由来调用相关注册的函数示例：

```python
class MyApp():
    def __init__(self):
        self.func_map = {}

    def register(self, name):
        def func_wrapper(func):
            self.func_map[name] = func
            return func
        return func_wrapper

    def call_method(self, name=None):
        func = self.func_map.get(name, None)
        if func is None:
            raise Exception("No function registered against - " + str(name))
        return func()

app = MyApp()

@app.register('/')
def main_page_func():
    return "This is the main page."

@app.register('/next_page')
def next_page_func():
    return "This is the next page."

print app.call_method('/')
print app.call_method('/next_page')

# result
This is the main page.
This is the next page.
```

注意：

1. 上面这个示例中，用类的实例来做decorator。
2. decorator类中没有__call__()，也就是说，你调用main_page_func()或是next_page_func()就调到了黑洞了，啥也不会发生。你只有通过app.call_method才行。

### 给函数打日志

下面这个示例演示了一个logger的decorator，这个decorator输出了函数名，参数，返回值，和运行时间。

```python
from functools import wraps
def logger(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        ts = time.time()
        result = fn(*args, **kwargs)
        te = time.time()
        print "function      = {0}".format(fn.__name__)
        print "    arguments = {0} {1}".format(args, kwargs)
        print "    return    = {0}".format(result)
        print "    time      = %.6f sec" % (te-ts)
        return result
    return wrapper

@logger
def multipy(x, y):
    return x * y

@logger
def sum_num(n):
    s = 0
    for i in xrange(n+1):
        s += i
    return s

print multipy(2, 10)
print sum_num(100)
print sum_num(10000000)

# result
function      = multipy
    arguments = (2, 10) {}
    return    = 20
    time      = 0.000002 sec
20
function      = sum_num
    arguments = (100,) {}
    return    = 5050
    time      = 0.000009 sec
5050
function      = sum_num
    arguments = (10000000,) {}
    return    = 50000005000000
    time      = 0.469507 sec
50000005000000
```

上面那个打日志还是有点粗糙，让我们看一个更好一点的（带log level参数的）：


```python
import inspect
def get_line_number():
    return inspect.currentframe().f_back.f_back.f_lineno

def logger(loglevel):
    def log_decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            ts = time.time()
            result = fn(*args, **kwargs)
            te = time.time()
            print "function   = " + fn.__name__,
            print "    arguments = {0} {1}".format(args, kwargs)
            print "    return    = {0}".format(result)
            print "    time      = %.6f sec" % (te-ts)
            if (loglevel == 'debug'):
                print "    called_from_line : " + str(get_line_number())
            return result
        return wrapper
    return log_decorator
```
但是，上面这个带log level参数的有两具不好的地方

1. loglevel不是debug的时候，还是要计算函数调用的时间。
2. 不同level的要写在一起，不易读。

我们再接着改进：

```python
import inspect

def advance_logger(loglevel):

    def get_line_number():
        return inspect.currentframe().f_back.f_back.f_lineno

    def _basic_log(fn, result, *args, **kwargs):
        print "function   = " + fn.__name__,
        print "    arguments = {0} {1}".format(args, kwargs)
        print "    return    = {0}".format(result)


    def info_log_decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            result = fn(*args, **kwargs)
            _basic_log(fn, result, args, kwargs)
        return wrapper

    def debug_log_decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            ts = time.time()
            result = fn(*args, **kwargs)
            te = time.time()
            _basic_log(fn, result, args, kwargs)
            print "    time      = %.6f sec" % (te-ts)
            print "    called_from_line : " + str(get_line_number())
        return wrapper

    if loglevel is "debug":
        return debug_log_decorator
    else:
        return info_log_decorator
```

1. 我们分了两个log level，一个是info的，一个是debug的，然后我们在外尾根据不同的参数返回不同的decorator。
2. 我们把info和debug中的相同的代码抽到了一个叫_basic_log的函数里，DRY原则。

### 一个MySQL的Decorator

```python
import umysql
from functools import wraps

class Configuraion:
    def __init__(self, env):
        if env == "Prod": 
            self.host    = "coolshell.cn"
            self.port    = 3306
            self.db      = "coolshell"
            self.user    = "coolshell"
            self.passwd  = "xxx"
        elif env == "Test":
            self.host   = 'localhost'
            self.port   = 3300
            self.user   = 'coolshell'
            self.db     = 'coolshell'
            self.passwd = 'xxx'

def mysql(sql):

    _conf = Configuraion(env="Prod")

    def on_sql_error(err):
        print err
        sys.exit(-1)

    def handle_sql_result(rs):
        if rs.rows > 0:
            fieldnames = [f[0] for f in rs.fields]
            return [dict(zip(fieldnames, r)) for r in rs.rows]
        else:
            return []

    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            mysqlconn = umysql.Connection()
            mysqlconn.settimeout(5)
            mysqlconn.connect(_conf.host, _conf.port, _conf.user, \
                              _conf.passwd, _conf.db, True, 'utf8')
            try:
                rs = mysqlconn.query(sql, {})       
            except umysql.Error as e:
                on_sql_error(e)

            data = handle_sql_result(rs)
            kwargs["data"] = data
            result = fn(*args, **kwargs)
            mysqlconn.close()
            return result
        return wrapper

    return decorator


@mysql(sql = "select * from coolshell" )
def get_coolshell(data):
    ... ...
    ... ..
```

### 线程异步

```python
from threading import Thread
from functools import wraps

def async(func):
    @wraps(func)
    def async_func(*args, **kwargs):
        func_hl = Thread(target = func, args = args, kwargs = kwargs)
        func_hl.start()
        return func_hl

    return async_func

if __name__ == '__main__':
    from time import sleep

    @async
    def print_somedata():
        print 'starting print_somedata'
        sleep(2)
        print 'print_somedata: 2 sec passed'
        sleep(2)
        print 'print_somedata: 2 sec passed'
        sleep(2)
        print 'finished print_somedata'

    def main():
        print_somedata()
        print 'back in main'
        print_somedata()
        print 'back in main'

    main()
```
## 参考

* [Python深入05 装饰器](http://www.cnblogs.com/vamei/archive/2013/02/16/2820212.html)
* [Python修饰器的函数式编程](http://coolshell.cn/articles/11265.html)