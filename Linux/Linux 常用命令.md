# 常用的命令
sh脚本结合系统命令便有了强大的威力，在字符处理领域，有grep、awk、sed三剑客，grep负责找出特定的行，awk能将行拆分成多个字段，sed则可以实现更新插入删除等写操作。

## id
```sh
id
```
查看用户的UID和GID等信息

## pwd
```sh
pwd
```
查看当前用户位置

## su
```sh
su <user>
```
su 表示切换当前的用户指定到 user

non-login shell

```sh
su
su root
```
login shell

```sh
su -
su - root
```

切换到root做一次操作，后面加 -c

```sh
su -c
```

## sudo
sudo 表示获取临时的root权限命令 super-user do

通过sudo，能把某些超级权限有针对的下放，并且不需要普通用户知道root密码

sudo配置文件在 /etc/sudoers ，可以通过 visudo 进行修改

1. 当用户执行sudo时，系统于/etc/sudoers文件中查找该用户是否有执行sudo的权限；
2. 若用户具有可执行sudo的权限，那么让用户输入用户自己的密码，注意这里输入的是用户自己的密码；
3. 如果密码正确，变开始进行sudo后面的命令，root执行sudo是不需要输入密码的，切换到的身份与执行者身份相同的时候，也不需要输入密码。

## 文件权限
所有者为 `owner/group/others` 拥有者/组/其他
权限为 `read/write/execute` 读/写/执行
对应数字分别为

* r:4
* w:2
* x:1

` [-rwxrwx---] `的意思解释为

```sh
owner = rwx = 4+2+1 = 7
group = rwx = 4+2+1 = 7
others= --- = 0+0+0 = 0
```

## chgrp
更改文件的所属组

```sh
chgrp [-cfhvR] [--help] file...
-c : 若该档案拥有者确实已经更改，才显示其更改动作
-f : 若该档案拥有者无法被更改也不要显示错误讯息
-h : 只对于连结(link)进行变更，而非该 link 真正指向的档案
-v : 显示拥有者变更的详细资料
-R : 对目前目录下的所有档案与子目录进行相同的拥有者变更(即以递回的方式逐个变更)

chgrp -R users /usr/local/test
```

## chown
更改与文件关联的所有者或组，一个文件可以归某个用户所有，同时也归某个组所有。

```sh
chown [-cfhvR] [--help] [--version] user[:group] file...
user : 新的档案拥有者的使用者 ID
group : 新的档案拥有者的使用者群体(group)
-c : 若该档案拥有者确实已经更改，才显示其更改动作
-f : 若该档案拥有者无法被更改也不要显示错误讯息
-h : 只对于连结(link)进行变更，而非该 link 真正指向的档案
-v : 显示拥有者变更的详细资料
-R : 对目前目录下的所有档案与子目录进行相同的拥有者变更(即以递回的方式逐个变更)

chown -R Alvin /home/wwwroot/
chown -R Alvin:root /home/wwwroot/
```

## chmod
chmod命令用于改变linux系统文件或目录的访问权限。用它控制文件或目录的访问权限。该命令有两种用法。一种是包含字母和操作符表达式的文字设定法；另一种是包含数字的数字设定法。

```sh
      u
      g = r
      o - w
chmod a + x file #user group others al =设定 -减少权限 +增加权限

chmod a+x test.sh #给所有人增加execute权限
chmod u=rwx,go=rx test.sh #给users增加所有权限，给group&others增加读和执行权限

chomd [-R] xyz file #xyz 为数字777 770 等

chmod 770 test.sh
```

## touch

1. 一是用于把已存在文件的时间标签更新为系统当前的时间（默认方式），它们的数据将原封不动地保留下来；
2. 二是用来创建新的空文件。

	-a：或--time=atime或--time=access或--time=use 只更改存取时间；  
	-c：或--no-create 不建立任何文件；  
	-d：<时间日期> 使用指定的日期时间，而非现在的时间；  
	-f：此参数将忽略不予处理，仅负责解决BSD版本touch指令的兼容性问题；  
	-m：或--time=mtime或--time=modify 只更该变动时间；   
	-r：<参考文件或目录> 把指定文件或目录的日期时间，统统设成和参考文件或目录的日期时间相同；  
	-t：<日期时间> 使用指定的日期时间，而非现在的时间；  

## > >>
`>` 写入文件并覆盖旧文件

`>>` 加到文件的尾部，保留旧文件内容。

## cat
* 显示文件内容  
	最简单的方法是直接输入‘cat file_name’.  
	-n 显示行号（包括空行）  
	-b 非空行显示行号  
* 新建文件  
	cat > operatingsystem  
	它会生成一个operatingsystem的文件。然后下面会显示空行。此时你可输入内容  
* 向文件中追加内容  
	cat /root/linux >> /root/desktop  
	当你使用两个 > 符时, 会将第一个文件中的内容追加到第二个文件的末尾  
* 从/root/linux中读取内容，然后排序，将结果输出并生成linux-sort新文件  
	cat < /root/linux | sort > linux-sort

## top
动态的显示进程信息，默认5秒刷新一下进程列表，快捷键q退出。

前面几行是任务队列信息，CPU和内存等信息

排序：

* M,（注意大写）,按内存使用情况排序
* P , 根据CPU使用百分比大小进行排序
* T,  根据时间/累计时间进行排序。



## ps
Process Status 查看进程列表

```sh
ps -A #显示所有进程信息
ps -u root #显示指定用户信息
ps -ef #显示所有进程信息，连同命令行
ps -ef| grep ssh #查找特定进程
ps -ef | grep nginx | grep -v grep #查找特定进程不显示grep进程
ps -ef | grep nginx | grep -v grep | wc -l #查找特定进程的数量
ps aux #列出目前所有的正在内存当中的程序
```

## grep

```sh
在多个文件中查找： 
grep "match_pattern" file_1 file_2 file_3 ...

#输出除之外的所有行 -v 选项：
grep -v "match_pattern" file_name
```

## awk

## sed
参考：http://coolshell.cn/articles/9104.html

```sh
#下面的命令只替换第3到第6行的文本。
$ sed "3,6s/my/your/g" pets.txt
This is my cat
  my cat's name is betty
This is your dog
  your dog's name is frank
This is your fish
  your fish's name is george
This is my goat
  my goat's name is adam
```

## ssh-copy-id

```sh
ssh-copy-id -i ~/.ssh/id_rsa.pub root@8.8.8.8
```



## xargs
## curl

## 挂载局域网共享文件夹
```sh
mount -t cifs -o username="administrator",password="123456" //192.168.1.10/movie /mnt/

#mount -t cifs -o 这个就不多说了(照着写吧)。
#username="administrator" 访问需要的用户名。
#password="123456" 访问需要的密码(空密码)。
#//192.168.1.10/movie 共享机器的IP地址，后面的movie为共享名(非cp命令)。
#/mnt/ 挂载的目录(共享目录被挂载到这里)。

ll /mnt/

umount /mnt/
```

## Ctrl-z

灵活运用 CTRL-z
在我们的日常工作中，我们可以用 CTRL-z 来将当前进程挂起到后台暂停运行，执行一些别的操作，然后再用 fg 来将挂起的进程重新放回前台（也可用 bg 来将挂起的进程放在后台）继续运行。这样我们就可以在一个终端内灵活切换运行多个任务，这一点在调试代码时尤为有用。因为将代码编辑器挂起到后台再重新放回时，光标定位仍然停留在上次挂起时的位置，避免了重新定位的麻烦。

## df
查看整体磁盘使用量

```sh
df -h
```
## du
查看目录的磁盘使用量

```sh
du -h #显示目录或者文件所占空间 
du -h log.log 显示指定文件所占空间
du -h dir 查看指定目录的所占空间
du -sh 只显示总和的大小
du -sh * 显示当前目录下文件夹大小
```

显示前10个占用空间最大的文件或目录：

```sh
du -s * | sort -nr | head
-h 已易读的格式显示指定目录或文件的大小
-s 选项指定对于目录不详细显示每个子目录或文件的大小
```

## ulimit
命令用来限制系统用户对shell资源的访问

```sh
[root@localhost ~]# ulimit -a
core file size (blocks, -c) 0 #core文件的最大值为100 blocks。
data seg size (kbytes, -d) unlimited #进程的数据段可以任意大。
scheduling priority (-e) 0 file size (blocks, -f) unlimited #文件可以任意大。
pending signals (-i) 98304 #最多有98304个待处理的信号。
max locked memory (kbytes, -l) 32 #一个任务锁住的物理内存的最大值为32KB。
max memory size (kbytes, -m) unlimited #一个任务的常驻物理内存的最大值。
open files (-n) 1024 #一个任务最多可以同时打开1024的文件。
pipe size (512 bytes, -p) 8 #管道的最大空间为4096字节。
POSIX message queues (bytes, -q) 819200 #POSIX的消息队列的最大值为819200字节。
real-time priority (-r) 0 stack size (kbytes, -s) 10240 #进程的栈的最大值为10240字节。
cpu time (seconds, -t) unlimited #进程使用的CPU时间。
max user processes (-u) 98304 #当前用户同时打开的进程（包括线程）的最大个数为98304。
virtual memory (kbytes, -v) unlimited #没有限制进程的最大地址空间。
file locks (-x) unlimited #所能锁住的文件的最大个数没有限制。
```

## chkconfig
chkconfig命令检查、设置系统的各种服务。这是Red Hat公司遵循GPL规则所开发的程序，它可查询操作系统在每一个执行等级中会执行哪些系统服务，其中包括各类常驻服务。谨记chkconfig不是立即自动禁止或激活一个服务，它只是简单的改变了符号连接。

```sh
chkconfig
# 等级0表示：表示关机
# 等级1表示：单用户模式
# 等级2表示：无网络连接的多用户命令行模式
# 等级3表示：有网络连接的多用户命令行模式
# 等级4表示：不可用
# 等级5表示：带图形界面的多用户模式
# 等级6表示：重新启动 

chkconfig --list #列出所有的系统服务。
chkconfig --add httpd #增加httpd服务。
chkconfig --del httpd #删除httpd服务。
chkconfig --level httpd 2345 on #设置httpd在运行级别为2、3、4、5的情况下都是on（开启）的状态。
chkconfig --list #列出系统所有的服务启动情况。
chkconfig --list mysqld #列出mysqld服务设置情况。
chkconfig --level 35 mysqld on #设定mysqld在等级3和5为开机运行服务，--level 35表示操作只在等级3和5执行，on表示启动，off表示关闭。
chkconfig mysqld on #设定mysqld在各等级为on，“各等级”包括2、3、4、5等级。

```

### 如何增加一个服务：
服务脚本必须存放在/etc/ini.d/目录下；

```sh
#在chkconfig工具服务列表中增加此服务，此时服务会被在/etc/rc.d/rcN.d中赋予K/S入口了；
chkconfig --add servicename

#修改服务的默认启动等级。
chkconfig --level 35 mysqld on
```


### netstat

Netstat 是一款命令行工具，可用于列出系统上所有的网络套接字连接情况，包括 tcp, udp 以及 unix 套接字，另外它还能列出处于监听状态（即等待接入请求）的套接字


```sh
# 列出所有连接
netstat -a
netstat -tnlp

-a或–all 显示所有连线中的Socket。
-A<网络类型>或–<网络类型> 列出该网络类型连线中的相关地址。
-c或–continuous 持续列出网络状态。
-C或–cache 显示路由器配置的快取信息。
-e或–extend 显示网络其他相关信息。
-F或–fib 显示FIB。
-g或–groups 显示多重广播功能群组组员名单。
-h或–help 在线帮助。
-i或–interfaces 显示网络界面信息表单。
-l或–listening 显示监控中的服务器的Socket。
-M或–masquerade 显示伪装的网络连线。
-n或–numeric 直接使用IP地址，而不通过域名服务器。
-N或–netlink或–symbolic 显示网络硬件外围设备的符号连接名称。
-o或–timers 显示计时器。
-p或–programs 显示正在使用Socket的程序识别码和程序名称。
-r或–route 显示Routing Table。
-s或–statistice 显示网络工作信息统计表。
-t或–tcp 显示TCP传输协议的连线状况。
-u或–udp 显示UDP传输协议的连线状况。
-v或–verbose 显示指令执行过程。
-V或–version 显示版本信息。
-w或–raw 显示RAW传输协议的连线状况。
-x或–unix 此参数的效果和指定”-A unix”参数相同。
–ip或–inet 此参数的效果和指定”-A inet”参数相同。
```

## 修改主机名

```
vim /etc/sysconfig/network
```