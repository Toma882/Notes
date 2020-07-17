## iptables

>CentOS 7 使用 [FirewallD](FirewallD.md) ，根据自己情况判断是否继续使用 iptables
>
>iptable 专指 IPv4 网络
>
>以下环境为：CentOS 6.5 64位

防火墙的作用除了特定的服务建立新的外出和接入连接之外，对其他从因特网到非公共服务进行了缺省拒绝设计。
在面对外部攻击时，可以变更规则用来抵御外部攻击。

Iptable 的前身 ipchains 增加规则链的概念；iptable 则将概念扩展为表。所以 iptable 的结构是：

`iptables > tables > chains > rules`

文件位置：

```sh
vi /etc/sysconfig/iptables
```

iptable 具有四个内置表：

```
Filter 表：默认表，具有如下链：
    INPUT 用于传到本地服务器的包。
    OUTPUT 用于本地生成以及传出本地服务器的包。
    FORWARD 用于通过本地服务器路由的包。
NAT 表（网络地址转换 network-address-translation ）：
    PREROUTING：用于目的 NAT，它在路由前更改包 IP 地址。
    POSTROUTING：用于源 NAT，它在路由前更改包 IP 地址。
    OUTPUT：用于防火墙上本地生成包的 NAT。
Mangle 表：用于特定包的更改：
    PREROUTING
    OUTPUT
    FORWARD
    INPUT
    POSTROUTING
Raw 表：用于配置免除：
    PREROUTING
    OUTPUT
```

![](assets/iptables.jpg)

## iptables 命令

### 基本命令
```sh
# 查看当前iptables的应用规则
iptables -L
iptables -nvL

# 重启生效
chkconfig iptables on 
chkconfig iptables off

# 即时生效
service iptables stop
service iptables start
```

如何保存 iptables 规则

```sh
# 查看当前服务端口
cat /etc/services

# 若已对vi /etc/sysconfig/iptables进行修改后，使用restart进行保存
service iptables restart

# 添加任意一条防火墙规则，命令如下：
# iptables -P OUTPUT ACCEPT...
# 保存 iptables 策略：
service iptables save
# 执行启动 iptables 的命令启动：
service iptables start

# 导出目前的iptables
iptables-save > iptables-script
# 恢复保存的iptables
iptables-restore iptables-script
```


### 建立规则和链

```sh
iptables [-t table] command [match] [target]
```

#### 表（table）
`[-t table]` 选项允许使用标准表之外的任何表。表是包含仅处理特定类型信息包的规则和链的信息包过滤表。
有三种可用的表选项： `filter 、 nat 和 mangle` 。该选项不是必需的，如果未指定， 则 **`filter` 用作缺省表**。

* `filter` 表用于一般的信息包过滤，它包含 `INPUT 、 OUTPUT 和 FORWARD` 链。
* `nat` 表用于要转发的信息包，它包含 `PREROUTING 、 OUTPUT 和 POSTROUTING` 链。 
* 如果信息包及其头内进行了任何更改，则使用 `mangle` 表。 该表包含一些规则来标记用于高级路由的信息包，该表包含 `PREROUTING 和 OUTPUT` 链。

注：`PREROUTING` 链由指定信息包一到达防火墙就改变它们的规则所组成，而 `POSTROUTING` 链由指定正当信息包打算离开防火墙时改变它们的规则所组成。

#### 命令（command）

```sh
-A 或 --append ： 该命令将一条规则附加到链的末尾。 
示例：
$ iptables -A INPUT -s 205.168.0.1 -j ACCEPT
该示例命令将一条规则附加到 INPUT 链的末尾，确定来自源地址 205.168.0.1 的信息包可以 ACCEPT 。

-D 或 --delete ： 通过用 -D 指定要匹配的规则或者指定规则在链中的位置编号，该命令从链中删除该规则。 
                  下面的示例显示了这两种方法。 
示例：
$ iptables -D INPUT --dport 80 -j DROP 
$ iptables -D OUTPUT 3
第一条命令从 INPUT 链删除规则，它指定 DROP 前往端口 80 的信息包。第二条命令只是从 OUTPUT 链删除编号为 3 的规则。

-P 或 --policy ： 该命令设置链的缺省目标，即策略。 所有与链中任何规则都不匹配的信息包都将被强制使用此链的策略。 
示例：
$ iptables -P INPUT DROP
$ iptables -P FORWARD DROP
$ iptables -P OUTPUT ACCEPT
该命令将 INPUT 链的缺省目标指定为 DROP 。这意味着，将丢弃所有与 INPUT 链中任何规则都不匹配的信息包。

-N 或 --new-chain ： 用命令中所指定的名称创建一个新链。 
示例：
$ iptables -N allowed-chain

-F 或 --flush ： 如果指定链名，该命令删除链中的所有规则， 如果未指定链名，该命令删除所有链中的所有规则。
                 此参数用于快速清除。 
示例：
$ iptables -F FORWARD 
$ iptables -F

-X 清除预设表filter中使用者自定链中的规则
$ iptables -X

-L 或 --list ： 列出指定链中的所有规则。 
示例：
$ iptables -L allowed-chain
$ iptables -L -v
```

#### 匹配（match）

ptables 命令的可选 match 部分指定信息包与规则匹配所应具有的特征（如源和目的地地址、协议等）。  
匹配分为两大类： **通用匹配**和 **特定于协议的匹配**。  
这里，我将研究可用于采用任何协议的信息包的通用匹配。 下面是一些重要的且常用的通用匹配及其示例和说明：

```sh
-p 或 --protocol ： 该通用协议匹配用于检查某些特定协议。 协议示例有 TCP 、 UDP 、 ICMP 、用逗号分隔的任何这三种协议的组合列表以及 ALL （用于所有协议）。
                    ALL 是缺省匹配。可以使用 ! 符号，它表示不与该项匹配。 
示例：
$ iptables -A INPUT -p TCP, UDP 
$ iptables -A INPUT -p ! ICMP
在上述示例中，这两条命令都执行同一任务 — 它们指定所有 TCP 和 UDP 信息包都将与该规则匹配。 
通过指定 ! ICMP ，我们打算允许所有其它协议（在这种情况下是 TCP 和 UDP ）， 而将 ICMP 排除在外。

-s 或 --source ： 该源匹配用于根据信息包的源 IP 地址来与它们匹配。
                  该匹配还允许对某一范围内的 IP 地址进行匹配，可以使用 ! 符号，表示不与该项匹配。
                  缺省源匹配与所有 IP 地址匹配。 
示例：
$ iptables -A OUTPUT -s 192.168.1.1 
$ iptables -A OUTPUT -s 192.168.0.0/24 
$ iptables -A OUTPUT -s ! 203.16.1.89
第二条命令指定该规则与所有来自 192.168.0.0 到 192.168.0.24 的 IP 地址范围的信息包匹配。
第三条命令指定该规则将与 除来自源地址 203.16.1.89 外的任何信息包匹配。

-d 或 --destination ： 该目的地匹配用于根据信息包的目的地 IP 地址来与它们匹配。 
                       该匹配还允许对某一范围内 IP 地址进行匹配，可以使用 ! 符号，表示不与该项匹配。 
示例：
$ iptables -A INPUT -d 192.168.1.1 
$ iptables -A INPUT -d 192.168.0.0/24 
$ iptables -A OUTPUT -d ! 203.16.1.89

--dport or --sport (destination or source ports)
要使用 dport 和 sport ，必须指定协议(tcp, udp, icmp, all)。
同样可以设置一个端口范围，如下面例子中的 6881 到 6890。
示例：
$ iptables -A INPUT -p tcp --dport 6881:6890 -j ACCEPT

-i (for interface) 本地(localhost, 127.0.0.1)
we use the -i switch (for interface) to specify packets matching or destined for the lo (localhost, 127.0.0.1) interface and finally -j (jump) to the target action for packets matching the rule - in this case ACCEPT. 
So this rule will allow all incoming packets destined for the localhost interface to be accepted. This is generally required as many software applications expect to be able to communicate with the localhost adaptor.
示例：
$ iptables -A INPUT -i lo -j ACCEPT

-m 
Here we are using the -m switch to load a module (state). 
The state module is able to examine the state of a packet and determine if it is NEW, ESTABLISHED or RELATED. 
NEW refers to incoming packets that are new incoming connections that weren't initiated by the host system. 
ESTABLISHED and RELATED refers to incoming packets that are part of an already established connection or related to and already established connection.
示例：
$ iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

First we use -m mac to load the mac module and then we use --mac-source to specify the mac address of the source IP address (192.168.0.4).
You will need to find out the mac address of each ethernet device you wish to filter against.
Running ifconfig (or iwconfig for wireless devices) as root will provide you with the mac address.
示例：
# Accept packets from trusted IP addresses
$ iptables -A INPUT -s 192.168.0.4 -m mac --mac-source 00:50:8D:FD:E6:32 -j ACCEPT
```

#### 目标（target）
我们已经知道，目标是由规则指定的操作，对与那些规则匹配的信息包执行这些操作。 除了允许用户定义的目标之外，还有许多可用的目标选项。下面是常用的一些目标及其示例和说明：

```sh
ACCEPT ： 当信息包与具有 ACCEPT 目标的规则完全匹配时， 会被接受（允许它前往目的地），
          并且它将停止遍历链（虽然该信息包可能遍历另一个表中的其它链，并且有可能在那里被丢弃）。
          该目标被指定为 -j ACCEPT 。

DROP ： 当信息包与具有 DROP 目标的规则完全匹配时，会阻塞该信息包，并且不对它做进一步处理。 
        该目标被指定为 -j DROP 。
        
REJECT ： 该目标的工作方式与 DROP 目标相同，但它比 DROP 好。
          和 DROP 不同， REJECT 不会在服务器和客户机上留下死套接字。 
          另外， REJECT 将错误消息发回给信息包的发送方。该目标被指定为 -j REJECT 。 
示例：
$ iptables -A FORWARD -p TCP --dport 22 -j REJECT
$ iptables -A OUTPUT -p TCP --sport 80 -j ACCEPT

RETURN ： 在规则中设置的 RETURN 目标让与该规则匹配的信息包停止遍历包含该规则的链。 
          如果链是如 INPUT 之类的主链，则使用该链的缺省策略处理信息包。 
          它被指定为 -jump RETURN 。
示例：
$ iptables -A FORWARD -d 203.16.1.89 -jump RETURN

还有许多用于建立高级规则的其它目标，如 LOG 、 REDIRECT 、 MARK 、 MIRROR 和 MASQUERADE 等。
```

## iptables state 状态

假设服务器 A(IP地址为`1.1.1.1`)提供 WWW 服务，另有客户端 B(`2.2.2.2`)、C(`3.3.3.3`)  
服务器A运行提供WWW服务的后台程序(比如 Apache )并且把该服务绑定到端口 80，也就是在端口80进行监听。

客户端 B 发起一个连接请求时,客户端 B 将打开一个大于 1024 的连接端口( 1024 内为已定义端口),假设为1037。客户端 A 在接收到请求后，用80端口与客户端 B 建立连接以响应客户端 B 的请求，同时产生一个80端口绑定的拷贝，继续监听客户端的请求。

客户端 A 又接收到客户端 C 的连接请求(设连接请求端口为1071)，则客户端 A 在与客户端 C 建立连接的同时又产生一个 80 端口绑定的拷贝继续监听客户端的请求。

如下所示，因为系统是以源地址、源端口、目的地址、目的端口来标识一个连接的，所以在这里每个连接都是唯一的。

**套接字对(socket pairs)：每个网络连接包括以下信息：源地址、目的地址、源端口和目的端口**

source  | source-port | Link | destination  | destination-port  
------- | ----------- | ---- | ------------ | ------------- 
1.1.1.1 | 80          | <--> | 2.2.2.2      | 1037
1.1.1.1 | 80          | <--> | 3.3.3.3      | 1071 

源地址、目的地址、源端口和目的端口，协议类型、连接状态(TCP协议)和超时时间等。iptable 防火墙把这些信息叫作状态( `stateful` )，能够检测每个连接状态的防火墙叫作状态包过滤防火墙。它除了能够完成简单包过滤防火墙的包过滤工作外，还在自己的内存中维护一个跟踪连接状态的表，比简单包过滤防火墙具有更大的安全性。这连接跟踪的表是 `/proc/net/ip_conntrack` ( `conntrack` 就是 `connection tracking` 的首字母缩写)，能容纳多少记录是被一个变量控制的。默认值取决于你的内存大小，128MB可以包含8192条目录，256MB是16376条。你也可以在 `/proc/sys/net/ipv4/ip_conntrack_max` 里查看、设置。

每一种特定的服务都有自己特定的端口，一般说来小于 1024 的端口多为服务器保留端口，这些端口分配给众所周知的服务(如WWW、FTP等等)，从 512 到 1024 的端口通常保留给特殊的 UNIX TCP/IP 应用程序，具体情况请参考 `/etc/services` 文件或 RFC1700。

iptables中的状态检测功能是由state选项来实现iptable的。对这个选项，在iptables的手册页中有以下描述：

```sh
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

这个模块能够跟踪分组的连接状态(即状态检测)。
格式：--state XXXXX
这里，state是一个用逗号分割的列表，表示要匹配的连接状态。
```

在iptables中有四种状态：`NEW, ESTABLISHED, RELATED, INVALID`。

```
NEW
表示这个分组需要发起一个连接，或者说，分组对应的连接在两个方向上都没有进行过分组传输。
NEW 说明这个包是我们看到的第一个包。
意思就是，这是 conntrack 模块看到的某个连接第一个包，它即将被匹配了。
比如，我们看到一个 SYN 包，是我们所留意的连接的第一个包，就要匹配它。
第一个包也可能不是 SYN 包，但它仍会被认为是 NEW 状态。
比如一个特意发出的探测包，可能只有 RS T位，但仍然是 NEW。

ESTABLISHED
表示分组对应的连接已经进行了双向的分组传输，也就是说连接已经建立，而且会继续匹配这个连接的包。
处于ESTABLISHED状态的连接是非常容易理解的。只要发送并接到应答，连接就是ESTABLISHED的了。
一个连接要从NEW变为ESTABLISHED，只需要接到应答包即可，不管这个包是发往防火墙的，还是要由防火墙转发的。
ICMP的错误和重定向等信息包也被看作是ESTABLISHED，只要它们是我们所发出的信息的应答。

RELATED
表示分组要发起一个新的连接，但是这个连接和一个现有的连接有关，
例如：FTP的数据传输连接和控制连接之间就是RELATED关系。
RELATED是个比较麻烦的状态。当一个连接和某个已处于ESTABLISHED状态的连接有关系时，就被认为是RELATED的了。
换句话说，一个连接要想是RELATED的，首先要有一个ESTABLISHED的连接。
这个ESTABLISHED连接再产生一个主连接之外的连接，这个新的连接就是RELATED的了，
当然前提是conntrack模块要能理解RELATED。
ftp是个很好的例子，FTP-data连接就是和FTP-control有RELATED的。还有其他的例子，

INVAILD
表示分组对应的连接是未知的，说明数据包不能被识别属于哪个连接或没有任何状态。
有几个原因可以产生这种情况，比如，内存溢出，收到不知属于哪个连接的ICMP错误信息。
一般地，我们DROP这个状态的任何东西。
```

这些状态可以一起使用，以便匹配数据包。这可以使我们的防火墙非常强壮和有效。以前，我们经常打开1024以上的所有端口来放行应答的数据。现在，有了状态机制，就不需再这样了。因为我们可以只开放那些有应答数据的端口，其他的都可以关闭。这样就安全多了。

## iptables中的ICMP

在iptables看来，只有四种ICMP分组，以下分组类型可以被归为`NEW、ESTABLISHED`

* ECHO请求(ping,8)和ECHO应答(ping,0)
* 时间戳请求(13)和应答(14)
* 信息请求(15)和应答(16)
* 地址掩码请求(17)和应答(18)

这些 ICMP 分组类型中，请求分组属于 NEW，应答分组属于 ESTABLISHED。而其它类型的 ICMP 分组不基于请求/应答方式，一律被归入 RELATED。


## 其他

`iptables` 会以程序方式（自上而下）读取规则，并且在某条规则匹配后，就不会对其他事项进行评估，特别是对 `DROP` 的位置进行特别注意

```sh
# -A INPUT：将此规则添加至 INPUT 链。
# -m conntrack：对下列连接通信与当前的包/连接进行匹配。
# -ctstate ESTABLISHED, RELATED：规则将应用到的连接状态。在本例中，ESTABLISHED 连接代表能够看到两个方向数据包的连接，而 RELATED 类型代表，数据包开启一个新连接，但是与现有连接相关联。
# -j ACCEPT：告知防火墙接收之前描述的连接。-j 标记的另一个有效设置是 DROP
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

---
# 允许所有传入的 SSH 通信
# ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh
# -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
# 获得 ssh 端口，然后写入 iptables ？ssh 改变端口后 nmap 没有扫描出来？
iptables -A INPUT -p tcp --dport ssh -j ACCEPT

---
# 拒绝所有规则
iptables -A INPUT -j DROP

---
# 不开放端口下，启用http服务、对外服务不开放端口下，启用http服务、对外服务
# 用 -P 来拦截全部的通信，然后在来允许哪些端口可以被使用你可以这样写
iptables -P INPUT -j DROP
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

---
# 不想让别人可以PING到我
iptables -A INPUT -p icmp --icmp-type echo-request -i ppp0 -j DROP
```

修改已有规则的例子

```sh
# 关掉现有 iptables
service iptables stop
# 清空现有规则
iptables -F

# 开放ssh端口
iptables -A INPUT -p tcp --dport ssh -j ACCEPT
# 开放80端口
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
开放6842端口
iptables -A INPUT -p tcp --dport 6842 -j ACCEPT
允许8.8.8.8端口443（SVN服务器）连接本机
iptables -A INPUT -s 8.8.8.8 -p tcp --sport 443 -j ACCEPT
允许6.6.6.6连接本机端口3306（MYSQL）
iptables -A INPUT -s 6.6.6.6 -p tcp --dport 3306 -j ACCEPT

# 允许内网localhost可以连接
iptables -A INPUT -i lo -j ACCEPT

# 拒绝所有其他规则
iptables -A INPUT -j DROP

# 保存命令会把临时的iptables保存到 /etc/sysconfig/iptables
service iptables save
# 开启防火墙
service iptables start
```

## 其他过滤
`-m string --hex-string`

```
# 06为google 03为com 的长度 
iptables -A OUTPUT -o eth0 -p udp --port 53 -m string --hex-string "|06|google|03|com" -algo bm -j ACCEPT
```

[参考1](http://stackoverflow.com/questions/14096966/can-iptables-allow-dns-queries-only-for-a-certain-domain-name)

[Iptables drop domain dns request packet](https://blog.tankywoo.com/2014/08/02/iptables-block-domain.html)

## RHEL 7 / CentOS 7 firewalld
With `RHEL 7 / CentOS 7`, `firewalld` was introduced to manage iptables. IMHO, firewalld is more suited for workstations than for server environments.

It is possible to go back to a more classic iptables setup. First, stop and mask the firewalld service:

```
systemctl stop firewalld
systemctl mask firewalld
```

Then, install the iptables-services package:

```
yum install iptables-services
```

Enable the service at boot-time:

```
systemctl enable iptables
```
Managing the service

```
systemctl [stop|start|restart] iptables
```
Saving your firewall rules can be done as follows:

```
service iptables save
```

or

```
/usr/libexec/iptables/iptables.init save
```

##参考

* [netfilter/iptables 简介](https://www.ibm.com/developerworks/cn/linux/network/s-netip/)
* [iptables 的防火墙正常运行时间和安全性](https://www.ibm.com/developerworks/cn/opensource/os-iptables/)
* [CentOS iptables](https://wiki.centos.org/HowTos/Network/IPTables)
* [linux下IPTABLES配置详解](http://www.cnblogs.com/alimac/p/5848372.html)