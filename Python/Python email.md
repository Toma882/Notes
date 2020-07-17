## Python

`SMTP` 是发送邮件的协议，`Python` 内置对``SMTP` 的支持，可以发送纯文本邮件、HTML邮件以及带附件的邮件。
`Python` 对 `SMTP` 支持有 `smtplib` 和 `email` 两个模块，`email` 负责构造邮件，`smtplib` 负责发送邮件。

首先，我们来构造一个最简单的纯文本邮件：

```python
from email.mime.text import MIMEText
msg = MIMEText('hello, send by Python...', 'plain', 'utf-8')
```

注意到构造 `MIMEText` 对象时，第一个参数就是邮件正文，第二个参数是 `MIME` 的 `subtype`，传入 `plain`，最终的 `MIME` 就是 `text/plain` ，最后一定要用 `utf-8` 编码保证多语言兼容性。


## 例子
使用qq服务器发送邮件

```python
#!/usr/bin/python2.7
# -*- coding: UTF-8 -*-
# sendmail.py
#
########################################################################
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.encoders import encode_base64
from email.utils import parseaddr, formataddr
from email.header import Header
import traceback
import string

def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr((Header(name, 'utf-8').encode(), addr.encode('utf-8') if isinstance(addr, unicode) else addr))

def _format_utf8(s):
    return Header(s, 'utf-8').encode()

class SmtpSendMail:
    

    def __init__(self, config):
        try:
            # 设置发件服务器地址, 如: "smtp.qq.com"
            self.host = config["host"]
            # 设置发件服务器端口号. 有SSL(465)和非SSL(25)两种形式
            self.port = config["port"]
            # 设置发件邮箱, 一定要自己注册的邮箱, 如: "xxx@qq.com"
            self.sender = config["sender"]
            # 设置发件邮箱的密码, 登陆会用到
            self.password = config["password"]
            # 设置超时秒
            self.timeout = config["timeout"]

            # SSL
            if not config.get("SSL"):
                self.SSL = False
            else:
                self.SSL = True

            # session
            if self.SSL:
                session = smtplib.SMTP_SSL(self.host, self.port, self.timeout)
            else:
                session = smtplib.SMTP(self.host, self.port, self.timeout)

            # 登陆邮箱
            session.login(self.sender, self.password)
            self.session = session
        except Exception, e:
            traceback.print_exc()
        pass

    def sendMail(self, mailto):
        result = False
        try:
            # 设置正文为符合邮件格式的HTML内容
            msg = MIMEText(mailto["body"], 'html', 'utf-8')
            # 设置发送人
            msg['from'] = _format_addr(u'XXX监控 <%s>' % self.sender)
            # 设置邮件接收人
            msg['to'] = mailto["receiver"]
            # 设置邮件标题
            msg['subject'] = _format_utf8(mailto["title"])
            # 发送邮件
            self.session.sendmail(self.sender, string.splitfields(mailto["receiver"], ","), msg.as_string())
            result = True
        except Exception, e:
            traceback.print_exc()
        finally:
            return result
        pass

    def sendMailAttach(self, mailto, attachFile):
        result = False
        try:
            # 邮件对象:
            msg = MIMEMultipart()
            msg['From'] = _format_addr(u'XXX监控 <%s>' % self.sender)
            msg['To'] = mailto["receiver"]
            msg['Subject'] = _format_utf8(mailto["title"])

            # 邮件正文是MIMEText:
            msg.attach(MIMEText(mailto["body"], 'html', 'utf-8'))

            # 添加附件就是加上一个MIMEBase，从本地读取一个图片:
            # with open('/Users/Alvin/Desktop/QQ20161104-0.png', 'rb') as f:
            #     # 设置附件的MIME和文件名，这里是png类型:
            #     mime = MIMEBase('image', 'png', filename='test.png')
            #     # 加上必要的头信息:
            #     mime.add_header('Content-Disposition', 'attachment', filename='test.png')
            #     mime.add_header('Content-ID', '<0>')
            #     mime.add_header('X-Attachment-Id', '0')
            #     # 把附件的内容读进来:
            #     mime.set_payload(f.read())
            #     # 用Base64编码:
            #     encode_base64(mime)
            #     # 添加到MIMEMultipart:
            #     msg.attach(mime)

            # 添加附件就是加上一个MIMEBase:
            with open(attachFile, 'rb') as f:
                # 设置附件的MIME和文件名，这里是png类型:
                mime = MIMEBase('Content-Type: application/zip', 'tar.gz', filename='dumps.tar.gz')
                # 加上必要的头信息:
                mime.add_header('Content-Disposition', 'attachment', filename='dumps.tar.gz')
                mime.add_header('Content-ID', '<0>')
                mime.add_header('X-Attachment-Id', '0')
                # 把附件的内容读进来:
                mime.set_payload(f.read())
                # 用Base64编码:
                encode_base64(mime)
                # 添加到MIMEMultipart:
                msg.attach(mime)

            # 发送邮件
            self.session.sendmail(self.sender, string.splitfields(mailto["receiver"], ","), msg.as_string())
            result = True
        except Exception, e:
            traceback.print_exc()
        finally:
            return result
        pass




# test
mailfrom = {
    "host": "smtp.exmail.qq.com",
    "port": 465,
    "sender": "hello@world.com",
    "password": "abc",
    "timeout": 30,
    "SSL": True
}

mailto = {
    "receiver": "hello@qq.com, world@qq.com",
    "title": "XXX 服务器报错 ",
    "body": "<h1>Hi</h1><p>Dumps</p>"
}

import sys, subprocess

def sh(shCmd):
    subprocess.call(shCmd, shell=True)

mailto["title"] = mailto["title"]+sys.argv[1]
smtp = SmtpSendMail(mailfrom)
sys_argv_length = len(sys.argv[1:])
if sys_argv_length == 1:
    print smtp.sendMail(mailto)
elif sys_argv_length == 2:
    print smtp.sendMailAttach(mailto, sys.argv[2])
```

## 继承关系
构造一个邮件对象就是一个Messag对象，如果构造一个MIMEText对象，就表示一个文本邮件对象，如果构造一个MIMEImage对象，就表示一个作为附件的图片，要把多个对象组合起来，就用MIMEMultipart对象，而MIMEBase可以表示任何对象。它们的继承关系如下：

```
Message
+- MIMEBase
   +- MIMEMultipart
   +- MIMENonMultipart
      +- MIMEMessage
      +- MIMEText
      +- MIMEImage
```

## 参考

* [email.mime](https://docs.python.org/2/library/email.mime.html)
* [smtp发送邮件](http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000/001386832745198026a685614e7462fb57dbf733cc9f3ad000)