# 表单

## 一个简单的表单

```html
<form action="/your-name/" method="post">
    <label for="your_name">Your name: </label>
    <input id="your_name" type="text" name="your_name" value="{{ current_name }}">
    <input type="submit" value="OK">
</form>
```


form.py

```python
from django import forms

class NameForm(forms.Form):
    your_name = forms.CharField(label='Your name', max_length=100)
```

views.py

返回`True`，将表单的数据放到`cleaned_data` 属性中

```python
from django.shortcuts import render
from django.http import HttpResponseRedirect

from .forms import NameForm

def get_name(request):
    # if this is a POST request we need to process the form data
    if request.method == 'POST':
        # create a form instance and populate it with data from the request:
        form = NameForm(request.POST)
        # check whether it's valid:
        if form.is_valid():
            # process the data in form.cleaned_data as required
            # ...
            # redirect to a new URL:
            return HttpResponseRedirect('/thanks/')

    # if a GET (or any other method) we'll create a blank form
    else:
        form = NameForm()

    return render(request, 'name.html', {'form': form})
```

name.html 

```python
<form action="/your-name/" method="post">
    {% csrf_token %}
    {{ form }}
    <input type="submit" value="Submit" />
</form>
```

Django 原生支持一个简单易用的跨站请求伪造的防护。  
当提交一个启用`CSRF` 防护的`POST` 表单时，你必须使用上面例子中的`csrf_token` 模板标签

## Form 详解
### `Form.is_bound`

* 如果是绑定的，那么它能够验证数据，并渲染表单及其数据成HTML。
* 如果是未绑定的，那么它不能够完成验证（因为没有可验证的数据！），但是仍然能渲染空白的表单成HTML

```python
# 未绑定
>>> f = ContactForm()

# 绑定
>>> data = {'subject': 'hello',
...         'message': 'Hi there',
...         'sender': 'foo@example.com',
...         'cc_myself': True}
>>> f = ContactForm(data)
# 创建一个带有空数据的绑定的表单
>>> f = ContactForm(data)
```

### `Form.clean()`

为相互依赖的字段添加自定义验证

### `Form.Field`

```python
from django import forms

# 字段都具有一个合理的默认Widget。例如，默认情况下，CharField 具有一个TextInput Widget，它在HTML 中生成一个<input type="text">。
# 如果你需要<textarea>，在定义表单字段时你应该指定一个合适的Widget，例如我们定义的message 字段。

class ContactForm(forms.Form):
    subject = forms.CharField(max_length=100)
    message = forms.CharField(widget=forms.Textarea)
    sender = forms.EmailField()
    cc_myself = forms.BooleanField(required=False)
```

验证后的表单数据将位于`form.cleaned_data` 字典中

```python
from django.core.mail import send_mail

if form.is_valid():
    subject = form.cleaned_data['subject']
    message = form.cleaned_data['message']
    sender = form.cleaned_data['sender']
    cc_myself = form.cleaned_data['cc_myself']

    recipients = ['info@example.com']
    if cc_myself:
        recipients.append(sender)

    send_mail(subject, message, sender, recipients)
    return HttpResponseRedirect('/thanks/')
```

### `Form.has_changed()`

检查表单的数据是否从初始数据发生改变时

### `Form.fields`

你可以从表单实例的fields属性访问字段：

```python
>>> for row in f.fields.values(): print(row)
...
<django.forms.fields.CharField object at 0x7ffaac632510>
<django.forms.fields.URLField object at 0x7ffaac632f90>
<django.forms.fields.CharField object at 0x7ffaac3aa050>
>>> f.fields['name']
<django.forms.fields.CharField object at 0x7ffaac6324d0>
```

### `Form.cleaned_data`

“清洁” —— 将它们转换为正确的格式，如 `1994-07-15` 格式的字符串转化成 `Date` 对象  

* 没有通过验证：  
    `cleaned_data`只包含合法的字段
* 通过验证：  
    `cleaned_data`包含所有的字段的键和值，若没有传递，值我空`''`；  
    始终只包含表单中定义的字段，即使你在构建表单时传递了额外的数据

### 输出HTML

**`print | Form.as_table()`**

```python
>>> f = ContactForm()
>>> print(f)
<tr><th><label for="id_subject">Subject:</label></th><td><input id="id_subject" type="text" name="subject" maxlength="100" /></td></tr>
<tr><th><label for="id_message">Message:</label></th><td><input type="text" name="message" id="id_message" /></td></tr>
<tr><th><label for="id_sender">Sender:</label></th><td><input type="email" name="sender" id="id_sender" /></td></tr>
<tr><th><label for="id_cc_myself">Cc myself:</label></th><td><input type="checkbox" name="cc_myself" id="id_cc_myself" /></td></tr>
```

* 为了灵活性，输出不包含`<table> 和</table>、<form> 和</form> 以及<input type="submit"> `标签。你需要添加它们。
* 每个字段类型有一个默认的HTML 表示。`CharField` 表示为一个`<input type="text">`，`EmailField` 表示为一个`<input type="email">`。`BooleanField` 表示为一个`<input type="checkbox">`。注意，这些只是默认的表示；你可以使用`Widget` 指定字段使用哪种HTML，我们将稍后解释。
* 每个标签的HTML `name` 直接从`ContactForm` 类中获取。
* 每个字段的文本标签 —— 例如`'Subject:'、'Message:' 和'Cc myself:'` 通过将所有的下划线转换成空格并大写第一个字母生成。再次提醒，这些只是默认的表示；你可以手工指定标签。
* 每个文本标签周围有一个HTML `<label>` 标签，它指向表单字段的`id`。这个`id`，是通过在字段名称前面加上`'id_'` 前缀生成。`id` 属性和`<label>` 标签默认包含在输出中，但你可以改变这一行为。

**`Form.as_p()`**

`as_p()` 渲染表单为一系列的`<p>` 标签，每个`<p>` 标签包含一个字段：

```python
>>> f = ContactForm()
>>> f.as_p()
'<p><label for="id_subject">Subject:</label> <input id="id_subject" type="text" name="subject" maxlength="100" /></p>\n<p><label for="id_message">Message:</label> <input type="text" name="message" id="id_message" /></p>\n<p><label for="id_sender">Sender:</label> <input type="text" name="sender" id="id_sender" /></p>\n<p><label for="id_cc_myself">Cc myself:</label> <input type="checkbox" name="cc_myself" id="id_cc_myself" /></p>'
>>> print(f.as_p())
<p><label for="id_subject">Subject:</label> <input id="id_subject" type="text" name="subject" maxlength="100" /></p>
<p><label for="id_message">Message:</label> <input type="text" name="message" id="id_message" /></p>
<p><label for="id_sender">Sender:</label> <input type="email" name="sender" id="id_sender" /></p>
<p><label for="id_cc_myself">Cc myself:</label> <input type="checkbox" name="cc_myself" id="id_cc_myself" /></p>
```

**`Form.as_ul()`**

`as_ul()` 渲染表单为一系列的`<li>`标签，每个`<li>` 标签包含一个字段。它不包含`<ul> 和</ul>`，所以你可以自己指定`<ul>` 的任何HTML 属性

```python
>>> f = ContactForm()
>>> f.as_ul()
'<li><label for="id_subject">Subject:</label> <input id="id_subject" type="text" name="subject" maxlength="100" /></li>\n<li><label for="id_message">Message:</label> <input type="text" name="message" id="id_message" /></li>\n<li><label for="id_sender">Sender:</label> <input type="email" name="sender" id="id_sender" /></li>\n<li><label for="id_cc_myself">Cc myself:</label> <input type="checkbox" name="cc_myself" id="id_cc_myself" /></li>'
>>> print(f.as_ul())
<li><label for="id_subject">Subject:</label> <input id="id_subject" type="text" name="subject" maxlength="100" /></li>
<li><label for="id_message">Message:</label> <input type="text" name="message" id="id_message" /></li>
<li><label for="id_sender">Sender:</label> <input type="email" name="sender" id="id_sender" /></li>
<li><label for="id_cc_myself">Cc myself:</label> <input type="checkbox" name="cc_myself" id="id_cc_myself" /></li>
```



## 表单渲染

* 表单的输出不包含`<form>` 标签，和表单的`submit` 按钮
* 每个表单字段具有一个`ID` 属性并设置为`id_<field-name>`，它被一起的`label` 标签引用


对于`<label>/<input>` 对，还有几个输出选项：

`{{ form.as_table }}` 以表格的形式将它们渲染在`<tr>` 标签中
`{{ form.as_p }}`  将它们渲染在`<p>` 标签中
`{{ form.as_ul }}` 将它们渲染在`<li>` 标签中
注意，你必须自己提供`<table>` 或`<ul>` 元素。

下面是我们的`ContactForm` 实例的输出`{{ form.as_p }}`：

```python
<p><label for="id_subject">Subject:</label>
    <input id="id_subject" type="text" name="subject" maxlength="100" /></p>
<p><label for="id_message">Message:</label>
    <input type="text" name="message" id="id_message" /></p>
<p><label for="id_sender">Sender:</label>
    <input type="email" name="sender" id="id_sender" /></p>
<p><label for="id_cc_myself">Cc myself:</label>
    <input type="checkbox" name="cc_myself" id="id_cc_myself" /></p>
```

### 手工渲染字段
```python
{{ form.non_field_errors }}
<div class="fieldWrapper">
    {{ form.subject.errors }}
    <label for="{{ form.subject.id_for_label }}">Email subject:</label>
    {{ form.subject }}
</div>
<div class="fieldWrapper">
    {{ form.message.errors }}
    <label for="{{ form.message.id_for_label }}">Your message:</label>
    {{ form.message }}
</div>
<div class="fieldWrapper">
    {{ form.sender.errors }}
    <label for="{{ form.sender.id_for_label }}">Your email address:</label>
    {{ form.sender }}
</div>
<div class="fieldWrapper">
    {{ form.cc_myself.errors }}
    <label for="{{ form.cc_myself.id_for_label }}">CC yourself?</label>
    {{ form.cc_myself }}
</div>
```

### 可重用的表单模板

```python
# In your form template:
{% include "form_snippet.html" %}

# In form_snippet.html:
{% for field in form %}
    <div class="fieldWrapper">
        {{ field.errors }}
        {{ field.label_tag }} {{ field }}
    </div>
{% endfor %}

# 如果传递到模板上下文中的表单对象具有一个不同的名称，你可以使用include 标签的with 参数来对它起个别名：

{% include "form_snippet.html" with form=comment_form %}
```

## 表单验证

`full_clean() -> Field clean() -> Form Clean_*() -> Form clean() -> errors or cleaned_data`

* 函数`full_clean()`依次调用每个`field`的`clean()`函数，该函数针对`field`的`max_length，unique`等约束进行验证，如果验证成功则返回值，否则抛出`ValidationError`错误。如果有值返回，则放入`form`的`cleaned_data`字典中。
* 如果每个`field`的内置`clean()`函数没有抛出`ValidationError`错误，则调用以`clean_开头`，以`field`名字结尾的自定义`field`验证函数。验证成功和失败的处理方式同步骤1。
* 最后，调用`form`的`clean()`函数——注意，这里是`form`的`clean()`,而不是`field`的`clean()`——如果`clean`没有错误，那么它将返回`cleaned_data`字典。
* 如果到这一步没有`ValidationError`抛出，那么`cleaned_data`字典就填满了有效数据。否则`cleaned_data`不存在，`form`的另外一个字典`errors`填上验证错误。在`template`中，每个`field`获取自己错误的方式是：`{{ form.username.errors }}`。
* 最后，如果有错误`is_valid()`返回`False`，否则返回`True`。