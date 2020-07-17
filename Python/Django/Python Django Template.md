# Template 模板


Django模板是一个简单的文本文档，或用Django模板语言标记的一个Python字符串。 某些结构是被模板引擎解释和识别的。主要的有变量和标签。

模板是由`context`来进行渲染的。渲染的过程是用在`context`中找到的值来替换模板中相应的变量，并执行相关`tags`。其他的一切都原样输出。

## 模板继承

```html
# base.html

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="style.css" />
    <title>{% block title %}My amazing site{%/span> endblock %}</title>
</head>

<body>
    <div id="sidebar">
        {% block sidebar %}
        <ul>
            <li><a href="/">Home</a></li>
            <li><a href="/blog/">Blog</a></li>
        </ul>
        {% endblock %}
    </div>

    <div id="content">
        {% block content %}{% endblock %}
    </div>
</body>
</html>
```

子模板可能看起来这样：

```python
{% extends "base.html" %}/span>

{% block title %}My amazing blog{% endblock %}

{% block content %}
{% for entry in blog_entries %}
    <h2>{{ entry.title }}</h2>
    <p>{{ entry.body }}</p>
{% endfor %}
{% endblock %}
```

`extends` 标签是这里的关键;模版引擎将注意到 `base.html` 中的三个 `block` 标签，并用子模版中的内容来替换这些`block`

使用继承的一个常用方式是类似下面的三级结构：

* 创建一个 `base.html` 模版来控制您整个站点的主要视觉和体验。
* 为您的站点的每一个“分支”创建一个`base_SECTIONNAME.html` 模版。例如， `base_news.html`, `base_sports.html`。这些模版都继承自 `base.html` ，并且包含了每部分特有的样式和设计。
* 为每一种页面类型创建独立的模版，例如新闻内容或者博客文章。这些模版继承对应分支的模版。

这里是使用继承的一些提示：

* 如果你在模版中使用 `{% extends %}` 标签，它必须是模版中的第一个标签。其他的任何情况下，模版继承都将无法工作。
* 在base模版中设置越多的 `{% block %}` 标签越好。请记住，子模版不必定义全部父模版中的`blocks`，所以，你可以在大多数`blocks`中填充合理的默认内容，然后，只定义你需要的那一个。多一点钩子总比少一点好。
* 如果你发现你自己在大量的模版中复制内容，那可能意味着你应该把内容移动到父模版中的一个 `{% block %}` 中。
* 如果需要获取父模板中的`block` 的内容，可以使用`{{ block.super }}` 变量。如果你想要在父`block` 中新增内容而不是完全覆盖它，它将非常有用。使用`{{ block.super }}` 插入的数据不会被自动转义（参见下一节），因为父模板中的内容已经被转义。

## 变量

变量的值是来自`context`中的输出, 这类似于字典对象的`keys`到`values`的映射关系

`{{ }}`

字典查询，属性查询和列表索引查找都是通过一个点符号来实现：

```
{{ my_dict.key }}
{{ my_object.attribute }}
{{ my_list.0 }}
```

例子：

```
My first name is {{ first_name }}. My last name is {{ last_name }}.

# 如果使用一个 context包含 {'first_name': 'John', 'last_name': 'Doe'}, 这个模板渲染后的情况将是:

My first name is John. My last name is Doe.
```


## 标签

标签在渲染的过程中提供任意的逻辑。

这个定义是刻意模糊的。例如，一个标签可以输出内容，作为控制结构，例如`if`语句或`for`循环从数据库中提取内容，甚至可以访问其他的模板标签。

`{% %}`

例子：

```
{%< if user.is_authenticated %}Hello, {{ user.username }}.{%< endif %}
```

### 常见的内置标签


**comment**

```html
<p>Rendered text with {{ pub_date|date:"c" }}</p>
{% comment "Optional note" %}
    <p>Commented out text with {{ create_date|date:"c" }}</p>
{% endcomment %}
```

**cycle**

```html
{% for o in some_list %}
    <tr class="{% cycle 'row1' 'row2' %}">
        ...
    </tr>
{% endfor %}

# 第一次迭代产生的HTML引用了 row1类，第二次则是row2类，第三次 又是row1 类，如此类推。
# 你也可以使用变量，例如，如果你有两个模版变量, rowvalue1和rowvalue2, 你可以让他们的值像这样替换:

{% for o in some_list %}
    <tr class="{% cycle rowvalue1 rowvalue2 %}">
        ...
    </tr>
{% endfor %}

# 禁止自动转义
{% for o in some_list %}
    <tr class="{% autoescape off %}{% cycle rowvalue1 rowvalue2 %}{% endautoescape %}">
        ...
    </tr>
{% endfor %}

# 混合使用变量和字符串：
{% for o in some_list %}
    <tr class="{% cycle 'row1' rowvalue2 'row3' %}">
        ...
    </tr>
{% endfor %}


<tr>
    <td class="{% cycle 'row1' 'row2' as rowcolors %}">...</td>
    <td class="{{ rowcolors }}">...</td>
</tr>
<tr>
    <td class="{% cycle rowcolors %}">...</td>
    <td class="{{ rowcolors }}">...</td>
</tr>
# 将输出：
<tr>
    <td class="row1">...</td>
    <td class="row1">...</td>
</tr>
<tr>
    <td class="row2">...</td>
    <td class="row2">...</td>
</tr>

# 默认情况下，当你在cycle标签中使用as 关键字时，关于{% cycle %}的使用，
# 会启动cycle并且直接产生第一个值。如果你想要在嵌套循环中或者included模版中使用这个值，
# 那么将会遇到困难。如果你只是想要声明cycle，但是不产生第一个值，
# 你可以添加一个silent关键字来作为cycle标签的最后一个关键字。例如:
{% for obj in some_list %}
    {% cycle 'row1' 'row2' as rowcolors silent %}
    <tr class="{{ rowcolors }}">{% include "subtemplate.html" %}</tr>
{% endfor %}
# 这将输出<tr>元素的列表，其中class在row1和row2之间交替。子模板将在其上下文中访问rowcolors，并且该值将匹配包围它的<tr>的类
```

**firstof**

输出第一个不为False参数。如果传入的所有变量都为False，就什么也不输出

```python
{% firstof var1 var2 var3 %}
# 它等价于：
{% if var1 %}
    {{ var1 }}
{% elif var2 %}
    {{ var2 }}
{% elif var3 %}
    {{ var3 }}
{% endif %}
```

**for**

```python
<ul>
{% for athlete in athlete_list %}
    <li>{{ athlete.name }}</li>
{% endfor %}
</ul>

# 反向循环
{% for obj in list reversed %}

forloop.counter	# The current iteration of the loop (1-indexed)
forloop.counter0	# The current iteration of the loop (0-indexed)
forloop.revcounter	# The number of iterations from the end of the loop (1-indexed)
forloop.revcounter0	# The number of iterations from the end of the loop (0-indexed)
forloop.first	True # if this is the first time through the loop
forloop.last	True # if this is the last time through the loop
forloop.parentloop	# For nested loops, this is the loop surrounding the current one
```

**for ... empty**

```python
<ul>
{% for athlete in athlete_list %}
    <li>{{ athlete.name }}</li>
{% empty %}
    <li>Sorry, no athletes in this list.</li>
{% endfor %}
</ul>

它和下面的例子作用相等，但是更简洁、更清晰甚至可能运行起来更快：

<ul>
  {% if athlete_list %}
    {% for athlete in athlete_list %}
      <li>{{ athlete.name }}</li>
    {% endfor %}
  {% else %}
    <li>Sorry, no athletes in this list.</li>
  {% endif %}
</ul>
```

**if**

`if` 可以配合的标签：

* and
* or
* not
* ==
* !=
* <
* >
* <=
* >=
* in

**ifequal**

判断是否相等;`ifequal`标记的替代方法是使用`if`标记和`==`运算符


```
{% ifequal user.pk comment.user_id %}
    ...
{% endifequal %}
```

**include**

加载模板并以标签内的参数渲染。 `include` 标签应该被理解为是一种"将子模版渲染并嵌入HTML中"的变种方法,而不是认为是"解析子模版并在被父模版包含的情况下展现其被父模版定义的内容"。这意味着在不同的被包含的子模版之间并不共享父模版的状态,每一个子包含都是完全独立的渲染过程。

`Block`模块在被包含之前就已经被执行； 这意味着模版在被包含之前就已经从另一个`block`扩展并已经被执行并完成渲染 - 没有`block`模块会被`include`引入并执行,即使父模版中的扩展模版.

模板名可以是变量或者是硬编码的字符串，可以用单引号也可以是双引号

`{% include template_name %}`

```python
# 下面这个示例生成输出“Hello, John!”：
# 上下文：变量person设置为“John”，变量greeting设置为“Hello”。
# 模板：
{% include "name_snippet.html" %}

# name_snippet.html模板：
{{ greeting }}, {{ person|default:"friend" }}!

# 你可以使用关键字参数将额外的上下文传递到模板：
{% include "name_snippet.html" with person="Jane" greeting="Hello" %}
```

**regroup**

```
cities = [
    {'name': 'Mumbai', 'population': '19,000,000', 'country': 'India'},
    {'name': 'Calcutta', 'population': '15,000,000', 'country': 'India'},
    {'name': 'New York', 'population': '20,000,000', 'country': 'USA'},
    {'name': 'Chicago', 'population': '7,000,000', 'country': 'USA'},
    {'name': 'Tokyo', 'population': '33,000,000', 'country': 'Japan'},
]
```

你会希望用下面这种方式来展示国家和城市的信息

```
India
    孟买：19,000,000
    加尔各答：15,000,000
USA
    纽约：20,000,000
    芝加哥：7,000,000
Japan
    东京：33,000,000

# 你可以使用{% regroup %}标签来给每个国家的城市分组。以下模板代码片段将实现这一点：

{% regroup cities by country as country_list %}

# 让我们来看看这个例子。{% regroup %}有三个参数： 你想要重组的列表, 被分组的属性, 还有结果列表的名字. 
# 在这里，我们通过country属性重新分组cities列表，并调用结果country_list。
# {％ regroup ％}产生一个清单（在本例中为country_list的组对象。每个组对象有两个属性：
#   grouper - 按分组的项目（例如，字符串“India”或“Japan”）。
#   list - 此群组中所有项目的列表（例如，所有城市的列表，其中country ='India'）。

<ul>
{% for country in country_list %}
    <li>{{ country.grouper }}
    <ul>
        {% for item in country.list %}
          <li>{{ item.name }}: {{ item.population }}</li>
        {% endfor %}
    </ul>
    </li>
{% endfor %}
</ul>

# 使用dictsort过滤器对模板中的数据进行排序，如果您的数据在字典列表中：
{% regroup cities|dictsort:"country" by country as country_list %}
```

**templatetag**

```
openblock	{%
closeblock	%}
openvariable	{{
closevariable	}}
openbrace	{
closebrace	}
opencomment	{#
closecomment	#}

{% templatetag openblock %} url 'entry_list' {% templatetag closeblock %}
```

**widthratio**

为了创建条形图等，此标签计算给定值与最大值的比率，然后将该比率应用于常量。

```
<img src="bar.png" alt="Bar"
     height="10" width="{% widthratio this_value max_value max_width %}" />
如果this_value是175，max_value是200，并且max_width是100，则上述示例中的图像将是88像素宽（因为175 / 200 = .875； .875 * 100 = 87.5，上舍入为88）。

# 在某些情况下，您可能想要捕获变量中的widthratio的结果。
# 它可以是有用的，例如，在blocktrans像这样：

{% widthratio this_value max_value max_width as width %}
{% blocktrans %}The width is: {{ width }}{% endblocktrans %}
```

**with**

使用一个简单地名字缓存一个复杂的变量，当你需要使用一个“昂贵的”方法（比如访问数据库）很多次的时候是非常有用的

例如：

```
{% with total=business.employees.count %}
    {{ total }} employee{{ total|pluralize }}
{% endwith %}

# 你可以分配多个上下文变量：

{% with alpha=1 beta=2 %}
    ...
{% endwith %}
```

### 其他内置标签

```python
autoescape # 自动转义
block
csrf_token # 跨站请求伪造保护
debug
extends # {% extends "base.html" %} {% extends variable %}
filter
now # 显示最近的日期或事件,可以通过给定的字符串格式显示
spaceless # 删除HTML标签之间的空白格.包括制表符和换行
url 
```

## 过滤器
过滤器会更改变量或标签参数的值

`{{ django|title }}`

例子

```
{'django': 'the web framework for perfectionists with deadlines'}
{{ django|title }}
The Web Framework For Perfectionists With Deadlines
{{ my_date|date:"Y-m-d" }}
```

**内置过滤器**

```
add {{ value|add:"2" }} # 把add后的参数加给value
addslashes {{ value|addslashes }} # "I'm using Django", 输出将变成 "I\'m using Django".
capfirst {{ value|capfirst }} # "django", 输出将变成 "Django"
center {{ value|center:"15" }} # 使"value"在给定的宽度范围内居中
cut {{ value|cut:" " }} # “String with spaces”，输出将为"Stringwithspaces"
date {{ value|date:"D d M Y" }} {{ value|date:"SHORT_DATE_FORMAT" }} {{ value|date }} {{ value|date:"D d M Y" }} {{ value|time:"H:i" }}
time {{ value|time:"H:i" }}
timesince {{ blog_date|timesince:comment_date }}
timeuntil
default {{ value|default:"nothing" }} # value的计算结果为False，则使用给定的默认值。否则，使用该value
default_if_none {{ value|default_if_none:"nothing" }} # 如果value为None，则输出将为字符串“nothing”
dictsort {{ value|dictsort:"name" }} # 接受一个字典列表，并返回按参数中给出的键排序后的列表
divisibleby {{ value|divisibleby:"3" }} # 如果value可以被给出的参数整除，则返回 True
escape {{ title|escape }} # 转义字符串的HTML <转换为&lt;>转换为&gt;&转换为&amp;'（单引号）转换为&#39;"（双引号）转换为&quot;
filesizeformat {{ value|filesizeformat }} # 格式化数值为“人类可读”的文件大小（例如'13 KB', '4.1 MB', '102 bytes'等）
first {{ value|first }} # ['a'， 'b'， 'c'] ，输出将为'a'
last {{ value|last }} # ['a', 'b', 'c', 'd']，输出 "d"
length {{ value|length }} # value是['a'， 'b'， 'c'， 'd']或"abcd"，输出将为4；对于未定义的变量，过滤器返回0。以前，它返回一个空字符串
length_is {{ value|length_is:"4" }} # 如果值的长度是参数，则返回True，否则返回False；value是['a'， 'b'， 'c'， 'd']或"abcd"，输出将为True
floatformat
force_escape
get_digit {{ value|get_digit:"2" }} # 给定一个整数，返回所请求的数字，其中1是最右边的数字，2是第二个最右边的数字等；返回无效输入的原始值 如果value为123456789，则输出将为8
iriencode {{ value|iriencode }} # 转换为适合包含在URL中的字符串 value为"?test=1&me=2"，输出将为"?test=1&amp;me=2"
urlencode {{ value|urlencode }} # 转义要在URL中使用的值 value 为 "http://www.example.org/foo?a=b&c=d"，输出将为"http%3A//www.example.org/foo%3Fa%3Db%26c%3Dd"   {{ value|urlencode:"" }} value为"http://www.example.org/"，输出将为"http%3A%2F%2Fwww.example.org%2F"
urlize {{ value|urlize }} # 将文字中的网址和电子邮件地址转换为可点击的链接；由urlize生成的链接会向其中添加rel="nofollow"属性
urlizetrunc {{ value|urlizetrunc:15 }} # 将网址和电子邮件地址转换为可点击的链接，就像urlize，但截断长度超过给定字符数限制的网址
join {{ value|join:" // " }} # value是列表['a'， 'b'， 'c'] / t2>，输出将是字符串“a // b // c“
linebreaks {{ value|linebreaks }} # 用适当的HTML替换纯文本中的换行符；单个换行符变为HTML换行符（＆lt； br /＆gt；），新行后跟空行将成为段落（</p>）Joel为 a slug，输出将为＆lt； p＆gt； Joel＆lt； br /＆gt；是 a slug＆lt； / p＆gt；
linebreaksbr {{ value|linebreaksbr }} # 将纯文字中的所有换行符转换为HTML换行符（＆lt； br /＆gt；）value为Joel为 a slug，输出将为Joel＆lt； br /＆gt；是 a slug
linenumbers {{ value|linenumbers }} # 显示带行号的文本 value为one two three，那么输出为1. one 2. two 3. three
ljust {{ value|ljust }} # 将给定宽度的字段中的值左对齐
rjust {{ value|rjust }}
lower {{ value|lower }} # 将字符串转换为全部小写
upper {{ value|upper }}
make_list {{ value|make_list }} # 返回转换为列表的值。对于字符串，它是一个字符列表。对于整数，在创建列表之前将参数强制转换为unicode字符串
phone2numeric {{ value|phone2numeric }} # 将电话号码（可能包含字母）转换为其等效数字value为800-COLLECT，输出将为800-2655328
pluralize # 如果值不是1则返回一个复数形式通常用 's'表示.
random
safe
safeseq
slice {{ some_list|slice:":2" }}# 返回列表的一部 some_list是['a'， 'b'， 'c'] ，输出将为['a'， 'b']
slugify {{ value|slugify }} # 转换为ASCII。将空格转换为连字符。删除不是字母数字，下划线或连字符的字符。转换为小写。还剥离前导和尾随空格。
stringformat
striptags
title {{ value|title }} # value为“my FIRST post”，输出将为“My First Post”
truncatechars {{ value|truncatechars:9 }} # 字符串字符多于指定的字符数量，那么会被截断 value是“Joel 是 a >，输出将为“Joel i ...”
truncatechars_html {{ value|truncatechars_html:9 }} # 除了它知道HTML标记。在字符串中打开并且在截断点之前未关闭的任何标记在截断后立即关闭 value 是 "<p>Joel is a slug</p>", 输出为 "<p>Joel i...</p>".
truncatewords {{ value|truncatewords:2 }} # 在一定数量的字后截断字符串 "Joel is a slug", 输出变为 "Joel is ..."
truncatewords_html
wordcount
wordwrap
yesno {{ value|yesno:"yeah,no,maybe" }}
    True	 	yes
    True	"yeah,no,maybe"	yeah
    False	"yeah,no,maybe"	no
    None	"yeah,no,maybe"	maybe
    None	"yeah,no"	no (converts None to False if no mapping for None is given)
 
```



**自定义模板过滤器**

自定义过滤器就是一个带有一个或两个参数的Python 函数：

* （输入的）变量的值 —— 不一定是字符串形式。
* 参数的值 —— 可以有一个初始值，或者完全不要这个参数。

例如，在`{{ var|foo:"bar" }}`中，`foo`过滤器应当传入变量`var`和参数 `"bar"`。

```python
# 这是一个定义过滤器的例子：
def cut(value, arg):
    """Removes all values of arg from the given string"""
    return value.replace(arg, '')
    
# 下面是这个过滤器应该如何使用：
{{ somevariable|cut:"0" }}

# 大多数过滤器没有参数。在这种情况下，你的函数不带这个参数即可。示例︰
def lower(value): # Only one argument.
    """Converts a string into all lowercase"""
    return value.lower()
```

注册自定义过滤器

`django.template.Library.filter()`

```python
# Library.filter()方法需要两个参数：
# 过滤器的名称（一个字符串对象）
# 编译的函数 – 一个Python函数（不要把函数名写成字符串）
register.filter('cut', cut)
register.filter('lower', lower)

# 或装饰器方式
@register.filter(name='cut')
def cut(value, arg):
    return value.replace(arg, '')
@register.filter
def lower(value):
    return value.lower()
```

```python
# 使用：
polls/
    __init__.py
    models.py
    templatetags/
        __init__.py
        poll_extras.py
    views.py


# 请阅读Django的默认过滤器和标记的源代码。它们分别位于django/template/defaultfilters.py 和django/template/defaulttags.py 中
# 然后你可以在模板中像如下这样使用：
{% load poll_extras %}
```
更多请参考：[自定义过滤器](http://usyiyi.cn/documents/django_182/howto/custom-template-tags.html#howto-writing-custom-template-filters)


