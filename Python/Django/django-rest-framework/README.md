初期需要查看的源代码

```
rest_framework/
    mixins.py
    permissions.py
    renderers.py
    request.py
    response.py
    routers.py
    serializer.py
    status.py
    urlpatterns.py
    urls.py
    views.py
    viewsets.py
```

## Serializers

[serializers docs](http://www.django-rest-framework.org/api-guide/serializers/)

### Specifying which fields to include

```python
class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ('id', 'account_name', 'users', 'created')
        
# You can also set the fields attribute to the special value '__all__' to indicate that all fields in the model should be used.
# For example:

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = '__all__'
        
# You can set the exclude attribute to a list of fields to be excluded from the serializer.
# For example:

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        exclude = ('users',)
```

### Specifying nested serialization

```python
class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ('id', 'account_name', 'users', 'created')
        # max is 10
        depth = 1
        
```

### Specifying read only fields

```python
# You may wish to specify multiple fields as read-only. Instead of adding each field explicitly with the read_only=True attribute, you may use the shortcut Meta option, read_only_fields.

# This option should be a list or tuple of field names, and is declared as follows:

class AccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = Account
        fields = ('id', 'account_name', 'users', 'created')
        read_only_fields = ('account_name',)
        
# Model fields which have editable=False set, and AutoField fields will be set to read-only by default, and do not need to be added to the read_only_fields option.
```
## 参考

* [django-rest-framework tutorial](https://github.com/encode/django-rest-framework/tree/master/docs/tutorial)
* [A Django App that adds CORS (Cross-Origin Resource Sharing) headers to responses](https://github.com/ottoyiu/django-cors-headers/)