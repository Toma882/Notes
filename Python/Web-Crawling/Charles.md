# Charles


> Charles 是一个网络抓包工具，相比 Fiddler，其功能更为强大，而且跨平台支持得更好。    



## 证书配置

Windows

点击 `Help -> SSL Proxying -> Install Charles Root Certificate` 即可进入证书的安装页面

MAC

1. 点击 `Help -> SSL Proxying -> Install Charles Root Certificate` 即可进入证书的安装页面
1. 找到 Charles 的证书并双击，将 `信任` 设置为 `始终信任` 即可

iOS

1. 查看电脑的 Charles，点击 `Proxy -> Proxy Settings`
2. `Enable transparent HTTP proxying`
3. `Enbale SOCKS proxy`
4. 查看当前电脑 IP
5. 无线局域网选择 `HTTP 代理`，配置代理 为 手动，设定代理的服务器和端口为 Charles Proxy Settings 的地址和端口，存储按钮按下后，电脑端弹出提示框，询问是否允许此连接，点击 Allow
6. 接下来，再安装Charles的HTTPS证书
7. 在电脑上打开 `Help -> SSL Proxying -> Install Charles Root Certificate on a Mobile Device or Remote Browser`
8. 使用 Safari 浏览器访问 `chls.pro/ssl`
9. `通用 -> 描述文件 -> Charles Proxy CA -> 安装`
10. `通用 -> 关于本机 -> 证书信任位置 -> 打开 Charles Proxy CA 信任开关`

## 参考
[Charles Proxy](https://www.charlesproxy.com)