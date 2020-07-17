## 并发

传统的并发模型主要由两种实现的形式

* 同一个进程下,多个线程天然的共享内存, 由程序对读写做同步控制(有锁或无锁)
* 多个进程通过进程间通讯或者内存映射实现数据的同步

## Actors模型

Actors 模型更多的使用消息机制来实现并发, 目标是让开发者不再考虑线程这种东西, 每个 Actor 最多同时只能进行一样工作, Actor 内部可以有自己的变量和数据.

Actors 模型避免了由操作系统进行任务调度的问题, 在操作系统进程之上, 多个 Actor 可能运行在同一个进程(或线程)中,这就节省了大量的 Context 切换.

在 Actors 模型中,每个 Actor 都有一个专属的命名 `Mailbox`, 其他 Actor 可以随时选择一个 Actor 通过邮箱收发数据,对于 `Mailbox` 的维护,通常是使用发布订阅的机制实现的,比如我们可以定义发布者是自己,订阅者可以是某个 Socket 接口,另外的消息总线或者直接是目标 Actor.

理论上, 每个 Actor 有且只有一个 Mailbox, Mailbox 是概念上的而不是实体, 不过具体实现也能把信箱实体独立出来方便使用...

Actor 中,由于 send 这个动作是异步的,因此 Actor 的 receive 会按照信箱接受到消息的顺序来进行处理.

## CSP模型

>Communicating Sequential Process

CSP 模型提供一种多个进程公用的 `channel`, 这个 `channel` 中存放的是一个个 `task`.

目前正流行的 go语言中的 `goroutine` 就是参考的 `CSP` 模型,原始的 `CSP` 中 `channel` 里的任务都是立即执行的,而 go语言为其增加了一个缓存,即任务可以先暂存起来,等待执行进程准备好了再逐个按顺序执行.

默认情况下的 `channel` 是无缓存的, 对 `channel` 的 `send` 动作是同步阻塞的,直到另外一个持有该 `channel` 引用的执行块取出消息(`channel` 为空), 反之, `receive`动作亦然. 默认情况下的实际的 `receive` 操作只会在 `send` 之后才被发生.

CSP 并不 Focus 发送消息的 实体/Task, 而是 Focus 发送消息时消息所使用的载体,即 channel.

理论上, Channel 和 Process 之间没有从属关系. Process 可以订阅任意个 Channel, Process 没必要拥有标识符, 只有 Channel 需要, 因为只向 Channel 发消息. 不过具体实现也能把 Process 作为一个实体暴露出来...


## CSP和Actor的区别

* CSP 进程通常是同步的(即任务被推送进 `channel` 就立即执行,如果任务执行的线程正忙,则发送者就暂时无法推送新任务), Actor 进程通常是异步的(消息传递给 Actor 后并不一定马上执行).
* CSP 中的 `channel` 通常是匿名的, 即任务放进 `channel` 之后你并不需要知道是哪个 `channel` 在执行任务,执行块可以任意选择发送或者取出消息,而 Actor 有明确的 `send/receive` 的关系,可以明确的知道哪个 Actor 在执行任务.
* CSP 中,我们只能通过 `channel` 在任务间传递消息, 在Actor中我们可以直接从一个 Actor 往另一个 Actor 传输数据.
* CSP 中消息的交互是同步的, Actor 中支持异步的消息交互.

## 参考
[并发编程：Actors模型和CSP模型](http://www.tuicool.com/articles/AJRbYrV)