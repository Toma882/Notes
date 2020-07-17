## gunicorn

### 安装
```
pip install gunicorn
```
### 参数

[gunicorn setting docs](http://docs.gunicorn.org/en/latest/settings.html#settings)

```
gunicorn -w 1 -b 127.0.0.1:8000 code:application
# 其中 -w 指定 worker 数量， -b 指定监听地址
--log-file FILE The Error log file to write to.
--log-level LEVEL debug, info, warning, error, critical
-D, --daemon 后台执行
-p FILE, --pid FILE filename to use for the PID file
-t INT, --timeout INT Workers silent for more than this many seconds are killed and restarted
```




### 关闭
```
pkill gunicorn
```

OR 

假设Gunicorn写入PID文件

```
run("kill `cat /path/to/your/file/gunicorn.pid`")
```

##Nginx相关

[nginx-configuration docs](http://docs.gunicorn.org/en/stable/deploy.html#nginx-configuration)

Gunicorn 是 WSGI HTTP 服务，通常将其放到 Nginx 服务器后
```
server {
	listen 80;
	server_name example.org;
	access_log  /var/log/nginx/example.log;
	location / {
		proxy_pass http://127.0.0.1:8000;
		proxy_set_header Host $host;

		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	}
}
```

## 参考

[Python Web服务器并发性能测试](https://www.jianshu.com/p/2e713b54df0c)
