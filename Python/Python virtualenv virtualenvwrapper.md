## virtualenv

处理python环境的多版本和模块依赖，以及相应的权限是一个很常见的问题。比如，你有个应用使用的是LibFoo V1.0，但另一个应用却要用到LibFoo V2.0。 如何处理呢？如果把所有模块都安装到 /usr/lib/python2.7/site-packages (或是你本机python默认的模块安装目录)，那你极有可能无意中升级一些不该升级的模块。

virtualenv 是一个创建隔绝的Python环境的工具。virtualenv创建一个包含所有必要的可执行文件的文件夹，用来使用Python工程所需的包。该操作会创建 ENV/lib/pythonX.X/site-packages 目录 和 ENV/bin/python ， 前者用来存放要安装的模块，后者就是隔离环境的Python解释器。 在virtualenv环境下使用此解释器（包括以 #!/path/to/ENV/bin/python 开头的脚本）时，使用的都是隔离环境下的模块。

新的virtualenv还包含了 pip 包管理器，可以直接用 ENV/bin/pip 安装第三方模块。

```
pip install virtualenv
```
创建env的时候可以选择Python解释器

```
virtualenv -p /usr/local/bin/python3 venv
```

第一步，创建目录：

```
Mac:~ michael$ mkdir myproject
Mac:~ michael$ cd myproject/
Mac:myproject michael$
```

第二步，创建一个独立的Python运行环境，命名为venv：

```
Mac:myproject michael$ virtualenv --no-site-packages venv
Using base prefix '/usr/local/.../Python.framework/Versions/3.4'
New python executable in venv/bin/python3.4
Also creating executable in venv/bin/python
Installing setuptools, pip, wheel...done.
```

命令`virtualenv`就可以创建一个独立的Python运行环境，我们还加上了参数`--no-site-packages`，这样，已经安装到系统Python环境中的所有第三方包都不会复制过来，这样，我们就得到了一个不带任何第三方包的“干净”的Python运行环境。

如果想使用系统环境的第三方软件包，可以在创建虚拟环境时使用参数`–system-site-packages`

新建的Python环境被放到当前目录下的`venv`目录。有了`venv`这个Python环境，可以用`source`进入该环境：

```
Mac:myproject michael$ source venv/bin/activate
(venv)Mac:myproject michael$
```

注意到命令提示符变了，有个`(venv)`前缀，表示当前环境是一个名为`venv`的Python环境。

下面正常安装各种第三方包，并运行python命令：

```
(venv)Mac:myproject michael$ pip install jinja2
...
Successfully installed jinja2-2.7.3 markupsafe-0.23
(venv)Mac:myproject michael$ python myapp.py
...
```

在`venv`环境下，用`pip`安装的包都被安装到`venv`这个环境下，系统Python环境不受任何影响。也就是说，`venv`环境是专门针对`myproject`这个应用创建的。

退出当前的`venv`环境，使用`deactivate`命令：

```
(venv)Mac:myproject michael$ deactivate 
Mac:myproject michael$
```

此时就回到了正常的环境，现在`pip`或`python`均是在系统Python环境下执行。

完全可以针对每个应用创建独立的Python运行环境，这样就可以对每个应用的Python环境进行隔离。

`virtualenv`是如何创建“独立”的Python运行环境的呢？原理很简单，就是把系统Python复制一份到`virtualenv`的环境，用命令`source venv/bin/activate`进入一个`virtualenv`环境时，`virtualenv`会修改相关环境变量，让命令`python`和`pip`均指向当前的`virtualenv`环境。



## virtualenvwrapper

上述 `virtualenv` 的操作其实已经够简单了，但对于开发者来说还是不够简便，所以便有了 `virtualenvwrapper`。这是 `virtualenv` 的扩展工具，提供了一系列命令行命令，可以方便地创建、删除、复制、切换不同的虚拟环境。同时，使用该扩展后，所有虚拟环境都会被放置在同一个目录下。

安装`virtualenvwrapper`

```
pip install virtualenvwrapper
```

设置环境变量

把下面两行添加到`~/.bashrc`（或者`~/.zshrc`）里。

```
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
   export WORKON_HOME=$HOME/.virtualenvs 
   source /usr/local/bin/virtualenvwrapper.sh
fi
```

其中，`.virtualenvs` 是可以自定义的虚拟环境管理目录。

然后执行：`source ~/.bashrc`，就可以使用 `virtualenvwrapper` 了

命令如下，很多命令相同，如制定Python版本

```
mkvirtualenv venv # 创建虚拟环境
lsvirtualenv -b # 列出虚拟环境
workon [虚拟环境名称] # 切换虚拟环境
lssitepackages # 查看环境里安装了哪些包
cdvirtualenv [子目录名] # 进入当前环境的目录
cpvirtualenv [source] [dest] # 复制虚拟环境
deactivate # 退出虚拟环境
rmvirtualenv [虚拟环境名称] # 删除虚拟环境
```

**有了`virtualenvwrapper`命令，基本不再需要`virtualenv`命令行了**


## 问题集
### Install virtualenvwrapper for both Python 2.7 and 3.6

Making a virtual environment is a matter of passing a flag.

```
# make py3
mkvirtualenv py3 --python=python3

# make py2
mkvirtualenv py2 --python=python2
```

### Broken references in Virtualenvs

Mac 上因为 homebrew 升级 python 版本的原因报错

```
dyld: Library not loaded: @executable_path/../.Python
  Referenced from: /Users/[user]/.virtualenvs/modclass/bin/python
  Reason: image not found
Trace/BPT trap: 5
```

解决方案

```
## 安装 findutils
brew install findutils

## 寻找 my-virtual-env 下面失效的 python 版本进行确认删除
find ~/.virtualenvs/my-virtual-env/ -type l

gfind ~/.virtualenvs/my-virtual-env/ -type l -xtype l -delete

## 重新复制环境
virtualenv ~/.virtualenvs/my-virtual-env

```

### /usr/bin/python: No module named virtualenvwrapper错误解决方法

运行 virtualenvwrapper 会报错如下：

```
/usr/bin/python: No module named virtualenvwrapper
```

我的 virtualenvwrapper 实际上安装在python3下，python2下没有装。

但是virtualenvwrapper的脚本还是默认使用的`/usr/bin/python`，我们需要把他修改默认成`/usr/bin/python3`.

修改步骤，在`~/.bashrc`文件中，在`source /usr/local/bin/virtualenvwrapper.sh`前，加入：

`export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3`
也就是关于virtualenvwrapper.sh这段，修改成：

```
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi
```

[其他参考](https://stackoverflow.com/questions/23997403/installed-virtualenv-and-virtualenvwrapper-python-says-no-module-named-virtuale)