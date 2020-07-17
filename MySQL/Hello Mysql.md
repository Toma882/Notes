#Mysql Install

## Homebrew Install

### Homebrew  Install

```sh
# We've installed your MySQL database without a root password.
brew install mysql
```

{start|stop|restart|reload|force-reload|status}

```
# To have launchd start mysql now and restart at login:
brew services start mysql

# Or, if you don't want/need a background service you can just run:
mysql.server start

# Securing the MySQL server deployment:
# /usr/local/opt/mysql/bin/mysql_secure_installation
mysql_secure_installation

# To connect run:
mysql -uroot
```

conf

```sh
# For homebrew mysql installs, where's my.cnf?
mysql --help

# Default options are read from the following files in the given order:
# /etc/my.cnf /etc/mysql/my.cnf /usr/local/etc/my.cnf ~/.my.cnf
```

### homebrew  Uninstall

```sh
brew uninstall mysql
```


## pkg

### pkg Install
[Install Mysql 5.7.8 or Later](http://dev.mysql.com/doc/refman/5.7/en/osx-installation-pkg.html)

通过运行`sudo vi /etc/bashrc`，在`bash`的配置文件中加入`mysql`和`mysqladmin`的别名

```
#mysql
alias mysql='/usr/local/mysql/bin/mysql'
alias mysqladmin='/usr/local/mysql/bin/mysqladmin'
```

### pkg Uninstall

```sh
sudo rm /usr/local/mysql
sudo rm -rf /usr/local/mysql*
sudo rm -rf /Library/StartupItems/MySQLCOM
sudo rm -rf /Library/PreferencePanes/My*
vim /etc/hostconfig  (and removed the line MYSQLCOM=-YES-)
rm -rf ~/Library/PreferencePanes/My*
sudo rm -rf /Library/Receipts/mysql*
sudo rm -rf /Library/Receipts/MySQL*
sudo rm -rf /var/db/receipts/com.mysql.*
```

## 其他

密码修改：

```
mysqladmin -u root -p password <NEWPASSWORD>
```

日志：

错误日志默认会存在数据目录下，也就是上面所定义的 `/usr/local/var/mysql/`

## 版本Diff

* 更新了mysql 5.7.x后发现原本的date类型和datetime类型等无法设置为DEFAULT '0000-00-00'了

    原因是5.7 默认开始用以下
    
    ```
    sql mode :
    ONLY_FULL_GROUP_BY, STRICT_TRANS_TABLES, NO_ZERO_IN_DATE, NO_ZERO_DATE, ERROR_FOR_DIVISION_BY_ZERO, NO_AUTO_CREATE_USER, and NO_ENGINE_SUBSTITUTION
    ```
    
    其中`NO_ZERO_IN_DATE, NO_ZERO_DATE`两个选项禁止了`0000`这样的日期和时间。因此在mysql的配置文件中，重新设置`sql-mode`，去掉这两项就可以了。如： 
    
    ```
    sql-mode="ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES 
    ,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
    ```