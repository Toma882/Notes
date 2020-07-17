# Pip

## 安装 Pip

Mac 通过 `brew` 方式安装 `Python`，会自动安装好`Setuptools`和 `pip`

Linux 在带有 Python 的机器上，通过命令 `sudo easy_install pip` 进行安装

### Pip 版本
Mac 或 Linux 上有可能并存`Python 3.x`和`Python 2.x`，因此对应的 `pip` 命令是 `pip3`。

若安装了 `virtualenv`控制 Python 版本，需要激活 `active` 之后才能使用相应的 `pip` 安装。

第三方库都会在Python官方的 `pypi.python.org` 网站注册，要安装一个第三方库，必须先知道该库的名称，可以在官网或者`pypi` 上搜索，比如 `Pillow` 的名称叫 `Pillow`：

```python
# pip 寻找
pip search Pillow
# pip 安装
pip install Pillow
```

有了`Pillow`，处理图片易如反掌。随便找个图片生成缩略图：

```python
>>> from PIL import Image
>>> im = Image.open('test.png')
>>> print(im.format, im.size, im.mode)
PNG (400, 300) RGB
>>> im.thumbnail((200, 100))
>>> im.save('thumb.jpg', 'JPEG')
```

### 更改 pip 源

在 `~/.pip/` 目录下新建 `pip.conf` 文件

```
# 编辑 pip.conf 文件，写入阿里云

[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com

# 或者可以使用豆瓣的镜像：

[global]
index-url = http://pypi.douban.com/simple

[install]
trusted-host=pypi.douban.com
```

### 更新 pip 版本


On Linux or macOS:

```
pip install -U pip
```


On Windows:

```
python -m pip install -U pip
```


## Pip 对包的管理

```
pip search "query"

pip install SomePackage
pip uninstall SomePackage

pip list

# 查看过期
pip list --outdated

# 显示信息
pip show SomePackage

#指定版本
pip install --upgrade keras==2.1.0 升级
pip install  keras==2.1.0 安装
```

## requirements.txt


在查看别人的Python项目时，经常会看到一个`requirements.txt`文件，里面记录了当前程序的所有依赖包及其精确版本号

`requirements.txt`可以通过`pip`命令自动生成和安装

生成`requirements.txt`文件

```
pip freeze > requirements.txt
```

安装`requirements.txt`依赖

```
pip install -r requirements.txt
```

# 不同版本 Python2 Python3
```
python2   -m pip install SomePackage  # default Python 2
python2.7 -m pip install SomePackage  # specifically Python 2.7
python3   -m pip install SomePackage  # default Python 3
python3.4 -m pip install SomePackage  # specifically Python 3.4
```