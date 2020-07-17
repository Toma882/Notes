# Check your version of Git

```
$ git --version
```
---
# Git Latest Stable Release Version

[www.kernel.org](https://www.kernel.org/pub/software/scm/git)

[github.com](https://github.com/git/git/releases)

[git-scm.com](http://git-scm.com/downloads)

---
# Install or upgrade Git on Linux
获得最新版本号，如2.7.0，服务器为 CentOS 为例

#### 先安装依赖包
```sh
$ yum remove git
$ yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
$ yum install gcc perl-ExtUtils-MakeMaker
```

#### 下载Git源码包，并解压
```sh
$ cd /usr/local/src
$ wget https://github.com/git/git/archive/v2.7.0.tar.gz
$ tar -zxvf v2.7.0.tar.gz
```
#### 编译并安装

先检查一下 libiconv ，若没有则去下面指引安装 libiconv 

```sh
$ cd git-2.7.0
$ make configure
$ ./configure --prefix=/usr/local/ --with-iconv=/usr/local/libiconv/
$ make && make install
```
安装过程中，可能会出现如下错误：
若

```sh
$ /bin/sh: autoconf: 未找到命令
```
那么

```sh
$ yum install install autoconf automake libtool
```

若

```sh
LINK git-credential-store
libgit.a(utf8.o): In function `reencode_string_iconv': 
/opt/git-master/utf8.c:530: undefined reference to `libiconv' 
libgit.a(utf8.o): In function `reencode_string_len': 
/opt/git-master/utf8.c:569: undefined reference to `libiconv_open' 
/opt/git-master/utf8.c:588: undefined reference to `libiconv_close' 
/opt/git-master/utf8.c:582: undefined reference to `libiconv_open' 
collect2: ld 返回 1 
make: *** [git-credential-store] 错误 1
```

分析问题原因是找不到libiconv扩展包，包装libiconv包即可解决：
请勿下载更新版的libiconv包，1.14版本已经够用，
否则在运行Git时，会出现“/usr/local/bin/git: undefined symbol: locale_charset ”的错误

```sh
$ cd /usr/local/src
$ wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
$ tar -zxvf libiconv-1.14.tar.gz
$ cd libiconv-1.14/
$ ./configure --prefix=/usr/local/libiconv
$ make && make install
```

若

```sh
./stdio.h:1010:1: 错误：‘gets’未声明(不在函数内)
```

到1010行，注释掉该行即可：(vi跳转到指定行数命令为 :1010)

```sh
_GL_CXXALIASWARN (gets);
/* It is very rare that the developer ever has full control of stdin,
   so any use of gets warrants an unconditional warning.  Assume it is
   always declared, since it is required by C89.  */
//_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
#endif
```

重新make，OK。

创建一个软链接到/usr/lib

```sh
$ ln -s /usr/local/lib/libiconv.so /usr/lib
$ ln -s /usr/local/lib/libiconv.so.2 /usr/lib
```

libiconv安装成功后，再切回到git目录下面:

```sh
$ cd /usr/local/src/git-2.7.0
$ make configure
$ ./configure --prefix=/usr/local/ --with-iconv=/usr/local/libiconv/
$ make && make install
```

#### 确认GIT是否安装成功

```sh
$ git --version
```

通过如上命令查看Git版本，系统却提示：

```sh
bash: /usr/bin/git: No such file or directory
```

说明在“/usr/bin/”目录里，并没有Git的执行程序。
通过命令查找Git执行程序的目录：

```sh
$ which git
```

发现Git执行程序的目录在：

```sh
/usr/local/bin/git
```

通过如下命令，将之与“/usr/bin/”目录建立软链接：

```sh
$ sudo ln -s /usr/local/bin/git /usr/bin/git
```

再查看下版本：

```sh
$ git --version
```

Git即完全安装成功！

#### 更新GIT？
After this is done, you can also get Git via Git itself for updates:

```sh
$ git clone git://git.kernel.org/pub/scm/git/git.git
```
---
# 配置服务器

我们来看看如何配置服务器端的 SSH 访问。 本例中，我们将使用 authorized_keys 方法来对用户进行认证。 同时我们假设你使用的操作系统是标准的 Linux 发行版，比如 Ubuntu。 首先，创建一个操作系统用户 git，并为其建立一个 .ssh 目录。

```sh
$ sudo adduser git
$ su git
$ cd
$ mkdir .ssh && chmod 700 .ssh
$ touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
```

接着，我们需要为系统用户 git 的 authorized_keys 文件添加一些开发者 SSH 公钥。 假设我们已经获得了若干受信任的公钥，并将它们保存在临时文件中。 与前文类似，这些公钥看起来是这样的：

```sh
$ cat /tmp/id_rsa.john.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
dAv8JggJICUvax2T9va5 gsg-keypair
```
将这些公钥加入系统用户 git 的 .ssh 目录下 authorized_keys 文件的末尾：

```sh
$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys
```

现在我们来为开发者新建一个空仓库。可以借助带 --bare 选项的 git init 命令来做到这一点，该命令在初始化仓库时不会创建工作目录：

```sh
$ cd /opt/git
$ mkdir project.git
$ cd project.git
$ git init --bare
Initialized empty Git repository in /opt/git/project.git/
```

接下来使用客户端SourceTree对服务器进行连接

```sh
$ git clone git@gitservers.com/home/wwwroot/project.git
```

若修改过SSH的端口

```sh
$ git clone ssh://git@ gitservers.com:8888/home/wwwroot/project.git
```

#### 解决git能登陆Shell的问题
借助一个名为 git-shell 的受限 shell 工具，你可以方便地将用户 git 的活动限制在与 Git 相关的范围内。该工具随 Git 软件包一同提供。 如果将 git-shell 设置为用户 git 的登录 shell（login shell），那么用户 git 便不能获得此服务器的普通 shell 访问权限。 若要使用 git-shell，需要用它替换掉 bash 或 csh，使其成为系统用户的登录 shell。 为进行上述操作，首先你必须确保 git-shell 已存在于 /etc/shells 文件中：

```sh
$ cat /etc/shells   # see if `git-shell` is already in there.  If not...
$ which git-shell   # make sure git-shell is installed on your system.
$ sudo vim /etc/shells  # and add the path to git-shell from last command
```
现在你可以使用 chsh <username> 命令修改任一系统用户的 shell：

```sh
$ sudo chsh git  # and enter the path to git-shell, usually: /usr/bin/git-shell
```

这样，用户 git 就只能利用 SSH 连接对 Git 仓库进行推送和拉取操作，而不能登录机器并取得普通 shell。 如果试图登录，你会发现尝试被拒绝，像这样：

```sh
$ ssh git@gitserver
fatal: Interactive git shell is not enabled.
hint: ~/git-shell-commands should exist and have read and execute access.
Connection to gitserver closed.
```

---
### 参考文档：

* [Git分支管理策略](http://www.ruanyifeng.com/blog/2012/07/git.html)
* [开源分布式版本控制工具 —— Git 之旅](https://www.ibm.com/developerworks/cn/opensource/os-cn-tourofgit/)
* [升级Git时编译报utf8.c:502: undefined reference to `libiconv_open](http://www.molloc.com/archives/568)
* [centos编译安装 Git](http://marser.cn/archives/72/)
* [搭建Git服务器](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/00137583770360579bc4b458f044ce7afed3df579123eca000)
* [Installing-and-upgrading-git](https://confluence.atlassian.com/bitbucketserver/installing-and-upgrading-git-776640906.html)
* [4.1服务器上的-Git-协议](https://git-scm.com/book/zh/v1/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E5%8D%8F%E8%AE%AE)
* [4.2服务器上的 Git - 在服务器上搭建 Git](http://git-scm.com/book/zh/v2/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E5%9C%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E6%90%AD%E5%BB%BA-Git)
* [4.3 服务器上的 Git - 生成 SSH 公钥](http://git-scm.com/book/zh/v2/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E7%94%9F%E6%88%90-SSH-%E5%85%AC%E9%92%A5)
* [4.4服务器上的-Git-架设服务器](http://git-scm.com/book/zh/v2/%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E7%9A%84-Git-%E9%85%8D%E7%BD%AE%E6%9C%8D%E5%8A%A1%E5%99%A8)