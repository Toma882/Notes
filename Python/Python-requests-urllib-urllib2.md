## 结论

如果只是单纯的下载或者显示下载进度，不对下载后的内容做处理等，比如下载图片，css，js文件等，可以用

`urlilb.urlretrieve（）`

如果是下载的请求需要填写表单，输入账号，密码等，建议用

`urllib2.urlopen(urllib2.Request())`

在对字典数据编码时候，用到的是

`urllib.urlencode()`

获得文件内容，应该用 `requests` 最符合快速的符合人类的体验。

```
python2.X  -> python3.X

urllib, urllib2 -> urllib
httplib -> http.client
urllib3 -> urllib3
httplib2 -> httplib2
requests -> requests
```


## requests
> [Requests](http://docs.python-requests.org/en/latest/index.html) is the only Non-GMO HTTP library for Python, safe for human consumption.
> 
> Requests officially supports Python 2.7 & 3.4–3.7, and runs great on PyPy.

**特点**

* Keep-Alive & Connection Pooling
* International Domains and URLs
* Sessions with Cookie Persistence
* Browser-style SSL Verification
* Automatic Content Decoding
* Basic/Digest Authentication
* Elegant Key/Value Cookies
* Automatic Decompression
* Unicode Response Bodies
* HTTP(S) Proxy Support
* Multipart File Uploads
* Streaming Downloads
* Connection Timeouts
* Chunked Requests
* .netrc Support

**缺点**

* 直接使用不能异步调用，速度慢（from others）


--
# For Python2

* `httplib` 是`http`客户端协议的实现,通常不直接使用, `urllib`是以`httplib`为基础

* `urllib` 只能接受 `URL` 参数，`urllib2` 除了 URL 参数，还可以接受 `REQUEST, DATA, TIMEOUT` 等

* `urllib` 提供了 `urlencode` 的方法来处理字符串编码的问题，而 `urllib2` 是不提供的，所以他们经常混合起来使用。


## urllib

`urllib` 只能接受 `url` 对象

```
from urllib import request

with request.urlopen('https://api.douban.com/v2/book/2129650') as f:
    data = f.read()
    print('Status:', f.status, f.reason)
    for k, v in f.getheaders():
        print('%s: %s' % (k, v))
    print('Data:', data.decode('utf-8'))
```

如果我们要想模拟浏览器发送`GET`请求，就需要使用`Request`对象，通过往`Request`对象添加`HTTP`头

```
from urllib import request

req = request.Request('http://www.douban.com/')
req.add_header('User-Agent', 'Mozilla/6.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/8.0 Mobile/10A5376e Safari/8536.25')
with request.urlopen(req) as f:
    print('Status:', f.status, f.reason)
    for k, v in f.getheaders():
        print('%s: %s' % (k, v))
    print('Data:', f.read().decode('utf-8'))
```

如果还需要更复杂的控制，比如通过一个`Proxy`去访问网站，我们需要利用`ProxyHandler`来处理，示例代码如下：

```
proxy_handler = urllib.request.ProxyHandler({'http': 'http://www.example.com:3128/'})
proxy_auth_handler = urllib.request.ProxyBasicAuthHandler()
proxy_auth_handler.add_password('realm', 'host', 'username', 'password')
opener = urllib.request.build_opener(proxy_handler, proxy_auth_handler)
with opener.open('http://www.example.com/login.html') as f:
    pass
```


## urllib2
`urllib2 `可以接受 `Request` or `url`，可以接受参数，超时等，可以接受Request对象为URL设置头信息， 修改用户代理,设置cookie等

```
urllib2.urlopen(url[, data][, timeout])
```

处理信息比 `urllib` 更方便

```
import urllib
import urllib2
url = 'http://www.someserver.com/cgi-bin/register.cgi'
values = {'name' : 'Michael Foord',       'location' : 'Northampton', 'language' : 'Python' }
data = urllib.urlencode(values)      
req = urllib2.Request(url, data)   #send post
response = urllib2.urlopen(req)
page = response.read()
```

`headers`的处理

```
import urllib
import urllib2
url = 'http://www.someserver.com/cgi-bin/register.cgi'user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
values = {'name' : 'Michael Foord',        'location' : 'Northampton',        'language' : 'Python' }
headers = { 'User-Agent' : user_agent }
data = urllib.urlencode(values)
req = urllib2.Request(url, data, headers)
response = urllib2.urlopen(req)
the_page = response.read()
```

`http` 无状态协议的处理

```
import urllib2
opener = urllib2.build_opener()
opener.addheaders = [('User-agent', 'Mozilla/5.0')]
opener.open('http://www.example.com/')
```

```
import urllib2
req = urllib2.Request('http://www.python.org/')
opener=urllib2.build_opener()
＃ 创建opener对象
urllib2.install_opener(opener)
＃定义全局默认opener
f = urllib2.urlopen(req)
#urlopen使用默认opener，但是install_opener
#已经把opener设为全局默认了，这里便是使用上面的建立的opener
```


## urllib3
`requests` 使用的是 `urllib3`，继承了`urllib2`的所有特性。

--
# For Python3

## urllib
这里`urllib`成了一个包, 此包分成了几个模块,

* `urllib.request` 用于打开和读取 `URL`
* `urllib.error` 用于处理前面 `request`引起的异常
* `urllib.parse` 用于解析 `URL`
* `urllib.robotparser` 用于解析 `robots.txt` 文件

## urlopen
`python2.X` 中的 `urllib.urlopen()` 被废弃, `urllib2.urlopen()`相当于`python3.X`中的`urllib.request.urlopen()`

我们想导入`urlopen()`函数，在Python2中，他同时存在与`urllib2`和`urllib2`中（我们使用后者），在Python3中，他被集成到了`urllib.request`中，而你的方案是要既能在`2.x`和`3.x`中正常工作：

```
try:
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlopen
```
