# Flask

一个 Python 微型框架


## A Minimal Application

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'
```

## Route Rules

```python
@app.route('/')
def index():
    return 'Index Page'

@app.route('/hello')
def hello():
    return 'Hello, World'
```

### Variable Rules

type | Info
---  | ---
string | accepts any text without a slash (the default)
int | accepts integers
float | like int but for floating point values
path | like the default but also accepts slashes
any | matches one of the items provided
uuid | accepts UUID strings

```python
@app.route('/user/<username>')
def show_user_profile(username):
    # show the user profile for that user
    return 'User %s' % username

@app.route('/post/<int:post_id>')
def show_post(post_id):
    # show the post with the given id, the id is an integer
    return 'Post %d' % post_id
```

### URL Building

可以根据route， url_for 生成URL链接

```python
>>> from flask import Flask, url_for
>>> app = Flask(__name__)
>>> @app.route('/')
... def index(): pass
...
>>> @app.route('/login')
... def login(): pass
...
>>> @app.route('/user/<username>')
... def profile(username): pass
...
>>> with app.test_request_context():
...  print url_for('index')
...  print url_for('login')
...  print url_for('login', next='/')
...  print url_for('profile', username='John Doe')
...
/
/login
/login?next=/
/user/John%20Doe
```

### HTTP Methods

```python
from flask import request

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        do_the_login()
    else:
        show_the_login_form()
```

常用方法：

* GET
* HEAD 浏览器通知服务端，只关注headers信息而忽略页面内容本身
* POST
* PUT 和POST很像，在传递大数据可能出现断线的情况下，能支持快速二次上传数据
* DELETE
* OPTIONS

### Static Files

Flask 将所有静态文件放在`static`子目录下。使用`url_for(‘static’)`来获取静态文件目录。可以在创建应用时，指定”static_folder”参数。

```python
app = Flask(__name__, static_folder='files')

# static/style.css
url_for('static', filename='style.css')

```
## Rendering Templates

```python
from flask import render_template

@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)
```

hello.html

```html
<!doctype html>
<title>Hello from Flask</title>
{% if name %}
  <h1>Hello {{ name }}!</h1>
{% else %}
  <h1>Hello, World!</h1>
{% endif %}
```

### Templates 里可以适用的方法和参数

*  `request`
*  `session`
*  `g`  as  `get_flashed_messages()`

### 转义字符处理

```python
>>> from flask import Markup
>>> Markup('<strong>Hello %s!</strong>') % '<blink>hacker</blink>'
Markup(u'<strong>Hello &lt;blink&gt;hacker&lt;/blink&gt;!</strong>')
>>> Markup.escape('<blink>hacker</blink>')
Markup(u'&lt;blink&gt;hacker&lt;/blink&gt;')
>>> Markup('<em>Marked up</em> &raquo; HTML').striptags()
u'Marked up \xbb HTML'
```

## Request

`request` 对象只有在请求上下文的生命周期内才可以访问

```python
class flask.Request( environ, populate_request=True, shallow=False ) 
The request object used by default in Flask. Remembers the matched endpoint and view arguments.
It is what ends up as request. If you want to replace the request object used you can subclass this and set request_class to your subclass.
The request object is a Request subclass and provides all of the attributes Werkzeug defines plus a few Flask specific ones.

form 
一个包含解析过的从 POST 或 PUT 请求发送的表单对象的 MultiDict 。请注意上传的文件不会在这里，而是在 files 属性中。

args 
一个包含解析过的查询字符串（ URL 中问号后的部分）内容的 MultiDict 。

values 
一个包含 form 和 args 全部内容的 CombinedMultiDict 。

headers 
进入请求的标头存为一个类似字典的对象。

data 
如果进入的请求数据是 Flask 不能处理的 mimetype ，数据将作为字符串存于此。

files 
一个包含 POST 和 PUT 请求中上传的文件的 MultiDict 。每个文件存储为 FileStorage 对象。其基本的行为类似你在 Python 中见到的标准文件对象，差异在于这个对象有一个 save() 方法可以把文件存储到文件系统上。

method 
当前请求的 HTTP 方法 (POST ， GET 等等)

* blueprint 
The name of the current blueprint

* get_json( force=False, silent=False, cache=True ) 
Parses the incoming JSON request data and returns it. If parsing fails the on_json_loading_failed() method on the request object will be invoked. By default this function will only load the json data if the mimetype is application/json but this can be overriden by the force parameter.
参数:
- force : if set to True the mimetype is ignored.
- silent : if set to False this method will fail silently and return False.
- cache : if set to True the parsed JSON data is remembered on the request.

json 
If the mimetype is application/json this will contain the parsed JSON data. Otherwise this will be None.
The get_json() method should be used instead.
```
从中可以得到一些信息(POST方法)

* json格式的报文应该通过 request.get_json() 来获取
* 其他格式的报文 一般是通过 request.form.get()来获取

使用 `request.form` 的方式获取了数据

```python
@app.route('/login', methods=['POST', 'GET'])
def login():
    error = None
    if request.method == 'POST':
        if valid_login(request.form['username'],
                       request.form['password']):
            return log_the_user_in(request.form['username'])
        else:
            error = 'Invalid username/password'
    # the code below is executed if the request method
    # was GET or the credentials were invalid
    return render_template('login.html', error=error)
```

在URL中后面添加参数 (`?key=value`) 方式获取数据

```python
searchword = request.args.get('key', '')
```

**上述两种方式 没有相应的字段会 `raise KeyError`，页面会返回 `HTTP 400`**

## File Uploads 文件上传

可以轻易的使用 `flask` 进行文件上传，`form` 一定要对 `enctype="multipart/form-data"` 进行设置才能有效

```python
from flask import request

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # 上传成功的文件读取在内存当中后者存放在临时文件夹
        # 通过 request.files 方式获得文件数据
        f = request.files['the_file']
        # 通过 save 方式可以对文件进行存储
        f.save('/var/www/uploads/uploaded_file.txt')
        # 通过 secure_filename 方式获得客户端上传文件时候的文件名称
        # f.save('/var/www/uploads/' + secure_filename(f.filename))
    ...
```

## Flash

`“Flask Message`是一个很有意思的功能，一般一个操作完成后，我们都希望在页面上闪出一个消息，告诉用户操作的结果。用户看完后，这个消息就不复存在了。Flask提供的`flash`功能就是为了这个。我们还是拿用户登录来举例子：

```python
from flask import render_template, request, session, url_for, redirect, flash
 
@app.route('/')
def index():
    if 'user' in session:
        return render_template('hello.html', name=session['user'])
    else:
        return redirect(url_for('login'), 302)
 
@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        session['user'] = request.form['user']
        flash('Login successfully!')
        return redirect(url_for('index'))
    else:
        return '''
        <form name="login" action="/login" method="post">
            Username: <input type="text" name="user" />
        </form>
        '''
```
上例中，当用户登录成功后，就用`flash()`函数闪出一个消息。让我们找回第三篇中的模板代码，在`layout.html`加上消息显示的部分：

```python
<!doctype html>
<title>Hello Sample</title>
<link rel="stylesheet" type="text/css" href="{{ url_for('static', filename='style.css') }}">
{% with messages = get_flashed_messages() %}
  {% if messages %}
    <ul class="flash">
    {% for message in messages %}
      <li>{{ message }}</li>
    {% endfor %}
    </ul>
  {% endif %}
{% endwith %}
<div class="page">
    {% block body %}
    {% endblock %}
</div>
```

上例中`get_flashed_messages()`函数就会获取我们在`login()`中通过`flash()`闪出的消息。从代码中我们可以看出，闪出的消息可以有多个。模板`hello.html`不用改。运行下试试。登录成功后，是不是出现了一条`Login successfully`文字？再刷新下页面，你会发现文字消失了。你可以通过CSS来控制这个消息的显示方式。

`“flash()`方法的第二个参数是消息类型，可选择的有`message”, “info”, “warning”, “error`。你可以在获取消息时，同时获取消息类型，还可以过滤特定的消息类型。只需设置`get_flashed_messages()`方法的`with_categories`和`category_filter`参数即可。比如，Python部分可改为：

```python
@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        session['user'] = request.form['user']
        flash('Login successfully!', 'message')
        flash('Login as user: %s.' % request.form['user'], 'info')
        return redirect(url_for('index'))
    ...
```

layout模板部分可改为：

```python
...
{% with messages = get_flashed_messages(with_categories=true, category_filter=["message","error"]) %}
  {% if messages %}
    <ul class="flash">
    {% for category, message in messages %}
      <li class="{{ category }}">{{ category }}: {{ message }}</li>
    {% endfor %}
    </ul>
  {% endif %}
{% endwith %}
...
```

## Response

`Response` 为 `default_mimetype = 'text/html'` 的 `ResponseBase`

`jsonify` 为 `mimetype=current_app.config['JSONIFY_MIMETYPE']` 的 `BaseResponse`，具体为 `json` 的 type

## Cookies

通过 `set_cookie` 设置 `cookie` 信息

请求对象的 `cookies` 属性是一个包含客户端传输的所有 `cookies` 的字典，使用 [Sessions](#Sessions) 来代替 `cookies`

读取 cookies:

```python
from flask import request

@app.route('/')
def index():
    username = request.cookies.get('username')
    # use cookies.get(key) instead of cookies[key] to not get a
    # KeyError if the cookie is missing.
```

存储 cookies:

```python
from flask import make_response

# 通常返回的 Viewfunction 可以返回相应的 cookie，若你想修改他，可以使用 make_response 的方式进行修改
@app.route('/')
def index():
    resp = make_response(render_template(...))
    resp.set_cookie('username', 'the username')
    return resp
``` 

## Redirects and Errors 跳转 和 错误处理

跳转可以直接使用 `redirect` 方法，跳出错误则可以使用 `abort` 方法，传入相应的错误代码

```python
from flask import abort, redirect, url_for

@app.route('/')
def index():
    return redirect(url_for('login'))

@app.route('/login')
def login():
    abort(401)
    this_is_never_executed()
```

可以通过 `errorhandler()` 修饰符来创建自定义错误页面，如下面中经常碰到的 `404`

```python
from flask import render_template

@app.errorhandler(404)
def page_not_found(error):
    return render_template('page_not_found.html'), 404
```

## Sessions

```python
from flask import Flask, session, redirect, url_for, escape, request

app = Flask(__name__)

@app.route('/')
def index():
    if 'username' in session:
        return 'Logged in as %s' % escape(session['username'])
    return 'You are not logged in'

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['username'] = request.form['username']
        return redirect(url_for('index'))
    return '''
        <form action="" method="post">
            <p><input type=text name=username>
            <p><input type=submit value=Login>
        </form>
    '''

@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    session.pop('username', None)
    return redirect(url_for('index'))

# set the secret key.  keep this really secret:
app.secret_key = 'A0Zr98j/3yX R~XHH!jmN]LWX/,?RT'
```


## blueprint

`blueprint` 蓝图是 `flask` 进行模块化的关键。比较好的习惯是将蓝图放在一个单独的包里，所以先创建一个”simple_page”子目录，并创建一个空的”__init__.py”表示它是一个Python的包。

simple_page.py

```python
from flask import Blueprint, render_template, abort
from jinja2 import TemplateNotFound

simple_page = Blueprint('simple_page', __name__,
                        template_folder='templates')

@simple_page.route('/', defaults={'page': 'index'})
@simple_page.route('/<page>')
def show(page):
    try:
        return render_template('pages/%s.html' % page)
    except TemplateNotFound:
        abort(404)
```

```python
from flask import Flask
from yourapplication.simple_page import simple_page

app = Flask(__name__)
app.register_blueprint(simple_page)
```

如果你检查注册到应用的规则，你将会发现这些:

```python
[<Rule '/static/<filename>' (HEAD, OPTIONS, GET) -> static>,
 <Rule '/<page>' (HEAD, OPTIONS, GET) -> simple_page.show>,
 <Rule '/' (HEAD, OPTIONS, GET) -> simple_page.show>]
```

第一个显然是来自应用自身，用于静态文件。其它的两个用于 simple_page 蓝图中的 show 函数。如你所见，它们的前缀是蓝图的名称，并且用一个点(.)来分割。

不过，蓝图也可以在不同的位置挂载:

```python
app.register_blueprint(simple_page, url_prefix='/pages')
```
果然，生成这些规则:

```python
[<Rule '/static/<filename>' (HEAD, OPTIONS, GET) -> static>,
 <Rule '/pages/<page>' (HEAD, OPTIONS, GET) -> simple_page.show>,
 <Rule '/pages/' (HEAD, OPTIONS, GET) -> simple_page.show>]
```

### Blueprint Resources 蓝图资源文件夹

与常规应用一样，蓝图被认为是包含在一个文件夹中

```python
>>> simple_page.root_path
'/Users/username/TestProject/yourapplication'

# 你可以使用 open_resource() 函数快速性这个文件夹中打开资源:
with simple_page.open_resource('static/style.css') as f:
    code = f.read()
```

### 蓝图静态文件

一个蓝图可以通过 `static_folder` 关键字参数提供一个指向文件系统上文件夹的路 径，来公开一个带有静态文件的文件夹。这可以是一个绝对路径，也可以是相对于蓝图文件夹的路径:

```python
admin = Blueprint('admin', __name__, static_folder='static')
```

默认情况下，路径最右边的部分就是它在 `web` 上所公开的地址。因为这里这个文件夹叫做 `static` ， 它会在蓝图 `+ /static` 的位置上可用。也就是说，蓝图为 `/admin` 把静态文件夹注册到 `/admin/static` 。

最后是命名的 `blueprint_name.static` ，这样你可以生成它的 `URL` ，就像你对应用的静态文件夹所做的那样:

```python
url_for('admin.static', filename='style.css')
```

## endpoint

`route` 其实是 `add_url_rule ` 的包装

```python
@setupmethod
def add_url_rule(self, rule, endpoint=None, view_func=None, **options):
    """Connects a URL rule.  Works exactly like the :meth:`route`
    decorator.  If a view_func is provided it will be registered with the
    endpoint.

    Basically this example::

        @app.route('/')
        def index():
            pass

    Is equivalent to the following::

        def index():
            pass
        app.add_url_rule('/', 'index', index)

    If the view_func is not provided you will need to connect the endpoint
    to a view function like so::

        app.view_functions['index'] = index

    Internally :meth:`route` invokes :meth:`add_url_rule` so if you want
    to customize the behavior via subclassing you only need to change
    this method.

    For more information refer to :ref:`url-route-registrations`.

    .. versionchanged:: 0.2
       `view_func` parameter added.

    .. versionchanged:: 0.6
       ``OPTIONS`` is added automatically as method.

    :param rule: the URL rule as string
    :param endpoint: the endpoint for the registered URL rule.  Flask
                     itself assumes the name of the view function as
                     endpoint
    :param view_func: the function to call when serving a request to the
                      provided endpoint
    :param options: the options to be forwarded to the underlying
                    :class:`~werkzeug.routing.Rule` object.  A change
                    to Werkzeug is handling of method options.  methods
                    is a list of methods this rule should be limited
                    to (``GET``, ``POST`` etc.).  By default a rule
                    just listens for ``GET`` (and implicitly ``HEAD``).
                    Starting with Flask 0.6, ``OPTIONS`` is implicitly
                    added and handled by the standard request handling.
    """
    # endpoint为空时，用的是 view_func.__name__
    if endpoint is None:
        endpoint = _endpoint_from_view_func(view_func)
    options['endpoint'] = endpoint
    methods = options.pop('methods', None)

    # if the methods are not given and the view_func object knows its
    # methods we can use that instead.  If neither exists, we go with
    # a tuple of only ``GET`` as default.
    # 没有 methods 方法，则默认为 GET
    if methods is None:
        methods = getattr(view_func, 'methods', None) or ('GET',)
    if isinstance(methods, string_types):
        raise TypeError('Allowed methods have to be iterables of strings, '
                        'for example: @app.route(..., methods=["POST"])')
    methods = set(item.upper() for item in methods)

    # Methods that should always be added
    required_methods = set(getattr(view_func, 'required_methods', ()))

    # starting with Flask 0.8 the view_func object can disable and
    # force-enable the automatic options handling.
    provide_automatic_options = getattr(view_func,
        'provide_automatic_options', None)

    if provide_automatic_options is None:
        if 'OPTIONS' not in methods:
            provide_automatic_options = True
            required_methods.add('OPTIONS')
        else:
            provide_automatic_options = False

    # Add the required methods now.
    methods |= required_methods

    # 通过 options['endpoint']，rule.endpoint = endpoint
    rule = self.url_rule_class(rule, methods=methods, **options)
    rule.provide_automatic_options = provide_automatic_options
    
    # url_map 管理映射了 url --> endpoint 的关系
    self.url_map.add(rule)
    if view_func is not None:
        # 若存在已经有的 endpoint 则抛出错误
        old_func = self.view_functions.get(endpoint)
        if old_func is not None and old_func != view_func:
            raise AssertionError('View function mapping is overwriting an '
                                 'existing endpoint function: %s' % endpoint)
        # view_functions 管理映射了 endpoint --> view_func 的关系
        self.view_functions[endpoint] = view_func
```

为什么需要添加 `endpoint` 作为中间节点，来处理 `rule --> endpoint --> view_func` 的关系？
答案是为了 `url_for` 进行服务

user.py

```python
user = Blueprint('user', __name__)
@user.route('/greeting')
def greeting():
    return 'Hello, lowly normal user!'
```

admin.py

```python
admin = Blueprint('admin', __name__)
@admin.route('/greeting')
def greeting():
    return 'Hello, administrative user!'
```

分布在不同文件下的不同 `view` 函数，可以通过 `url_for('admin.greeting')` 或 `url_for('user.greeting')` 来跳转

## Signals
```python

# Signal的创建
from blinker import Namespace
my_signals = Namespace()
model_saved = my_signals.signal('model-saved')

# Signal的发送
# In case send signal in a class:
class Model(object):
    ...

    def save(self):
        model_saved.send(self)

# In case send signal in a function:
def save_model():
    ...

    model_saved.send(current_app._get_current_object())

# 编写Signal的订阅者
# 修饰符
from flask import template_rendered

# sender: 获取消息的发送者
# template: 被渲染的模板对象
# context: 当前请求的上下文环境
# **extra: 匹配任意额外的参数。如果上面三个存在，这个参数不加也没问题。但是如果你的参数少于三个，就一定要有这个参数。一般习惯上加上此参数。
@template_rendered.connect_via(app)
def when_template_rendered(sender, template, context, **extra):
    print 'Template %s is rendered with %s' % (template.name, context)

# 方法connect disconnect
template_rendered.connect(when_template_rendered, app)
template_rendered.disconnect(when_template_rendered, app)

```

## View 视图
### 视图装饰器

```python
from flask import Flask, render_template
 
app = Flask(__name__)
 
@app.route('/')
def index():
    return '<h1>Hello World!</h1>'
 
@app.route('/hello')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello-view.html', name=name)
 
@app.route('/admin')
def admin():
    return '<h1>Admin Dashboard</h1>'
 
if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

模板代码如下：

```python
<!DOCTYPE html>
<title>Hello View</title>
{% if name %}
  <h1>Welcome {{ name }}</h1>
{% else %}
  <h1>Welcome Guest</h1>
{% endif %}
```

现在，我希望当用户访问`admin`页面时，必须先登录。大家马上会想到在`admin()`方法里判断会话`session`。这样的确可以达成目的，不过当我们有n多页面都要进行用户验证的话，判断用户登录的代码就会到处都是，即便我们封装在一个函数里，至少调此函数的代码也会重复出现。有没有什么办法，可以像`Java Sevlet`中的`Filter`一样，能够在请求入口统一处理呢？`Flask`没有提供特别的功能来实现这个，因为`Python`本身有，那就是装饰器。

我们现在就来写个验证用户登录的装饰器：

```python
from functools import wraps
from flask import session, abort
 
def login_required(func):
    @wraps(func)
    def decorated_function(*args, **kwargs):
        if not 'user' in session:
            abort(401)
        return func(*args, **kwargs)
    return decorated_function
 
app.secret_key = '12345678'
```

代码很简单，就是在调用函数前，先检查session里有没有用户。此后，我们只需将此装饰器加在每个需要验证登录的请求方法上即可：

```python
@app.route('/admin')
@login_required
def admin():
    return '<h1>Admin Dashboard</h1>'
```

这个装饰器就被称为视图装饰器(View Decorator)。为了减少篇幅，我这里省略了登录部分的代码，大家可以参阅入门系列的第四篇中。朋友们想想，还有什么功能可以写在视图装饰器里？对，页面缓存。我们可以把页面的路径作为键，页面内容作为值，放在缓存里。每次进入请求函数前，先判断缓存里有没有该页面，有就直接将缓存里的值返回，没有则执行请求函数，将结果存在缓存后再返回。

官方文档中有更多视图装饰器的示例，大家可以借鉴下。

### URL集中映射

为了引出后面的内容，我们先来介绍下Flask中的URL集中映射功能。之前所有的例子中，URL路由都是作为装饰器写在请求函数，也就是视图函数之上的。这样做的优点就是程序一目了然，方便修改，就像Java领域的Hibernate，从3.0开始支持将数据库的字段映射直接写在JavaBean的属性上，代码维护起来方便多了。熟悉Django的朋友们知道，Django的URL路由是统一写在一个专门的文件里，习惯上是`urls.py`。Django为什么不学Flask呢？其实，对于规模较大的应用，URL路径相当多，这时所有的路由规则放在一起其实更容易管理，批量修改起来也方便。Django面向的应用一般规模较Flask要大，所以这种情况下，统一路由管理比程序一目了然可能更重要。

说了这么多，就是要告诉大家，其实Flask也支持像Django一样，把URL路由规则统一管理，而不是写在视图函数上。怎么做呢？我们先来写个视图函数，将它放在一个`views.py`文件中：

```python
def foo():
    return '<h1>Hello Foo!</h1>'
```
然后在Flask主程序上调用`app.add_url_rule`方法：

```python
app.add_url_rule('/foo', view_func=views.foo)
```

这样，路由`/foo`就绑定在`views.foo()`函数上了，效果等同于在`views.foo()`函数上加上`@app.route(‘/foo’)`装饰器。通过`app.add_url_rule`方法，我们就可以将路由同视图分开，将路由统一管理，实现完全的MVC。

那么在这种情况下，上一节定义的装饰器怎么用？大家想想，装饰器本质上是一个闭包函数，所以我们当然可以把它当函数使用：

```python
app.add_url_rule('/foo', view_func=login_required(views.foo))
```

### 可插拔视图Pluggable View

#### 视图类

上一节的URL集中映射，就是视图可插拔的基础，因为它可以支持在程序中动态的绑定路由和视图。Flask提供了视图类，使其可以变得更灵活，我们先看个例子：

```python
from flask.views import View
 
class HelloView(View):
    def dispatch_request(self, name=None):
        return render_template('hello-view.html', name=name)
 
view = HelloView.as_view('helloview')
app.add_url_rule('/helloview', view_func=view)
app.add_url_rule('/helloview/<name>', view_func=view)
```

我们创建了一个`flask.views.View`的子类，并覆盖了其`dispatch_request()`函数，渲染视图的主要代码必须写在这个函数里。然后我们通过`as_view()`方法把类转换为实际的视图函数，`as_view()`必须传入一个唯一的视图名。此后，这个视图就可以由`app.add_url_rule`方法绑定到路由上了。上例的效果，同本篇第一节中`/hello`路径的效果，完全一样。

这个例子比较简单，只是为了介绍怎么用视图类，体现不出它的灵活性，我们再看个例子：

```python
class RenderTemplateView(View):
    def __init__(self, template):
        self.template = template
 
    def dispatch_request(self):
        return render_template(self.template)
 
app.add_url_rule('/hello', view_func=RenderTemplateView.as_view('hello', template='hello-view.html'))
app.add_url_rule('/login', view_func=RenderTemplateView.as_view('login', template='login-view.html'))
```

很多时候，渲染视图的代码都类似，只是模板不一样罢了。我们完全可以把渲染视图的代码重用，上例中，我们就省去了分别定义`hello`和`login`视图函数的工作了。

#### 视图装饰器支持

在使用视图类的情况下，视图装饰器要怎么用呢？Flask在0.8版本后支持这样的写法：

```python
class HelloView(View):
    decorators = [login_required]
 
    def dispatch_request(self, name=None):
        return render_template('hello-view.html', name=name)
```

我们只需将装饰器函数加入到视图类变量`decorators`中即可。它是一个列表，所以能够支持多个装饰器，并按列表中的顺序执行。

#### 请求方法的支持

当我们的视图要同时支持GET和POST请求时，视图类可以这么定义：

```python
class MyMethodView(View):
    methods = ['GET', 'POST']
 
    def dispatch_request(self):
        if request.method == 'GET':
            return '<h1>Hello World!</h1>This is GET method.'
        elif request.method == 'POST':
            return '<h1>Hello World!</h1>This is POST method.'
 
app.add_url_rule('/mmview', view_func=MyMethodView.as_view('mmview'))
```

我们只需将需要支持的HTTP请求方法加入到视图类变量`methods`中即可。没加的话，默认只支持GET请求。

#### 基于方法的视图

上节介绍的HTTP请求方法的支持，的确比较方便，但是对于RESTFul类型的应用来说，有没有更简单的方法，比如省去那些if, else判断语句呢？Flask中的`flask.views.MethodView`就可以做到这点，它是`flask.views.View`的子类。我们写个user API的视图吧：

```python
from flask.views import MethodView
 
class UserAPI(MethodView):
    def get(self, user_id):
        if user_id is None:
            return 'Get User called, return all users'
        else:
            return 'Get User called with id %s' % user_id
 
    def post(self):
        return 'Post User called'
 
    def put(self, user_id):
        return 'Put User called with id %s' % user_id
 
    def delete(self, user_id):
        return 'Delete User called with id %s' % user_id
```

现在我们分别定义了`get, post, put, delete`方法来对应四种类型的HTTP请求，注意函数名必须这么写。怎么将它绑定到路由上呢？

```python
user_view = UserAPI.as_view('users')
# 将GET /users/请求绑定到UserAPI.get()方法上，并将get()方法参数user_id默认为None
app.add_url_rule('/users/', view_func=user_view, 
                            defaults={'user_id': None}, 
                            methods=['GET',])
# 将POST /users/请求绑定到UserAPI.post()方法上
app.add_url_rule('/users/', view_func=user_view, 
                            methods=['POST',])
# 将/users/<user_id>URL路径的GET，PUT，DELETE请求，
# 绑定到UserAPI的get(), put(), delete()方法上，并将参数user_id传入。
app.add_url_rule('/users/<user_id>', view_func=user_view, 
                                     methods=['GET', 'PUT', 'DELETE'])
```

为了方便阅读，我将注释放到了代码上，大家如果直接拷贝的话，记得在代码开头加上`#coding:utf8`来支持中文。上例中`app.add_url_rule()`可以传入参数`default`，来设置默认值；参数`methods`，来指定支持的请求方法。

如果API多，有人觉得每次都要加这么三个路由规则太麻烦，可以将其封装个函数：

```python
def register_api(view, endpoint, url, primary_id='id', id_type='int'):
    view_func = view.as_view(endpoint)
    app.add_url_rule(url, view_func=view_func,
                          defaults={primary_id: None},
                          methods=['GET',])
    app.add_url_rule(url, view_func=view_func,
                          methods=['POST',])
    app.add_url_rule('%s<%s:%s>' % (url, id_type, primary_id),
                          view_func=view_func,
                          methods=['GET', 'PUT', 'DELETE'])
 
register_api(UserAPI, 'users', '/users/', primary_id='user_id')
```

现在，一个`register_api()`就可以绑定一个API了，还是挺easy的吧。

### 延迟加载视图

当某一视图很占内存，而且很少会被使用，我们会希望它在应用启动时不要被加载，只有当它被使用时才会被加载。也就是接下来要介绍的延迟加载。Flask原生并不支持视图延迟加载功能，但我们可以通过代码实现。这里，我引用了官方文档上的一个实现。

```python
from werkzeug import import_string, cached_property
 
class LazyView(object):
    def __init__(self, import_name):
        self.__module__, self.__name__ = import_name.rsplit('.', 1)
        self.import_name = import_name
 
    @cached_property
    def view(self):
        return import_string(self.import_name)
 
    def __call__(self, *args, **kwargs):
        return self.view(*args, **kwargs)
```

我们先写了一个LazyView，然后在views.py中定义一个名为bar的视图函数：

```python
def bar():
    return '<h1>Hello Bar!</h1>'
```

现在让我们来绑定路由：

```python
app.add_url_rule('/lazy/bar', view_func=LazyView('views.bar'))
```

路由绑定在LazyView的对象上，因为实现了`__call__`方法，所以这个对象可被调用，不过只有当`/lazy/bar`地址被请求时才会被调用。此时`werkzeug.import_string`方法会被调用，看了下Werkzeug的源码，它的本质就是调用`__import__`来动态地导入Python的模块和函数。所以，这个`view.bar`函数只会在`/lazy/bar`请求发生时才被导入到主程序中。不过要是每次请求发生都被导入一次的话，开销也很大，所以，代码使用了`werkzeug.cached_property`装饰器把导入后的函数缓存起来。

这个LazyView的实现还是挺有趣的吧。可能有一天，Flask会把延迟加载视图的功能加入到它的原生代码中。同上一节的`register_api()`函数一样，你也可以把绑定延迟加载视图的代码封装在一个函数里。

```python
def add_url_for_lazy(url_rule, import_name, **options):
    view = LazyView(import_name)
    app.add_url_rule(url_rule, view_func=view, **options)
 
add_url_for_lazy('/lazy/bar', 'views.bar')
```

## 获取用户真实ip
从request.headers获取

```python
real_ip = request.headers.get('X-Real-Ip', request.remote_addr)
```

或者, 使用werkzeug的middleware 文档

```python
from werkzeug.contrib.fixers import ProxyFix
app.wsgi_app = ProxyFix(app.wsgi_app)
```
##参考

* [Flask@PyPI](http://flask.pocoo.org/)
* [Flask@GitHub](https://github.com/mitsuhiko/flask-sqlalchemy)
* [Flask@Doc](http://flask.pocoo.org/docs)
* [SQLAlchemy](http://www.sqlalchemy.org/)
* [Flask-SQLAlchemy](http://flask-sqlalchemy.pocoo.org/)
* [Flask-SQLAlchemy@Doc-CN](http://www.pythondoc.com/flask-sqlalchemy/)
* [Flask入门系列](http://www.bjhee.com/flask-1.html)
* [Flask进阶系列](http://www.bjhee.com/flask-ad1.html)
* [Flask扩展系列](http://www.bjhee.com/flask-ext1.html)