##.bash_profile .bashrc

> ###login shell
> 当你通过终端输入用户名和密码，然后进入到`terminal`，这时候进入的`shell`环境就叫做是`login shell`，例如，通过`ssh`远程进入到主机。
> 
> ###no-login shell
> 顾名思义就是不需要输入用户名密码而进入的`shell`环境，例如你已经登陆了你的桌面电脑，这时候在应用管理器中找到`termianl`图标，然后双击打开终端，也就是通过像`gnome,KDE`这种桌面环境而进入的终端，这时候你进入的`shell`环境就是所谓的`no-login shell`环境。简而言之，就是把你想通过`login shell`运行的`shell`命令放入到`.bash_profile`中，把想通过`no-login shell`运行的`shell`命令放入到`.bashrc文`件中。


###/etc/profile

`/etc/profile.d` 搜集`shell`的设置-->`/etc/profile`

此文件为系统的每个用户设置环境信息,当用户第一次登录时,该文件被执行。设定的变量(全局)的可以作用于任何用户。

###/etc/bashrc
为每一个运行`bash shell`的用户执行此文件.当`bash shell`被打开时,该文件被读取.

###~/.bash_profile

交互式 `login` 方式进入 `bash` 运行

每个用户都可使用该文件输入专用于自己使用的`shell`信息,当用户登录时,该
文件仅仅执行一次!默认情况下,他设置一些环境变量,执行用户的`.bashrc`文件.

###~/.bashrc

交互式 `non-login` 方式进入 `bash` 运行

该文件包含专用于你的`bash shell`的`bash`信息,当登录时以及每次打开新的`shell`时,该该文件被读取.

设定的变量(局部)只能继承/etc/profile中的变量,他们是\"父子\"关系.


###~/.bash_logout
当每次退出系统(退出bash shell)时,执行该文件. 

###MAC
有一个例外就是在`Mac OS`系统中，当你每次运行`termianl`的时候，系统都会默认的给你运行一个`login shell`环境，所以你看到在`Mac OS`系统中`~/`目录下只有一个`.bash_profile`文件而没有`.bashrc`文件，就是这个道理了。

如何同时使用两个文件？

那么如果我在`Mac OS`系统中也想把一些`shell`命令放到`.bashrc`文件中呢？当然不推荐这么做，也没什么意义，那么你可以创建一个`.bashrc`的文件。然后在`.bash_profile`文件中写上如下代码：

```
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
```

在`terminal`读取`.bash_profile`文件后就会`load.bashrc`文件中的内容。