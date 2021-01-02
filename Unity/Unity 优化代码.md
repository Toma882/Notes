# Unity
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


## 参考
* [[Unity优化]gc03：代码优化](https://www.cnblogs.com/lyh916/p/10835884.html)