## $PATH

系统当中有很多个Python，当我们敲Python的时候，系统是如何知道要执行Python，并优先找到其中一个版本的呢？

`echo $PATH`

```
/usr/local/sbin:
/usr/local/bin:
/usr/bin:
/bin:
/usr/sbin:
/sbin
```
`:`是分隔符，上面原本是一行

代表了在敲出某命令时，查找对应的目录优先执行顺序