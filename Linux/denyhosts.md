## denyhosts

`http://denyhosts.sourceforge.net/`

* **安装前执行：`echo "" > /var/log/secure && service rsyslog restart` 清空以前的日志并重启一下`rsyslog`**
* 为防止自己的IP被屏蔽，可以：`echo "你的IP" >>  /usr/share/denyhosts/allowed-hosts` 将你的IP加入白名单，再重启DenyHosts：`/etc/init.d/denyhosts` ，如果已经被封，需要先按下面的命令删除被封IP后再加白名单。
* 如有IP被误封，可以执行下面的命令解封：`wget http://soft.vpser.net/security/denyhosts/denyhosts_removeip.sh && bash denyhost_removeip.sh` 要解封的IP

```sh

# 下载DenyHosts 并解压
wget http://soft.vpser.net/security/denyhosts/DenyHosts-2.6.tar.gz
tar zxvf DenyHosts-2.6.tar.gz
cd DenyHosts-2.6

# 因为DenyHosts是基于python的，所以要已安装python，大部分Linux发行版一般都有。
# 默认是安装到/usr/share/denyhosts/目录的,进入相应的目录修改配置文件
python setup.py install

cd /usr/share/denyhosts/
cp denyhosts.cfg-dist denyhosts.cfg
cp daemon-control-dist daemon-control

# 默认的设置已经可以适合centos系统环境，你们可以使用vi命令查看一下denyhosts.cfg和daemon-control，里面有详细的解释
# 接着使用下面命令启动denyhosts程序
chown root daemon-control
chmod 700 daemon-control
./daemon-control start

# 重启启动
ln -sf /usr/share/denyhosts/daemon-control /etc/init.d/denyhosts
chkconfig --add denyhosts
chkconfig --level 2345 denyhosts on
# 或者执行下面的命令加入开机启动，将会修改/etc/rc.local文件
echo "/usr/share/denyhosts/daemon-control start" >> /etc/rc.local
```

DenyHosts配置文件`/usr/share/denyhosts/denyhosts.cfg`说明：

```sh
SECURE_LOG = /var/log/secure
#sshd日志文件，它是根据这个文件来判断的，不同的操作系统，文件名稍有不同。

HOSTS_DENY = /etc/hosts.deny
#控制用户登陆的文件

PURGE_DENY = 5m
DAEMON_PURGE = 5m
#过多久后清除已经禁止的IP，如5m（5分钟）、5h（5小时）、5d（5天）、5w（5周）、1y（一年）

BLOCK_SERVICE  = sshd
#禁止的服务名，可以只限制不允许访问ssh服务，也可以选择ALL

DENY_THRESHOLD_INVALID = 5
#允许无效用户失败的次数

DENY_THRESHOLD_VALID = 10
#允许普通用户登陆失败的次数

DENY_THRESHOLD_ROOT = 5
#允许root登陆失败的次数

HOSTNAME_LOOKUP=NO
#是否做域名反解

DAEMON_LOG = /var/log/denyhosts
```
## 参考
[DenyHosts](http://www.vpser.net/security/denyhosts.html) 