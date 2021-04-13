## 术语

### Android 内存指标
#### RSS(Resident Set Size)
当前 APP 所应用到的所有内存。除了自己的 APP 所使用的内存之外，你调用的各种服务、共用库所产生的内存都会统计到RSS之中。

#### PSS(Proportional Set Size)
与 RSS 不同的是，PSS 会把公共库所使用的内存 **平摊** 到所有调用这个库的 APP 上。可能你自己的应用没有申请很多内存，但是你的调用的某个公共库已经有了很大的内存分配，平摊下来就会导致你自己的 APP 的 PSS 虚高。

#### USS(Unique Set Size)
只有此 APP 所使用的内存，剔除掉公共库的内存分配。

### Unity 内存

#### Native Memory
#### Managed Memory

* 用 Destory 而不是 NULL 。
* 多使用 Struct。
* 使用内存池（UI、粒子系统等）
* 闭包和匿名函数：减少使用。所有的闭包和匿名函数最后都会成一个 Class。
* 协程：只要不被释放，里面所有引用的所有内存都会存在。* 用的时候生产一个，不用的时候扔掉）。
* 配置表：减少一次性使用的配置表数量；
* 单例：慎用，会长期占用内存。

Unity官方的视频：浅谈Unity内存管理（https://www.bilibili.com/video/BV1aJ411t7N6）

## Unity
1. GameObject.name和GameObject.tag会产生gc，替代方案为GameObject.CompareTag
2. Input.touches会产生gc，替代方案为Input.touchCount配合Input.GetTouch
3. Physics.SphereCastAll会产生gc，替代方案为Physics.SphereCastNonAlloc  
    从2和3可以看出，如果方法返回的是一个数组，那么说明执行这个方法时会分配内存产生一个新的数组，从而产生gc
4. 装箱操作(值类型转化为引用类型)会产生gc，典型的例子为Debug.Log，其方法签名是public static void Log(object message);
5. StartCoroutine会产生gc
6. yield return 0会产生gc(因为装箱操作)，替代方案为yield return null
7. yield return new WaitForSeconds(0.1f)会产生gc(因为new一个对象)，替代方案为：
    ```
    WaitForSeconds waitForSeconds = new WaitForSeconds(0.1f);
    IEnumerator A()
    {
        while (true)
        {
            yield return waitForSeconds;
        }
    }
    ```
8. foreach几乎不会产生gc(unity5.5版本修复了，但第一次执行foreach仍会触发gc)

## Lua

## C#
Common Language Runtime

CLR 的核心功能包括内存管理，程序集加载，类型安全，异常处理和线程同步，而且还负责对代码实施严格的类型安全检查，保证代码的准确性，这些功能都可以提供给面向CLR的所有语言（C#，F#等）使用。


CLR 支持两种类型

* 值类型 Value Types
* 引用类型 Reference Types

引用类型总是处于已装箱操作。

其中注意的是 除了 Object， String 也是引用类型，因此 String 字符串不可变。

## C# Lua 交互




## 参考
* [[Unity优化]gc03：代码优化](https://www.cnblogs.com/lyh916/p/10835884.html)