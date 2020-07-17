## Auth

`auth.authenticate(username=username, password=password)`

## 权限 permissions

Django中的`Permissions`设置，主要通过Django自带的`Admin`界面进行维护。Django会为`Model`自动创建 `add\change\delete` 三种类型的权限，即是设置某些人对某些模型能够增加、修改、删除的权限设置。Permission不仅仅能够设置`Model`，还可以针对一个模型的某一个对象进行设置。 

若 App 有个叫做 school，里面有个模型叫做 StudyGroup，可以用任何一个user对象执行下面的程序

```python
user.has_perm('school.add_studygroup')
user.has_perm('school.change_studygroup')
user.has_perm('school.delete_studygroup')
```

### Model中创建 Permission

一个模型类叫做Discussion，我们可以创建几个权限来对这个模型的权限许可进行控制，控制某些人可以发起讨论、发起回复，关闭讨论。

```python
class Discussion(models.Model):
    ...
    class Meta:
        permissions = (
            ("open_discussion", "Can create a discussion"),
            ("reply_discussion", "Can reply discussion"),
            ("close_discussion", "Can remove a discussion by setting its status as closed"),
        )
```

### 动态创建 Permission

```python
from django.contrib.auth.models import Group, Permission
from django.contrib.contenttypes.models import ContentType
 
content_type = ContentType.objects.get(app_label='school', model='Discussion')
permission = Permission.objects.create(codename='can_publish',
                                       name='Can Publish Discussions',
                                       content_type=content_type)
```

### Permission在模板中的使用
`settings` 中的 `django.contrib.auth.context_processors.auth` 对其进行了支持

```html
{% if perms.school %}
    <p>You have permission to do something in the school app.</p>
    {% if perms.school.publish_discussion %}
        <p>You can discussion!</p>
    {% endif %}
    {% if perms.school.reply_discussion %}
        <p>You can reply discussion!</p>
    {% endif %}
{% else %}
    <p>You don't have permission to do anything in the school app.</p>
{% endif %}
```


### Permission 属性
所属模块：django.contrib.auth.models
属性：
name:必填。小于50个字符。例如：'Can publish'。
content_type：必填。一个指向django_content_type数据库表，对于每一个Django模型，在这个表里面都有一个记录对应。
codename：必填。小于100个字符。例如：'can_publish'。



 Django内置的权限系统包括以下三个部分：

* Users
* Permissions：用来定义一个用户（user）是否能够做某项任务（task）
* Groups：permissions 的一个合集，一种批量分配许可到多个用户的通用方式



```python
newUser = User.objects.create_user(username, None, password);
newUser.groups # add remove clear
newUser.user_permissions # add remove clear

newUser.is_staff # 用这个来判断是否用户可以登录进入admin site。
newUser.is_active # 用来判断该用户是否是可用激活状态。在删除一个帐户的时候，可以选择将这个属性置为False，而不是真正删除。这样如果应用有外键引用到这个用户，外键就不会被破坏。
newUser.is_superuser # 该属性用来表示该用户拥有所有的许可，而无需明确的赋予给他。


# 返回该用户通过组所拥有的许可（字符串列表每一个代表一个许可）。obj如果指定，将会返回关于该对象的许可，而不是模型。
get_group_permissions(obj=None)：

# 返回该用户所拥有的所有的许可，包括通过组的和通过用户赋予的许可。
get_all_permissions(obj=None):

has_perm(perm,obj=None)
has_perms(perm_list,obj=None)
# 传入的是Django app label，按照'<app label>.<permission codename>'格式。当用户拥有该app label下面所有的perm时，返回值为True。如果用户为inactive，返回值永远为False。
has_module_perms(package_name)
```




通过`Meta`

```python
class Task(models.Model):
    ...
    class Meta:
        permissions = (
            ("view_task", "Can see available tasks"),
            ("change_task_status", "Can change the status of tasks"),
            ("close_task", "Can remove a task by setting its status as closed"),
        )
```

写好之后运行`manage.py migrate`创建这些额外的权限

检查用户是否可以查看任务：

```python
user.has_perm('app.view_task')
```



## 参考
* [django.contrib.auth](https://yiyibooks.cn/xx/django_182/ref/contrib/auth.html)
* [扩展已有的用户模型](https://yiyibooks.cn/xx/django_182/topics/auth/customizing.html#extending-the-existing-user-model)
* [How to Extend Django User Model](https://simpleisbetterthancomplex.com/tutorial/2016/07/22/how-to-extend-django-user-model.html)