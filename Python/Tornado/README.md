# Python Tornado


> Tornado is a Python web framework and asynchronous networking library, originally developed at FriendFeed. By using non-blocking network I/O, Tornado can scale to tens of thousands of open connections, making it ideal for long polling, WebSockets, and other applications that require a long-lived connection to each user.

## Install

```
pip3 install tornado
```

## Example

```
import tornado.ioloop
import tornado.web
 
class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world")
 
def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])
 
if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
```

## 参考

* [GitHub](https://github.com/tornadoweb/tornado)
* [Docs](http://www.tornadoweb.org)

