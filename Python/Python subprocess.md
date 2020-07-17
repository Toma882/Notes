#subprocess

`subprocess`替代其他几个老的模块或者函数，比如：

```
os.system
os.spawn* 
os.popen* 
popen2.* 
commands.*
```

不但可以调用外部的命令作为子进程，而且可以连接到子进程的`input/output/error`管道，获取相关的返回信息

##基础知识

###shell=True

为了让`subprocess`支持更多的使用案例，`Popen`支持大量的可用参数，因此为了让`shell`参数更加明确为`shell`使用，那么
设置 `shell=True`，相关参数将通过`shell`来执行，避免参数方面的混淆。

```python
# subprocess.call 默认shell=False

subprocess.call("ls") #returncode:0
subprocess.call("ps -ef") #error
subprocess.call(["ps","-ef"]) #ok
```

###Popen
`subprocess`最重要的方法为`Popen`，`call`等函数也是`Popen`方法的封装。

```python
#!/usr/bin/python
# -*- coding: UTF-8 -*-
subprocess.Popen(
            # args可以是字符串或者序列类型（如：list，元组），用于指定进程的可执行文件及其参数。
            # args如果是序列类型，第一个元素通常是可执行文件的路径。我们也可以显式的使用executeable参数来指定可执行文件的路径。
            args,
            # bufsize指定缓冲。0 无缓冲,1 行缓冲,其他 缓冲区大小,负值 系统缓冲(全缓冲) 
            bufsize=0, 
            # 是否可执行
            executable=None,
            # stdin, stdout, stderr分别表示程序的标准输入、输出、错误句柄。
            # 他们可以是PIPE，文件描述符或文件对象，也可以设置为None，表示从父进程继承。
            stdin=None,
            stdout=None, 
            stderr=None, 
            # preexec_fn只在Unix平台下有效，用于指定一个可执行对象（callable object），它将在子进程运行之前被调用。
            preexec_fn=None, 
            # close_fds：在windows平台下，如果close_fds被设置为True，则新创建的子进程将不会继承父进程的输入、输出、错误管道。
            # 我们不能将close_fds设置为True同时重定向子进程的标准输入、输出与错误(stdin, stdout, stderr)。
            close_fds=False,
            # shell设为true，程序将通过shell来执行 
            shell=False, 
            # cwd用于设置子进程的当前目录
            cwd=None, 
            # env是字典类型，用于指定子进程的环境变量。如果env = None，子进程的环境变量将从父进程中继承。
            env=None, 
            # universal_newlines:不同操作系统下，文本的换行符是不一样的。如：windows下用'/r/n'表示换，而Linux下用'/n'。如果将此参数设置为True，Python统一把这些换行符当作'/n'来处理。
            universal_newlines=False, 
            # startupinfo与createionflags只在windows下有效，它们将被传递给底层的CreateProcess()函数，用于设置子进程的一些属性，如：主窗口的外观，进程的优先级等等。
            startupinfo=None, 
            creationflags=0)
```

##推荐方式

在满足基本需求的情况下，优先推荐使用下列方法，下列的方式其实`Popen`的封装，

如`subprocess.call()`等同于`subprocess.Popen(*popenargs, **kwargs).wait()`。

###subprocess.call()
`subprocess.call(args, *, stdin=None, stdout=None, stderr=None, shell=False)`

返回值：returncode，相当于Linux exit code，正确为 0  
父进程等待子进程完成  


###subprocess.check_call()
`subprocess.check_call(args, *, stdin=None, stdout=None, stderr=None, shell=False)`

返回值：检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性，可用try…except…来检查

父进程等待子进程完成  

###subprocess.check_output()
`subprocess.check_output(args, *, stdin=None, stderr=None, shell=False, universal_newlines=False)`

返回值：执行带参数的命令并将它的输出作为字节字符串返回
检查退出信息，如果returncode不为0，则举出错误subprocess.CalledProcessError，该对象包含有returncode属性和output属性，output属性为标准输出的输出结果，可用try…except…来检查。

父进程等待子进程完成 

##Popen方法

`Popen`对象创建后，主程序不会自动等待子进程完成。我们必须调用对象的`wait()`方法，如`subprocess.call()`等同于`subprocess.Popen(*popenargs, **kwargs).wait()`，父进程才会等待 (也就是阻塞block)。

###Popen.wait() & Popen.communicate()

```python
# 等待子进程结束。
# 设置并返回returncode属性
# 若使用`stdout=PIPE and/or stderr=PIPE`并且程序输出超过操作系统的`pipe size`时，可能会发生死锁。
# 可以适用`Popen.communicate(input=None)`来避免
Popen.wait()

# 等待子进程结束。
# 设置并返回 tuple (stdoutdata, stderrdata)
Popen.communicate(input=None)
```

`Popen.wait()`把输出放入到了`pipe`中，这跟系统给的`pipe`大小有很大关系。`pipe`大小可以适用`ulimit -a`的方法获取相关信息。

`Popen.communicate()`则把输出放入到了内存中，一般情况下则不会发生死锁，若需要`returncode`，先调用`Popen.communicate()`再调用`Popen.returncode`即可。

```python
#!/usr/bin/env python
# coding: utf-8
#linux 默认的 pipe size 是 64KB。

import subprocess

def test(size):
    print 'start'

    cmd = 'dd if=/dev/urandom bs=1 count=%d 2>/dev/null' % size
    p = subprocess.Popen(args=cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, close_fds=True)
    #p.communicate()
    p.wait()

    print 'end'

# 64KB
test(64 * 1024)
# start
# end

# 64KB + 1B
test(64 * 1024 + 1)
# start
# (deadlock)
```


###其他
```python
# 用于检查子进程是否已经结束。设置并返回returncode属性
Popen.poll()

# 等待子进程结束。设置并返回returncode属性
Popen.wait()

# 向子进程发送信号
Popen.send_signal(signal)

# 停止(stop)子进程。在windows平台下，该方法将调用Windows API TerminateProcess（）来结束子进程
Popen.terminate()

# 杀死子进程
# On Posix OSs the function sends SIGKILL to the child. On Windows kill() is an alias for terminate().
Popen.kill()

# 如果在创建Popen对象是，参数stdin=PIPE，Popen.stdin将返回一个文件对象用于策子进程发送指令。否则返回None
Popen.stdin

# 如果在创建Popen对象是，参数stdout=PIPE，Popen.stdin将返回一个文件对象用于策子进程发送指令。否则返回None
Popen.stdout
If the stdout argument was PIPE, this attribute is a file object that provides output from the child process. Otherwise, it is None.

# 如果在创建Popen对象是，参数stderr=PIPE，Popen.stdin将返回一个文件对象用于策子进程发送指令。否则返回None
Popen.stderr

# 获取子进程的进程ID
Popen.pid

# poll() and wait() (and indirectly by communicate())获取进程的返回值。如果进程还没有结束，返回None
# A negative value -N indicates that the child was terminated by signal N (Unix only).
Popen.returncode
```

##参考
* [subprocess API](https://docs.python.org/2/library/subprocess.html)
