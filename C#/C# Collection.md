# C# 集合 Collection
`using System`

### Array
 `Array` 具有固定的容量。 若要增加容量，必须创建 `Array` 具有所需容量的新对象，将旧对象中的元素复制 `Array` 到新对象，并删除旧对象 `Array` 。

## 关联性泛型集合类
`using System.Collection.Generic`
### `List<T>`


### `Dictionary<TKey,TValue>`
`Dictionary<TKey,TValue>` 的实现是一种典型的牺牲空间换取时间（双数组）。内部有两个数组，一个数组名为 buckets，另一个数组为 entries 。

时间复杂度:`O(1)`

适用场景：  
Dictionary 遍历输出的顺序，就是加入的顺序。**访问性能最快，不支持排序**

### `SortedDictionary<TKey,TValue>`
使用一种平衡搜索二叉树——红黑树，作为存储结构。因为基于二分查找，所以添加、查找、删除元素的时间复杂度是`O(log n)`。

适用场景：  
`SortedDictionary<TKey,TValue>` 在添加和删除元素时更快一些。**适用于如果想要快速查询的同时又能很好的支持排序的话，并且添加和删除元素也比较频繁的场景。**

### `SortedList<TKey,TValue>`
集合内部是使用数组实现的，添加和删除元素的时间复杂度是`O(n)`，查找元素利用了二分查找，所以查找元素的时间复杂度是`O(log n)`。

适用场景：  
`SortedList<TKey,TValue>` 优势在于使用的内存比 `SortedDictionary<TKey,TValue>` 少；但是`SortedDictionary<TKey,TValue>` 可对未排序的数据执行更快的插入和移除操作：它的时间复杂度为` O(log n)`，而 `SortedList<TKey,TValue>` 为 `O(n)`。所以 `SortedList<TKey,TValue>` **适用于既需要快速查找又需要顺序排列但是添加和删除元素较少的场景。**


## 非关联性泛型集合类
`using System.Collections`
### ArrayList 
 `ArrayList` 类对象相比 `Array` 被设计成为一个动态数组类型，其容量会随着需要而适当的扩充。

**不建议使用 `ArrayList` 类进行新的开发。 相反，我们建议使用泛型 `List<T>` 类。**

### Hashtable 
据键的哈希代码进行组织的键/值对的集合。

**不建议使用 Hashtable 类进行新的开发。 相反，我们建议使用泛型 Dictionary<TKey,TValue> 类。**

`Hashtable` 和 `Dictionary <K, V>` 类型
* 单线程程序中推荐使用 `Dictionary`, 有泛型优势, 且读取速度较快, 容量利用更充分.
* 多线程程序中推荐使用 `Hashtable`, 默认的 `Hashtable` 允许单线程写入, 多线程读取, 对 `Hashtable` 进一步调用` Synchronized()` 方法可以获得完全线程安全的类型. 而 `Dictionary` 非线程安全, 必须人为使用 `lock` 语句进行保护, 效率大减.
* `Dictionary` 有按插入顺序排列数据的特性 (注: 但当调用 `Remove()` 删除过节点后顺序被打乱), 因此在需要体现顺序的情境中使用 `Dictionary` 能获得一定方便.

### List
Array 是长度固定的，那么 List 不限制长度必定需要维护这个数组。实际上 List 维护了一定长度的数组（默认为4），当插入元素的个数超过4或初始长度时，会去重新创建一个新的数组,这个新数组的长度是初始长度的2倍，然后将原来的数组赋值到新的数组中。

适用场景：  
Array 扩容的场景涉及到对象的创建和赋值，是比较消耗性能的。所以如果能指定一个合适的初始长度，能避免频繁的对象创建和赋值。再者，因为内部的数据结构是数组，插入和删除操作需要移动元素位置，所以不适合频繁的进行插入和删除操作；但是可以通过数组下标查找元素。**适合读多写少的场景。**



### LinkedList
适用场景：  
内部实现使用的是链表结构，而且还是双向链表。**适合写多读少的场景。**

### HashSet

`HashSet` 是一个无序的能够保持唯一性的集合。我们可以将 `HashSet` 看作是简化的 `Dictionary<TKey,TValue>` ，只不过 `Dictionary<TKey,TValue>` 存储的键值对对象，而 `HashSet` 存储的是普通对象。其内部实现也和 `Dictionary<TKey,TValue>` 基本一致，也是散列函数加双数组实现的,区别是存储的 `Slot` 结构体不再有 `key` 。

适用场景：  
**元素唯一性的集合，不支持排序。**


### SortedSet
`SortedSet` 和 `HashSet` ,就像 `SortedDictionary<TKey,TValue>` 和 `Dictionary<TKey,TValue>``一样。SortedSet` 支持元素按顺序排列，内部实现也是红黑树，并且 `SortedSet` 对于红黑树的操作方法和 `SortedDictionary<TKey,TValue>` 完全相同。

适用场景：  
能保持元素唯一性并且支持排序。

### Stack
栈 LIFO 后进先出

### Queue
队列 FIFO 先进先出

泛型集合类是在`.NET2.0`的时候出来的, 来看看`1.0`时代的`.NET`程序员们都有哪些集合类可以用。
* `ArraryList` 后来被 `List<T>` 替代。
* `HashTable` 后来被 `Dictionary<TKey,TValue>` 替代。
* `Queue` 后来被 `Queue<T>` 替代。
* `SortedList` 后来被 `SortedList<T>` 替代。
* `Stack` 后来被 `Stack<T>` 替代。

## 线程安全的集合类
`System.Collections.Concurrent`

* ConcurrentQueue： 线程安全版本的Queue
* ConcurrentStack：线程安全版本的Stack
* ConcurrentBag：线程安全的对象集合
* ConcurrentDictionary：线程安全的Dictionary


## IEnumerable和IEnumerator

集合基于 `ICollection` 接口、 `IList` 接口、 `IDictionary` 接口或它们对应的泛型集合

类				| 基于 | 特点
---			| --- | ---
`ICollection`	| `IEnumerable` | 
`IList IDictionary`	| `ICollection` | 
`Array ArrayList List<T>`	| `IList` | 每个元素都只有一个值
`Queue ConcurrentQueue<T> Stack ConcurrentStack<T> LinkedList<T>`	| `ICollection` | 每个元素都只有一个值
` Hashtable  SortedList Dictionary<TKey,TValue> SortedList<TKey,TValue>`			| `IDictionary` | 每个元素都有一个键和一个值
`ConcurrentDictionary<TKey,TValue>`		| | 每个元素都有一个键和一个值
`KeyedCollection<TKey,TItem>`		| | 值中嵌键的值的列表


类				| 描述
---			| ---
`ArrayList`	| 动态数组，会自动调整其大小，通过索引来访问
`Hashtable`	| 只能使用 元素的键 访问
`SortedList`	| 使用 键 和 索引 来访问元素 提供， `Hashtable` 类和 `Dictionary<TKey,TValue>`泛型类的已排序版本
`KeyedCollection<TKey,TItem>`	| 使用 键 和 索引 来访问元素
`Stack`			| 后进先出 LIFO
`Queue`			| 先进先出 FIFO
`BitArray`		| 1 和 0 的二进制数组

`IEnumerator` 定义了我们遍历集合的基本方法，以便我们可以实现单向向前的访问集合中的每一个元素。


```c#
public interface IEnumerator
{
 
    bool MoveNext();
    object Current {  get; }
    void Reset();
}
```

而 `IEnumerable` 只有一个方法 `GetEnumerator` 即得到遍历器。

```c#
public interface IEnumerable
{
    IEnumerator GetEnumerator();
}
```

我们经常用的 `foreach` 即是一种语法糖，实际上还是调用 `Enumerator` 里面的 `Current` 和 `MoveNext` 实现的遍历功能。

```c#
List<string> list = new List<string>()
{
    "Jesse",
    "Chloe",
    "Lei",
    "Jim",
    "XiaoJun"
};
 
// Iterate the list by using foreach
foreach (var buddy in list)
{
    Console.WriteLine(buddy);
}
 
// Iterate the list by using enumerator
List<string>.Enumerator enumerator = list.GetEnumerator();
while (enumerator.MoveNext())
{
    Console.WriteLine(enumerator.Current);
}
```





## 参考

* [C#集体类型](https://www.cnblogs.com/jesse2013/p/collectionsincsharp.html)
* [C#集合](https://www.jianshu.com/p/6e701ee2f0b8)
* [C#集合类型大揭秘](https://juejin.cn/post/6844903620886921223)
* [.NET 常用的集合类型](https://docs.microsoft.com/zh-cn/dotnet/standard/collections/commonly-used-collection-types)
* [C# 集合类总结 ：（Array、 Arraylist、List、Hashtable、Dictionary、Stack、Queue）](https://www.cnblogs.com/DebugLZQ/archive/2011/08/09/2132457.html)