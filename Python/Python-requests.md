# Python requests

## 安装

```sh
pip install requests
```

## 基础

### 发送请求

```python
>>> import requests
>>> 
>>> # 有一个名为 r 的 Response 对象。我们可以从这个对象中获取所有我们想要的信息
>>> r = requests.put("http://httpbin.org/put")
>>> r = requests.delete("http://httpbin.org/delete")
>>> r = requests.head("http://httpbin.org/get")
>>> r = requests.options("http://httpbin.org/get")
```

### 传递 URL 参数

```python
>>> payload = {'key1': 'value1', 'key2': 'value2'}
>>> r = requests.get("http://httpbin.org/get", params=payload)
>>> print(r.url)
http://httpbin.org/get?key2=value2&key1=value1

>>> payload = {'key1': 'value1', 'key2': ['value2', 'value3']}
>>> r = requests.get('http://httpbin.org/get', params=payload)
>>> print(r.url)
http://httpbin.org/get?key1=value1&key2=value2&key2=value3
```

### 响应内容

```python
>>> import requests
>>> r = requests.get('https://github.com/timeline.json')
>>> r.text
u'[{"repository":{"open_issues":0,"url":"https://github.com/...

>>> r.encoding
'utf-8'

>>> # 能够使用 r.encoding 属性来改变它
>>> r.encoding = 'ISO-8859-1'
```

### 二进制响应内容
你也能以字节的方式访问请求响应体，对于非文本请求：

```python
>>> r.content
b'[{"repository":{"open_issues":0,"url":"https://github.com/...
Requests 会自动为你解码 gzip 和 deflate 传输编码的响应数据。
```

例如，以请求返回的二进制数据创建一张图片，你可以使用如下代码：

```python
>>> from PIL import Image
>>> from io import BytesIO

>>> i = Image.open(BytesIO(r.content))
```

### JSON 响应内容
Requests 中也有一个内置的 JSON 解码器，助你处理 JSON 数据：

```python
>>> import requests

>>> r = requests.get('https://github.com/timeline.json')
>>> r.json()
[{u'repository': {u'open_issues': 0, u'url': 'https://github.com/...
```

如果 JSON 解码失败， `r.json` 就会抛出一个异常。例如，相应内容是 `401 (Unauthorized)`，尝试访问 `r.json` 将会抛出 `ValueError: No JSON object could be decoded` 异常。

### 原始响应内容

在罕见的情况下，你可能想获取来自服务器的原始套接字响应，那么你可以访问 `r.raw`。 如果你确实想这么干，那请你确保在初始请求中设置了 `stream=True`。具体你可以这么做：

```python
>>> r = requests.get('https://github.com/timeline.json', stream=True)
>>> r.raw
<requests.packages.urllib3.response.HTTPResponse object at 0x101194810>
>>> r.raw.read(10)
'\x1f\x8b\x08\x00\x00\x00\x00\x00\x00\x03'
```

但一般情况下，你应该以下面的模式将文本流保存到文件：

```python
with open(filename, 'wb') as fd:
    for chunk in r.iter_content(chunk_size):
        fd.write(chunk)
```
使用 `Response.iter_content` 将会处理大量你直接使用 `Response.raw` 不得不处理的。 当流下载时，上面是优先推荐的获取内容方式。

### 定制请求头

如果你想为请求添加 HTTP 头部，只要简单地传递一个 dict 给 headers 参数就可以了。

例如，在前一个示例中我们没有指定 `content-type`:

```python
>>> url = 'https://api.github.com/some/endpoint'
>>> headers = {'user-agent': 'my-app/0.0.1'}

>>> r = requests.get(url, headers=headers)
```

注意: 定制 header 的优先级低于某些特定的信息源，例如：

* 如果在 `.netrc` 中设置了用户认证信息，使用 `headers=` 设置的授权就不会生效。而如果设置了 `auth=` 参数，``.netrc`` 的设置就无效了。
* 如果被重定向到别的主机，授权 `header` 就会被删除。
* 代理授权 `header` 会被 `URL` 中提供的代理身份覆盖掉。
* 在我们能判断内容长度的情况下，`header` 的 `Content-Length` 会被改写。

更进一步讲，`Requests` 不会基于定制 `header` 的具体情况改变自己的行为。只不过在最后的请求中，所有的 `header` 信息都会被传递进去。

注意: 所有的 `header` 值必须是 `string、bytestring 或者 unicode`。尽管传递 `unicode header` 也是允许的，但不建议这样做。

### 更加复杂的 POST 请求
通常，你想要发送一些编码为表单形式的数据——非常像一个 HTML 表单。要实现这个，只需简单地传递一个字典给 data 参数。你的数据字典在发出请求时会自动编码为表单形式：

```python
>>> payload = {'key1': 'value1', 'key2': 'value2'}

>>> r = requests.post("http://httpbin.org/post", data=payload)
>>> print(r.text)
{
  ...
  "form": {
    "key2": "value2",
    "key1": "value1"
  },
  ...
}
```

很多时候你想要发送的数据并非编码为表单形式的。如果你传递一个 `string` 而不是一个 `dict`，那么数据会被直接发布出去。

例如，Github API v3 接受编码为 JSON 的 POST/PATCH 数据：

```python
>>> import json

>>> url = 'https://api.github.com/some/endpoint'
>>> payload = {'some': 'data'}

>>> r = requests.post(url, data=json.dumps(payload))
```

此处除了可以自行对 `dict` 进行编码，你还可以使用 `json` 参数直接传递，然后它就会被自动编码。这是 2.4.2 版的新加功能：

```python
>>> url = 'https://api.github.com/some/endpoint'
>>> payload = {'some': 'data'}

>>> r = requests.post(url, json=payload)
```


### POST一个多部分编码(Multipart-Encoded)的文件
Requests 使得上传多部分编码文件变得很简单：

```python
>>> url = 'http://httpbin.org/post'
>>> files = {'file': open('report.xls', 'rb')}

>>> r = requests.post(url, files=files)
>>> r.text
{
  ...
  "files": {
    "file": "<censored...binary...data>"
  },
  ...
}
```
你可以显式地设置文件名，文件类型和请求头：

```python
>>> url = 'http://httpbin.org/post'
>>> files = {'file': ('report.xls', open('report.xls', 'rb'), 'application/vnd.ms-excel', {'Expires': '0'})}

>>> r = requests.post(url, files=files)
>>> r.text
{
  ...
  "files": {
    "file": "<censored...binary...data>"
  },
  ...
}
```

也可以直接写入 String 进行文件的 Post：

```python
>>> url = 'http://httpbin.org/post'
>>> files = {'file': ('report.csv', 'some,data,to,send\nanother,row,to,send\n')}

>>> r = requests.post(url, files=files)
>>> r.text
{
  ...
  "files": {
    "file": "some,data,to,send\\nanother,row,to,send\\n"
  },
  ...
}
```
如果你发送一个非常大的文件作为 `multipart/form-data` 请求，你可能希望将请求做成数据流。默认下 `requests` 不支持, 但有个第三方包 `requests-toolbelt` 是支持的。你可以阅读 `toolbelt` 文档 来了解使用方法。

**强烈建议你用二进制模式(binary mode)打开文件**

如果用文本模式`text mode`打开文件，判断内容长度的情况下，header 中的 `Content-Length` 可能是错误的。

### 响应状态码

我们可以检测响应状态码：

```python
>>> r = requests.get('http://httpbin.org/get')
>>> r.status_code
200
为方便引用，Requests还附带了一个内置的状态码查询对象：

>>> r.status_code == requests.codes.ok
True
```

如果发送了一个错误请求(一个 4XX 客户端错误，或者 5XX 服务器错误响应)，我们可以通过 `Response.raise_for_status()` 来抛出异常：

```python
>>> bad_r = requests.get('http://httpbin.org/status/404')
>>> bad_r.status_code
404

>>> bad_r.raise_for_status()
Traceback (most recent call last):
  File "requests/models.py", line 832, in raise_for_status
    raise http_error
requests.exceptions.HTTPError: 404 Client Error
```

但是，由于我们的例子中 r 的 `status_code` 是 200 ，当我们调用 `raise_for_status()` 时，得到的是：

```python
>>> r.raise_for_status()
None
```

### 响应头
我们可以查看以一个 Python 字典形式展示的服务器响应头：

```python
>>> r.headers
{
    'content-encoding': 'gzip',
    'transfer-encoding': 'chunked',
    'connection': 'close',
    'server': 'nginx/1.0.4',
    'x-runtime': '148ms',
    'etag': '"e1ca502697e5c9317743dc078f67693f"',
    'content-type': 'application/json'
}
```
但是这个字典比较特殊：它是仅为 HTTP 头部而生的。根据 RFC 2616， HTTP 头部是大小写不敏感的。

因此，我们可以使用任意大写形式来访问这些响应头字段：

```python
>>> r.headers['Content-Type']
'application/json'

>>> r.headers.get('content-type')
'application/json'
```

### Cookie
如果某个响应中包含一些 cookie，你可以快速访问它们：

```python
>>> url = 'http://example.com/some/cookie/setting/url'
>>> r = requests.get(url)

>>> r.cookies['example_cookie_name']
'example_cookie_value'
```

要想发送你的cookies到服务器，可以使用 cookies 参数：

```python
>>> url = 'http://httpbin.org/cookies'
>>> cookies = dict(cookies_are='working')

>>> r = requests.get(url, cookies=cookies)
>>> r.text
'{"cookies": {"cookies_are": "working"}}'
```

### 重定向与请求历史
默认情况下，除了 `HEAD, Requests` 会自动处理所有重定向。

可以使用响应对象的 `history` 方法来追踪重定向。

`Response.history` 是一个 `Response` 对象的列表，为了完成请求而创建了这些对象。这个对象列表按照从最老到最近的请求进行排序。

例如，`Github` 将所有的 `HTTP` 请求重定向到 `HTTPS`：

```python
>>> r = requests.get('http://github.com')

>>> r.url
'https://github.com/'

>>> r.status_code
200

>>> r.history
[<Response [301]>]
```
如果你使用的是`GET、OPTIONS、POST、PUT、PATCH 或者 DELETE`，那么你可以通过 `allow_redirects` 参数禁用重定向处理：

```python
>>> r = requests.get('http://github.com', allow_redirects=False)
>>> r.status_code
301
>>> r.history
[]
```

如果你使用了 HEAD，你也可以启用重定向：

```python
>>> r = requests.head('http://github.com', allow_redirects=True)
>>> r.url
'https://github.com/'
>>> r.history
[<Response [301]>]
```

### 超时
你可以告诉 `requests` 在经过以 `timeout` 参数设定的秒数时间之后停止等待响应：

```python
>>> requests.get('http://github.com', timeout=0.001)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
requests.exceptions.Timeout: HTTPConnectionPool(host='github.com', port=80): Request timed out. (timeout=0.001)
```

timeout 仅对连接过程有效，与响应体的下载无关。 timeout 并不是整个下载响应的时间限制，而是如果服务器在 timeout 秒内没有应答，将会引发一个异常（更精确地说，是在 timeout 秒内没有从基础套接字上接收到任何字节的数据时）

### 错误与异常
遇到网络问题（如：DNS 查询失败、拒绝连接等）时，`Requests` 会抛出一个 `ConnectionError` 异常。

如果 `HTTP` 请求返回了不成功的状态码， `Response.raise_for_status()` 会抛出一个 `HTTPError` 异常。

若请求超时，则抛出一个 `Timeout` 异常。

若请求超过了设定的最大重定向次数，则会抛出一个 `TooManyRedirects` 异常。

所有`Requests`显式抛出的异常都继承自 `requests.exceptions.RequestException` 。

## 高级用法

### 会话对象

会话对象让你能够跨请求保持某些参数。它也会在同一个 Session 实例发出的所有请求之间保持 cookie， 期间使用 `urllib3` 的 `connection pooling` 功能。所以如果你向同一主机发送多个请求，底层的 TCP 连接将会被重用，从而带来显著的性能提升。 (参见 `HTTP persistent connection`).

会话对象具有主要的 Requests API 的所有方法。

我们来跨请求保持一些 cookie:

```python
s = requests.Session()

s.get('http://httpbin.org/cookies/set/sessioncookie/123456789')
r = s.get("http://httpbin.org/cookies")

print(r.text)
# '{"cookies": {"sessioncookie": "123456789"}}'
会话也可用来为请求方法提供缺省数据。这是通过为会话对象的属性提供数据来实现的：

s = requests.Session()
s.auth = ('user', 'pass')
s.headers.update({'x-test': 'true'})

# both 'x-test' and 'x-test2' are sent
s.get('http://httpbin.org/headers', headers={'x-test2': 'true'})
```

任何你传递给请求方法的字典都会与已设置会话层数据合并。方法层的参数覆盖会话的参数。

不过需要注意，就算使用了会话，方法级别的参数也不会被跨请求保持。下面的例子只会和第一个请求发送 cookie ，而非第二个：

```python
s = requests.Session()

r = s.get('http://httpbin.org/cookies', cookies={'from-my': 'browser'})
print(r.text)
# '{"cookies": {"from-my": "browser"}}'

r = s.get('http://httpbin.org/cookies')
print(r.text)
# '{"cookies": {}}'
```

如果你要手动为会话添加 cookie，就是用 Cookie utility 函数 来操纵 Session.cookies。

会话还可以用作前后文管理器：

```python
with requests.Session() as s:
    s.get('http://httpbin.org/cookies/set/sessioncookie/123456789')
```
这样就能确保 `with` 区块退出后会话能被关闭，即使发生了异常也一样。

从字典参数中移除一个值:设置为 `None`

### 请求与响应对象
任何时候调用 `requests.*()` 你都在做两件主要的事情。其一，你在构建一个 Request 对象， 该对象将被发送到某个服务器请求或查询一些资源。其二，一旦 requests 得到一个从 服务器返回的响应就会产生一个 Response 对象。该响应对象包含服务器返回的所有信息， 也包含你原来创建的 Request 对象。如下是一个简单的请求，从 Wikipedia 的服务器得到 一些非常重要的信息：

```python
>>> r = requests.get('http://en.wikipedia.org/wiki/Monty_Python')
```

如果想访问服务器返回给我们的响应头部信息，可以这样做：

```python
>>> r.headers
{'content-length': '56170', 'x-content-type-options': 'nosniff', 'x-cache':
'HIT from cp1006.eqiad.wmnet, MISS from cp1010.eqiad.wmnet', 'content-encoding':
'gzip', 'age': '3080', 'content-language': 'en', 'vary': 'Accept-Encoding,Cookie',
'server': 'Apache', 'last-modified': 'Wed, 13 Jun 2012 01:33:50 GMT',
'connection': 'close', 'cache-control': 'private, s-maxage=0, max-age=0,
must-revalidate', 'date': 'Thu, 14 Jun 2012 12:59:39 GMT', 'content-type':
'text/html; charset=UTF-8', 'x-cache-lookup': 'HIT from cp1006.eqiad.wmnet:3128,
MISS from cp1010.eqiad.wmnet:80'}
```

然而，如果想得到发送到服务器的请求的头部，我们可以简单地访问该请求，然后是该请求的头部：

```python
>>> r.request.headers
{'Accept-Encoding': 'identity, deflate, compress, gzip',
'Accept': '*/*', 'User-Agent': 'python-requests/0.13.1'}
```

### Prepared Request

[Prepared Request](http://docs.python-requests.org/en/latest/user/advanced/#prepared-requests)

### SSL 证书验证
Requests 可以为 HTTPS 请求验证 SSL 证书，就像 web 浏览器一样。要想检查某个主机的 SSL 证书，你可以使用 `verify` 参数:

```python
>>> requests.get('https://kennethreitz.com', verify=True)
requests.exceptions.SSLError: hostname 'kennethreitz.com' doesn't match either of '*.herokuapp.com', 'herokuapp.com'
```

在该域名上我没有设置 `SSL`，所以失败了。但 Github 设置了 `SSL`:

```python
>>> requests.get('https://github.com', verify=True)
<Response [200]>
```

对于私有证书，你也可以传递一个 `CA_BUNDLE` 文件的路径给 `verify`。你也可以设置 `REQUEST_CA_BUNDLE` 环境变量。

如果你将 `verify` 设置为 `False`，`Requests` 也能忽略对 `SSL` 证书的验证。

```python
>>> requests.get('https://kennethreitz.com', verify=False)
<Response [200]>
```

默认情况下， `verify` 是设置为 `True` 的。选项 `verify` 仅应用于主机证书。

你也可以指定一个本地证书用作客户端证书，可以是单个文件（包含密钥和证书）或一个包含两个文件路径的元组:

```python
>>> requests.get('https://kennethreitz.com', cert=('/path/server.crt', '/path/key'))
<Response [200]>
```

如果你指定了一个错误路径或一个无效的证书:

```python
>>> # 本地证书的私有 key 必须是解密状态。目前，Requests 不支持使用加密的 key。
>>> requests.get('https://kennethreitz.com', cert='/wrong_path/server.pem')
SSLError: [Errno 336265225] _ssl.c:347: error:140B0009:SSL routines:SSL_CTX_use_PrivateKey_file:PEM lib
```

### Body Content Workflow

默认情况下，当你进行网络请求后，响应体会立即被下载。你可以通过 stream 参数覆盖这个行为，推迟下载响应体直到访问 `Response.content` 属性：

```python
tarball_url = 'https://github.com/kennethreitz/requests/tarball/master'
r = requests.get(tarball_url, stream=True)
```

此时仅有响应头被下载下来了，连接保持打开状态，因此允许我们根据条件获取内容：

```python
if int(r.headers['content-length']) < TOO_LONG:
  content = r.content
  ...
```
你可以进一步使用 `Response.iter_content` 和 `Response.iter_lines` 方法来控制工作流，或者以 `Response.raw` 从底层 `urllib3` 的 `urllib3.HTTPResponse <urllib3.response.HTTPResponse` 读取。

如果你在请求中把 `stream` 设为 `True`，`Requests` 无法将连接释放回连接池，除非你 消耗了所有的数据，或者调用了 `Response.close`。 这样会带来连接效率低下的问题。如果你发现你在使用 `stream=True` 的同时还在部分读取请求的 `body`（或者完全没有读取 body），那么你就应该考虑使用 `contextlib.closing` (文档)， 如下所示：

```python
from contextlib import closing

with closing(requests.get('http://httpbin.org/get', stream=True)) as r:
    # 在此处理响应。
```

### Keep-Alive
只有所有的响应体数据被读取完毕连接才会被释放为连接池；所以确保将 `stream` 设置为 `False` 或读取 `Response` 对象的 `content` 属性


### Streaming Uploads

```python
#  recommended that you open files in binary mode.
with open('massive-body', 'rb') as f:
    requests.post('http://some.url/streamed', data=f)
```

### POST Multiple Multipart-Encoded Files

```python
<input type="file" name="images" multiple="true" required="true"/>
```

要实现，只要把文件设到一个元组的列表中，其中元组结构为 `(form_field_name, file_info)`:

```python
>>> url = 'http://httpbin.org/post'
>>> multiple_files = [
        ('images', ('foo.png', open('foo.png', 'rb'), 'image/png')),
        ('images', ('bar.png', open('bar.png', 'rb'), 'image/png'))]
>>> r = requests.post(url, files=multiple_files)
>>> r.text
{
  ...
  'files': {'images': 'data:image/png;base64,iVBORw ....'}
  'Content-Type': 'multipart/form-data; boundary=3131623adb2043caaeb5538cc7aa0b3a',
  ...
}
```

### Event Hooks 事件钩子

Requests有一个钩子系统，你可以用来操控部分请求过程，或信号事件处理。

Available hooks:
`
response:
The response generated from a Request.`

你可以通过传递一个 `{hook_name: callback_function}` 字典给 `hooks` 请求参数 为每个请求分配一个钩子函数：

```python
hooks=dict(response=print_url)
callback_function 会接受一个数据块作为它的第一个参数。

def print_url(r, *args, **kwargs):
    print(r.url)
```

若执行你的回调函数期间发生错误，系统会给出一个警告。

若回调函数返回一个值，默认以该值替换传进来的数据。若函数未返回任何东西， 也没有什么其他的影响。

我们来在运行期间打印一些请求方法的参数：

```python
>>> requests.get('http://httpbin.org', hooks=dict(response=print_url))
http://httpbin.org
<Response [200]>
```

### Proxy

如果需要使用代理，你可以通过为任意请求方法提供 proxies 参数来配置单个请求:

```python
import requests

proxies = {
  "http": "http://10.10.1.10:3128",
  "https": "http://10.10.1.10:1080",
}

requests.get("http://example.org", proxies=proxies)
```

你也可以通过环境变量 `HTTP_PROXY` 和 `HTTPS_PROXY` 来配置代理。

```python
$ export HTTP_PROXY="http://10.10.1.10:3128"
$ export HTTPS_PROXY="http://10.10.1.10:1080"

$ python
>>> import requests
>>> requests.get("http://example.org")
```

若你的代理需要使用`HTTP Basic Auth`，可以使用 `http://user:password@host/` 语法：

```python
proxies = {
    "http": "http://user:pass@10.10.1.10:3128/",
}
```
要为某个特定的连接方式或者主机设置代理，使用 `scheme://hostname` 作为 key， 它会针对指定的主机和连接方式进行匹配。

```python
proxies = {'http://10.20.1.128': 'http://10.10.1.10:5323'}
```

注意，代理 URL 必须包含连接方式。

### SOCKS
>2.10.0 新版功能.

除了基本的 HTTP 代理，Request 还支持 SOCKS 协议的代理。这是一个 **可选** 功能，若要使用， 你需要安装第三方库。

你可以用 pip 获取依赖:

```
$ pip install requests[socks]
```

安装好依赖以后，使用 SOCKS 代理和使用 HTTP 代理一样简单：

```python
proxies = {
    'http': 'socks5://user:pass@host:port',
    'https': 'socks5://user:pass@host:port'
}
```

## 参考

* [awesome-python](https://github.com/vinta/awesome-python)
* [python-requests doc](http://docs.python-requests.org/en/latest/)
