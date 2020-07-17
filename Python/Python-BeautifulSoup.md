# BeautifulSoup
> Version 4.2.0
> 
> Beautiful Soup 是一个可以从HTML或XML文件中提取数据的Python库

## 例子

```python
html_doc = """
<html><head><title>The Dormouse's story</title></head>
<body>
<p class="title"><b>The Dormouse's story</b></p>

<p class="story">Once upon a time there were three little sisters; and their names were
<a href="http://example.com/elsie" class="sister" id="link1">Elsie</a>,
<a href="http://example.com/lacie" class="sister" id="link2">Lacie</a> and
<a href="http://example.com/tillie" class="sister" id="link3">Tillie</a>;
and they lived at the bottom of a well.</p>

<p class="story">...</p>
"""

from bs4 import BeautifulSoup
soup = BeautifulSoup(html_doc)

print(soup.prettify())
# <html>
#  <head>
#   <title>
#    The Dormouse's story
#   </title>
#  </head>
#  <body>
#   <p class="title">
#    <b>
#     The Dormouse's story
#    </b>
#   </p>
#   <p class="story">
#    Once upon a time there were three little sisters; and their names were
#    <a class="sister" href="http://example.com/elsie" id="link1">
#     Elsie
#    </a>
#    ,
#    <a class="sister" href="http://example.com/lacie" id="link2">
#     Lacie
#    </a>
#    and
#    <a class="sister" href="http://example.com/tillie" id="link2">
#     Tillie
#    </a>
#    ; and they lived at the bottom of a well.
#   </p>
#   <p class="story">
#    ...
#   </p>
#  </body>
# </html>


soup.title
# <title>The Dormouse's story</title>

soup.title.name
# u'title'

soup.title.string
# u'The Dormouse's story'

soup.title.parent.name
# u'head'

soup.p
# <p class="title"><b>The Dormouse's story</b></p>

soup.p['class']
# u'title'

soup.a
# <a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>

soup.find_all('a')
# [<a class="sister" href="http://example.com/elsie" id="link1">Elsie</a>,
#  <a class="sister" href="http://example.com/lacie" id="link2">Lacie</a>,
#  <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>]

soup.find(id="link3")
# <a class="sister" href="http://example.com/tillie" id="link3">Tillie</a>

for link in soup.find_all('a'):
    print(link.get('href'))
    # http://example.com/elsie
    # http://example.com/lacie
    # http://example.com/tillie
    
print(soup.get_text())
# The Dormouse's story
#
# The Dormouse's story
#
# Once upon a time there were three little sisters; and their names were
# Elsie,
# Lacie and
# Tillie;
# and they lived at the bottom of a well.
#
# ...
```

## Install
在`PyPi`中还有一个名字是 `BeautifulSoup` 的包,但那可能不是你想要的,那是 `Beautiful Soup3` 的发布版本,因为很多项目还在使用`BS3`, 所以 `BeautifulSoup` 包依然有效.但是如果你在编写新项目,那么你应该安装的 `beautifulsoup4`

```sh
$ pip install beautifulsoup4
```

### 安装解析器
`html.parser` 容错能力差，`html5lib `速度慢，因此需要安装新的解析器`lxml`

* [cannot-install-lxml](http://stackoverflow.com/questions/19548011/cannot-install-lxml-on-mac-os-x-10-9)]
* [lxml.de install](http://lxml.de/installation.html)

```sh
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# If you have solved the problem using this method but it pops up again at a later time, you might need to run this before the four lines above:

brew unlink libxml2
brew unlink libxslt

# 没有测试是否成功
STATIC_DEPS=true sudo pip install lxml
```

MAC 版本需要先重新设定环境变量，`MacOSX10.12`为 Mac 系统的版本号。

```
export C_INCLUDE_PATH=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/usr/include/libxml2:$C_INCLUDE_PATH
```
## 参考

* [BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/bs4)