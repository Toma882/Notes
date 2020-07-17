## 注意点

* `count()`比`len()`快，若只为求长度
* 对查询集调用`list()` 将强制对它求值。  
 `entry_list = list(Entry.objects.all())`
* 如果至少有一个记录，则查询集为True，否则为False。  
` if Entry.objects.filter(headline="Test"):`
* 若需要知道是否存在至少一条记录（而不需要真实的对象）。  
  使用 `exists()`方法更高效
* `values(*fields)`
返回一个`ValuesQuerySet —— QuerySet` 的一个子类，迭代时返回字典
 



## 参考
* [QuerySet API参考](http://python.usyiyi.cn/translate/django_182/ref/models/querysets.html)