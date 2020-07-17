## Menu Add & Remove

Add:   
```
/System/Library/CoreServices/Menu Extras
```    
直接把相应文件拖到菜单栏右侧

Remvoe:   
按住Cmd，把菜单栏图标拖下来


## DNS Clean
Windows:   

```
ipconfig /flushdns
net stop dnscache
net start dnscache
```

MAC:   
```
sudo /etc/init.d/dns-clean start
```

在 OS X v10.10.4 或更高版本中，请使用以下“终端”命令来还原 DNS 缓存设置：

```
sudo killall -HUP mDNSResponder
```

在 OS X v10.10 至 v10.10.3 中，请使用以下“终端”命令来还原 DNS 缓存设置：

```
sudo discoveryutil mdnsflushcache
```

OS X Mavericks、Mountain Lion 和 Lion
在 OS X v10.9.5 及更低版本中，请使用以下“终端”命令来还原 DNS 缓存设置：

```
sudo killall -HUP mDNSResponder
```

Mac OS X Snow Leopard
在 OS X v10.6 至 v10.6.8 中，请使用以下“终端”命令来还原 DNS 缓存设置：

```
sudo dscacheutil -flushcache
```

## 重装后硬盘为 `未命名`

只能使用终端修改：
输入：diskutil cs list并回车
可以看到类似的界面   
```
Logiccal Volume Group "......"
```     

其中"......"是GUID

输入：   
```
diskutil coreStorage rename GUID NEW_NAME
```    
回车

## Splayer 字幕位置

资源库/Application Support/SPlayerX/SVPSub, 打开Finder，单击“前往”


## 查看端口占用

```
lsof -i:8080
```