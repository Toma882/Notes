# Django
Django is a high-level Python Web framework that encourages rapid development and clean, pragmatic design. 

与以往其他的不一样，Django 使用命令行操作居多。

## 安装

使用 [`mkvirtualenv`](https://github.com/ibelongedtoyou/Notes/blob/master/Python/Python%20virtualenv%20virtualenvwrapper.md#virtualenvwrapper) or PyCharm 创建 `venv_django`

```sh
$ workon venv_django
$ pip install Django
```

版本号

```sh
python -c "import django; print(django.get_version())"
```

## 快速创建一个项目

### 目录结构

将 Python 代码放在你的 Web 服务器的根目录不是个好主意，因为它可能会产生让人们在网上看到你的代码的风险。 这样不安全。

将你的代码放置在Web服务器根目录以外的地方，例如`/home/mysite`

创建

```sh
$ django-admin startproject mysite
```
or
使用 `PyCharm` 创建 `mysite` 项目

目录如下

```
mysite/
    manage.py # 一个命令行工具，可以使你用多种方式对Django项目进行交互。 
              # 你可以在django-admin和manage.py中读到关于manage.py的所有细节
    mysite/ # 内层的mysite/目录是你的项目的真正的Python包。         
            # 它是你导入任何东西时将需要使用的Python包的名字（例如 mysite.urls）
        __init__.py
        settings.py # 该Django 项目的设置/配置
        urls.py # 该Django项目的URL声明；你的Django站点的“目录”，URL 转发器
        wsgi.py # 用于你的项目的与WSGI兼容的Web服务器入口。
        
```

`mysite`可以重命名成任意名字

### 数据库

默认情况下，该配置使用 SQLite。

DB API Drivers

* MySQL ：

    * [mysqlclient](https://pypi.python.org/pypi/mysqlclient) Django 推荐
    * [MySQL Connector/Python](https://github.com/ibelongedtoyou/Notes/blob/master/MySQL/Mysql%20Python%E9%A9%B1%E5%8A%A8.md) by Oracle

* [其他数据库相关](https://docs.djangoproject.com/en/1.11/ref/databases/)


编辑`mysite/settings.py`。它是一个用模块级别变量表示 Django 配置的普通 Python 模块。

Mysql配置

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'mysite',                      # Or path to database file if using sqlite3.
        # The following settings are not used with sqlite3:
        'USER': 'root',
        'PASSWORD': 'root',
        'HOST': '127.0.0.1',                      # Empty for localhost through domain sockets or '127.0.0.1' for localhost through TCP.
        'PORT': '3306',                      # Set to empty string for default.
    }
}
```

### 数据库初始化
现在 mysite 的数据库还是空的，需要使用 

```sh
# 在 migrations 文件夹下生成 migrations 文件
$ python manage.py makemigrations # make new migrations, and then re-run 'manage.py migrate' to apply them.

# 根据 mysite/settings.py 文件 和 migrations 文件作用于数据库
$ python manage.py migrate
# migrate查看INSTALLED_APPS设置并根据mysite/settings.py文件中的数据库设置创建任何必要的数据库表，数据库的迁移还会跟踪应用的变化
```

根据 `setting.py`的`INSTALLED_APPS` 进行初始化数据库中的表结构

### 运行服务器

```sh
$ python manage.py runserver
# 默认端口：8000
# python manage.py runserver 8080
# python manage.py runserver 0.0.0.0:8000
```

浏览器访问相应地址，出现 `Welcome to Django` 的页面那么就成功。

### 其他配置

```
TIME_ZONE # 默认：'UTC'
```

## 创建一个程序
我们将在你的manage.py文件同级目录创建我们的投票应用，以便可以将它作为顶层模块导入，而不是mysite的子模块

```sh
$ python manage.py startapp polls
```

这将创建一个目录polls，它的结构如下：

```
polls/
    __init__.py
    admin.py
    migrations/
        __init__.py
    models.py
    tests.py
    views.py
```

### 使用模型

编辑`polls/models.py`文件：

```python
from django.db import models

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

class Choice(models.Model):
    question = models.ForeignKey(Question)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
```

告诉Django 使用这些模型，再次编辑`mysite/settings.py`文件，并修改`INSTALLED_APPS`设置以包含字符串`polls`：

```
INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'polls',
)
```

### makemigrations

```
$ python manage.py makemigrations polls
```

你应该看到类似下面的内容：

```
Migrations for 'polls':
  0001_initial.py:
    - Create model Question
    - Create model Choice
    - Add field question to choice
```

通过运行`makemigrations`告诉Django，已经对模型做了一些更改（在这个例子中，你创建了一个新的模型）并且会将这些更改记录为迁移文件。

迁移是 Django 如何储存模型的变化（以及您的数据库模式），它们只是磁盘上的文件。如果愿意，你可以阅读这些为新模型建立的迁移文件；这个迁移文件就是 `polls/migrations/0001_initial.py`。可以手工稍微修改一下Django的某些具体行为。


### sqlmigrate

```
$ python manage.py sqlmigrate polls 0001
```

你应该会看到类似如下的内容（为了便于阅读我们对它重新编排了格式）：

```python
BEGIN;
CREATE TABLE "polls_choice" (
    "id" serial NOT NULL PRIMARY KEY,
    "choice_text" varchar(200) NOT NULL,
    "votes" integer NOT NULL
);
CREATE TABLE "polls_question" (
    "id" serial NOT NULL PRIMARY KEY,
    "question_text" varchar(200) NOT NULL,
    "pub_date" timestamp with time zone NOT NULL
);
ALTER TABLE "polls_choice" ADD COLUMN "question_id" integer NOT NULL;
ALTER TABLE "polls_choice" ALTER COLUMN "question_id" DROP DEFAULT;
CREATE INDEX "polls_choice_7aa0f6ee" ON "polls_choice" ("question_id");
ALTER TABLE "polls_choice"
  ADD CONSTRAINT "polls_choice_question_id_246c99a640fbbd72_fk_polls_question_id"
    FOREIGN KEY ("question_id")
    REFERENCES "polls_question" ("id")
    DEFERRABLE INITIALLY DEFERRED;

COMMIT;
```

### migrate

`migrate`命令会找出所有还没有被应用的迁移文件（`Django`使用数据库中一个叫做`django_migrations`的特殊表来追踪哪些迁移文件已经被应用过），并且在你的数据库上运行它们 —— 本质上来讲，就是使你的数据库模式和你改动后的模型进行同步。

迁移功能非常强大，可以让你在开发过程中不断修改你的模型而不用删除数据库或者表然后再重新生成一个新的 —— 它专注于升级你的数据库且不丢失数据。 我们将在本教程的后续章节对迁移进行深入地讲解，但是现在，请记住实现模型变更的三个步骤：

* 修改你的模型（在models.py文件中）。
* 运行`python manage.py makemigrations` ，为这些修改创建迁移文件
* 运行`python manage.py migrate` ，将这些改变更新到数据库中。
* 运行`python manage.py showmigrations` ，展示项目中所有的迁移。

## admin

创建第一个用户

```
python manage.py createsuperuser

```

## 启动服务器 

```
python manage.py runserver
```


## 参考

* [django-Github](https://github.com/django/django)
* [django-Docs](https://docs.djangoproject.com/en/stable/)
* [django中文文档](http://usyiyi.cn/translate/django_182/index.html)
* [django中文教程](https://code.ziqiangxuetang.com/django/django-tutorial.html)