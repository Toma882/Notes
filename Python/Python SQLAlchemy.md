# SQLAlchemy

SQLAlchemy is the Python SQL toolkit and Object Relational Mapper that gives application developers the full power and flexibility of SQL.

目前正学习 Python ，并且使用 Flask 框架，下面例子为 Flask-SQLAlchemy

>Flask-SQLAlchemy 是一个为您的 Flask 应用增加 SQLAlchemy 支持的扩展。它需要 SQLAlchemy 0.6 或者更高的版本。它致力于简化在 Flask 中 SQLAlchemy 的使用，提供了有用的默认值和额外的助手来更简单地完成常见任务。

## Select, Update, Delete
```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True)
    data = db.Column(db.PickleType())

    def __init__(self, name, data):
        self.name = name
        self.data = data

    def __repr__(self):
        return '<User %r>' % self.username

db.create_all()

# ADD a user.
bob = User('Bob', {})
db.session.add(bob)
db.session.commit()

# UPDATE data
bob = User.query.filter_by(name='Bob').first()
bob.data['foo'] = 123
db.session.commit()

bob = User.query.filter_by(name =='Bob').update(dict(data='bob@example.com')))
db.session.commit()

# DELETE a user
bob = User.query.filter_by(name='Bob').first()
db.session.delete(bob)
db.session.commit()


```

## Relationships

### Simple

```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True)
    email = db.Column(db.String(120), unique=True)

    def __init__(self, username, email):
        self.username = username
        self.email = email

    def __repr__(self):
        return '<User %r>' % self.username
```

类型 | 备注
--- | ---
Integer |	一个整数
String | (size)	有长度限制的字符串
Text	| 一些较长的 unicode 文本
DateTime	| 表示为 Python datetime 对象的 时间和日期
Float	| 存储浮点值
Boolean	| 存储布尔值
PickleType	| 存储为一个持久化的 Python 对象
LargeBinary	| 存储一个任意大的二进制数据


### One-to-Many Relationships
例如如果 Person 定义了一个到 Article 的关系，而 Article 在文件的后面才会声明。

关系使用 `relationship()` 函数表示。然而外键必须用类 `sqlalchemy.schema.ForeignKey` 来单独声明

```python
class Person(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    addresses = db.relationship('Address', backref='person',
                                lazy='dynamic')

class Address(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(50))
    person_id = db.Column(db.Integer, db.ForeignKey('person.id'))
```

`db.relationship()` 做了什么？这个函数返回一个可以做许多事情的新属性。在本案例中，我们让它指向 `Address` 类并加载多个地址。它如何知道会返回不止一个地址？因为 `SQLALchemy` 从您的声明中猜测了一个有用的默认值。 如果您想要一对一关系，您可以把 `uselist=False` 传给 `relationship()`

#### `backref`
是一个在 `Address` 类上声明新属性的简单方法。您也可以使用 `my_address.person` 来获取使用该地址(`address`)的人(`person`)

#### `lazy`
决定了 `SQLAlchemy` 什么时候从数据库中加载数据:

* select (默认值) 就是说 SQLAlchemy 会使用一个标准的 select 语句必要时一次加载数据。
* joined 告诉 SQLAlchemy 使用 JOIN 语句作为父级在同一查询中来加载关系。
* subquery 类似 joined ，但是 SQLAlchemy 会使用子查询。
* dynamic 在有多条数据的时候是特别有用的。不是直接加载这些数据，SQLAlchemy 会返回一个查询对象，在加载数据前您可以过滤（提取）它们。

您如何为反向引用（backrefs）定义惰性（lazy）状态？使用 backref() 函数:

```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    addresses = db.relationship('Address',
        backref=db.backref('person', lazy='joined'), lazy='dynamic')
```

### Many-to-Many Relationships

如果您想要用多对多关系，您需要定义一个用于关系的辅助表。对于这个辅助表， 强烈建议 **不** 使用模型，而是采用一个实际的表:

```python
tags = db.Table('tags',
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id')),
    db.Column('page_id', db.Integer, db.ForeignKey('page.id'))
)

class Page(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    tags = db.relationship('Tag', secondary=tags,
        backref=db.backref('pages', lazy='dynamic'))

class Tag(db.Model):
    id = db.Column(db.Integer, primary_key=True)
```
这里我们配置 Page.tags 加载后作为标签的列表，因为我们并不期望每页出现太多的标签。而每个 tag 的页面列表（ Tag.pages）是一个动态的反向引用。 正如上面提到的，这意味着您会得到一个可以发起 select 的查询对象。



## 参考

* [SQLAlchemy](http://www.sqlalchemy.org/)
* [Flask-SQLAlchemy](http://flask-sqlalchemy.pocoo.org/)
* [Flask-SQLAlchemy@Doc-CN](http://www.pythondoc.com/flask-sqlalchemy/)