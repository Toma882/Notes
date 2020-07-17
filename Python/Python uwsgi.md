#uwsgi

## 概念
WSGI（Web Server Gateway Interface）  
> WSGI不是服务器，python模块，框架，API或者任何软件，只是一种规范，描述web server如何与web application通信的规范  
> 要实现WSGI协议，必须同时实现web server和web application，当前运行在WSGI协议之上的web框架有Bottle, Flask, Django

uwsgi
>
与WSGI一样是一种通信协议，是uWSGI服务器的独占协议，用于定义传输信息的类型(type of information)，每一个uwsgi packet前4byte为传输信息类型的描述，与WSGI协议是两种东西，据说该协议是fcgi协议的10倍快

uWSGI
> 一个web服务器，实现了WSGI协议、uwsgi协议、http协议等。

## 常用命令
```
pip install uwsgi
uwsgi --version    # 查看 uwsgi 版本
uwsgi --ini uwsgi.ini # 使用 ini 配置启动
cat uwsgi/uwsgi.pid # 查看 pid 可以 ps aux | grep uwsgi 确认是否一致
uwsgi --reload uwsgi.pid
uwsgi --connect-and-read uwsgi.status
uwsgi --stop uwsgi.pid # 可以 ps aux | grep uwsgi 确认是否已经存在
```

**重启uWSGI**

```
# using kill to send the signal 使用kill发送信号
kill -HUP `cat /tmp/project-master.pid`
#友好重启，不会丢失会话
kill -HUP pid
#强制重启，可能丢失会话
kill -TERM pid

# or the convenience option --reload 或者使用简单选项 --reload
uwsgi --reload /tmp/project-master.pid

# or if uwsgi was started with touch-reload=/tmp/somefile 或者，如果uwsgi是使用touch-reload=/tmp/somefile启动
touch /tmp/somefile

# Or from your application, in Python: 或者在Python程序里：
uwsgi.reload()

# 注意，如果要使用pid，需要在uwsgi启动参数中指定 --pidfile，
# 如：/etc/rc.local 修改自启动
/usr/local/bin/uwsgi /var/www/html/mz_uwsgi.ini --pidfile /tmp/uwsgi.pid
```

## 配置
在相应工程目录下创建uwsgi文件夹，用来存放uwsgi相关文件

在uwsgi文件夹中使用touch创建uwsgi.pid和uwsgi.status文件

* uwsgi.pid文件用来重启和停止uwsgi服务
* uwsgi.status用来查看uwsgi的服务状态

```
touch uwsgi.pid
touch uwsgi.status
```

### uwsgin.ini
```
[uwsgi]
#使用HTTP访问的端口号, 使用这个端口号是直接访问了uWSGI, 绕过了Nginx
http = :8010
#与外界连接的端口号, Nginx通过这个端口转发给uWSGI
socket = 127.0.0.1:8001
#是否使用主线程
master = true
# 项目在服务器中的目录(绝对路径)
chdir = /home/wwwroot/sgss_mt/mtDjango/
# Django's wsgi 文件目录
wsgi-file = mtDjango/wsgi.py
# 最大进程数
processes = 4
#每个进程的线程数
threads = 2
#状态监听端口
stats = 127.0.0.1:9191
# 退出时自动清理环境配置
vacuum = true
#目录下文件改动时自动重启
touch-reload = /home/wwwroot/sgss_mt/mtDjango
#Python文件改动时自动重启
py-auto-reload = 1
#后台运行相关uwsgi文件
daemonize = /home/wwwroot/sgss_mt/uwsgi/uwsgi.log
stats = /home/wwwroot/sgss_mt/uwsgi/uwsgi.status           
pidfile = /home/wwwroot/sgss_mt/uwsgi/uwsgi.pid 
```



## 参考
[做python Web开发你要理解：WSGI & uwsgi](https://www.jianshu.com/p/679dee0a4193)