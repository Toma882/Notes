# Python Install

## Mac

### homebrew只支持编译系统默认和brew安装的python版本
| 来源 | python安装路径 |
---|---
系统默认 |  /System/Library/Frameworks/Python.framework/Versions/2.7
brew安装 |/usr/local/Cellar
官网pkg安装 | /Library/Frameworks/Python.framework/Versions/2.7


`brew install python`

Pip and setuptools have been installed. To update them
  `pip install --upgrade pip setuptools`

You can install Python packages with
  `pip install <package>`

They will install into the site-package directory
  `/usr/local/lib/python2.7/site-packages`

See: https://github.com/Homebrew/brew/blob/master/docs/Homebrew-and-Python.md

`.app` bundles were installed.
Run `brew linkapps python` to symlink these to `/Applications`.



## Centos6.5  


`Python2.6 -> 2.7.13`，需更新Python和相应的`pip`。

```
# 同时需要2个版本存在使用pip
python -m pip -V
python3 -m pip -V
```

在安装Python2.7之前，首先安装相关的依赖

```
yum install gcc zlib* openssl openssl-devel sqlite-devel -y
```

下载Python2.7.13

```
wget http://www.python.org/ftp/python/2.7.13/Python-2.7.13.tar.xz
unxz Python-2.7.13.tar.xz
tar -vxf Python-2.7.13.tar
```

修改配置

```
#进入python文件夹
cd Python-2.7.13
#--enable-loadable-sqlite-extensions是sqlite的扩展，如果需要使用的话则带上这个选项
./configure --enable-shared --enable-loadable-sqlite-extensions --with-zlib --with-ssl
#修改Setup.dist文件
vim ./Modules/Setup.dist
#找到#zlib zlibmodule.c -I$(prefix)/include -L$(exec_prefix)/lib -lz去掉注释并保存
make && make install #安装
```


更改原来的Python2.6相关工作

```
mv /usr/bin/python /usr/bin/python2.6.6 保存原来的
ln -s /usr/local/bin/python2.7 /usr/bin/python 进行软链接

#修改yum文件，将第一行的#!/usr/bin/python修改成  #!/usr/bin/python2.6.6
vim /usr/bin/yum

#查看python版本
python -V
#如果上述命令出错，修改配置文件/etc/ld.so.conf，添加新的一行：/usr/local/lib
vim /etc/ld.so.conf
#然后执行命令
/sbin/ldconfig
/sbin/ldconfig -v
#然后重新输入命令
python -V

# vim /etc/profile
# #加入下面一行
# #export PATH="/usr/local/python2.7/bin:$PATH"
# #保存退出
# source /etc/profile #生效
# python -V
```

安装pip

```
wget  --no-check-certificate https://bootstrap.pypa.io/get-pip.py
python get-pip.py

# mv /usr/bin/pip /usr/bin/pip-python2.6
# ln -s /usr/local/python2.7/bin/pip /usr/bin/pip
pip -V
```

### Centos install python3

```
yum install -y  libffi-devel  gcc-c++  zlib*  bzip2  sqlite*
```

```
wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz
tar zxvf openssl-1.1.1c.tar.gz
mv openssl-1.1.1c openssl-1.1.1

cd openssl-1.1.1/
./config --prefix=/usr/local/openssl
make
make install

cd /usr/local
ldd /usr/local/openssl/bin/openssl

mv /usr/bin/openssl /usr/bin/openssl.old
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
echo "/usr/local/openssl/lib/" >> /etc/ld.so.conf
ldconfig -v
```

```
wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
xz -d Python-3.7.3.tar.xz
tar xvf Python-3.7.3.tar

cd Python-3.7.3
./configure --prefix='/usr/local/Python-3.7.3' --with-openssl=/usr/local/openssl/
make
make install

ln -s /usr/local/Python-3.7.3/bin/python3 /usr/bin/python3
ln -s /usr/local/Python-3.7.3/bin/pip3 /usr/bin/pip3

ln -s /usr/local/Python-3.7.3/bin/python3 /usr/local/bin/python3
ln -s /usr/local/Python-3.7.3/bin/pip3 /usr/local/bin/pip3
```


### python3相关


解决Python导入ssl模块报错:·ImportError: No module named _ssl
Python3.7需要openssl1.0.2以上版本
#### 第①步：
在官网 https://www.openssl.org 上已提供了文件 openssl-1.1.1.tar.gz 的下载

```
yum install perl-Test-Harness
yum  install  perl-CPAN
perl  -MCPAN  -e  shell
# 在 cpan[1]> 命令行提示符后面输入命令 install Text::Template
# 在 cpan[2]> 安装完成后，键入 exit 退出 cpan 命令行
# 执行以下命令重新编译 OpenSSL：
mkdir /usr/local/openssl-1.1.1
./config --prefix=/usr/local/openssl-1.1.1
make clean
make
make test
make install

# 解决openssl: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory错误
#/usr/local/lib64/libssl 自己的openssl位置
ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1


# 查看openssl版本
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/openssl-1.1.1/lib
cd /usr/local/openssl-1.1.1/bin
./openssl
```

#### 第②步：

```
# 不确定哪个起作用？
vim ./Modules/Setup
vim ./Modules/Setup.dist

# 找到SSL，修改为下面部分，其中SSL为自己的路径
    # Socket module helper for socket(2)
    _socket socketmodule.c
    
    # Socket module helper for SSL support; you must comment out the other
    # socket line above, and possibly edit the SSL variable:
    SSL=/usr/local/openssl-1.1.1/
    _ssl _ssl.c \
            -DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
            -L$(SSL)/lib -lssl -lcrypto

#找到#zlib zlibmodule.c -I$(prefix)/include -L$(exec_prefix)/lib -lz去掉注释并保存
make && make install

# python3
# import ssl 查看错误

```








## Windows
可通过 [Python官网](http://python.org/) 的”Windows Installer”链接保证下载到的版本是最新的

在 **Powershell** 中运行:

```
\\ [Environment]::SetEnvironmentVariable("Path", "$env:Path;C:\Python27\;C:\Python27\Scripts\", "User")
```

**虚拟环境(Virtual Environment)**

[virtualenvwrapper-win](https://github.com/davidmarble/virtualenvwrapper-win/)

```
pip install virtualenvwrapper-win
```

### virtualenvwrapper-winThese scripts should work on any version of Windows (Windows XP, Windows Vista, Windows 7/8).However, they only work in the **regular command prompt**. They **will not work in Powershell.** There are other virtualenvwrapper projects out there for Powershell.To use these scripts from any directory, make sure the ``Scripts`` subdirectory of Python is in your PATH. For example, if python is installed in ``C:\Python27\``, you should make sure ``C:\Python27\Scripts`` is in your PATH.To install, run one of the following::
```sh# using pippip install virtualenvwrapper-win
mkvirtualenv <name>lsvirtualenvrmvirtualenv <name>workon [<name>]deactivate
```