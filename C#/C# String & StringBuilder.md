# C# String & StringBuilder

## 什么时候用String？什么时候用StringBuilder?

字符串一旦创建就不可修改大小，每次使用 `System.String` 类中的方法之一时，都要在内存中创建一个新的字符串对象，这就需要为该新对象分配新的空间。在需要对字符串执行重复修改的情况下，与创建新的String对象相关的系统开销可能会非常昂贵。如果要修改字符串而不创建新的对象，则可以使用 `System.Text.StringBuilder` 类。例如当在一个循环中将许多字符串连接在一起时，使用 `StringBuilder` 类可以提升性能。

**所以对字符串添加或删除操作不频繁的话，就几个固定的string累加的时候就不需要 `StringBuilder` 了,毕竟 `StringBuilder` 的初始化也是需要时间的。对字符串添加或删除操作比较频繁的话那就用 `StringBuilder` 。**

```c#
String a1 = "abc";　　//分配固定的内存大小
a1+="def";　　//创建新的内存分配a1，代价比较昂贵

StringBuilder sb = new StringBuilder(20);　　//指定分配大小
sb.Append('abc');　　//分配到堆区
sb.Append('def');　　//不会被销毁，而是直接追加到后面。
```

## String 与 StringBuilder的区别

`String` 声明之后在内存中大小是不可修改的，而 `StringBuilder` 可以自由扩展大小(**String 分配在栈区Stack，StringBuilder 分配在堆区Heap**)

```c#
StringBuilder sb = new StringBuilder(5); //当指定分配大小之后，性能就会得到提升。在达到容量之前，它不会为其自己重新分配空间。如果超过指定大小系统会当前大小倍增，也就10,15,20。建议指定大小
sb.Append('china');
sb.Capacity = 25; //另外，可以使用读/写Capacity属性来设置对象的最大长度。

//EnsureCapacity方法可用来检查当前StringBuilder的容量。如果容量大于传递的值，则不进行任何更改；但是，如果容量小于传递的值，则会更改当前的容量以使其与传递的值匹配。   
//也可以查看或设置Length属性。如果将Length属性设置为大于Capacity属性的值，则自动将Capacity属性更改为与Length属性相同的值。如果将Length属性设置为小于当前StringBuilder对象内的字符串长度的值，则会缩短该字符串。   

//5个修改StringBuilder的内容的方法
StringBuilder.Append         //将信息追加到当前StringBuilder的结尾。     
StringBuilder.AppendFormat   //用带格式文本替换字符串中传递的格式说明符。     
StringBuilder.Insert         //将字符串或对象插入到当前StringBuilder对象的指定索引处。     
StringBuilder.Remove         //从当前StringBuilder对象中移除指定数量的字符。     
StringBuilder.Replace        //替换指定索引处的指定字符。

//Append   
//Append方法可用来将文本或对象的字符串表示形式添加到由当前StringBuilder对象表示的字符串的结尾处。
//以下示例将一个StringBuilder对象初始化为“Hello   World”，然后将一些文本追加到该对象的结尾处。将根据需要自动分配空间。 
StringBuilder sb = new StringBuilder("Hello World!");  
sb.Append(" What a beautiful day.");  
Console.WriteLine(sb); //结果：Hello World! What a beautiful day. 

//AppendFormat   
//AppendFormat方法将文本添加到StringBuilder的结尾处，而且实现了IFormattable接口，因此可接受格式化部分中描述的标准格式字符串。可以使用此方法来自定义变量的格式并将这些值追加到StringBuilder的后面。
//以下示例使用AppendFormat方法将一个设置为货币值格式的整数值放置到StringBuilder的结尾。  
int MyInt = 25;    
StringBuilder sb = new StringBuilder("Your total is ");  
sb.AppendFormat("{0:C}   ",   MyInt);  
Console.WriteLine(sb); //结果：Your total is $25.00   

//Insert   
//Insert方法将字符串或对象添加到当前StringBuilder中的指定位置。
//以下示例使用此方法将一个单词插入到StringBuilder的第六个位置。
StringBuilder sb = new StringBuilder("Hello World!");  
sb.Insert(6,"Beautiful ");  
Console.WriteLine(sb); //结果：Hello Beautiful World!  

//Remove   
//Remove方法从当前StringBuilder中移除指定数量的字符，移除过程从指定的从零开始的索引处开始。
//以下示例使用Remove方法缩短StringBuilder。   
StringBuilder sb = new StringBuilder("Hello World!");  
sb.Remove(5,7);  
Console.WriteLine(sb); //结果：Hello

//Replace   
//使用Replace方法，可以用另一个指定的字符来替换StringBuilder对象内的字符。
//以下示例使用Replace方法来搜索StringBuilder对象，查找所有的感叹号字符(!)，并用问号字符(?)来替换它们。
StringBuilder sb = new StringBuilder("Hello World!");  
sb.Replace('!',   '?');  
Console.WriteLine(sb); //结果：Hello World?
```

## 参考
* [[Unity优化]gc01：字符串常量池](https://www.cnblogs.com/lyh916/p/10848138.html)
* [[Unity优化]gc02：StringBuilder](https://www.cnblogs.com/lyh916/p/10850742.html)