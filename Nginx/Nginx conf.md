##配置文件位置

CentOS位置：
`/etc/nginx/nginx.conf`

Mac位置（Homebrew安装）：
`/usr/local/etc/nginx/nginx.conf`


##nginx.conf

```
#定义Nginx运行的用户和用户组。默认为 user nginx
user www www;

#nginx进程数，建议设置为等于CPU总核心数。默认为 auto
worker_processes 8;

#全局错误日志定义类型
error_log /var/log/nginx/error.log info;#debug|info|notice|warn|error|crit

#进程文件
pid /var/run/nginx.pid;

#一个nginx进程打开的最多文件描述符数目，如果没设置的话，这个值为操作系统的限制
#理论值应该是最多打开文件数（系统的值`ulimit -n`）与nginx进程数相除，但是nginx分配请求并不均匀，所以建议与`ulimit -n`的值保持一致。
worker_rlimit_nofile 65535;

#工作模式与连接数上限
events
{
    #参考事件模型，use[kqueue|rtsig|epoll|/dev/poll|select|poll];
    #epoll模型是Linux 2.6以上版本内核中的高性能网络I/O模型，如果跑在FreeBSD上面，就用kqueue模型。
    use epoll;
    #单个进程最大连接数（最大连接数=连接数*进程数）
    worker_connections 65535; #默认10240
}


#设定http服务器
http
{
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile on; #开启高效文件传输模式，sendfile指令指定nginx是否调用sendfile函数来输出文件，对于普通应用设为 on，如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。注意：如果图片显示不正常把这个改成off。
    tcp_nopush on; #防止网络阻塞
    tcp_nodelay on; #防止网络阻塞
    keepalive_timeout 120; #长连接超时时间，单位是秒，默认65
    types_hash_max_size 2048;#配置块：http、server、location。types_hash_max_size影响散列表的冲突率。types_hash_max_size越大，就会消耗更多的内存，但散列key的冲突率会降低，检索速度就更快。types_hash_max_size越小，消耗的内存就越小，但散列key的冲突率可能上升
    
    server_names_hash_bucket_size 128; #服务器名字的hash表大小
    client_header_buffer_size 32k; #上传文件大小限制
    large_client_header_buffers 4 64k; #设定请求缓
    client_max_body_size 8m; #设定请求缓
    
    autoindex on; #开启目录列表访问，合适下载服务器，默认关闭。
    
    include mime.types; #文件扩展名与文件类型映射表
    default_type application/octet-stream; #默认文件类型
    #charset utf-8; #默认编码
    	
    #FastCGI相关参数是为了改善网站的性能：减少资源占用，提高访问速度。下面参数看字面意思都能理解。
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    	
    #gzip模块设置
    gzip on; #开启gzip压缩输出
    gzip_min_length 1k; #最小压缩文件大小
    gzip_buffers 4 16k; #压缩缓冲区
    gzip_http_version 1.0; #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
    gzip_comp_level 2; #压缩等级
    gzip_types text/plain application/x-javascript text/css application/xml;
    #压缩类型，默认就已经包含text/html，所以下面就不用再写了，写上去也不会有问题，但是会有一个warn。
    gzip_vary on;
    #limit_zone crawler $binary_remote_addr 10m; #开启限制IP连接数的时候需要使用

    #Todo
    upstream up.helloworld.com.
    {
        # upstream的负载均衡，weight是权重，可以根据机器配置定义权重。weigth参数表示权值，权值越高被分配到的几率越大。
        # least_conn ip_hash
        server 192.168.80.101:80 weight=1;
        server 192.168.80.102:80 weight=2;
        server 192.168.80.103:80 weight=3;
    }

    #虚拟主机的配置
    #为方便每个虚拟主机的配置文件，  
    #在`nginx.conf`同级目录下新建文件夹`vhost`，  
    #然后再`nginx.conf`中的`http{}`里面添加`include vhost/*.conf;`。
    include vhost/*.conf;

    server
    {
        #域名可以有多个，用空格隔开
        server_name www.helloworld.com helloworld.com;
        #监听端口
        listen 80;
        #默认主页
        index index.html index.htm index.php;
        	
        root /data/www/helloworld;
        #---默认上面已经结束
        
        #语法规则： location [=|~|~*|^~] /uri/ { … }
        #= 开头表示精确匹配
        #^~ 开头表示uri以某个常规字符串开头，理解为匹配 url路径即可。nginx不对url做编码，因此请求为/static/20%/aa，可以被规则^~ /#static/ /aa匹配到（注意是空格）。
        #~ 开头表示区分大小写的正则匹配
        #~* 开头表示不区分大小写的正则匹配
        #!~和!~*分别为区分大小写不匹配及不区分大小写不匹配 的正则
        #/ 通用匹配，任何请求都会匹配到。
        
        #php解析
        location ~ .*\.(php|php5)?$
        {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
        }
        
        #设置图片缓存时间设置
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires 10d;
        }


        #JS和CSS缓存时间设置
        location ~ .*\.(js|css)?$
        {
            expires 1h;
        }

        #定义本虚拟主机的访问日志 需要新建vhost
        access_log /var/log/nginx/vhost/helloworld.log access;

        #对 "/" 启用反向代理
        location / {
            root /home/wwwroot/login/;
            proxy_pass http://127.0.0.1:8080;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            #后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #以下是一些反向代理的配置，可选。
            proxy_set_header Host $host;
            client_max_body_size 10m; #允许客户端请求的最大单文件字节数
            client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数，
            proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间(代理连接超时)
            proxy_send_timeout 90; #后端服务器数据回传时间(代理发送超时)
            proxy_read_timeout 90; #连接成功后，后端服务器响应时间(代理接收超时)
            proxy_buffer_size 4k; #设置代理服务器（nginx）保存用户头信息的缓冲区大小
            proxy_buffers 4 32k; #proxy_buffers缓冲区，网页平均在32k以下的设置
            proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
            proxy_temp_file_write_size 64k;
            #设定缓存文件夹大小，大于这个值，将从upstream服务器传
        }

        #设定查看Nginx状态的地址
        location /NginxStatus
        {
            stub_status on;
            access_log on;
            auth_basic "NginxStatus";
            auth_basic_user_file conf/htpasswd;
            #htpasswd文件的内容可以用apache提供的htpasswd工具来产生。
        }

        #本地动静分离反向代理配置
        #所有jsp的页面均交由tomcat或resin处理
        location ~ .(jsp|jspx|do)?$
        {
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://127.0.0.1:8080;
        }
        
        #所有静态文件由nginx直接读取不经过tomcat或resin
        location ~ .*.(htm|html|gif|jpg|jpeg|png|bmp|swf|ioc|rar|zip|txt|flv|mid|doc|ppt|pdf|xls|mp3|wma)$
        {
            expires 15d;
        }
        location ~ .*.(js|css)?$
        {
            expires 1h;
        }
        
        
    }
    
    #Redirect语法
    server
    {
        listen 80;s
        server_name start.igrow.cn;
        index index.html index.php;
        root html;
        if ($http_host !~ "^star\.igrow\.cn$"
        {
            rewrite ^(.*) http://star.igrow.cn$1 redirect;
        }
        
        #防盗链
        location ~* \.(gif|jpg|swf)$
        {
            valid_referers none blocked start.igrow.cn sta.igrow.cn;
            if ($invalid_referer)
            {
                rewrite ^/ http://$host/logo.png;
            }
        }
    }

}
```

##参考

http://wiki.nginx.org/Main

http://tengine.taobao.org/book/index.html