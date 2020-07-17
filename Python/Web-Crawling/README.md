# Python



## 相关包

### 解析链接

* urlparse
* urlunparse
* urlsplit
* urlunsplit
* urljoin
* urlencode
* parse_qs
* parse_qsl
* quote
* unquote

### 分析Robots协议

`urllib.robotparser.RobotFileParser(url='')`

| - | -| -| 
--- | --- | ---
| BaiduSpider | 百度 | www.baidu.com |
| Googlebot | 谷歌 | www.google.com |
| 360Spider | 360搜索 | www.so.com |
| YodaoBot | 有道 | www.youdao.com |
| ia_archiver | Alexa | www.alexa.cn |
| Scooter | altavista | www.altavista.com |

### 爬虫框架

**Scrapy** ★★★

Scrapy 是一个 Python 的爬虫框架，它依赖的工具比较多，本身包括了爬取、处理、存储等工具。

需要你针对具体任务进行编写。比如在 `item.py` 对抓取的内容进行定义，在 `spider.py` 中编写爬虫，在 `pipeline.py` 中对抓取的内容进行存储，可以保存为 `csv` 等格式。

### 爬取内容

* [requests](../Python-requests.md)
* [urllib](../Python-requests-urllib-urllib2.md)
* [urllib2](../Python-requests-urllib-urllib2.md)


### 解析内容


* [lxml](../Python-lxml.md) - A very fast, easy-to-use and versatile library [XPath](https://www.w3school.com.cn/xpath/index.asp) for handling HTML and XML.
* [BeautifulSoup4](../Python-BeautifulSoup.md) - Providing Pythonic idioms for iterating, searching, and modifying HTML or XML.
* [pyquery](../Python-pyquery.md) - A jQuery-like library for parsing HTML.
* [tesserocr](./tesserocr.md) - OCR 识别





### Others





### js
* [Selenium](./Selenium.md)
* Splash
* ghost
* [PhantomJS](./PhantomJS.md) 不再支持
* Puppeteer 是个很好的选择，可以控制 Headless Chrome，这样就不用 Selenium 和 PhantomJS。

    与 Selenium 相比，Puppeteer 直接调用 Chrome 的 API 接口，不需要打开浏览器，直接在 V8 引擎中处理。


## 反爬虫策略

* 代理 IP
* [fake-useragent](https://github.com/hellysmile/fake-useragent)
* [Google 抓取工具](https://support.google.com/webmasters/answer/1061943?hl=zh-Hans)
* 爬取间隔自适应
* PIL
* opencv
* pybrain
* 打码平台

## 集群方式
* 基本的爬虫工作原理
* 基本的http抓取工具，scrapy
* Bloom Filter: [Bloom Filters by Example](https://link.zhihu.com/?target=http%3A//billmill.org/bloomfilter-tutorial/)
* 如果需要大规模网页抓取，你需要学习分布式爬虫的概念。其实没那么玄乎，你只要学会怎样维护一个所有集群机器能够有效分享的分布式队列就好。最简单的实现是python-rq: [https://github.com/nvie/rq](https://link.zhihu.com/?target=https%3A//github.com/nvie/rq)
* rq和Scrapy的结合：[darkrho/scrapy-redis · GitHub](https://link.zhihu.com/?target=https%3A//github.com/darkrho/scrapy-redis)
* 后续处理，网页析取([grangier/python-goose · GitHub](https://link.zhihu.com/?target=https%3A//github.com/grangier/python-goose))，存储(Mongodb)

## 抓取工具

* [火车采集器](http://www.locoy.com/)
* [八爪鱼](http://www.bazhuayu.com/)
* [集搜客](http://www.gooseeker.com/)

## 日志采集第三方工具

* 友盟
* Google Analysis
* Talkingdata

## 参考

* [Python 爬虫进阶](https://www.zhihu.com/question/35461941)
* [如何入门 Python 爬虫？](https://www.zhihu.com/question/20899988)
* [Python开发知识体系图](http://www.jikexueyuan.com/path/python/)
* [利用爬虫技术能做到哪些很酷很有趣很有用的事情？](https://www.zhihu.com/question/27621722)