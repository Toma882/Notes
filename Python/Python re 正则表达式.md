##正则表达式
Python提供re模块，包含所有正则表达式的功能


```python
#普通的String需要转义字符
s = 'ABC\\-001' # -> 'ABC\-001'

#强烈建议使用Python的r前缀，就不用考虑转义的问题了
s = r'ABC\-001' # -> 'ABC\-001'
```


##re.complie & Pattern

Pattern对象是一个编译好的正则表达式，通过Pattern提供的一系列方法可以对文本进行匹配查找。不能直接实例化，必须使用`re.compile()`进行构造。  

Pattern提供了几个可读属性用于获取表达式的相关信息：  

* pattern: 编译时用的表达式字符串。
* flags: 编译时用的匹配模式。数字形式。
* groups: 表达式中分组的数量。
* groupindex: 以表达式中有别名的组的别名为键、以该组对应的编号为值的字典，没有别名的组不包含在内。

```
#第一个参数string，传入需要的正则表达式
#第二个参数flag是匹配模式，取值可以使用按位或运算符'|'表示同时生效，比如re.I | re.M
re.compile(strPattern[, flag]): Pattern
```

```python
a = re.compile(r"a")
b = re.compile(r"b")
a.match("apple")
b.search("banana")
```

##re.match && re.search

* `re.match` 尝试从字符串的**起始位置**匹配一个模式
* `re.search` 扫描整个字符串并**返回第一个成功**的匹配。

如果不是起始位置匹配成功的话，`match()`就返回`None`。

若匹配成功，可以使用`group(num)` 或 `groups()` 匹配对象函数来获取。

```python
# pattern	匹配的正则表达式
# string	要匹配的字符串。
# flags	标志位，用于控制正则表达式的匹配方式，如：是否区分大小写，多行匹配等等。
re.match(pattern, string, flags=0)
re.search(pattern, string, flags=0)
```

例子：

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
import re

# 寻找pid & name
line = "psutil.Process(pid=6666, name='php-fpm'), psutil.Process(pid=7777, name='nginx')";

# 必须 psutil.Process 开头,若 match `pid=(\d+),\sname=\'(.*?)\'`, 则返回None
matchObj = re.match( "psutil.Process\(pid=(\d+),\sname=\'(.*?)\'\)", line, re.I)
# matchObj = re.match( "pid=(\d+),\sname=\'(.*?)\'", line, re.I) #Nothing found!

if matchObj:
    print "matchObj.span() : ", matchObj.span()
    print "matchObj.group() : ", matchObj.group()
    print "matchObj.group(1) : ", matchObj.group(1)
    print "matchObj.group(2) : ", matchObj.group(2)
else:
    print "Nothing found!!"


searchObj = re.search( "pid=(\d+),\sname=\'(.*?)\'", line, re.I)

if searchObj:
    print "searchObj.span() : ", searchObj.span()
    print "searchObj.group() : ", searchObj.group()
    print "searchObj.group(1) : ", searchObj.group(1)
    print "searchObj.group(2) : ", searchObj.group(2)
else:
    print "Nothing found!!"
```

##split
`split(string[, maxsplit]) | re.split(pattern, string[, maxsplit])`

按照能够匹配的子串将string分割后返回列表。maxsplit用于指定最大分割次数，不指定将全部分割。 

```python
import re
 
p = re.compile(r'\d+')
print p.split('one1two2three3four4')
print p.split('one1two2three3four4', 2)
 
### output ###
# ['one', 'two', 'three', 'four', '']
# ['one', 'two', 'three3four4']
```


##findall & finditer
搜索string，以列表形式返回全部能匹配的子串。 
`findall(string[, pos[, endpos]]) | re.findall(pattern, string[, flags])`

搜索string，返回一个顺序访问每一个匹配结果（Match对象）的迭代器。
`finditer(string[, pos[, endpos]]) | re.finditer(pattern, string[, flags])`

```python
import re
 
p = re.compile(r'\d+')
print p.findall('one1two2three3four4')
 
### output ###
# ['1', '2', '3', '4']

p = re.compile(r'\d+')
for m in p.finditer('one1two2three3four4'):
    print m.group(),
 
### output ###
# 1 2 3 4
```




##sub
使用repl替换string中每一个匹配的子串后返回替换后的字符串。 
当repl是一个字符串时，可以使用\id或\g<id>、\g<name>引用分组，但不能使用编号0。 
当repl是一个方法时，这个方法应当只接受一个参数（Match对象），并返回一个字符串用于替换（返回的字符串中不能再引用分组）。 
count用于指定最多替换次数，不指定时全部替换。 
`sub(repl, string[, count]) | re.sub(pattern, repl, string[, count])`



返回 (sub(repl, string[, count]), 替换次数)。 
`subn(repl, string[, count]) |re.sub(pattern, repl, string[, count])`


```python
import re
 
p = re.compile(r'(\w+) (\w+)')
s = 'i say, hello world!'
 
print p.sub(r'\2 \1', s)
 
def func(m):
    return m.group(1).title() + ' ' + m.group(2).title()
 
print p.sub(func, s)
 
### output ###
# say i, world hello!
# I Say, Hello World!

print p.subn(func, s)
 
### output ###
# ('say i, world hello!', 2)
# ('I Say, Hello World!', 2)
```