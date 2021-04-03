## 先决条件
* 一个域名
* 一台VPS
* CloudFlare账号


##  VPS上的操作
2.1. 利用certbot获取免费证书
这一步的目的是为了从 Let's Encrypt 上获得免费的ssl证书。

```
# 下载certbot软件
wget  https://github.com/certbot/certbot/archive/v0.34.2.tar.gz
# 解压
tar xzf v0.34.2.tar.gz
# 进入目录
cd certbot-0.34.2
# 申请过程要验证绑定的域名是否属于申请人，
# 需要停止nginx，让出80端口，以便进行验证
systemctl stop nginx
# 申请ssl证书，可添加多个-d参数。这条命令会自动安装python等软件
# 申请到的证书存储在目录/etc/letsencrypt/live/v1.yourdomain.net/
./certbot-auto certonly --standalone --email youremail@126.com -d v1.yourdomain.net

免费证书的有效期是3个月，到期前的一个月可以续期
./certbot-auto renew

```

2.2. 在Nginx上添加一个配置
添加新的配置文件

```
vi /etc/nginx/conf.d/v1.conf
```

内容为：

```
server{
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/v1.yourdomain.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/v1.yourdomain.net/privkey.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;
    server_name v1.yourdomain.net;
    location /ws {
      proxy_redirect off;
      proxy_pass http://127.0.0.1:12345;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host $http_host;
    }
}

```
启动Nginx

```
systemctl start nginx
```

2.3. 安装V2ray

```
# 切换至主目录
cd ~
# 下载安装脚本
wget https://install.direct/go.sh
# 安装unzip
yum install zip unzip
# 执行安装
bash go.sh
```


修改v2ray的配置文件

```
vi /etc/v2ray/config.json
```

内容改为：

```
{
  "inbounds": [{
    "port": 12345,
    "listen":"127.0.0.1",
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "3feb5394-2dfd-4604-9b4b-aef9be9d1f70",
          "alterId": 64
        }
      ]
    },
    "streamSettings":{
       "network":"ws",
       "wsSettings":{
         "path":"/ws"
       }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}

```

启动v2ray

```
systemctl start v2ray
```

3. 在CloudFlare上的操作
注册一个账号
先要添加根域名，之后可以在DNS页面添加二级域名
域名的名称服务器要修改为CloudFlare提供的，需要在购买域名的后台进行操作
在Crypto页面，SSL选为FULL
DNS添加需要等待几个小时才能生效，直接ping域名，如果返回的是Cloudflare的ip地址，则表示已经生效

4. V2Ray的客户端
客户端的名称是v2rayN，从https://github.com/2dust/v2rayN/releases/download/2.29/v2rayN-Core.zip下载解压后，运行v2rayN.exe程序
添加VMess服务器
地址：上述指定的域名或二级域名
端口：443
用户id：要和v2ray配置文件里的一致，很长的那一串
额外id：要和v2ray配置文件里的一致
传输协议：ws
路径：/ws
底层传输安全：tls
启动服务
右键点击v2rayN在托盘的图标，选择“启动Http代理”

等CloudFlare里的DNS生效之后，客户端才能连接上