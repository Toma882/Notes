# Widget

Widget 是 HTML 输入元素的表示

不要将 Widget 与表单字段Field 搞混淆。表单字段Field 负责验证输入并直接在模板中使用。Widget 负责渲染网页上HTML 表单的输入元素和提取提交的原始数据。但是，Widget 需要赋值给表单字段Field。


```python
from django import forms

class CommentForm(forms.Form):
    name = forms.CharField()
    url = forms.URLField()
    # 这将使用一个Textarea Widget来设置表单的评论 ，而不是默认的TextInput Widget。
    comment = forms.CharField(widget=forms.Textarea)
```

## 设置 Widget 的参数

```python
from django import forms
from django.forms.extras.widgets import SelectDateWidget

BIRTH_YEAR_CHOICES = ('1980', '1981', '1982')
FAVORITE_COLORS_CHOICES = (('blue', 'Blue'),
                            ('green', 'Green'),
                            ('black', 'Black'))

class SimpleForm(forms.Form):
    birth_year = forms.DateField(widget=SelectDateWidget(years=BIRTH_YEAR_CHOICES))
    favorite_colors = forms.MultipleChoiceField(required=False,
        widget=forms.CheckboxSelectMultiple, choices=FAVORITE_COLORS_CHOICES)
```

## 设置 Widget 的属性

```python
>>> from django import forms
>>> name = forms.TextInput(attrs={'size': 10, 'title': 'Your name',})
>>> name.render('name', 'A name')
'<input title="Your name" type="text" name="name" value="A name" size="10" />'
```

## 常见的Widget

```python
TextInput
NumberInput
EmailInput
URLInput
PasswordInput
HiddenInput
DateInput
DateTimeInput
TimeInput
Textarea
CheckboxInput
Select
NullBooleanSelect
RadioSelect
CheckboxSelectMultiple
FileInput
ClearableFileInput
MultipleHiddenInput
SplitDateTimeWidget
SplitHiddenDateTimeWidget
SelectDateWidget
```


```python
```
