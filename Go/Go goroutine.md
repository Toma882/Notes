#goroutine

`go function`

`goroutine`是一种函数的并发执行方式，而`channel`是用来在`goroutine`之间进行参数传递。`main`函数本身也运行在一个`goroutine`中，而`go function`则表示创建一个新的`goroutine`，并在这个新的`goroutine`中执行这个函数。

## 初识 goroutine


```go
// Fetchall fetches URLs in parallel and reports their times and sizes.
package main

import (
    "fmt"
    "io"
    "io/ioutil"
    "net/http"
    "os"
    "time"
)

func main() {
    start := time.Now()
    ch := make(chan string)
    for _, url := range os.Args[1:] {
        go fetch(url, ch) // start a goroutine
    }
    for range os.Args[1:] {
        fmt.Println(<-ch) // receive from channel ch
    }
    fmt.Printf("%.2fs elapsed\n", time.Since(start).Seconds())
}

func fetch(url string, ch chan<- string) {
    start := time.Now()
    resp, err := http.Get(url)
    if err != nil {
        ch <- fmt.Sprint(err) // send to channel ch
        return
    }
    nbytes, err := io.Copy(ioutil.Discard, resp.Body)
    resp.Body.Close() // don't leak resources
    if err != nil {
        ch <- fmt.Sprintf("while reading %s: %v", url, err)
        return
    }
    secs := time.Since(start).Seconds()
    ch <- fmt.Sprintf("%.2fs  %7d  %s", secs, nbytes, url)
}
```

## 理解

来源：[知乎](https://www.zhihu.com/question/20862617/answer/36191625)

要理解这个事儿首先得了解操作系统是怎么玩线程的。一个线程就是一个栈加一堆资源。操作系统一会让cpu跑线程`A`，一会让cpu跑线程`B`，靠`A`和`B`的栈来保存`A`和`B`的执行状态。每个线程都有他自己的栈。
但是线程又老贵了，花不起那个钱，所以go发明了`goroutine`。大致就是说给每个`goroutine`弄一个分配在`heap`里面的栈来模拟线程栈。比方说有3个`goroutine`，`A,B,C`，就在`heap`上弄三个栈出来。然后Go让一个单线程的`scheduler`开始跑他们仨。相当于 `{ A(); B(); C() }`，连续的，串行的跑。

和操作系统不太一样的是，操作系统可以随时随地把你线程停掉，切换到另一个线程。这个单线程的`scheduler`没那个能力啊，他就是`user space`的一段朴素的代码，他跑着`A`的时候控制权是在A的代码里面的。`A`自己不退出谁也没办法。
所以`A`跑一小段后需要主动说，老大（`scheduler`），我不想跑了，帮我把我的所有的状态保存在我自己的栈上面，让我歇一会吧。这时候你可以看做A返回了。`A`返回了`B`就可以跑了，然后`B`跑一小段说，跑够了，保存状态，返回，然后`C`再跑。`C`跑一段也返回了。
这样跑完`{A(); B(); C()}`之后，我们发现，好像他们都只跑了一小段啊。所以外面要包一个循环，大致是： 

```go
goroutine_list = [A, B, C]
while(goroutine):
  for goroutine in goroutine_list:
    r = goroutine()
    if r.finished():
      goroutine_list.remove(r)
```

比如跑完一圈`A，B，C`之后谁也没执行完，那么就在回到`A`执行一次。由于我们把A的栈保存在了`HEAP`里，这时候可以把A的栈复制粘贴会系统栈里（我很确定真实情况不是这么玩的，会意就行），然后再调用`A`，这时候由于A是跑到一半自己说跳出来的，所以会从刚刚跳出来的地方继续执行。比如`A`的内部大致上是这样

```go
def A:
  上次跑到的地方 = 找到上次跑哪儿了
  读取所有临时变量
  goto 上次跑到的地方
  a = 1
  print("do something")
  go.scheduler.保存程序指针 // 设置"这次跑哪儿了"
  go.scheduler.保存临时变量们
  go.scheduler.跑够了_换人 //相当于return
  print("do something again")
  print(a)
```

第一次跑`A`，由于这是第一次，会打印`do something`，然后保存临时变量`a`，并保存跑到的地方，然后返回。再跑一次`A`，他会找到上次返回的地方的下一句，然后恢复临时变量`a`，然后接着跑，会打印`“do something again"`和`1`

所以你看出来了，这个关键就在于每个`goroutine`跑一跑就要让一让。一般支持这种玩意（叫做`coroutine`）的语言都是让每个`coroutine`自己说，我跑够了，换人。`goroutine`比较文艺的地方就在于，他可以来帮你判断啥时候“跑够了”。

其中有一大半就是靠的你说的“异步并发”。go把每一个能异步并发的操作，像你说的文件访问啦，网络访问啦之类的都包包好，包成一个看似朴素的而且是同步的“方法”，比如`string readFile`（我瞎举得例子）。但是神奇的地方在于，这个方法里其实会调用“异步并发”的操作，比如某操作系统提供的`asyncReadFile`。你也知道，这种异步方法都是很快返回的。
所以你自己在某个`goroutine`里写了

```go
string s = go.file.readFile("/root")
```

其实go偷偷在里面执行了某操作系统的API `asyncReadFIle`。跑起来之后呢，这个方法就会说，我当前所在的`goroutine`跑够啦，把刚刚跑的那个异步操作的结果保存下下，换人：

```go
// 实际上
handler h = someOS.asyncReadFile("/root") //很快返回一个handler
while (!h.finishedAsyncReadFile()): //很快返回Y/N
  go.scheduler.保存现状()
  go.scheduler.跑够了_换人() // 相当于return，不过下次会从这里的下一句开始执行
string s = h.getResultFromAsyncRead()
```

然后`scheduler`就换下一个`goroutine`跑了。等下次再跑回刚才那个`goroutine`的时候，他就看看，说那个`asyncReadFile`到底执行完没有啊，如果没有，就再换个人吧。如果执行完了，那就把结果拿出来，该干嘛干嘛。所以你看似写了个同步的操作，已经被`go`替换成异步操作了。

还有另外一种情况是，某个`goroutine`执行了某个不能异步调用的会`blocking`的系统调用，这个时候`goroutine`就没法玩那种异步调用的把戏了。他会把你挪到一个真正的线程里让你在那个县城里等着，他接茬去跑别的`goroutine`。比如`A`这么定义

```go
def A:
  print("do something")
  go.os.InvokeSomeReallyHeavyAndBlockingSystemCall()
  print("do something 2")
go会帮你转成
def 真实的A:
  print("do something")
  Thread t = new Thread( () => {
    SomeReallyHeavyAndBlockingSystemCall();
  })
  t.start()
  while !t.finished():
    go.scheduler.保存现状
    go.scheduler.跑够了_换人
  print("finished")
```

所以真实的`A`还是不会`blocking`，还是可以跟别的小伙伴(`goroutine`)愉快地玩耍（轮流往复的被执行），但他其实已经占了一个真是的系统线程了。

当然会有一种情况就是A完全没有调用任何可能的“异步并发”的操作，也没有调用任何的同步的系统调用，而是一个劲的用`CPU`做运算（比如用个死循环调用`a++`）。在早期的`go`里，这个`A`就把整个程序`block`住了。后面新版本的`go`好像会有一些处理办法，比如如果你A里面`call`了任意一个别的函数的话，就有一定几率被踢下去换人。好像也可以自己主动说我要换人的，可以去查查新的`go`的`spec`
另外，请不要在意语言细节，技术细节。会意即可




