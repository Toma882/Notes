# crontab
crontab是一个Unix/Linux系统下的常用的定时执行工具，可以在无需人工干预的情况下运行指定作业。

crontab 目前很多主机已经自带

文件位置

```sh
# root为用户名
vim /var/spool/cron/root
```

## crontab的安装

### CentOS下面安装crontab

```sh
//vixie-cron软件包是cron的主程序；crontabs软件包是用来安装、卸装、 或列举用来驱动 cron 守护进程的表格的程序
yum install vixie-cron crontabs

//设为开机自启动
chkconfig crond on
//启动
service crond start
```

### Debian下面安装crontab

```sh
//大部分情况下Debian都已安装。
apt-get install cron

//重启crontab
/etc/init.d/cron restart
```

## crontab使用方法
```sh
# 查看crontab定时执行任务列表
crontab -l

# 添加crontab定时执行任务
crontab -e
```

## crontab 任务命令书写格式


格式 | minute | hour | dayofmonth | month | dayofweek
--- | --- | --- | --- | --- | --- | ---
解释 | 分钟 | 小时 | 日期 | 月付 | 周 | 命令
范围 | 0-59 | 0～23 | 1～31 | 1～12 | 0～7，0和7都代表周日


符号 | 解释
--- | ---
`*(星号)` | 代表所有有效的值。 如：`0 23 * * * backup` 不论几月几日周几的23点整都执行backup命令。
`,(逗号)` | 代表分割开多个值。如：`30 9 1,16,20 * * command` 每月的1、16、20号9点30分执行command命令。
`-(减号)` | 代表一段时间范围。如`0 9-17 * * * checkmail` 每天9点到17点的整点执行checkmail命令
`/n` | 代表每隔n长时间。如`*/5 * * * * check` 每隔5分钟执行一次check命令，与`0-59/5`一样。	


```sh
每天凌晨3:00执行备份程序：0 3 * * * /root/backup.sh

每周日8点30分执行日志清理程序：30 8 * * 7 /root/clear.sh

每周1周5 0点整执行test程序：0 0 * * 1,5 test

每年的5月12日14点执行wenchuan程序：0 14 12 5 * /root/wenchuan

每晚18点到23点每15分钟重启一次php-fpm：*/15 18-23 * * * /etc/init.d/php-fpm
```

## 参考
[Linux VPS/服务器上用Crontab来定时执行实现VPS自动化](http://www.vpser.net/manage/crontab.html)