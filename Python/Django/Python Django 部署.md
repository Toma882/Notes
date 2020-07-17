# Django部署

本文使用uwsgi+nginx方式进行部署

## Python升级
Python大多数为2.6版本，手动升级为2.7版本，详情见[Python Install](../Python Install.md)

## 部署
### 基本
```
pip freeze >requirements.txt 
```

```
# 安装依赖软件
yum install zlib zlib-devel openssl openssl-devel libcurl-devel gcc gcc-c++ sqlite-devel -y
# 安装django
pip install django
# 安装uwsgi
pip install uwsgi
# 安装项目依赖
pip install -r requirements.txt
# 收集静态文件
python manage.py collectstatic
# 在 migrations 文件夹下生成 migrations 文件
python manage.py makemigrations
# 生成数据库
python manage.py migrate
# 创建超级用户
python manage.py createsuperuser
```

### 配置 Nginx
```
server {
    listen 80;
    server_name 193.112.177.230 localhost;
    charset     utf-8;
    # access_log /home/wwwroot/sgss_mt/mtDjango/log/nginx_access.log;
    # error_log /home/wwwroot/sgss_mt/mtDjango/log/nginx_error.log;
    
    location /static {
        alias /home/wwwroot/sgss_mt/mtDjango/static;
    }
    
    location / {
        include uwsgi_params;
        uwsgi_pass 127.0.0.1:8001;
    }
}
```
### 配置uwsgi

在目录下新建 uwsgi 文件夹存放相关文件

```
uwsgi.ini
uwsgi.log
uwsgi.pid
uwsgi.status
```

命令

```
uwsgi --ini uwsgi.ini             # 启动
uwsgi --reload uwsgi.pid          # 重启
uwsgi --stop uwsgi.pid            # 关闭
uwsgi --connect-and-read uwsgi/uwsgi.status # 读取uwsgi实时状态
```

ini 配置

```
# 使用HTTP访问的端口号, 使用这个端口号是直接访问了uWSGI, 绕过了Nginx
#http = :8010
# 与外界连接的端口号, Nginx通过这个端口转发给uWSGI
socket = 127.0.0.1:8001
# 是否使用主线程
master = true
# 项目在服务器中的目录(绝对路径)
chdir = /home/wwwroot/sgss_mt/mtDjango/
# Django's wsgi 文件目录
wsgi-file = mtDjango/wsgi.py
# 最大进程数
processes = 4
# 每个进程的线程数
threads = 2
# 状态监听端口
stats = 127.0.0.1:9191
# 退出时自动清理环境配置
vacuum = true
# 目录下文件改动时自动重启
touch-reload = /home/wwwroot/sgss_mt/mtDjango
# Python文件改动时自动重启
py-auto-reload = 1
# 后台运行相关uwsgi文件
daemonize = /home/wwwroot/sgss_mt/uwsgi/uwsgi.log
stats = /home/wwwroot/sgss_mt/uwsgi/uwsgi.status
pidfile = /home/wwwroot/sgss_mt/uwsgi/uwsgi.pid
```






    

## 参考

* [使用 Nginx 和 Gunicorn 部署 Django 博客](https://www.zmrenwu.com/post/20/)
* [在 Linux 服务器上使用 Nginx + Gunicorn 部署 Django 项目的正确姿势](http://www.tendcode.com/article/set-up-django-with-nginx-and-gunicorn/)
* [Django Nginx+uwsgi 安装配置](http://www.runoob.com/django/django-nginx-uwsgi.html)
* [通过Nginx部署Django（基于ubuntu)](http://www.cnblogs.com/fnng/p/5268633.html)
* [Nginx＋Django＋uWSGI部署服务器详细解析](https://www.jianshu.com/p/a13307242ca3)
* [Django开发个人博客网站——32、启用Let's Encrypt免费的HTTPS证书](http://www.geerniya.cn/blog/51/)
* [Nginx+uwsgi+Django服务器部署](https://hellohxk.com/blog/nginx-uwsgi-django/)