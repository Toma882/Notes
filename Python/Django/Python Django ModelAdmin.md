### 怎样自定义列表页面？

```python
class AuthorAdmin(admin.ModelAdmin):
	#列表页，列表顶部显示的字段名称
	list_display = ('first_name', 'last_name', 'email')

	#列表页出现搜索框，参数是搜索的域
	search_fields = ('first_name', 'last_name')

	#右侧会出现过滤器，根据字段类型，过滤器显示过滤选项
	list_filter = ('publication_date',)

	#页面中的列表顶端会有一个逐层深入的导航条，逐步迭代选项
	date_hierarchy = 'publication_date'

	#自然是排序所用了，减号代表降序排列
	ordering = ('-publication_date',)

```
### 将Author模块和管理类绑定在一起，注册到后台管理

```python
admin.site.register(Author, AuthorAdmin)
```

### 以下显示怎样自定义表单编辑页面的显示，注意它和列表页是在一个Admin类内部的

```python
class BookAdmin(admin.ModelAdmin):
	#
	# 这里可以写一些列表页面自定义选项
	#
	# 以下是表单编辑页面自定义选项
	# 表单编辑页面，字段显示的顺序，如果没有某个选项，就不会显示
	fields = ('title', 'authors', 'publisher', 'publication_date')
	# 有了该设定，表单中该选项，变成了一个用JS动态选择的选择框，就是左右两列\
	# 左边选择，右边显示被选中的内容，
	# 强烈建议针对那些拥有十个以上选项的"多对多字段"使用filter_horizontal
	filter_horizontal = ('authors',)
	# 用于外键，并且外键超级多的时候，是一个包含外键字段名称的元组，
	# 它包含的字段将被展现成`` 文本框`` ，而不再是`` 下拉框``
	raw_id_fields = ('publisher',)

```