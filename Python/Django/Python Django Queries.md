# 查询

```python
from django.db import models

class Blog(models.Model):
    name = models.CharField(max_length=100)
    tagline = models.TextField()

    def __str__(self):              # __unicode__ on Python 2
        return self.name

class Author(models.Model):
    name = models.CharField(max_length=50)
    email = models.EmailField()

    def __str__(self):              # __unicode__ on Python 2
        return self.name

class Entry(models.Model):
    blog = models.ForeignKey(Blog)
    headline = models.CharField(max_length=255)
    body_text = models.TextField()
    pub_date = models.DateField()
    mod_date = models.DateField()
    authors = models.ManyToManyField(Author)
    n_comments = models.IntegerField()
    n_pingbacks = models.IntegerField()
    rating = models.IntegerField()

    def __str__(self):              # __unicode__ on Python 2
        return self.headline
```

## 创建/保存对象

`Model.save([force_insert=False, force_update=False, using=DEFAULT_DB_ALIAS, update_fields=None])`

没有返回值

```python
>>> from blog.models import Blog
>>> b = Blog(name='Beatles Blog', tagline='All the latest Beatles news.')
>>> b.save()
```

## 获取对象

### 管理器
管理器只可以通过模型的类访问，而不可以通过模型的实例访问，目的是为了强制区分“表级别”的操作和“记录级别”的操作。  
每个模型都至少有一个管理器，它默认命名为`objects`。

```python
>>> Blog.objects
<django.db.models.manager.Manager object at ...>
>>> b = Blog(name='Foo', tagline='Bar')
>>> b.objects
Traceback:
    ...
AttributeError: "Manager isn't accessible via Blog instances."
```

### 使用过滤器获取特定对象

* `all()` 方法返回了一个包含数据库表中所有记录查询集。
* `filter(**kwargs)` 返回一个新的查询集，它包含满足查询参数的对象。
* `exclude(**kwargs)` 返回一个新的查询集，它包含不满足查询参数的对象。
* `lt` `<` `gt` `>` `lte` `<=` `gte` `>=`
* `exact` 精确匹配 `iexact` 大小写不敏感匹配
* `contains` 大小写敏感包含关系 `icontains`
* `startswith, endswith`

### 通过 get 获取一个单一的对象

```python
# 如果没有结果满足查询，get() 将引发一个DoesNotExist 异常。
# 所以在上面的代码中，如果没有主键为1 的Entry 对象，Django 将引发一个Entry.DoesNotExist。
# 类似地，如果有多条记录满足get() 的查询条件，Django 也将报错。
# 这种情况将引发MultipleObjectsReturned，它同样是模型类自身的一个属性。
>>> one_entry = Entry.objects.get(pk=1)
```

在Blog 模型示例中，主键是id 字段，所以下面三条语句是等同的：

```python
>>> Blog.objects.get(id__exact=14) # Explicit form
>>> Blog.objects.get(id=14) # __exact is implied
>>> Blog.objects.get(pk=14) # pk implies id__exact
```

pk 的使用不仅限于__exact 查询 —— 任何查询类型都可以与pk 结合来完成一个模型上对主键的查询：

```python
# Get blogs entries with id 1, 4 and 7
>>> Blog.objects.filter(pk__in=[1,4,7])

# Get all blog entries with id > 14
>>> Blog.objects.filter(pk__gt=14)
```

pk查询在join 中也可以工作。例如，下面三个语句是等同的：

```python
>>> Entry.objects.filter(blog__id__exact=3) # Explicit form
>>> Entry.objects.filter(blog__id=3)        # __exact is implied
>>> Entry.objects.filter(blog__pk=3)        # __pk implies __id__exact
```

### 跨关联关系的查询
若要跨越关联关系，只需使用关联的模型字段的名称，并使用双下划线分隔，直至你想要的字段  
下面这个例子获取所有`Blog` 的`name` 为`Beatles Blog` 的`Entry` 对象：

```python
>>> Entry.objects.filter(blog__name='Beatles Blog')
```

这种跨越可以是任意的深度。

它还可以反向工作。若要引用一个“反向”的关系，只需要使用该模型的小写的名称。

下面的示例获取所有的`Blog` 对象，它们至少有一个`Entry` 的`headline` 包含`Lennon`：

```python
>>> Blog.objects.filter(entry__headline__contains='Lennon')
```

如果你在多个关联关系直接过滤而且其中某个中介模型没有满足过滤条件的值，Django 将把它当做一个空的（所有的值都为`NULL`）但是合法的对象。这意味着不会有错误引发。例如，在下面的过滤器中：

```python
Blog.objects.filter(entry__authors__name='Lennon')
```

（如果有一个相关联的`Author` 模型），如果`Entry` 中没有找到对应的`author`，那么它将当作其没有`name`，而不会因为没有`author` 引发一个错误。通常，这就是你想要的。唯一可能让你困惑的是当你使用`isnull` 的时候。因此：

```python
Blog.objects.filter(entry__authors__name__isnull=True)
```

返回的`Blog` 对象包括`author__name` 为空的Blog对象,以及`author__name`不为空但`author__name`关联的`entry__author` 为空的对象。如果你不需要后者，你可以这样写：

```python
Blog.objects.filter(entry__authors__isnull=False,
        entry__authors__name__isnull=True)
```

### Filter 可以引用模型的字段 `F()`

Django 提供F 表达式 来允许这样的比较。`F()` 返回的实例用作查询内部对模型字段的引用。

例如，为了查找`comments` 数目多于`pingbacks` 的`Entry`，我们将构造一个`F()`对象来引用`pingback` 数目，并在查询中使用该`F()` 对象：

```python
>>> from django.db.models import F
>>> Entry.objects.filter(n_comments__gt=F('n_pingbacks'))
>>> Entry.objects.filter(rating__lt=F('n_comments') + F('n_pingbacks'))
>>> from datetime import timedelta
>>> Entry.objects.filter(mod_date__gt=F('pub_date') + timedelta(days=3))
>>> F('somefield').bitand(16)
```

### 使用Q 对象进行复杂的查询 `Q()`

```python
# 例如，下面的语句产生一个Q 对象，表示两个"question__startswith" 查询的“OR” ：
Q(question__startswith='Who') | Q(question__startswith='What')

# 它等同于下面的SQL WHERE 子句：
WHERE question LIKE 'Who%' OR question LIKE 'What%'

# 你可以组合& 和|  操作符以及使用括号进行分组来编写任意复杂的Q 对象。同时，Q 对象可以使用~ 操作符取反，这允许组合正常的查询和取反(NOT) 查询：
Q(question__startswith='Who') | ~Q(pub_date__year=2005)

Poll.objects.get(
    Q(question__startswith='Who'),
    Q(pub_date=date(2005, 5, 2)) | Q(pub_date=date(2005, 5, 6))
)
# ... 大体上可以翻译成这个SQL：
SELECT * from polls WHERE question LIKE 'Who%'
    AND (pub_date = '2005-05-02' OR pub_date = '2005-05-06')
    
# 查询函数可以混合使用Q 对象和关键字参数。所有提供给查询函数的参数（关键字参数或Q 对象）都将"AND”在一起。但是，如果出现Q 对象，它必须位于所有关键字参数的前面。例如：
Poll.objects.get(
    Q(pub_date=date(2005, 5, 2)) | Q(pub_date=date(2005, 5, 6)),
    question__startswith='Who')
# ... 是一个合法的查询，等同于前面的例子；但是：
# INVALID QUERY
Poll.objects.get(
    question__startswith='Who',
    Q(pub_date=date(2005, 5, 2)) | Q(pub_date=date(2005, 5, 6)))
```

### LIKE

```python
# Django 会帮你转义；生成的SQL 看上去会是这样：
>>> Entry.objects.filter(headline__contains='%')

SELECT ... WHERE headline LIKE '%\%%';
```

## 更新对象
**一次更新多个对象**

```python
# 有时你想为一个查询集中所有对象的某个字段都设置一个特定的值。这时你可以使用update() 方法。例如：
# Update all the headlines with pub_date in 2007.
Entry.objects.filter(pub_date__year=2007).update(headline='Everything is the same')

# 更新查询集 唯一的限制是它只能访问一个数据库表，也就是模型的主表。你可以根据关联的字段过滤，但是你只能更新模型主表中的列。例如：
>>> b = Blog.objects.get(pk=1)
# Update all the headlines belonging to this Blog.
>>> Entry.objects.select_related().filter(blog=b).update(headline='Everything is the same')

# 要注意update() 方法会直接转换成一个SQL 语句。
# 它是一个批量的直接更新操作。
# 它不会运行模型的save() 方法，或者发出pre_save 或 post_save信号（调用save()方法产生）或者查看auto_now 字段选项。
# 如果你想保存查询集中的每个条目并确保每个实例的save() 方法都被调用，你不需要使用任何特殊的函数来处理。只需要迭代它们并调用save()：
for item in my_queryset:
    item.save()
   
# 对update 的调用也可以使用F 表达式 来根据模型中的一个字段更新另外一个字段。这对于在当前值的基础上加上一个值特别有用。例如，增加Blog 中每个Entry 的pingback 个数：
>>> Entry.objects.all().update(n_pingbacks=F('n_pingbacks') + 1)
# THIS WILL RAISE A FieldError
>>> Entry.objects.update(headline=F('blog__name'))
```

## 删除对象
`e.delete()`

## 拷贝对象

```python
blog = Blog(name='My blog', tagline='Blogging is easy')
blog.save() # blog.pk == 1

blog.pk = None
blog.save() # blog.pk == 2

# 如果你用继承，那么会复杂一些。考虑下面Blog 的子类：
class ThemeBlog(Blog):
    theme = models.CharField(max_length=200)
django_blog = ThemeBlog(name='Django', tagline='Django is easy', theme='python')
django_blog.save() # django_blog.pk == 3
# 由于继承的工作方式，你必须设置pk 和 id 都为None：
django_blog.pk = None
django_blog.id = None
django_blog.save() # django_blog.pk == 4

# 这个过程不会拷贝关联的对象。如果你想拷贝关联关系，你必须编写一些更多的代码。
# 在我们的例子中，Entry 有一个到Author 的多对多字段：
entry = Entry.objects.all()[0] # some previous entry
old_authors = entry.authors.all()
entry.pk = None
entry.save()
entry.authors = old_authors # saves new many2many relations

# 若要更新ForeignKey 字段，需设置新的值为你想指向的新的模型实例。例如：
>>> b = Blog.objects.get(pk=1)
# Change every Entry so that it belongs to this Blog.
>>> Entry.objects.all().update(blog=b)
```


## 比较对象

```python
利用上面的Entry 示例，下面两个语句是等同的：

>>> some_entry == other_entry
>>> some_entry.id == other_entry.id
如果模型的主键不叫id，也没有问题。比较将始终使用主键，无论它叫什么。例如，如果模型的主键字段叫做name，下面的两条语句是等同的：

>>> some_obj == other_obj
>>> some_obj.name == other_obj.name
```



## 缓存和查询集

**首次对查询集进行求值** —— 同时发生数据库查询 ——Django 将保存查询的结果到查询集的缓存中并返回明确请求的结果（例如，如果正在迭代查询集，则返回下一个结果）

```python
# 下面的语句创建两个查询集，对它们求值，然后扔掉它们
>>> print([e.headline for e in Entry.objects.all()])
>>> print([e.pub_date for e in Entry.objects.all()])

# 为了避免这个问题，只需保存查询集并重新使用它：
>>> queryset = Entry.objects.all()
>>> print([p.headline for p in queryset]) # Evaluate the query set.
>>> print([p.pub_date for p in queryset]) # Re-use the cache from the evaluation.
```

注意`select_related()` 查询集方法递归地预填充所有的一对多关系到缓存中。例如：

```python
>>> e = Entry.objects.select_related().get(id=2)
>>> print(e.blog)  # Doesn't hit the database; uses cached version.
>>> print(e.blog)  # Doesn't hit the database; uses cached version.
```

### 何时查询集不会被缓存?

简单地打印查询集不会填充缓存。因为`__repr__()` 调用只返回全部查询集的一个切片

```python
# 重复获取查询集对象中一个特定的索引将每次都查询数据库：
>>> queryset = Entry.objects.all()
>>> print queryset[5] # Queries the database
>>> print queryset[5] # Queries the database again

# 然而，如果已经对全部查询集求值过，则将检查缓存：
>>> queryset = Entry.objects.all()
>>> [entry for entry in queryset] # Queries the database
>>> print queryset[5] # Uses cache
>>> print queryset[5] # Uses cache

# 下面是一些其它例子，它们会使得全部的查询集被求值并填充到缓存中：
>>> [entry for entry in queryset]
>>> bool(queryset)
>>> entry in queryset
>>> list(queryset)
```
