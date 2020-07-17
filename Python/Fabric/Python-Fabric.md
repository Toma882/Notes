# Fabric

Fabric是一个Python (2.5-2.7)库和命令行工具，它可以将使用SSH操作的应用部署或系统管理任务更加地高效，因为可以在其身上可以进行二次开发，管理的效率也都还不错，用到公司的运维项目中，毕竟有 Instagram 背书嘛。

类似的工具有

* [Ansible](https://github.com/ansible/ansible) - A radically simple IT automation platform.
* [OpenStack](http://www.openstack.org/) - Open source software for building private and public clouds.
* [SaltStack](https://github.com/saltstack/salt) - Infrastructure automation and management system.

实践成果：用Fabric管理了公司上百台的服务器

## Install Fabric
```
brew install fabirc
```

## Main
fabric 默认寻找文件名为`fabfile.py`的 Python 文件

若为其他名字，则设定
通过 `-f hello.py` 进行指定  
或  
在`~/.fabricrc`文件中指定`fabfile = hello.py`

否则会报 `Fatal error: Couldn’t find any fabfiles` 的错误

## Hello fab

```
def hello(name="world"):
    print("Hello %s!" % name)

$ fab hello:name=fab
Hello fab!
```

## API

```python
#coding=utf-8
from __future__ import with_statement
from fabric.api import *
from fabric.colors import *
from fabric.contrib.console import confirm

# 默认是 False 线性而非并行；线性时候遇到交互可以在界面上进行yes/no类似的交互，而并行却不可以
env.parallel = True 
# 输出到终端的错误信息会显示成红色，警告信息则显示为洋红色
env.colorize_errors = True

# fabric.colors.blue(text, bold=False)
# fabric.colors.cyan(text, bold=False)
# fabric.colors.green(text, bold=False)
# fabric.colors.magenta(text, bold=False)
# fabric.colors.red(text, bold=False)
# fabric.colors.white(text, bold=False)
# fabric.colors.yellow(text, bold=False)
prompt(blue("tips")) //red, blue

# Download one or more files from a remote host.
fabric.operations.get(*args, **kwargs)

# Upload one or more files to a remote host.
fabric.operations.put(*args, **kwargs)

# Run a command on the local system.
fabric.operations.local(command, capture=False, shell=None)

# Run a shell command on a remote host.
fabric.operations.run(*args, **kwargs)

# Invoke a fully interactive shell on the remote end.
fabric.operations.open_shell(*args, **kwargs)

# Prompt user with text and return the input (like raw_input).
fabric.operations.prompt(text, key=None, default='', validate=None)
# 默认提示选择
def ssh_copy_id():
    env.prompts = {
    "Are you sure you want to continue connecting (yes/no)?":"yes"
    }
    for newServer in newServers:
        result = local("ssh-copy-id -i ~/.ssh/id_rsa.pub " + newServer)

# 多线程最大5
@parallel(pool_size=5)
def smile(serverType):
    paramHosts = getHosts(serverType)
    execute(__smile, hosts = paramHosts)

def __smile():
    run("uname -s")
```

采用 ssh 登陆，略过用户密码这一章节

## 参考
* [Fabric](http://www.fabfile.org/)
* [Fabric Doc](http://docs.fabfile.org/)
* [Fabric Doc 中文版](http://fabric-docs-cn.readthedocs.io/zh_CN/latest/index.html)
