
# 视图 View

URL 解析器将请求和关联的参数发送给一个可调用的**函数**而不是一个类

## 一个简单的视图
### 视图函数
Django 传递一个`HttpRequest` 给你的函数并期待返回一个`HttpResponse`

```python
from django.http import HttpResponse

def my_view(request):
    if request.method == 'GET':
        # <view logic>
        return HttpResponse('result')
```


### 基于类的视图
```python
from django.http import HttpResponse
from django.views.generic import View

class MyView(View):
    def get(self, request):
        # <view logic>
        return HttpResponse('result')
```

## HttpResponse
当请求一个页面时，Django会建立一个包含请求元数据的 `HttpRequest` 对象。 当Django 加载对应的视图时，`HttpRequest` 对象将作为视图函数的第一个参数。每个视图会返回一个 `HttpResponse` 对象。

`django.http.HttpResponse`

* `class HttpResponseRedirect` `302`   
* `class HttpResponsePermanentRedirect` `302` 
* `class HttpResponseNotModified` `304`  
* `class HttpResponseBadRequest` `400`  
* `class HttpResponseNotFound` `404`  
* `class HttpResponseForbidden` `403`  
* `class HttpResponseNotAllowed` `405`  
* `class HttpResponseGone` `410`  
* `class HttpResponseServerError` `500`


3种 常见的`HttpResponse`方式

* `render`
* `render_to_response`
* `TemplateResponse`

### `render`

> 结合一个给定的模板和一个给定的上下文字典，并返回一个渲染后的 `HttpResponse` 对象。  
> `render()` 与以一个强制使用`RequestContext`的`context_instance`，参数调用`render_to_response()` 相同。

`render(request, template_name[, context][, context_instance][, content_type][, status][, current_app][, dirs][, using])`

```python
from django.shortcuts import render

def my_view(request):
    # View code here...
    return render(request, 'myapp/index.html', {"foo": "bar"},
        content_type="application/xhtml+xml")

这个示例等同于：

from django.http import HttpResponse
from django.template import RequestContext, loader

def my_view(request):
    # View code here...
    t = loader.get_template('myapp/index.html')
    c = RequestContext(request, {'foo': 'bar'})
    return HttpResponse(t.render(c),
        content_type="application/xhtml+xml")
```

### `render_to_response`

> 根据一个给定的上下文字典渲染一个给定的目标，并返回渲染后的HttpResponse。

`render_to_response(template_name[, context][, context_instance][, content_type][, status][, dirs][, using])[source]`

```python
from django.shortcuts import render_to_response

def my_view(request):
    # View code here...
    return render_to_response('myapp/index.html', {"foo": "bar"},
        content_type="application/xhtml+xml")


# 这个示例等同于：

from django.http import HttpResponse
from django.template import Context, loader

def my_view(request):
    # View code here...
    t = loader.get_template('myapp/index.html')
    c = Context({'foo': 'bar'})
    return HttpResponse(t.render(c),
        content_type="application/xhtml+xml")
```

### `render_to_json_response `

Mixin 提供一个`render_to_json_response()` 方法，它与 `render_to_response()` 的参数相同。要使用它，我们只需要将它与`TemplateView` 组合，并覆盖`render_to_response()` 来调用`render_to_json_response()`：

```python
from django.views.generic import TemplateView

class JSONView(JSONResponseMixin, TemplateView):
    def render_to_response(self, context, **response_kwargs):
        return self.render_to_json_response(context, **response_kwargs)
```

DetailView 版本

```python
from django.views.generic.detail import BaseDetailView

class JSONDetailView(JSONResponseMixin, BaseDetailView):
    def render_to_response(self, context, **response_kwargs):
        return self.render_to_json_response(context, **response_kwargs)
```

HybridDetailView

```python
from django.views.generic.detail import SingleObjectTemplateResponseMixin

class HybridDetailView(JSONResponseMixin, SingleObjectTemplateResponseMixin, BaseDetailView):
    def render_to_response(self, context):
        # Look for a 'format=json' GET argument
        if self.request.GET.get('format') == 'json':
            return self.render_to_json_response(context)
        else:
            return super(HybridDetailView, self).render_to_response(context)≈
```

### `TemplateResponse`
> Django 不提供返回`TemplateResponse` 的快捷函数，因为`TemplateResponse` 的构造与`render()` 提供的便利是一个层次的。
> 标准的`HttpResponse` 对象是静态的结构，`TemplateResponse` 对象会记住视图提供的模板和上下文的详细信息来计算响应。
> 响应的最终结果在后来的响应处理过程中直到需要时才计算。
> `TemplateResponse` 是`SimpleTemplateResponse` 的子类，而且能知道当前的`HttpRequest`。
> 可以用来作为`render()` 和`render_to_response()` 的另外一种选择

有三种情况会渲染TemplateResponse

```python
# 使用SimpleTemplateResponse.render() 方法显式渲染TemplateResponse 实例的时候
>>> from django.template.response import TemplateResponse
>>> t = TemplateResponse(request, 'original.html', {})
>>> t.render()
>>> print(t.content)
Original content

# SimpleTemplateResponse.render() 的第一次调用设置响应的内容；以后的响应不会改变响应的内容
>>> t.template_name = 'new.html'
>>> t.render()
>>> print(t.content)
Original content

# 通过给response.content 赋值显式设置响应内容的时候
>>> t.content = t.rendered_content
>>> print(t.content)
New content

# 传递给模板响应中间件之后，响应中间件之前。
>>> ...
```

渲染后的回调函数

```python
# my_render_callback() 将在mytemplate.html 渲染之后调用，并将被传递一个TemplateResponse 实例作为参数
from django.template.response import TemplateResponse

def my_render_callback(response):
    # Do content-sensitive processing
    do_post_processing()

def my_view(request):
    # Create a response
    response = TemplateResponse(request, 'mytemplate.html', {})
    # Register the callback
    response.add_post_render_callback(my_render_callback)
    # Return the response
    return response
```



## 视图

`View.as_view()` 本质也是`HttpResponse` 的某种形式  

### Mixin

基于类的视图有一个`as_view()` 类方法用来作为类的可调用入口  
该`as_view` 入口点创建类的一个实例并调用`dispatch()` 方法，  
`dispatch` 查看请求是`GET` 还是`POST` 等等，并将请求转发给相应的方法，  
如果该方法没有定义则引发`HttpResponseNotAllowed`


```python
class View(object):
    http_method_names = ['get', 'post', 'put', 'patch', 'delete', 'head', 'options', 'trace']

    @classonlymethod
    def as_view(cls, **initkwargs)
    def dispatch(self, request, *args, **kwargs)
    def http_method_not_allowed(self, request, *args, **kwargs)
    def options(self, request, *args, **kwargs)

class ContextMixin(object):
    def get_context_data(self, **kwargs)

class TemplateResponseMixin(object):
    template_name = None
    template_engine = None
    response_class = TemplateResponse
    content_type = None

    def render_to_response(self, context, **response_kwargs)
    def get_template_names(self)

class TemplateView(TemplateResponseMixin, ContextMixin, View):
    def get(self, request, *args, **kwargs):
        context = self.get_context_data(**kwargs)
        return self.render_to_response(context)

class RedirectView(View):
    permanent = False
    url = None
    pattern_name = None
    query_string = False

    def get_redirect_url(self, *args, **kwargs)
```


### 通用视图

* `DetailView`  
   提供一个`get_object()` 方法获取对象；  
   覆盖 `get_template_names()`
* `ListView`  
  它提供`get_queryset()` 和`paginate_queryset()` 两种方法获取对象；  
  覆盖 `get_template_names()`

`DetailView`  
依赖 `BaseDetailView`， `BaseDetailView` 依赖 `View` `SingleObjectMixin`，   
为了生成 `TemplateResponse`，还使用 `SingleObjectTemplateResponseMixin` 扩展自 `TemplateResponseMixin`

`ListView`   
依赖 `BaseListView`，`BaseListView` 依赖 `View`  `MultipleObjectMixin`，  
为了生成 `TemplateResponse`，还使用 `MultipleObjectTemplateResponseMixin`  扩展自 `TemplateResponseMixin`

### 扩展通用视图

比起传递大量的配置到`URLconf`中，**更推荐的扩展通用视图的方法是子类化它们，并且重写它们的属性或者方法**。


**修改模板数据名字`context_object_name`**

当你处理一个普通对象或者`Queryset` 时，Django 能使用其模型类的小写名称来放入`Context`。实现方法是，除了默认的`object_list`，还提供一个包含完全相同数据的变量，例如`publisher_list`。

如果这个变量仍然不能很好的符合要求，你可以手动设置上下文变量的名字。通用视图的`context_object_name` 属性指定要使用的上下文变量：

```python
# views.py
from django.views.generic import ListView
from books.models import Publisher

class PublisherList(ListView):
    model = Publisher
    context_object_name = 'my_favorite_publishers'
```

**提供额外信息`get_context_data `**

你会经常需要展示一些通用视图不能提供的额外信息。 比如，考虑一下在每个`Publisher` 详细页面上显示一个包含所有图书的列表。`DetailView` 通用视图提供了`Publisher` 对象给上下文，但是我们如何在模板中获得附加信息呢？

答案是继承`DetailView`，并且在`get_context_data`方法中提供你自己的实现。默认的实现只是简单地给模板添加要展示的对象，但是你这可以覆盖它来展示更多信息：

```python
from django.views.generic import DetailView
from books.models import Publisher, Book

class PublisherDetail(DetailView):

    model = Publisher
    
    # ListView
    # context.is_paginated
    # context.object_list
    # context.#context_object_name#
    # context.page_obj
    # context.paginator
    # context.view
    def get_context_data(self, **kwargs):
        # Call the base implementation first to get a context
        context = super(PublisherDetail, self).get_context_data(**kwargs)
        # Add in a QuerySet of all the books
        context['book_list'] = Book.objects.all()
        return context
```

**过滤`filter`**

根据 `allowed_filters ` 设定符合的过滤选项，通过继承 `FilterMixin `，`queryset`自动进行过滤

```python
class FilterMixin(object):

    def get_queryset_filters(self):
        filters = {}
        for item in self.allowed_filters:
            if item in self.request.GET:
                 filters[self.allowed_filters[item]] = self.request.GET[item]
        return filters

    def get_queryset(self):
        return super(FilterMixin, self).get_queryset()\
            .filter(**self.get_queryset_filters())
            
class ServerListView(FilterMixin, generic.ListView):
    template_name = 'mt/server_list.html'
    model = Connect
    context_object_name = 'latest_server_list'

    allowed_filters = {
        'name': 'name',
        'tag': 'tag__name',
        'zone_index':'zone_index',
        'pf':'game_server__pf__pf_info__name',
    }

    def get_queryset(self):
        # object_list = self.model.objects.all()
        # object_list = self.model.objects.filter(game_server__pf__pf_info__name='hly')
        object_list = super(ServerListView, self).get_queryset()
        return object_list.order_by("game_server")

    def get_context_data(self, **kwargs):
        # Call the base implementation first to get a context
        context = super(ServerListView, self).get_context_data(**kwargs)
        # Add in a QuerySet of all the books
        context['pf_list'] = OpPlatformInfo.objects.all()
        return context
```


**巧妙使用`get_object `**

巧妙使用`get_object `来修改最新一次的访问时间

```python
get_object是用来获取对象的方法 —— 因此我们简单的重写它并封装调用：

from django.views.generic import DetailView
from django.utils import timezone
from books.models import Author

class AuthorDetailView(DetailView):

    queryset = Author.objects.all()

    def get_object(self):
        # Call the superclass
        object = super(AuthorDetailView, self).get_object()
        # Record the last accessed date
        object.last_accessed = timezone.now()
        object.save()
        # Return the object
        return object
```


## 装饰基于类的视图

### 在URLconf 中装饰

```python
from django.contrib.auth.decorators import login_required, permission_required
from django.views.generic import TemplateView

from .views import VoteView

urlpatterns = [
    url(r'^about/', login_required(TemplateView.as_view(template_name="secret.html"))),
    url(r'^vote/', permission_required('polls.can_vote')(VoteView.as_view())),
]
```

### 装饰类

若要装饰基于类的视图的每个实例，你需要装饰类本身。可以将装饰器运用到类的`dispatch()` 方法上来实现这点。

类的方法和独立的函数不完全相同，所以你不可以直接将函数装饰器运用到方法上 —— 你首先需要将它转换成一个方法装饰器。
`method_decorator `装饰器将函数装饰器转换成方法装饰器，这样它就可以用于实例方法上。例如：

```python
from django.contrib.auth.decorators import login_required
from django.utils.decorators import method_decorator
from django.views.generic import TemplateView

class ProtectedView(TemplateView):
    template_name = 'secret.html'

    @method_decorator(login_required)
    def dispatch(self, *args, **kwargs):
        return super(ProtectedView, self).dispatch(*args, **kwargs)
```








## 其他常见的函数

### 重定向
`redirect(to, [permanent=False, ]*args, **kwargs)[source]`

```python
# 通过传递一个对象；将调用get_absolute_url() 方法来获取重定向的URL：
from django.shortcuts import redirect
def my_view(request):
    ...
    object = MyModel.objects.get(...)
    return redirect(object)
    
# 通过传递一个视图的名称，可以带有位置参数和关键字参数；将使用reverse() 方法反向解析URL：
def my_view(request):
    ...
    return redirect('some-view-name', foo='bar')
    
# 传递要重定向的一个硬编码的URL：
def my_view(request):
    ...
    return redirect('/some/url/')
    
# 完整的URL 也可以：
def my_view(request):
    ...
    return redirect('http://example.com/')
    
# 默认情况下，redirect() 返回一个临时重定向。
# 以上所有的形式都接收一个permanent 参数；如果设置为True，将返回一个永久的重定向：
def my_view(request):
    ...
    object = MyModel.objects.get(...)
    return redirect(object, permanent=True)
```

### `get_object_or_404`
`get_object_or_404(klass, *args, **kwargs)[source]`

```python
from django.shortcuts import get_object_or_404

def my_view(request):
    my_object = get_object_or_404(MyModel, pk=1)
```

这个示例等同于：

```python
from django.http import Http404

def my_view(request):
    try:
        my_object = MyModel.objects.get(pk=1)
    except MyModel.DoesNotExist:
        raise Http404("No MyModel matches the given query.")
```

### `get_list_or_404 `

`get_list_or_404(klass, *args, **kwargs)[source]`

下面的示例从MyModel 中获取所有发布出来的对象：

```python
from django.shortcuts import get_list_or_404

def my_view(request):
    my_objects = get_list_or_404(MyModel, published=True)
```

这个示例等同于：

```python
from django.http import Http404

def my_view(request):
    my_objects = list(MyModel.objects.filter(published=True))
    if not my_objects:
        raise Http404("No MyModel matches the given query.")
```

### 返回错误

```python
from django.http import HttpResponse, HttpResponseNotFound

def my_view(request):
    # ...
    if foo:
        return HttpResponseNotFound('<h1>Page not found</h1>')
    else:
        return HttpResponse('<h1>Page was found</h1>')
```

### Http404

```python
from django.http import Http404
from django.shortcuts import render_to_response
from polls.models import Poll

def detail(request, poll_id):
    try:
        p = Poll.objects.get(pk=poll_id)
    except Poll.DoesNotExist:
        raise Http404("Poll does not exist")
    return render_to_response('polls/detail.html', {'poll': p})
```

### 指定自定义错误视图
只要在你的`URLconf`中指定下面的处理器

```python
handler404 = 'mysite.views.my_custom_page_not_found_view'
handler500 = 'mysite.views.my_custom_error_view'
handler403 = 'mysite.views.my_custom_permission_denied_view'
handler400 = 'mysite.views.my_custom_bad_request_view'
```



## 参考
### 通用视图列表

* 基础视图
    * View
    * TemplateView
    * RedirectView
* 通用的显示视图
    * DetailView
    * ListView
* 通用的编辑视图
    * FormView
    * CreateView
    * UpdateView
    * DeleteView
* 通用的日期视图
    * ArchiveIndexView
    * YearArchiveView
    * MonthArchiveView
    * WeekArchiveView
    * DayArchiveView
    * TodayArchiveView
    * DateDetailView
* 基于类的视图的Mixins
    * 简单的混合
        * ContextMixin
        * TemplateResponseMixin
    * 单对象混合
        * SingleObjectMixin
        * SingleObjectTemplateResponseMixin
    * 多个对象混合
        * MultipleObjectMixin
        * MultipleObjectTemplateResponseMixin
    * 编辑mixins
        * FormMixin
        * ModelFormMixin
        * ProcessFormView
        * DeletionMixin
    * 基于日期的混合
        * YearMixin
        * MonthMixin
        * DayMixin
        * WeekMixin
        * DateMixin
        * BaseDateListView