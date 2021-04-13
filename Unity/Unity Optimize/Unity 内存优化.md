## UWA测评的内存标准
项目较为合理的内存分配如下：

* 纹理资源： 50 MB
* 网格资源： 20 MB
* 动画片段： 15 MB
* 音频片段： 15 MB
* Mono堆内存： 40 MB
* 其他： 10 MB
  
需要指出的是，150MB 中并没有涵盖较为复杂的字体文件（比如微软雅黑）以及Text Asset，这些需要根据游戏需求而定。




## 总结
* 用 Destory 而不是 NULL 。
* 多使用 Struct。
* 使用内存池（UI、粒子系统等）
* 闭包和匿名函数：减少使用。所有的闭包和匿名函数最后都会成一个 Class。
* 协程：只要不被释放，里面所有引用的所有内存都会存在。* 用的时候生产一个，不用的时候扔掉）。
* 配置表：减少一次性使用的配置表数量；
* 单例：慎用，会长期占用内存。

## 术语
### Unity 内存

#### Native Memory
#### Managed Memory 托管堆内存


### Android 内存指标
#### RSS(Resident Set Size)
当前 APP 所应用到的所有内存。除了自己的 APP 所使用的内存之外，你调用的各种服务、共用库所产生的内存都会统计到RSS之中。

#### PSS(Proportional Set Size)
与 RSS 不同的是，PSS 会把公共库所使用的内存 **平摊** 到所有调用这个库的 APP 上。可能你自己的应用没有申请很多内存，但是你的调用的某个公共库已经有了很大的内存分配，平摊下来就会导致你自己的 APP 的 PSS 虚高。

#### USS(Unique Set Size)
只有此 APP 所使用的内存，剔除掉公共库的内存分配。

## 参考
* [Unity3D 游戏开发之内存优化](https://www.cnblogs.com/qiaogaojian/p/5968890.html)
* [Unity官方的视频：浅谈Unity内存管理](https://www.bilibili.com/video/BV1aJ411t7N6)