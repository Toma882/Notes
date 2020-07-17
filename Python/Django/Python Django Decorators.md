## 装饰器 decorators

```python
# 限制 HTTP 的请求方法
# django.views.decorators.http 包里的装饰器可以基于请求的方法来限制对视图的访问。
# 若条件不满足会返回 django.http.HttpResponseNotAllowed
# require_http_methods(request_method_list)[source]
from django.views.decorators.http import require_http_methods

# HTTP请求的方法名必须大写
@require_http_methods(["GET", "POST"])
def my_view(request):
    # I can assume now that only GET or POST requests make it this far
    # ...
    pass

# 只允许视图接受GET方法的装饰器。
require_GET()

# 只允许视图接受POST方法的装饰器。
require_POST()

# 只允许视图接受 GET 和 HEAD 方法的装饰器。
require_safe()



# 可控制的视图处理
# django.views.decorators.http 中的以下装饰器可以用来控制特定视图的缓存行为
# 这些装饰器可以用于生成ETag 和Last-Modified 头部
condition(etag_func=None, last_modified_func=None)[source]
etag(etag_func)[source]
last_modified(last_modified_func)[source]


# GZip 压缩
# django.views.decorators.gzip 里的装饰器基于每个视图控制其内容压缩。
# 如果浏览器允许gzip 压缩，这个装饰器将对内容进行压缩。
gzip_page()

# Vary 头部
# django.views.decorators.vary 可以用来基于特定的请求头部来控制缓存。
# 到当构建缓存的键时，Vary 头部定义一个缓存机制应该考虑的请求头。
vary_on_cookie(func)[source]
vary_on_headers(*headers)[source]

```