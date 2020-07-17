## 模型是什么

* 每个模型都是django.db.models.Model 的一个Python 子类。
* 模型的每个属性都表示为数据库中的一个字段。
* Django 提供一套自动生成的用于数据库访问的API


```python
from django.db import models

class Person(models.Model):
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)
```


上面的Person 模型会在数据库DB中创建这样一张表：

```python
CREATE TABLE myapp_person (
    "id" serial NOT NULL PRIMARY KEY,
    "first_name" varchar(30) NOT NULL,
    "last_name" varchar(30) NOT NULL
);
```



## 字段 Field
### 字段选项 (Field options)
下列参数是全部字段类型都可用的，而且都是可选择的。

```python
* Field.null
* Field.blank
* Field.choices
* Field.db_column # 数据库中用来表示该字段的名称。如果未指定，那么Django将会使用Field名作为字段名
* Field.db_index # 索引
* Field.db_tablespace # 如果该字段有索引的话，数据库表空间的名称将作为该字段的索引名
* Field.default # 这个默认值不可以是一个可变对象（如字典，列表，等等）,因为对于所有模型的一个新的实例来说，它们指向同一个引用
* Field.editable 
* Field.error_messages # 参数能够让你重写默认抛出的错误信息
* Field.help_text # 额外的 ‘help' 文本将被显示在表单控件form中
* Field.primary_key # primary_key=True 暗含着null=False 和unique=True. 一个对象上只能拥有一个主键
* Field.unique # 除了ManyToManyField、OneToOneField和FileField 以外的其他字段类型都可以使用这个设置
* Field.unique_for_date
* Field.unique_for_month
* Field.unique_for_year
* Field.verbose_name # 字段的自述名
* Field.validators
```

**Field.choices 例子**

```python
# 一般来说，最好在模型类内部定义choices，然后再给每个值定义一个合适名字的常量。
# 尽管你可以在模型类的外部定义choices然后引用它
# 但是在模型类中定义choices和其每个choice的name(即元组的第二个元素)可以保存所有使用choices的类的信息， 
# 也使得choices更容易被应用（例如， Student.SOPHOMORE 可以在任何引入Student 模型的位置生效)。
# 除非blank=False 和default一起在字段中被设置，否则，可选择菜单将会有"---------" 的标签
from django.db import models

class Student(models.Model):
    FRESHMAN = 'FR'
    SOPHOMORE = 'SO'
    JUNIOR = 'JR'
    SENIOR = 'SR'
    YEAR_IN_SCHOOL_CHOICES = (
        (FRESHMAN, 'Freshman'),
        (SOPHOMORE, 'Sophomore'),
        (JUNIOR, 'Junior'),
        (SENIOR, 'Senior'),
    )
    year_in_school = models.CharField(max_length=2,
                                      choices=YEAR_IN_SCHOOL_CHOICES,
                                      default=FRESHMAN)

    def is_upperclass(self):
        return self.year_in_school in (self.JUNIOR, self.SENIOR)
```

### 字段类型 (Field types)

```python
* class AutoField(**options)
* class IntegerField([**options])
* class SmallIntegerField([**options])
* class PositiveIntegerField([**options])
* class PositiveSmallIntegerField([**options])
* class BigIntegerField([**options]) # 64位整数 默认的表单组件是一个TextInput
* class BinaryField([**options]) # 存储原始二进制码的Field. 只支持bytes 赋值
* class BooleanField(**options) # 默认表单挂件是一个CheckboxInput
* class NullBooleanField([**options])
* class CharField(max_length=None[, **options]) # 如果是巨大的文本类型, 可以用 TextField.这个字段默认的表单样式是 TextInput
* class TextField([**options]) # 该模型默认的表单组件是Textarea
* class DecimalField(max_digits=None, decimal_places=None[, **options]) # 十进制浮点数
* class FloatField([**options]) # FloatField 使用的是Python内部的 float 类型, 而DecimalField 使用的是Python的 Decimal 类型
* class CommaSeparatedIntegerField(max_length=None[, **options]) # 一个逗号分隔的整数字段
* class DateField([auto_now=False, auto_now_add=False, **options])
* class DateTimeField([auto_now=False, auto_now_add=False, **options])
* class TimeField([auto_now=False, auto_now_add=False, **options]) # 时间字段，和Python中 datetime.time 一样。接受与DateField相同的自动填充选项
* class EmailField([max_length=254, **options]) # 一个 CharField 用来检查输入的email地址是否合法
* class FileField([upload_to=None, max_length=100, **options]) # 一个上传文件的字段
* class FilePathField(path=None[, match=None, recursive=False, max_length=100, **options])
* class ImageField([upload_to=None, height_field=None, width_field=None, max_length=100, **options])
* class GenericIPAddressField([protocol=both, unpack_ipv4=False, **options])
* class SlugField([max_length=50, **options])
* class URLField([max_length=200, **options])
* class UUIDField([**options])
```

## 关系字段

### 多对一关系 ForeignKey

对象与自己具有多对一的关系 —— 请使用`models.ForeignKey('self')`

`class ForeignKey(othermodel[, **options])` 

```python
from django.db import models

class Car(models.Model):
    manufacturer = models.ForeignKey('Manufacturer')
    # ...

class Manufacturer(models.Model):
    # ...
    pass
```

```
ForeignKey.limit_choices_to
ForeignKey.related_name
ForeignKey.related_query_name
ForeignKey.to_field
ForeignKey.db_constraint
ForeignKey.on_delete
ForeignKey.swappable
ForeignKey.allow_unsaved_instance_assignment
```

### 多对多关联 ManyToManyField
`class ManyToManyField(othermodel[, **options])` 

在幕后，Django 创建一个中间表来表示多对多关系。默认情况下，这张中间表的名称使用多对多字段的名称和包含这张表的模型的名称生成。因为某些数据库支持的表的名字的长度有限制，这些表的名称将自动截短到64 个字符并加上一个唯一性的哈希值。这意味着，你看的表的名称可能类似 `author_books_9cdf4`；这再正常不过了。你可以使用`db_table` 选项手工提供中间表的名称。

```
ManyToManyField.related_name
ManyToManyField.related_query_name
ManyToManyField.limit_choices_to
ManyToManyField.symmetrical
ManyToManyField.through
ManyToManyField.through_fields
ManyToManyField.db_table
ManyToManyField.db_constraint
ManyToManyField.swappable
ManyToManyField.allow_unsaved_instance_assignment
```


例如，有这样一个应用，它记录音乐家所属的音乐小组。我们可以用一个`ManyToManyField` 表示小组和成员之间的多对多关系。但是，有时你可能想知道更多成员关系的细节，比如成员是何时加入小组的。

对于这些情况，`Django` 允许你指定一个中介模型来定义多对多关系。 你可以将其他字段放在中介模型里面。源模型的`ManyToManyField` 字段将使用`through` 参数指向中介模型。对于上面的音乐小组的例子，代码如下：

```python
from django.db import models

class Person(models.Model):
    name = models.CharField(max_length=128)

    def __str__(self):              # __unicode__ on Python 2
        return self.name

class Group(models.Model):
    name = models.CharField(max_length=128)
    members = models.ManyToManyField(Person, through='Membership')

    def __str__(self):              # __unicode__ on Python 2
        return self.name

class Membership(models.Model):
    person = models.ForeignKey(Person)
    group = models.ForeignKey(Group)
    date_joined = models.DateField()
    invite_reason = models.CharField(max_length=64)
```

### 一对一关系 OneToOneField
`class OneToOneField(othermodel[, parent_link=False, **options])` 一对一关联关系

字段很像是`ForeignKey` 设置了`unique=True`，数据库结构一样，不同的是它会直接返回关系另一边的单个对象。

例如，你想建一个`places` 数据库，里面有一些常用的字段，比如`address、 phone number` 等等。 接下来，如果你想在`Place` 数据库的基础上建立一个`Restaurant` 数据库，而不想将已有的字段复制到`Restaurant`模型，那你可以在 `Restaurant` 添加一个`OneToOneField` 字段，这个字段指向`Place`（因为`Restaurant` 本身就是一个`Place`；事实上，在处理这个问题的时候，你应该使用一个典型的 继承，它隐含一个一对一关系)

## Meta(元)的选择

```python
# 模型元数据是“任何不是字段的数据”，
# 比如排序选项（ordering），数据库表名（db_table）或者人类可读的单复数名称（verbose_name 和verbose_name_plural）
from django.db import models

class Ox(models.Model):
    horn_length = models.IntegerField()

    class Meta:
        ordering = ["horn_length"]
        verbose_name_plural = "oxen"
        # abstract
        # app_label
        # db_table
        # db_tablespace
        # get_latest_by
        # managed
        # order_with_respect_to
        # ordering
        # permissions
        # default_permissions
        # proxy
        # select_on_save
        # unique_together
        # index_together
        # verbose_name
        # verbose_name_plural

```

## 模型的方法

### 属性
```python
from django.db import models

class Person(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    birth_date = models.DateField()

    def baby_boomer_status(self):
        "Returns the person's baby-boomer status."
        import datetime
        if self.birth_date < datetime.date(1945, 8, 1):
            return "Pre-boomer"
        elif self.birth_date < datetime.date(1965, 1, 1):
            return "Baby boomer"
        else:
            return "Post-boomer"

    def _get_full_name(self):
        "Returns the person's full name."
        return '%s %s' % (self.first_name, self.last_name)
    full_name = property(_get_full_name)
```

### 重写预定义的模型方法

```python
from django.db import models

class Blog(models.Model):
    name = models.CharField(max_length=100)
    tagline = models.TextField()

    def save(self, *args, **kwargs):
        do_something()
        super(Blog, self).save(*args, **kwargs) # Call the "real" save() method.
        do_something_else()
```

## 模型继承

### 抽象基类

写完基类之后，在 Meta类中设置 `abstract=True` ，这个模型就不会被用来创建任何数据表。取而代之的是，当它被用来作为一个其他model的基类时，它的字段将被加入那些子类中

```python
from django.db import models

class CommonInfo(models.Model):
    name = models.CharField(max_length=100)
    age = models.PositiveIntegerField()

    class Meta:
        abstract = True

class Student(CommonInfo):
    home_group = models.CharField(max_length=5)
```

#### 元 继承
如果子类没有声明自己的Meta 类, 他将会继承父类的Meta. 如果子类想要扩展父类的Meta类，它可以作为其子类

```python
from django.db import models

class CommonInfo(models.Model):
    # ...
    class Meta:
        abstract = True
        ordering = ['name']

class Student(CommonInfo):
    # ...
    class Meta(CommonInfo.Meta):
        db_table = 'student_info'
```

#### 小心使用 related_name
当你在(且仅在)抽象基类中使用 `related_name` 时，如果想绕过这个问题，名称中就要包含`%(app_label)s`和 `%(class)s`。

* `%(class)s` 会替换为子类的小写加下划线格式的名称，字段在子类中使用。
* `%(app_label)s` 会替换为应用的小写加下划线格式的名称，应用包含子类。每个安装的应用名称都应该是唯一的，而且应用里每个模型类的名称也应该是唯一的，所以产生的名称应该彼此不同。

### 多表继承

继承关系在子 `model` 和它的每个父类之间都添加一个链接 (通过一个自动创建的 `OneToOneField`来实现)

```python
from django.db import models

class Place(models.Model):
    name = models.CharField(max_length=50)
    address = models.CharField(max_length=80)

class Restaurant(Place):
    serves_hot_dogs = models.BooleanField(default=False)
    serves_pizza = models.BooleanField(default=False)
```

#### 多表继承中的Meta

子 `model` 并不能访问它父类的 `Meta` 类。但是在某些受限的情况下，子类可以从父类继承某些 `Meta` ：如果子类没有指定 `ordering`属性或 `get_latest_by` 属性，它就会从父类中继承这些属性。

如果父类有了排序设置，而你并不想让子类有任何排序设置，你就可以显式地禁用排序：

```python
class ChildModel(ParentModel):
    # ...
    class Meta:
        # Remove parent's ordering effect
        ordering = []
```

### 代理模型
如果你想改变**默认的排序**、自定义管理器以及**自定义模型方法**，而不需要对数据库中存储的内容做任何改变，则选择代理模型。

声明代理 `model` 和声明普通 `model` 没有什么不同。 设置`Meta`类中 `proxy` 的值为 `True`，就完成了对代理 model 的声明。

举个例子，假设你想给 `Person` 模型添加一个方法。你可以这样做：

```python
from django.db import models

class Person(models.Model):
    first_name = models.CharField(max_length=30)
    last_name = models.CharField(max_length=30)

class MyPerson(Person):
    class Meta:
        proxy = True

    def do_something(self):
        # ...
        pass
```

`MyPerson`类和它的父类 `Person` 操作同一个数据表。特别的是，`Person` 的任何实例也可以通过 `MyPerson`访问，反之亦然：

```python
>>> p = Person.objects.create(first_name="foobar")
>>> MyPerson.objects.get(first_name="foobar")
<MyPerson: foobar>
```

你也可以使用代理 `model` 给 `model` 定义不同的默认排序设置。 你可能并不想每次都给Person模型排序，但是使用代理的时候总是按照`last_name`属性排序。这非常容易：

```python
class OrderedPerson(Person):
    class Meta:
        ordering = ["last_name"]
        proxy = True
```

现在，普通的`Person`查询是无序的，而 `OrderedPerson`查询会按照`last_name`排序。


### 多重继承

就像`Python`的子类那样，`django`的模型可以继承自多个父类模型。切记一般的`Python`名称解析规则也会适用。出现特定名称的第一个基类(比如`Meta`)是所使用的那个。例如，这意味着如果多个父类含有 `Meta`类，只有第一个会被使用，剩下的会忽略掉。

多重继承主要对`mix-in`类有用：向每个继承`mix-in`的类添加一个特定的、额外的字段或者方法

```python
class Article(models.Model):
    headline = models.CharField(max_length=50)
    body = models.TextField()

class Book(models.Model):
    title = models.CharField(max_length=50)

class BookReview(Book, Article):
    pass
```