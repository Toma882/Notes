# django-transactions

## 默认行为

* SQL标准中, 每个SQL语句在执行时都会启动一个事务，除非已经存在一个事务了。这样事务必须明确是提交还是回滚。
* Django 的默认行为是运行在自动提交模式下, 当 `autocommit` 被打开并且事物处于活动状态时，每个SQL查询都可以看成是一个事务。也就是说, 不但每个查询是每个事物的开始，而且每个事物会自动提交或回滚，这取决于该查询是否成功执行。
* 尽量优先选择`atomic()`来控制事务 ，它遵守数据库的相关特性并且防止了非法操作。

## 把事务绑定到 HTTP 请求上

`ATOMIC_REQUESTS`

* 默认为False
* 当需要将每个HTTP 请求封装在一个数据库事务中时，设置它为True，
* 注意当流量增长时它会表现出较差的效率

`AUTOCOMMIT`

* 默认：True
* 如果你需要禁用Django 的事务管理并自己实现，设置它为False。

`non_atomic_requests(using=None)`

当 `ATOMIC_REQUESTS` 被启用后，仍然有办法来阻止视图运行一个事务操作

```python
# 这个装饰器会否定一个由 ATOMIC_REQUESTS设定的视图
from django.db import transaction

@transaction.non_atomic_requests
def my_view(request):
    do_stuff()

@transaction.non_atomic_requests(using='other')
def my_other_view(request):
    do_stuff_on_the_other_database()
```

## 更加明确地控制事务

`atomic(using=None, savepoint=True)`

* 原子性是由数据库的事务操作来界定的。
* atomic允许我们在执行代码块时，在数据库层面提供原子性保证。 如果代码块成功完成， 相应的变化会被提交到数据库进行commit；如果有异常，则更改将回滚。
* atomic块可以嵌套。 
* 避免在 atomic里捕获异常!

在下面的例子里，使用with语句，当一个内部块完成后，如果某个异常在外部块被抛出，内部块上的操作仍然可以回滚(前提是外部块也被atomic装饰过)。

```python
# atomic 被用作装饰器
from django.db import transaction

@transaction.atomic
def viewfunc(request):
    # This code executes inside a transaction.
    do_stuff()
    
# atomic 被用作 上下文管理器
from django.db import transaction

def viewfunc(request):
    # This code executes in autocommit mode (Django's default).
    do_stuff()

    with transaction.atomic():
        # This code executes inside a transaction.
        do_more_stuff()
```

在这个例子中，即使`generate_relationships()` 违反完整性约束导致了数据库错误， 你仍可以进行 `add_children()`的操作, 并且`create_parent()`的变化仍然存在。注意，当 `handle_exception()`被触发时，在`generate_relationships()`上的尝试操作已经被安全回滚，所以若有必要，这个`handle_exception`也能够操作数据库。

```python
from django.db import IntegrityError, transaction

@transaction.atomic
def viewfunc(request):
    create_parent()

    try:
        with transaction.atomic():
            generate_relationships()
    except IntegrityError:
        handle_exception()

    add_children()
```

**捕捉异常**

当一个原子块执行完退出时，Django会审查是正常提交还是回滚。

如果你在 `transaction.atomic` 中捕获了异常的句柄, 你可能就向Django隐藏了问题的发生。这可能会导致意想不到的后果。

这主要是考虑到 `DatabaseError`和其诸如`IntegrityError`这样的子类。 若是遇到这样的错误，事务的原子性会被打破，Django会在原子代码块上执行回滚操作。

如果你试图在回滚发生前运行数据库查询，Django会产生一个`TransactionManagementError`的异常。当一个`ORM-相关`的信号句柄操作异常时，你可能也会遇到类似的情形。

正确捕捉数据库异常应该是类似上文所讲 ，基于`atomic` 代码块来做。若有必要,可以额外增加一层`atomic`代码来用于此目的。这种模式还有另一个优势：它明确了当一个异常发生时，哪些操作将回滚。

**savepoints**

在底层，Django的事务管理代码：

* 当进入到最外层的 `atomic` 代码块时会打开一个事务;
* 当进入到内层`atomic`代码块时会创建一个保存点;
* 当退出内部块时会释放或回滚保存点;
* 当退出外部块时提交或回退事物。

你可以通过设置`savepoint` 参数为 `False`来使对内层的保存点失效。如果异常发生，若设置了`savepoint`，Django会在退出第一层代码块时执行回滚，否则会在最外层的代码块上执行回滚。 原子性始终会在外层事物上得到保证。这个选项仅仅用在设置保存点开销很明显时的情况下。它的缺点是打破了上述错误处理的原则。

在`autocommit`关闭的情况下，你可以使用`atomic`. 这只使用`savepoints`功能，即使是对于最外层的块。如果在最外层的块上声明`savepoint=False`，这将会产生一个错误。






## 参考

* [数据库库事务](http://usyiyi.cn/translate/django_182/topics/db/transactions.html)