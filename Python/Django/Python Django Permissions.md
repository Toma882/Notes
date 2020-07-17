# Permissions

`Django`用`user, group`和`permission`完成了权限机制，这个权限机制是将属于`model`的某个`permission`赋予`user`或`group`，可以理解为全局的权限。

`group`的定义其实为`permission`的`group`，而非所谓的`user`的`group`。

`Django`自带的权限机制基本为对象为`Model`的`('add', 'change', 'delete')`，无法满足所有的需求。

## Basic

```python
myuser.groups.set([group_list])
myuser.groups.add(group, group, ...)
myuser.groups.remove(group, group, ...)
myuser.groups.clear()
myuser.user_permissions.set([permission_list])
myuser.user_permissions.add(permission, permission, ...)
myuser.user_permissions.remove(permission, permission, ...)
myuser.user_permissions.clear()

# Assuming you have an application with an app_label foo and a model named Bar, 
# to test for basic permissions you should use:
# add
user.has_perm('foo.add_bar')
# change
user.has_perm('foo.change_bar')
# delete
user.has_perm('foo.delete_bar')
```

## 自定义 Permissions

```python
# This is a list or tuple of 2-tuples in the format (permission_code, human_readable_permission_name).
permissions = (
    ("can_deliver_pizzas", "Can deliver pizzas"),
    ("can_eat_pizzas", "Can eat pizzas"),
)
```


与现有的`models.Model`相互关联，`Options.default_permissions` 拥有默认的 `('add', 'change', 'delete')`，现在添加`'view'`的权限。

```python
class User_Profile(models.Model):
    ...

    class Meta:
        default_permissions = ('add', 'change', 'delete', 'view')
```      

或者

```python
from myapp.models import BlogPost
from django.contrib.auth.models import Permission
from django.contrib.contenttypes.models import ContentType

content_type = ContentType.objects.get_for_model(BlogPost)
permission = Permission.objects.create(codename='can_publish',
                                       name='Can Publish Posts',
                                       content_type=content_type)
```

## Permission 缓存
`Permission`拥有缓存，需重新获得`Permission`

```python
from django.contrib.auth.models import Permission, User
from django.contrib.contenttypes.models import ContentType
from django.shortcuts import get_object_or_404

from myapp.models import BlogPost

def user_gains_perms(request, user_id):
    user = get_object_or_404(User, pk=user_id)
    # any permission check will cache the current set of permissions
    user.has_perm('myapp.change_blogpost')

    content_type = ContentType.objects.get_for_model(BlogPost)
    permission = Permission.objects.get(
        codename='change_blogpost',
        content_type=content_type,
    )
    user.user_permissions.add(permission)

    # Checking the cached permission set
    user.has_perm('myapp.change_blogpost')  # False

    # Request new instance of User
    # Be aware that user.refresh_from_db() won't clear the cache.
    user = get_object_or_404(User, pk=user_id)

    # Permission cache is repopulated from the database
    user.has_perm('myapp.change_blogpost')  # True

    ...
```

## Permission 与 View
### decorator @
```python
from django.contrib.auth.decorators import permission_required

@permission_required('polls.can_vote', login_url='/loginpage/')
def my_view(request):
    ...
```

If you want to use raise_exception but also give your users a chance to login first, you can add the `login_required()` decorator:

```python
from django.contrib.auth.decorators import login_required, permission_required

@login_required
@permission_required('polls.can_vote', raise_exception=True)
def my_view(request):
    ...
```

### mixin
```python
from django.contrib.auth.mixins import PermissionRequiredMixin

class MyView(PermissionRequiredMixin, View):
    permission_required = 'polls.can_vote'
    # Or multiple of permissions:
    permission_required = ('polls.can_open', 'polls.can_edit')
```

Django 提供 AccessMixin 来进行帮助

```python
class AccessMixin(object):
    """
    Abstract CBV mixin that gives access mixins the same customizable
    functionality.
    """
    login_url = None
    permission_denied_message = ''
    raise_exception = False
    redirect_field_name = REDIRECT_FIELD_NAME

    def get_login_url(self):
        """
        Override this method to override the login_url attribute.
        """
        login_url = self.login_url or settings.LOGIN_URL
        if not login_url:
            raise ImproperlyConfigured(
                '{0} is missing the login_url attribute. Define {0}.login_url, settings.LOGIN_URL, or override '
                '{0}.get_login_url().'.format(self.__class__.__name__)
            )
        return force_text(login_url)

    def get_permission_denied_message(self):
        """
        Override this method to override the permission_denied_message attribute.
        """
        return self.permission_denied_message

    def get_redirect_field_name(self):
        """
        Override this method to override the redirect_field_name attribute.
        """
        return self.redirect_field_name

    def handle_no_permission(self):
        if self.raise_exception:
            raise PermissionDenied(self.get_permission_denied_message())
        return redirect_to_login(self.request.get_full_path(), self.get_login_url(), self.get_redirect_field_name())


class LoginRequiredMixin(AccessMixin):
    """
    CBV mixin which verifies that the current user is authenticated.
    """
    def dispatch(self, request, *args, **kwargs):
        if not request.user.is_authenticated:
            return self.handle_no_permission()
        return super(LoginRequiredMixin, self).dispatch(request, *args, **kwargs)


class PermissionRequiredMixin(AccessMixin):
    """
    CBV mixin which verifies that the current user has all specified
    permissions.
    """
    permission_required = None

    def get_permission_required(self):
        """
        Override this method to override the permission_required attribute.
        Must return an iterable.
        """
        if self.permission_required is None:
            raise ImproperlyConfigured(
                '{0} is missing the permission_required attribute. Define {0}.permission_required, or override '
                '{0}.get_permission_required().'.format(self.__class__.__name__)
            )
        if isinstance(self.permission_required, six.string_types):
            perms = (self.permission_required, )
        else:
            perms = self.permission_required
        return perms

    def has_permission(self):
        """
        Override this method to customize the way permissions are checked.
        """
        perms = self.get_permission_required()
        return self.request.user.has_perms(perms)

    def dispatch(self, request, *args, **kwargs):
        if not self.has_permission():
            return self.handle_no_permission()
        return super(PermissionRequiredMixin, self).dispatch(request, *args, **kwargs)
```
## View 中查看 permissions

```python
{{ perms }}

{% if perms.foo %}
    <p>You have permission to do something in the foo app.</p>
    {% if perms.foo.can_vote %}
        <p>You can vote!</p>
    {% endif %}
    {% if perms.foo.can_drive %}
        <p>You can drive!</p>
    {% endif %}
{% else %}
    <p>You don't have permission to do anything in the foo app.</p>
{% endif %}
```


## 第三方
[django guradian](https://github.com/lukaszb/django-guardian)
## 参考

* [default-permissions](https://docs.djangoproject.com/en/2.0/ref/models/options/)