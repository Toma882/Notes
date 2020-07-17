# Mysql Linux

输入用户名密码进入 Mysql 命令
`mysql -uroot -p'abc1234567'`

## status
`mysql-> status;`

查看 Mysql 运行状态



## show processlist

`mysql-> show processlist`

查看当前正在运行的SQL，从中找出运行慢的SQL语句，找到执行慢的语句后，再用`explain`命令查看这些语句的执行计划