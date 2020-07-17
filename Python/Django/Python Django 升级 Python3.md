# Django升级Python3版本


### models.ForeignKey

`topic = models.ForeignKey(Topic）`

修改为

`topic = models.ForeignKey(Topic,on_delete=models.CASCADE)`

### urls.py app_name

`path('',include('learning_logs.urls', namespace='learning_logs'))
]
`

修改为

`path('',include(('learning_logs.urls', 'learning_logs'), namespace='learning_logs'))
]
`

或者

在`learning_logs.urls.py`文件中
添加
`app_name = 'learning_logs'`

### StandardError
`StandardError` => `StandardError`