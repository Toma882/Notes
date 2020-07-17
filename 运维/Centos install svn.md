
```
svnserve -d -r /usr/local/svn --config-file /usr/local/svn/conf/svnserve.conf
mv svnserve.conf conf/
mv passwd conf/
mv authz conf/
mkdir conf
svnserve -d -r /usr/local/svn/
vim svnserve.conf
vim passwd
vim authz

svnadmin create sgss_server
svnadmin create sgss_cdn
svnadmin create sgss_install

yum install subversion
cd /usr/local/
mkdir svn
cd /usr/local/svn/

mkdir conf
svnadmin create tmp
cp tmp/conf/* conf/
# 复制 tmp/conf/ authz passwd svnserve.conf 到 conf 文件夹，所有配置在这里配置
# authz：负责账号权限的管理，控制账号是否读写权限
# passwd：负责账号和密码的用户名单管理
# svnserve.conf：svn服务器配置文件

svnadmin create server #创建项目仓库目录
svnadmin create cdn

svnserve -d -r /usr/local/svn --config-file /usr/local/svn/conf/svnserve.conf
```

修改authz文件信息：

```
>vi authz
```

在文件内容的末尾，添加如下：

```
[\]
#例如：admin = rw
账号1 = rw
账号2 = rw
```


 
修改passwd文件信息:

```
>vi passwd

# 账号密码文件无需做修改，也是直接将账号和密码信息追加到文件中即可，注意格式为：
# 账号 = 密码
admin = 123456
```


修改svnserve.conf（重要）
```
vi svnserve.conf
```
原始文件内容，都被注释掉的，我们只需要去掉4条指定内容前注释即可，如下：

```
### 有三种方式: none read write, 设置为 none 限制访问,read 为只读,write 为具有读写权限，默认为 read
anon-access = none
### 有三种方式: none read write, 设置为 none 限制访问,read 为只读,write 为具有读写权限，默认为 write
auth-access = write

password-db = passwd

realm = My First Repository
```

如果要关闭`svn`，直接使用`killall svnserve`命令
