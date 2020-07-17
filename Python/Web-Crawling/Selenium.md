# Selenium


> 用于 Web 测试的工具，支持多种浏览器和和自动化测试。目测网站很多会检测出来。

> 因为每次预习都打开一个浏览器，会加载图片，JS等于爬虫目标不相关的东西。造成速度慢，占用资源多，网络延迟，爬取规模不能太大。    



## Install

```
pip install selenium
```

## Drivers

[Browser Drivers](https://selenium-python.readthedocs.io/installation.html) MAC 的目录地址放在 `/usr/local/bin` 

* Chrome:	https://sites.google.com/a/chromium.org/chromedriver/downloads
* Edge:	https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/
* Firefox:	https://github.com/mozilla/geckodriver/releases
* Safari:	https://webkit.org/blog/6900/webdriver-support-in-safari-10/


## 基本使用

```python
# -*- coding: utf-8 -*-

from selenium import webdriver
import time

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--headless') # 增加无界面选项
chrome_options.add_argument('--disable-gpu') # 如果不加这个选项，有时定位会出现问题

driver = webdriver.Chrome(chrome_options=chrome_options)
driver.get("http://www.baidu.com")
# elem = driver.find_element_by_id("kw")
# elem.send_keys("selenium")
#
# search_btn = driver.find_element_by_id("su")
# search_btn.click()
print (driver.title)
# print (driver.page_source)
driver.close()
driver.quit()
```

## 不同浏览器初始化

```python
from selenium import webdriver

browser = webdriver.Chrome()
browser = webdriver.Firefox()
browser = webdriver.Edge()
browser = webdriver.PhantomJS()
browser = webdriver.Safari()
```

## 获取节点的方法

### 单个节点

```python
find_element(By.ID, 'title')
find_element_by_id
find_element_by_name
find_element_by_xpath
find_element_by_link_text
find_element_by_partial_link_text
find_element_by_tag_name
find_element_by_class_name
find_element_by_css_selector
```

### 多个节点

```python
find_elements(By.CSS_SELECTOR, 'li')
find_elements_by_id
find_elements_by_name
find_elements_by_xpath
find_elements_by_link_text
find_elements_by_partial_link_text
find_elements_by_tag_name
find_elements_by_class_name
find_elements_by_css_selector
```

## 节点互动

```python
from selenium import webdriver
import time

browser = webdriver.Chrome()
browser.get('https://www.taobao.com')
input = browser.find_element_by_id('q')
input.send_keys('iPhone')
time.sleep(1)
input.clear()
input.send_keys('iPad')
button = browser.find_element_by_class_name('btn-search')
button.click()
```

[更多节点互动](https://selenium-python.readthedocs.io/api.html#module-selenium.webdriver.remote.webelement)


## 动作链 Action Chains

```python
from selenium import webdriver
from selenium.webdriver import ActionChains

browser = webdriver.Chrome()
url = 'http://www.runoob.com/try/try.php?filename=jqueryui-api-droppable'
browser.get(url)
browser.switch_to.frame('iframeResult')
source = browser.find_element_by_css_selector('#draggable')
target = browser.find_element_by_css_selector('#droppable')
actions = ActionChains(browser)
actions.drag_and_drop(source, target)
actions.perform()
```

[更多动作链](https://selenium-python.readthedocs.io/api.html#module-selenium.webdriver.common.action_chains)

## 执行JavaScript

```python
from selenium import webdriver
 
browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
browser.execute_script('window.scrollTo(0, document.body.scrollHeight)')
browser.execute_script('alert("To Bottom")')
```

## 获取节点信息

```python
from selenium import webdriver
 
browser = webdriver.Chrome()
url = 'https://www.zhihu.com/explore'
browser.get(url)
input = browser.find_element_by_class_name('zu-top-add-question')
print(input.id)
print(input.location)
print(input.tag_name)
print(input.size)
```

## 切换Frame

> Selenium打开页面后，它默认是在父级Frame里面操作，  
> 而此时如果页面中还有子Frame，  
> 它是不能获取到子Frame里面的节点的。  
> 这时就需要使用switch_to.frame()方法来切换Frame

```python
import time
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
 
browser = webdriver.Chrome()
url = 'http://www.runoob.com/try/try.php?filename=jqueryui-api-droppable'
browser.get(url)
browser.switch_to.frame('iframeResult')
try:
    logo = browser.find_element_by_class_name('logo')
except NoSuchElementException:
    print('NO LOGO')
browser.switch_to.parent_frame()
logo = browser.find_element_by_class_name('logo')
print(logo)
print(logo.text)
```

## 延时等待

### 隐式等待
```python
from selenium import webdriver
 
browser = webdriver.Chrome()
browser.implicitly_wait(10)
browser.get('https://www.zhihu.com/explore')
input = browser.find_element_by_class_name('zu-top-add-question')
print(input)
```

### 显式等待
```python
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
 
browser = webdriver.Chrome()
browser.get('https://www.taobao.com/')
wait = WebDriverWait(browser, 10)
input = wait.until(EC.presence_of_element_located((By.ID, 'q')))
button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '.btn-search')))
print(input, button)
```

[更多等待条件的参数及用法](https://selenium-python.readthedocs.io/api.html#module-selenium.webdriver.support.expected_conditions)


## 前进和后退
```python
import time
from selenium import webdriver
 
browser = webdriver.Chrome()
browser.get('https://www.baidu.com/')
browser.get('https://www.taobao.com/')
browser.get('https://www.python.org/')
browser.back()
time.sleep(1)
browser.forward()
browser.close()
```

## Cookies

```python
from selenium import webdriver
 
browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
print(browser.get_cookies())
browser.add_cookie({'name': 'name', 'domain': 'www.zhihu.com', 'value': 'germey'})
print(browser.get_cookies())
browser.delete_all_cookies()
print(browser.get_cookies())
```

## 选项卡管理
```python
import time
from selenium import webdriver
 
browser = webdriver.Chrome()
browser.get('https://www.baidu.com')
browser.execute_script('window.open()')
print(browser.window_handles)
browser.switch_to_window(browser.window_handles[1])
browser.get('https://www.taobao.com')
time.sleep(1)
browser.switch_to_window(browser.window_handles[0])
browser.get('https://python.org')
```

## 异常处理
[异常类](http://selenium-python.readthedocs.io/api.html#module-selenium.common.exceptions)

## 参考

[Docs](https://selenium-python.readthedocs.io/index.html)