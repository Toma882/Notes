# Mysql

## 安装Mysql Python驱动

参考：

* https://github.com/mysql/mysql-connector-python
* http://dev.mysql.com/doc/connector-python/en/
* http://dev.mysql.com/doc/connector-python/en/connector-python-installation-source.html
* http://dev.mysql.com/downloads/connector/python/ （各平台 驱动，包括MAC）

### 通过源码安装（若同时使用 brew pip virtualenv 则推荐此方法）
到`http://dev.mysql.com/doc/relnotes/connector-python/en/`寻找相应的版本号

进行安装：

```sh
#可以根据版本修改'2.2.1'
wget http://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-2.2.1.zip
pip install mysql-connector-python-2.2.1.zip
```

Python3 使用 pymysql

```
pip install pymysql
```


## Python测试是否成功

```python
import mysql.connector
from mysql.connector import errorcode

config = {
    'user': 'root',
    'password': '',
    'host': '127.0.0.1',
    'database': 'mysql'
}

cnx = cur = None
try:
    cnx = mysql.connector.connect(**config)
except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print('Something is wrong with your user name or password')
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("Database does not exist")
    else:
        print(err)
else:
    cur = cnx.cursor()
    cur.execute('show databases;')
    for row in cur.fetchall():
        print(row)
finally:
    if cur:
        cur.close()
    if cnx:
        cnx.close()
```

## Centos 6.5

```
yum install mysql-devel -y
pip install mysql-connector-python
pip install mysqlclient
```

## MacOS Python3
```
brew install mysql-connector-c # macOS (Homebrew) (Currently, it has bug. See below)
```

Note about bug of MySQL Connector/C on macOS
See also: [https://bugs.mysql.com/bug.php?id=86971](https://bugs.mysql.com/bug.php?id=86971)

Versions of MySQL Connector/C may have incorrect default configuration options that cause compilation errors when mysqlclient-python is installed. (As of November 2017, this is known to be true for homebrew's mysql-connector-c and official package)

Modification of `mysql_config` resolves these issues as follows.

`mysql_config` file in
`/usr/local/Cellar/mysql-connector-c/6.1.11/bin`

Change

```
# on macOS, on or about line 112:
# Create options
libs="-L$pkglibdir"
libs="$libs -l "
```

to

```
libs="-L$pkglibdir"
libs="$libs -lmysqlclient -lssl -lcrypto"
```

then

```
LDFLAGS=-L/usr/local/opt/openssl/lib pip install mysqlclient
```
