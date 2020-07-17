# django-admin
`django-admin` 是用于管理`Django`的命令行工具集

## manage.py


`manage.py` 会在每个`Django`项目中自动生成。  
`manage.py` 是一个对`django-admin`的小包装，它可以在交付给`django-admin`之前为你做一些事情:

* 他把你的项目包放在 `python` 的系统目录中 `sys.path`。
* 它用于设置 `DJANGO_SETTINGS_MODULE` 环境变量，因此它指向工程的 `settings.py` 文件。
* 通过调用`django.setup()` 来初始化 `Django` 的内部变量。

## 参考

* [django-admin和manage.py](http://usyiyi.cn/translate/django_182/ref/django-admin.html)