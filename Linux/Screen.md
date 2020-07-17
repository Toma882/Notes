# Screen

为什么需要 `Screen` 需要阅读 [为什么关掉窗口/断开连接会使得正在运行的程序死掉](为什么关掉窗口/断开连接会使得正在运行的程序死掉.md)

## Install

```sh
yum install screen
```

## 如何使用 Screen

Screen 是一个可以在多个进程之间多路复用一个物理终端的窗口管理器。  
Screen 中有会话的概念，用户可以在一个 `screen` 会话中创建多个 `screen` 窗口，在每一个 `screen` 窗口中就像操作一个真实的 `telnet/SSH` 连接窗口那样。

在screen中创建一个新的窗口有这样几种方式：

### 直接 `screen` 命令

```
screen
```

Screen 将创建一个执行 `shell` 的全屏窗口。
键入 `exit` 退出窗口，如果这是该 `screen` 会话的唯一窗口，该 `screen` 会话退出，否则 `screen` 自动切换到前一个 `screen` 窗口。

### `screen` 命令后跟要执行程序

```sh
screen vi test.c
```

Screen 创建一个执行 `vi test.c` 的单窗口会话，退出 `vi` 将退出该窗口/会话。

### `screen` 中新建 `screen`

在一个已有 `screen` 会话中创建新的窗口。在当前 `screen` 窗口中键入 `Ctrl键+a键`，之后再按下 `c` 键，`screen` 在该会话内生成一个新的窗口并切换到该窗口。

### `screen` detach attach

不中断 `screen` 窗口中程序的运行而暂时断开（detach）`screen` 会话，并在随后时间重新连接（attach）该会话，重新控制各窗口中运行的程序。

例如，我们打开一个screen窗口编辑/tmp/abc文件：

```sh
screen vi /tmp/abc
```

在 `screen` 窗口键入 `C-a d`，Screen 会给出 `detached` 提示：
暂时中断会话
半个小时之来了，查找当前的 `screen` 列表：

```sh
screen -ls
# There is a screen on:
#         16582.pts-1.tivf06      (Detached)
# 1 Socket in /tmp/screens/S-root.
```

重新连接会话：

```sh
screen -r 16582
```

##Screen常用选项

命令 | 说明
--- | ---
-c file                         | 使用配置文件file，而不使用默认的$HOME/.screenrc
-------------                   |-------------
-d|-D [pid.tty.host]            | 不开启新的screen会话，而是断开其他正在运行的screen会话
-h num                          | 指定历史回滚缓冲区大小为num行
-list|-ls                       | 列出现有screen会话，格式为pid.tty.host
-d -m                           | 启动一个开始就处于断开模式的会话
-r sessionowner/ [pid.tty.host] | 重新连接一个断开的会话。多用户模式下连接到其他用户screen会话需要指定sessionowner，需要setuid-root权限
-S sessionname                  | 创建screen会话时为会话指定一个名字
-v                              | 显示screen版本信息
-wipe [match]                   | 同-list，但删掉那些无法连接的会话


下例显示当前有两个处于detached状态的screen会话，你可以使用screen -r <screen_pid>重新连接上：

```
[root@tivf18 root]# screen –ls
There are screens on:
        8736.pts-1.tivf18       (Detached)
        8462.pts-0.tivf18       (Detached)
2 Sockets in /root/.screen.

[root@tivf18 root]# screen –r 8736
```

如果由于某种原因其中一个会话死掉了（例如人为杀掉该会话），这时 `screen -list` 会显示该会话为dead状态。使用 `screen -wipe` 命令清除该会话：

```
[root@tivf18 root]# kill -9 8462
[root@tivf18 root]# screen -ls  
There are screens on:
        8736.pts-1.tivf18       (Detached)
        8462.pts-0.tivf18       (Dead ???)
Remove dead screens with 'screen -wipe'.
2 Sockets in /root/.screen.

[root@tivf18 root]# screen -wipe
There are screens on:
        8736.pts-1.tivf18       (Detached)
        8462.pts-0.tivf18       (Removed)
1 socket wiped out.
1 Socket in /root/.screen.

[root@tivf18 root]# screen -ls  
There is a screen on:
        8736.pts-1.tivf18       (Detached)
1 Socket in /root/.screen.

[root@tivf18 root]#
```

-d –m 选项是一对很有意思的搭档。他们启动一个开始就处于断开模式的会话。你可以在随后需要的时候连接上该会话。有时候这是一个很有用的功能，比如我们可以使用它调试后台程序。该选项一个更常用的搭配是：-dmS sessionname
启动一个初始状态断开的screen会话：

```sh
screen -d -m gdb execlp_test
```

```sh
# S 名字定义为 mygdb
screen -dmS mygdb gdb execlp_test
```

连接该会话：

```sh
screen -r mygdb
```