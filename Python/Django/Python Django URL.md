
## Django 如何处理一个请求

**URL 解析器将请求和关联的参数发送给一个可调用的函数而不是一个类**

当一个用户请求Django 站点的一个页面，下面是Django 系统决定执行哪个Python 代码遵循的算法：

1. Django 决定要使用的根`URLconf` 模块。通常，这个值就是`ROOT_URLCONF` 的设置，但是如果进来的`HttpRequest` 对象具有一个`urlconf` 属性（通过中间件`request processing` 设置），则使用这个值来替换`ROOT_URLCONF` 设置。
2. Django 加载该Python 模块并寻找可用的`urlpatterns`。它是`django.conf.urls.url()` 实例的一个Python 列表。
3. Django 依次匹配每个URL 模式，在与请求的URL 匹配的第一个模式停下来。
4. 一旦其中的一个正则表达式匹配上，Django 将导入并调用给出的视图，它是一个简单的Python 函数（或者一个基于类的视图）。视图将获得如下参数:
    * 一个`HttpRequest` 实例。
    * 如果匹配的正则表达式返回了没有命名的组，那么正则表达式匹配的内容将作为位置参数提供给视图。
    * 关键字参数由正则表达式匹配的命名组组成，但是可以被`django.conf.urls.url()`的可选参数kwargs覆盖。
5. 如果没有匹配到正则表达式，或者如果过程中抛出一个异常，Django 将调用一个适当的错误处理视图。请参见下面的错误处理。


urls.py

```python
from django.conf.urls import url

from . import views

# /articles/2005/03/ 请求将匹配列表中的第三个模式。Django 将调用函数views.month_archive(request, '2005', '03')。
urlpatterns = [
    url(r'^articles/2003/$', views.special_case_2003),
    url(r'^articles/([0-9]{4})/$', views.year_archive),
    url(r'^articles/([0-9]{4})/([0-9]{2})/$', views.month_archive),
    url(r'^articles/([0-9]{4})/([0-9]{2})/([0-9]+)/$', views.article_detail),
]
```

## URLconf

### 命名组

```python
from django.conf.urls import url

from . import views

# /articles/2005/03/ 请求将调用views.month_archive(request, year='2005', month='03')函数，而不是views.month_archive(request, '2005', '03')。
urlpatterns = [
    url(r'^articles/2003/$', views.special_case_2003),
    url(r'^articles/(?P<year>[0-9]{4})/$', views.year_archive),
    url(r'^articles/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/$', views.month_archive),
    url(r'^articles/(?P<year>[0-9]{4})/(?P<month>[0-9]{2})/(?P<day>[0-9]{2})/$', views.article_detail),
]
```


### 使用参数默认值

```python
# URLconf
from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^blog/$', views.page),
    url(r'^blog/page(?P<num>[0-9]+)/$', views.page),
]

# View (in blog/views.py)
def page(request, num="1"):
    # Output the appropriate page of blog entries, according to num.
    ...
```


### 传递额外参数

```python
from django.conf.urls import url
from . import views

# Django 将调用views.year_archive(request, year='2005', foo='bar')
urlpatterns = [
    url(r'^blog/(?P<year>[0-9]{4})/$', views.year_archive, {'foo': 'bar'}),
]
```

当你传递额外的选项给`include()` 时，被包含的URLconf 的每一 行将被传递这些额外的选项

```python
# main.py
from django.conf.urls import include, url

urlpatterns = [
    url(r'^blog/', include('inner'), {'blogid': 3}),
]

# inner.py
from django.conf.urls import url
from mysite import views

urlpatterns = [
    url(r'^archive/$', views.archive),
    url(r'^about/$', views.about),
]
```

### 包含其它的URLconfs

这个例子中的正则表达式没有包含`$`（字符串结束匹配符），但是包含一个末尾的斜杠  
每当Django 遇到`include()（django.conf.urls.include()）`时，  
它会去掉URL 中匹配的部分并将剩下的字符串发送给包含的URLconf 做进一步处理。

#### 指向其他项目

```python
from django.conf.urls import include, url

urlpatterns = [
    # ... snip ...
    url(r'^community/', include('django_website.aggregator.urls')),
    url(r'^contact/', include('django_website.contact.urls')),
    # ... snip ...
]
```

#### 实例的列表

```python
from django.conf.urls import include, url

from apps.main import views as main_views
from credit import views as credit_views


# 另外一种包含其它URL 模式的方式是使用一个url() 实例的列表

extra_patterns = [
    url(r'^reports/(?P<id>[0-9]+)/$', credit_views.report),
    url(r'^charge/$', credit_views.charge),
]

urlpatterns = [
    url(r'^$', main_views.homepage),
    url(r'^help/', include('apps.help.urls')),
    url(r'^credit/', include(extra_patterns)),
]
```

#### 一次前缀多次后缀

```python
from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^(?P<page_slug>[\w-]+)-(?P<page_id>\w+)/history/$', views.history),
    url(r'^(?P<page_slug>[\w-]+)-(?P<page_id>\w+)/edit/$', views.edit),
    url(r'^(?P<page_slug>[\w-]+)-(?P<page_id>\w+)/discuss/$', views.discuss),
    url(r'^(?P<page_slug>[\w-]+)-(?P<page_id>\w+)/permissions/$', views.permissions),
]
# 我们可以改进它，通过只声明共同的路径前缀一次并将后面的部分分组：

from django.conf.urls import include, url
from . import views

urlpatterns = [
    url(r'^(?P<page_slug>[\w-]+)-(?P<page_id>\w+)/', include([
        url(r'^history/$', views.history),
        url(r'^edit/$', views.edit),
        url(r'^discuss/$', views.discuss),
        url(r'^permissions/$', views.permissions),
    ])),
]
```

#### 嵌套参数/忽略相关参数

```python
from django.conf.urls import url

urlpatterns = [
    url(r'blog/(page-(\d+)/)?$', blog_articles),                  # bad
    # 外围参数是一个不捕获的参数(?:...)
    url(r'comments/(?:page-(?P<page_number>\d+)/)?$', comments),  # good
]
```

## URL 的反向解析
* 在模板中：使用`url` 模板标签。
* 在Python 代码中：使用`django.core.urlresolvers.reverse()` 函数。
* 在更高层的与处理Django 模型实例相关的代码中：使用`get_absolute_url()` 方法。

URLconf

```python
from django.conf.urls import url

from . import views

# name 相当于这条url 的 id
urlpatterns = [
    #...
    url(r'^articles/([0-9]{4})/$', views.year_archive, name='news-year-archive'),
    #...
]
```

模板

```python
# 使用url 模板标签找到URLconf，通过news-year-archive找到对应的URL解析，进行反向填充
# 填充结果为 articles/2012/
<a href="{% url 'news-year-archive' 2012 %}">2012 Archive</a>

<ul>
{% for yearvar in year_list %}
<li><a href="{% url 'news-year-archive' yearvar %}">{{ yearvar }} Archive</a></li>
{% endfor %}
</ul>
```

Python 代码

```python
from django.core.urlresolvers import reverse
from django.http import HttpResponseRedirect

def redirect_to_year(request):
    # ...
    year = 2006
    # ...
    return HttpResponseRedirect(reverse('news-year-archive', args=(year,)))
```

### 反查带命名空间的URL

URL命名是全局的，因此需要加入前缀来确认是全局唯一变量，如 `myapp-comment`

* 应用命名空间 `application namespace` 正在部署的应用的名称
* 实例命名空间 `instance namespace` 应用的一个特定的实例

URL 的命名空间使用`:` 操作符指定。例如，管理站点应用的主页使用`admin:index`。它表示`admin` 的一个命名空间和`index` 的一个命名URL。

命名空间也可以嵌套。命名URL`sports:polls:index` 将在命名空间`polls`中查找`index`，而`poll` 定义在顶层的命名空间`sports` 中。


urls.py

```python
from django.conf.urls import include, url

urlpatterns = [
    url(r'^author-polls/', include('polls.urls', namespace='author-polls', app_name='polls')),
    url(r'^publisher-polls/', include('polls.urls', namespace='publisher-polls', app_name='polls')),
]
```

polls/urls.py

```python
from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^$', views.IndexView.as_view(), name='index'),
    url(r'^(?P<pk>\d+)/$', views.DetailView.as_view(), name='detail'),
    ...
]
```


`reverse('polls:index', current_app=self.request.resolver_match.namespace)`

`{% url 'polls:index' %}`

在模板中的反查需要添加`request` 的`current_app` 属性

```python
def render_to_response(self, context, **response_kwargs):
    self.request.current_app = self.request.resolver_match.namespace
    return super(DetailView, self).render_to_response(context, **response_kwargs)
```