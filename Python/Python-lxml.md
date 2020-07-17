# lxml

> 网页解析利器，支持 HTML、XML、XPath XML Path Language 
> 解析，而且解析效率很高。可以通过元素和属性进行位置索引。
   



## Install

```
pip install lxml
```



## Example

```
from lxml import etree
html = etree.HTML(html)
result = html.xpath('//li')

import lxml.html
etree = lxml.html.etree
```
## 参考
* [lxml.de](http://lxml.de)
* [GitHub](https://github.com/lxml/lxml)