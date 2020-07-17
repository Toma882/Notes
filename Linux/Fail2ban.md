#Fail2ban

`https://github.com/fail2ban/fail2ban`

[DenyHosts](http://www.vpser.net/security/denyhosts.html) 会分析 `/var/log/secure（redhat，Fedora Core）` 等日志文件，当发现同一IP在进行多次SSH密码尝试时就会记录IP到 `/etc/hosts.deny` 文件，从而达到自动屏蔽该IP的目的。

fail2ban功能上更多，还可以对ftp等进行保护，fail2ban可以缓解暴力密码攻击，但是请注意，这并不能保护SSH服务器避免来自复杂的分布式暴力破解组织，这些攻击者通过使用成千上万个机器控制的IP地址来绕过fail2ban的防御机制。

开机自动启动

```sh
chkconfig fail2ban on
```

安装成功，但是执行失败，Python版本？


## 参考
* [ssh防止暴力破解及fail2ban的使用方法](http://www.cnblogs.com/jasmine-Jobs/p/5927968.html)
* [如何使用 fail2ban 防御 SSH 服务器的暴力破解攻击](https://linux.cn/article-5067-1.html#3_8058)
* [Fail2ban 原理 安装 使用](https://my.oschina.net/monkeyzhu/blog/418592)
