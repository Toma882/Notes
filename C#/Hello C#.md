# C# 

```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            HelloWorld();
            helloworld();
            Console.ReadKey();
        }

        static void HelloWorld()
        {
            /* 我的第一个 C# 程序*/
            Console.WriteLine("Hello World");
        }

        static void helloworld()
        {
            /* 小写字母*/
            Console.WriteLine("****");
        }
    }
}
```


注意事项

* C# 对大小写敏感，因此可以看到上面有 `helloworld` 和 `HelloWorld` ；建议用大写字母
* 文件名可以不同于类的名称
* 程序的执行从 `Main` 开始

## C# 基础类型

### C# 基本类型

**Object**

` object obj; obj = 20;`

Object 是所有类型的基类型

**Dynamic**

` dynamic d = 20; `

**String**

` String str = "www"; @"www"; string str = @"www"; string str="www"; `

`String` `string` 没啥区别

**C# 指针类型**

`type* identifier; `

`char* pt_char; `

`int* pt-int; `

### C# 数值类型
类型 	| 字节	| 范围 					| 描述
---		| ---	| ---					| ---
bool	| 	1	| True or False			|
byte	|	1	| 0-255					| 8 位无符号整数
char 	|	2	| U +0000 到 U +ffff		| 16 位 Unicode 字符
decimal	|	16	| 						| 128 位精确的十进制值，28-29 有效位数
double	|	8	| 64 位双精度浮点型		| 64 位双精度浮点型
float	|	4	| 32 位单精度浮点型		| 64 位双精度浮点型
int		|	4	| -2^31 到 2^31			| 32 位有符号整数类型
long	|	8	| -2^63 到 2^63			| 64 位有符号整数类型
sbyte	|	1	| -2^7 到 2^7			|  8 位有符号整数类型
short	|	2	| -2^15 到 2^15			| 16 位有符号整数类型
uint	|	4	| 0 到 2^32				| 32 位无符号整数类型
ulong	|	8	| 0 到 2^64				| 64 位无符号整数类型
ushort	|	2	| 0 到 2^16				| 16 位无符号整数类型


### C# 变量
```c#
int i = 1, j = 2, k = 3;
char c, ch;
float f, s;
double d;
```

接受来自用户的值

```c#
int num;
num = Convert.ToInt32(Console.ReadLine());
```

### C# 类型转化

隐式转化

`int num = 123;
long longNum = num;`

强制转化

`double d = 1.234;
int i = (int)d;//1`

都有相对应内置的类型转化方法

`ToBoolean();
ToByte();
ToChar();
ToDecimal();
ToDouble();
ToInt16();
ToInt32();
//...
`






### C# 可空类型

** Nullable **

C# 提供了一个特殊的数据类型，`nullable` 类型（可空类型），可空类型可以表示其基础值类型正常范围内的值，再加上一个 `null` 值。

例如，`Nullable< Int32 >`，读作"可空的 Int32"，可以被赋值为 `-2,147,483,648` 到 `2,147,483,647` 之间的任意值，也可以被赋值为 `null` 值。类似的，`Nullable< bool >` 变量可以被赋值为 `true` 或 `false` 或 `null`。


`??` 判断是否为空

```c#
using System;
namespace CalculatorApplication
{
   class NullablesAtShow
   {
      static void Main(string[] args)
      {
         int? num1 = null;
         int? num2 = 45;
         double? num3 = new double?();
         double? num4 = 3.14157;
         
         bool? boolval = new bool?();

         // 显示值
         
         Console.WriteLine("显示可空类型的值： {0}, {1}, {2}, {3}", 
                            num1, num2, num3, num4);
         Console.WriteLine("一个可空的布尔值： {0}", boolval);
         Console.ReadLine();
         //显示可空类型的值： , 45,  , 3.14157
         //一个可空的布尔值：

         double? num1 = null;
         double? num2 = 3.14157;
         double num3;
         num3 = num1 ?? 5.34;      
         Console.WriteLine("num3 的值： {0}", num3);
         num3 = num2 ?? 5.34; //num3 的值： 5.34
         Console.WriteLine("num3 的值： {0}", num3);
         Console.ReadLine(); //num3 的值： 3.14157
      }
   }
}
```


### C# 集合 Collection
类				| 描述
---				| ---
ArrayList		| 动态数组，会自动调整其大小，通过索引来访问
Hashtable		| 使用 键 来访问元素
SortedList		| 使用 键 和 索引 来访问元素
Stack			| 后进先出 LIFO
Queue			| 先进先出 FIFO
BitArray		| 1 和 0 的二进制数组

### Array

声明一个数组不会在内存中初始化数组。当初始化数组变量时，您可以赋值给数组。

数组是一个引用类型，所以您需要使用 new 关键字来创建数组的实例。

```c#
datatype[] arrayName;

double[] balance = new double[10];
int[] marks = {1, 2, 3, 4};
```

### enum

枚举是一组命名整型常量，C# 枚举是值数据类型。换句话说，枚举包含自己的值，且不能继承或传递继承。
枚举列表中的每个符号代表一个整数值，一个比它前面的符号大的整数值。默认情况下，第一个枚举符号的值是 0.例如：
`enum Days { Sun, Mon, tue, Wed, thu, Fri, Sat };`


## C# 定义方法


当定义一个方法时，从根本上说是在声明它的结构的元素。在 C# 中，定义方法的语法如下：

`
<Access Specifier> <Return Type> <Method Name>(Parameter List)
{
   Method Body
}
`

```c#
Public void TestFunction(int i);
```

下面是方法的各个元素：

* Access Specifier：访问修饰符，这个决定了变量或方法对于另一个类的可见性。
* Return type：返回类型，一个方法可以返回一个值。返回类型是方法返回的值的数据类型。如果方法不返回任何值，则返回类型为 void。
* Method name：方法名称，是一个唯一的标识符，且是大小写敏感的。它不能与类中声明的其他标识符相同。
* Parameter list：参数列表，使用圆括号括起来，该参数是用来传递和接收方法的数据。参数列表是指方法的参数类型、顺序和数量。参数是可选的，也就是说，一个方法可能不包含参数。
* Method body：方法主体，包含了完成任务所需的指令集。

### 参数传递关键字： `ref` `out`

```c#
using System;

namespace CalculatorApplication
{
    public string Topic  // Get Set
    {
         get
         {
            return topic;
         }
         set
         {
            topic = value;
         }
    }
    private string topic;

    class NumberManipulator
    {
         public void swap(int x, int y)
         {
            int temp;
            temp = x; /* 保存 x 的值 */
            x = y;    /* 把 y 赋值给 x */
            y = temp; /* 把 temp 赋值给 y */
         }

        public void swapRef(ref int x, ref int y)
        {
            int temp;
            temp = x; /* 保存 x 的值 */
            x = y;    /* 把 y 赋值给 x */
            y = temp; /* 把 temp 赋值给 y */
        }

        public void getValues(out int x, out int y )
         {
            Console.WriteLine("请输入第一个值： ");
            x = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("请输入第二个值： ");
            y = Convert.ToInt32(Console.ReadLine());
         }

        static void Main(string[] args)
        {
            NumberManipulator n = new NumberManipulator();
            /* 局部变量定义 */
            int a = 100;
            int b = 200;

            /* 调用函数来交换值 */
            n.swap(a, b); // a:100, b:200
            n.swapRef(ref a, ref b); // a:200, b:100

            int c , d;
            n.getValues(out c, out d);

            Console.ReadLine();
        }
    }
}
```

### C# 构造函数和析构函数

**构造函数**

类的一个特殊的成员函数，当创建类的新对象时执行。
构造函数的名称与类的名称完全相同，它没有任何返回类型。

**析构函数** 
在类的名称前加上一个波浪形（~）作为前缀，它不返回值，也不带任何参数。
析构函数用于在结束程序（比如关闭文件、释放内存等）之前释放资源。析构函数不能继承或重载。

### Struct

结构是值类型数据结构，它使得一个单一变量可以存储各种数据类型的相关数据。

```c#
struct Books
{
   public string title;
   public string author;
   public string subject;
   public int book_id;
};
```

**C# 结构的特点**

您已经用了一个简单的名为 Books 的结构。在 C# 中的结构与传统的 C 或 C++ 中的结构不同。C# 中的结构有一下特点：
* 结构可带有方法、字段、索引、属性、运算符方法和事件。
* 结构可定义构造函数，但不能定义析构函数。但是，您不能为结构定义默认的构造函数。默认的* * 构造函数是自动定义的，且不能被改变。
* 与类不同，结构不能继承其他的结构或类。
* 结构不能作为其他结构或类的基础结构。
* 结构可实现一个或多个接口。
* 结构成员不能指定为 abstract、virtual 或 protected。
* 当您使用 New 操作符创建一个结构对象时，会调用适当的构造函数来创建结构。与类不同，结* * 构可以不使用 New 操作符即可被实例化。
* 如果不使用 New 操作符，只有在所有的字段都被初始化之后，字段才被赋值，对象才被使用。

**类 vs 结构**

类和结构有以下几个基本的不同点：
* 类是引用类型，结构是值类型。
* 结构不支持继承。
* 结构不能声明默认的构造函数。
* 针对上述讨论，让我们重写前面的实例：

```c#
using System;
     
struct Books
{
   private string title;
   private string author;
   private string subject;
   private int book_id;
   public void getValues(string t, string a, string s, int id)
   {
      title = t;
      author = a;
      subject = s;
      book_id = id;
   }
   public void display()
   {
      Console.WriteLine("Title : {0}", title);
      Console.WriteLine("Author : {0}", author);
      Console.WriteLine("Subject : {0}", subject);
      Console.WriteLine("Book_id :{0}", book_id);
   }

};

public class testStructure
{
    public static void Main(string[] args)
    {

        Books Book1 = new Books(); /* 声明 Book1，类型为 Book */

        /* book 1 详述 */
        Book1.getValues("C Programming",
        "Nuha Ali", "C Programming Tutorial",6495407);

        /* 打印 Book1 信息 */
        Book1.display();

        Console.ReadKey();
    }
}
```


### C# Class 继承 Interface等
---

```c#
using System;
namespace InheritanceApplication
{
   class Shape 
   {
      public void setWidth(int w)
      {
         width = w;
      }
      public void setHeight(int h)
      {
         height = h;
      }
      protected int width;
      protected int height;
   }

   // 基类 PaintCost
   public interface PaintCost 
   {
      int getCost(int area);
   }
   // 派生类
   class Rectangle : Shape, PaintCost
   {
      public int getArea()
      {
         return (width * height);
      }
      public int getCost(int area)
      {
         return area * 70;
      }
   }
   class RectangleTester
   {
      static void Main(string[] args)
      {
         Rectangle Rect = new Rectangle();
         int area;
         Rect.setWidth(5);
         Rect.setHeight(7);
         area = Rect.getArea();
         // 打印对象的面积
         Console.WriteLine("总面积： {0}",  Rect.getArea());
         Console.WriteLine("油漆总成本： ${0}" , Rect.getCost(area));
         Console.ReadKey();
      }
   }
}
```

### C# 多态性

多态性意味着有多重形式。在面向对象编程范式中，多态性往往表现为"一个接口，多个功能"。

多态性可以是**静态**的或**动态**的。**在静态多态性中，函数的响应是在编译时发生的**。**在动态多态性中，函数的响应是在运行时发生的**。

**静态多态性**
在编译时，函数和对象的连接机制被称为早期绑定，也被称为静态绑定。C# 提供了两种技术来实现静态多态性。分别为：
* 函数重载
* 运算符重载

**函数重载**

```c#
using System;
namespace PolymorphismApplication
{
   class Printdata
   {
      void print(int i)
      {
         Console.WriteLine("Printing int: {0}", i );
      }

      void print(double f)
      {
         Console.WriteLine("Printing float: {0}" , f);
      }

      void print(string s)
      {
         Console.WriteLine("Printing string: {0}", s);
      }
      static void Main(string[] args)
      {
         Printdata p = new Printdata();
         // 调用 print 来打印整数
         p.print(5);
         // 调用 print 来打印浮点数
         p.print(500.263);
         // 调用 print 来打印字符串
         p.print("Hello C++");
         Console.ReadKey();
      }
   }
}
```

**动态多态性**
* 抽象类 abstract
* 虚方法 virtual

```c#
using System;
public abstract class A //抽象类A 
{
    private int num=0; //抽象类包变量 
    public virtual int getNum() //抽象类包含虚方法 
    { 
        return num; 
    }
    public void setNum(int n) // //抽象类包含普通方法 
    { 
        this.num = n; 
    }
    public abstract void E(); //类A中的抽象方法E 
}
public abstract class B : A //由于类B继承了类A中的抽象方法E,所以类B也变成了抽象类 
{ 
    
}
public class C : B 
{ 
    public override void E() //重写从类A继承的抽象方法。如果类B自己还定义了抽象方法，也必须重写 
    { 
        //throw new Exception("The method or operation is not implemented."); 
    } 
}
public class Test 
{ 
    static void Main() 
    { 
        C c = new C(); 
        c.E(); 
    } 
}
```

**抽象类（abstract）和接口（interface）的区别**

相同点：  
* 都可以被继承
* 都不能被实例化
* 派生类必须实现未实现的方法

不同点：  
* 接口可以被多重实现，抽象类只能单一被继承
* 抽象类是从一系列相关对象中抽象出来的概念，因此反映的是事物的**内部共性**，抽象类的成员可以具有访问级别，**可以有私有方法**，抽象的子类可以**选择性实现**其基类的抽象方法（抽象方法只能在与抽象类当中）；
* 接口是为了满足外部调用而定义的一个功能约定，因映的是事物的**外部特性**，成员**全部public级别**，而接口的子类必须实现


一般应用里，最顶级的是接口，然后是抽象类实现接口，最后才到具体类实现


**虚方法（virtual）和抽象方法（abstract）的区别**
```c#
//抽象方法
public abstract class Animal
{
    public abstract void Sleep();
}
//虚方法
public class Animal
{
    public virtual void Sleep(){}
}
```
抽象方法必须在抽象类中声明，抽象方法必须在派生类中重写，虚方法则不必


### C# 运算符重载
```c#
public static Class oprator+ ( Class c1, Class c2 )
{
}
public static bool oprator== ( Class c1, Class c2 )
{
	return true;
}
```

```c#
using System;

namespace OperatorOvlApplication
{
    class Box
    {
       private double length;      // 长度
       private double breadth;     // 宽度
       private double height;      // 高度
      
       public double getVolume()
       {
         return length * breadth * height;
       }
      public void setLength( double len )
      {
          length = len;
      }
      public void setBreadth( double bre )
      {
          breadth = bre;
      }
      public void setHeight( double hei )
      {
          height = hei;
      }

      // 重载 + 运算符来把两个 Box 对象相加
      public static Box operator+ (Box b, Box c)
      {
          Box box = new Box();
          box.length = b.length + c.length;
          box.breadth = b.breadth + c.breadth;
          box.height = b.height + c.height;
          return box;
      }
      public static bool operator == (Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length == rhs.length && lhs.height == rhs.height 
             && lhs.breadth == rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public static bool operator !=(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length != rhs.length || lhs.height != rhs.height 
              || lhs.breadth != rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public static bool operator <(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length < rhs.length && lhs.height 
              < rhs.height && lhs.breadth < rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public static bool operator >(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length > rhs.length && lhs.height 
              > rhs.height && lhs.breadth > rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public static bool operator <=(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length <= rhs.length && lhs.height 
              <= rhs.height && lhs.breadth <= rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public static bool operator >=(Box lhs, Box rhs)
      {
          bool status = false;
          if (lhs.length >= rhs.length && lhs.height 
             >= rhs.height && lhs.breadth >= rhs.breadth)
          {
              status = true;
          }
          return status;
      }
      public override string ToString()
      {
          return String.Format("({0}, {1}, {2})", length, breadth, height);
      }
   
   }
    
   class Tester
   {
      static void Main(string[] args)
      {
        Box Box1 = new Box();          // 声明 Box1，类型为 Box
        Box Box2 = new Box();          // 声明 Box2，类型为 Box
        Box Box3 = new Box();          // 声明 Box3，类型为 Box
        Box Box4 = new Box();
        double volume = 0.0;   // 体积

        // Box1 详述
        Box1.setLength(6.0);
        Box1.setBreadth(7.0);
        Box1.setHeight(5.0);

        // Box2 详述
        Box2.setLength(12.0);
        Box2.setBreadth(13.0);
        Box2.setHeight(10.0);

       // 使用重载的 ToString() 显示两个盒子
        Console.WriteLine("Box1： {0}", Box1.ToString());
        Console.WriteLine("Box2： {0}", Box2.ToString());
        
        // Box1 的体积
        volume = Box1.getVolume();
        Console.WriteLine("Box1 的体积： {0}", volume);

        // Box2 的体积
        volume = Box2.getVolume();
        Console.WriteLine("Box2 的体积： {0}", volume);

        // 把两个对象相加
        Box3 = Box1 + Box2;
        Console.WriteLine("Box3： {0}", Box3.ToString());
        // Box3 的体积
        volume = Box3.getVolume();
        Console.WriteLine("Box3 的体积： {0}", volume);

        //comparing the boxes
        if (Box1 > Box2)
          Console.WriteLine("Box1 大于 Box2");
        else
          Console.WriteLine("Box1 不大于 Box2");
        if (Box1 < Box2)
          Console.WriteLine("Box1 小于 Box2");
        else
          Console.WriteLine("Box1 不小于 Box2");
        if (Box1 >= Box2)
          Console.WriteLine("Box1 大于等于 Box2");
        else
          Console.WriteLine("Box1 不大于等于 Box2");
        if (Box1 <= Box2)
          Console.WriteLine("Box1 小于等于 Box2");
        else
          Console.WriteLine("Box1 不小于等于 Box2");
        if (Box1 != Box2)
          Console.WriteLine("Box1 不等于 Box2");
        else
          Console.WriteLine("Box1 等于 Box2");
        Box4 = Box3;
        if (Box3 == Box4)
          Console.WriteLine("Box3 等于 Box4");
        else
          Console.WriteLine("Box3 不等于 Box4");

        Console.ReadKey();
      }
    }
}
```

## C# 预处理器指令

预处理器指令指导编译器在实际编译开始之前对信息进行预处理。

所有的预处理器指令都是以 # 开始。且在一行上，只有空白字符可以出现在预处理器指令之前。预处理器指令不是语句，所以它们不以分号（;）结束。

预处理指令	| 描述
---			| ---
#define		| 它用于定义一系列成为符号的字符。
#undef		| 它用于取消定义符号。
#if			| 它用于测试符号是否为真。
#else		| 它用于创建复合条件指令，与 #if 一起使用。
#elif		| 它用于创建复合条件指令。
#endif		| 指定一个条件指令的结束。
#line		| 它可以让您修改编译器的行数以及（可选地）输出错误和警告的文件名。
#error		| 它允许从代码的指定位置生成一个错误。
#warning	| 它允许从代码的指定位置生成一级警告。
#region		| 它可以让您在使用 Visual Studio Code Editor 的大纲特性时，指定一个可展开或折叠的代码块。
#endregion	| 它标识着 #region 块的结束。

## C# 文件的输入与输出
**C# I/O 类**

I/O 类			| 描述
---				| ---
BinaryReader	| 从二进制流读取原始数据。
BinaryWriter	| 以二进制格式写入原始数据。
BufferedStream	| 字节流的临时存储。
Directory		| 有助于操作目录结构。
DirectoryInfo	| 用于对目录执行操作。
DriveInfo		| 提供驱动器的信息。
File			| 有助于处理文件。
FileInfo		| 用于对文件执行操作。
FileStream		| 用于文件中任何位置的读写。
MemoryStream	| 用于随机访问存储在内存中的数据流。
Path			| 对路径信息执行操作。
StreamReader	| 用于从字节流中读取字符。
StreamWriter	| 用于向一个流中写入字符。
StringReader	| 用于读取字符串缓冲区。
StringWriter	| 用于写入字符串缓冲区。


## C# 特性 Attribute

特性（Attribute）是用于**在运行时传递程序**中各种元素（比如类、方法、结构、枚举、组件等）的行为信息的**声明性标签**。您可以通过**使用特性向程序添加声明性信息**。

```c#
[attribute(positional_parameters, name_parameter = value, ...)]
element
```
特性包括：预定义特性和自定义特性

**预定义特性（Attribute）**

* `AttributeUsage`
* `Conditional`
* `Obsolete`

**`AttributeUsage`**

预定义特性 `AttributeUsage` 描述了如何使用一个自定义特性类。它规定了特性可应用到的项目的类型。
规定该特性的语法如下：

```
[AttributeUsage(AttributeTargets.Class |
AttributeTargets.Constructor |
AttributeTargets.Field |
AttributeTargets.Method |
AttributeTargets.Property, 
AllowMultiple = true, Inherited = true)]
```

* 参数 `validon` 规定特性可被放置的语言元素。它是枚举器 `AttributeTargets` 的值的组合。默认值是 `AttributeTargets.All`。
* 参数 `allowmultiple（可选的）为该特性的` `AllowMultiple` 属性（`property`）提供一个布尔值。如果为 `true`，则该特性是多用的。默认值是 `false`（单用的）。
* 参数 `inherited`（可选的）为该特性的 `Inherited` 属性（`property`）提供一个布尔值。如果为 `true`，则该特性可被派生类继承。默认值是 `false`（不被继承）

**`Conditional`**

这个预定义特性标记了一个条件方法，其执行依赖于它顶的预处理标识符。
它会引起方法调用的条件编译，取决于指定的值，比如 Debug 或 Trace。例如，当调试代码时显示变量的值。
规定该特性的语法如下：
```
[Conditional(conditionalSymbol)]
```

**`Obsolete`**

这个预定义特性标记了不应被使用的程序实体。它可以让您通知编译器丢弃某个特定的目标元素。例如，当一个新方法被用在一个类中，但是您仍然想要保持类中的旧方法，您可以通过显示一个应该使用新方法，而不是旧方法的消息，来把它标记为 `obsolete`（过时的）。
规定该特性的语法如下：
```
[Obsolete(
   message,
   iserror
)]
```
其中：
参数 `message`，是一个字符串，描述项目为什么过时的原因以及该替代使用什么。
参数 `iserror`，是一个布尔值。如果该值为 `true`，编译器应把该项目的使用当作一个错误。默认值是 `false`（编译器生成一个警告）。
下面的实例演示了该特性：

```c#
using System;
public class MyClass
{
   [Obsolete("Don't use OldMethod, use NewMethod instead", true)]
   static void OldMethod()
   { 
      Console.WriteLine("It is the old method");
   }
   static void NewMethod()
   { 
      Console.WriteLine("It is the new method"); 
   }
   public static void Main()
   {
      OldMethod();
   }
}
```

**自定义特性**
.Net 框架允许创建自定义特性，用于存储声明性的信息，且可在运行时被检索。该信息根据设计标准和应用程序需要，可与任何目标元素相关。

创建并使用自定义特性包含四个步骤：
- 声明自定义特性
- 构建自定义特性
- 在目标程序元素上应用自定义特性
- 通过反射访问特性

让我们构建一个名为 `DeBugInfo` 的自定义特性，该特性将存储调试程序获得的信息。它存储下面的信息：

bug 的代码编号
辨认该 bug 的开发人员名字
最后一次审查该代码的日期
一个存储了开发人员标记的字符串消息
我们的 `DeBugInfo` 类将带有三个用于存储前三个信息的私有属性（`property`）和一个用于存储消息的公有属性（`property`）。所以 bug 编号、开发人员名字和审查日期将是 `DeBugInfo` 类的必需的定位（ `positional`）参数，消息将是一个可选的命名（`named`）参数。

每个特性必须至少有一个构造函数。必需的定位（ `positional`）参数应通过构造函数传递。下面的代码演示了 `DeBugInfo` 类：

```c#
// 一个自定义特性 BugFix 被赋给类及其成员
[AttributeUsage(AttributeTargets.Class |
AttributeTargets.Constructor |
AttributeTargets.Field |
AttributeTargets.Method |
AttributeTargets.Property,
AllowMultiple = true)]

public class DeBugInfo : System.Attribute
{
  private int bugNo;
  private string developer;
  private string lastReview;
  public string message;

  public DeBugInfo(int bg, string dev, string d)
  {
      this.bugNo = bg;
      this.developer = dev;
      this.lastReview = d;
  }

  public int BugNo
  {
      get
      {
          return bugNo;
      }
  }
  public string Developer
  {
      get
      {
          return developer;
      }
  }
  public string LastReview
  {
      get
      {
          return lastReview;
      }
  }
  public string Message
  {
      get
      {
          return message;
      }
      set
      {
          message = value;
      }
  }
}

//...
[DeBugInfo(45, "Zara Ali", "12/8/2012", Message = "Return type mismatch")]
class Rectangle
{
}
```

### C# 反射 Reflection

反射 `Reflection` 对象用于在运行时获取类型信息。该类位于 `System.Reflection` 命名空间中，可访问一个正在运行的程序的元数据。

`System.Reflection` 命名空间包含了允许您获取有关应用程序信息及向应用程序动态添加类型、值和对象的类。
反射`Reflection`的用途：
- 它允许在运行时查看属性 `attribute` 信息。
- 它允许审查集合中的各种类型，以及实例化这些类型。
- 它允许延迟绑定的方法和属性 `property` 。
- 它允许在运行时创建新类型，然后使用这些类型执行一些任务。

```c#
using System;
using System.Reflection;
namespace BugFixApplication
{
   // 一个自定义属性 BugFix 被赋给类及其成员
   [AttributeUsage(AttributeTargets.Class |
   AttributeTargets.Constructor |
   AttributeTargets.Field |
   AttributeTargets.Method |
   AttributeTargets.Property,
   AllowMultiple = true)]

   public class DeBugInfo : System.Attribute
   {
      private int bugNo;
      private string developer;
      private string lastReview;
      public string message;

      public DeBugInfo(int bg, string dev, string d)
      {
         this.bugNo = bg;
         this.developer = dev;
         this.lastReview = d;
      }

      public int BugNo
      {
         get
         {
            return bugNo;
         }
      }
      public string Developer
      {
         get
         {
            return developer;
         }
      }
      public string LastReview
      {
         get
         {
            return lastReview;
         }
      }
      public string Message
      {
         get
         {
            return message;
         }
         set
         {
            message = value;
         }
      }
   }
   [DeBugInfo(45, "Zara Ali", "12/8/2012",
	Message = "Return type mismatch")]
   [DeBugInfo(49, "Nuha Ali", "10/10/2012",
	Message = "Unused variable")]
   class Rectangle
   {
      // 成员变量
      protected double length;
      protected double width;
      public Rectangle(double l, double w)
      {
         length = l;
         width = w;
      }
      [DeBugInfo(55, "Zara Ali", "19/10/2012",
	   Message = "Return type mismatch")]
      public double GetArea()
      {
         return length * width;
      }
      [DeBugInfo(56, "Zara Ali", "19/10/2012")]
      public void Display()
      {
         Console.WriteLine("Length: {0}", length);
         Console.WriteLine("Width: {0}", width);
         Console.WriteLine("Area: {0}", GetArea());
      }
   }//end class Rectangle  
   
   class ExecuteRectangle
   {
      static void Main(string[] args)
      {
         Rectangle r = new Rectangle(4.5, 7.5);
         r.Display();
         Type type = typeof(Rectangle);
         // 遍历 Rectangle 类的属性
         foreach (Object attributes in type.GetCustomAttributes(false))
         {
            DeBugInfo dbi = (DeBugInfo)attributes;
            if (null != dbi)
            {
               Console.WriteLine("Bug no: {0}", dbi.BugNo);
               Console.WriteLine("Developer: {0}", dbi.Developer);
               Console.WriteLine("Last Reviewed: {0}",
					dbi.LastReview);
               Console.WriteLine("Remarks: {0}", dbi.Message);
            }
         }
         
         // 遍历方法属性
         foreach (MethodInfo m in type.GetMethods())
         {
            foreach (Attribute a in m.GetCustomAttributes(true))
            {
               DeBugInfo dbi = (DeBugInfo)a;
               if (null != dbi)
               {
                  Console.WriteLine("Bug no: {0}, for Method: {1}",
						dbi.BugNo, m.Name);
                  Console.WriteLine("Developer: {0}", dbi.Developer);
                  Console.WriteLine("Last Reviewed: {0}",
						dbi.LastReview);
                  Console.WriteLine("Remarks: {0}", dbi.Message);
               }
            }
         }
         Console.ReadLine();
      }
   }
}
```

当上面的代码被编译和执行时，它会产生下列结果：

```c#
Length: 4.5
Width: 7.5
Area: 33.75
Bug No: 49
Developer: Nuha Ali
Last Reviewed: 10/10/2012
Remarks: Unused variable
Bug No: 45
Developer: Zara Ali
Last Reviewed: 12/8/2012
Remarks: Return type mismatch
Bug No: 55, for Method: GetArea
Developer: Zara Ali
Last Reviewed: 19/10/2012
Remarks: Return type mismatch
Bug No: 56, for Method: Display
Developer: Zara Ali
Last Reviewed: 19/10/2012
Remarks: 
```

### C# 属性 Property

```c#
// 声明类型为 string 的 Code 属性
public string Code
{
   get
   {
      return code;
   }
   set
   {
      code = value;
   }
}
```

#### C# 索引器 Indexer

```c#
element-type this[int index] 
{
   // get 访问器
   get 
   {
      // 返回 index 指定的值
   }

   // set 访问器
   set 
   {
      // 设置 index 指定的值 
   }
}
```

### C# 委托 Delegate

C# 中的委托 `Delegate` 类似于 C 或 C++ 中函数的指针。委托 `Delegate` 是存有**对某个方法**的引用的一种引用类型变量。引用可在运行时被改变。

委托 `Delegate` 特别用于实现事件和回调方法。所有的委托`Delegate`都派生自 `System.Delegate` 类。

**委托是可以把一个过程封装成变量进行传递并且执行的对象**

声明委托`Delegate`

```c#
delegate <return type> <delegate-name> <parameter list>;
```

```c#
public delegate int MyDelegate (string s);

using System;
delegate int NumberChanger(int n);
namespace DelegateAppl
{
   class TestDelegate
   {
      static int num = 10;
      public static int AddNum(int p)
      {
         num += p;
         return num;
      }
      public static int MultNum(int q)
      {
         num *= q;
         return num;
      }
      public static int getNum()
      {
         return num;
      }
      static void Main(string[] args)
      {
         // 创建委托实例
         NumberChanger nc;
         NumberChanger nc1 = new NumberChanger(AddNum);
         NumberChanger nc2 = new NumberChanger(MultNum);
         nc = nc1;
         nc += nc2;
         // 调用多播
         nc(5);
         Console.WriteLine("Value of Num: {0}", getNum());//75
         Console.ReadKey();
      }
   }
}
```


#### C# 事件 Event
**事件是一种封装，就好像属性会封装字段一样，可以把定义和实现隔离开来**

给你举个例子就是 `DateTime` 实际上你看那么多属性，其实里面只有一个字段存储时间，各种日期啊年啊属性都是根据这个时间算出来的。事件也把内部类型为一个委托的字段封装起来，这样在类的外部就只能使用事件来注册或者注销事件关注，而不能引发事件。



### C# 泛型 Generic

泛型 `Generic` 允许您延迟编写类或方法中的编程元素的数据类型的规范，直到实际在程序中使用它的时候。换句话说，泛型允许您编写一个可以与任何数据类型一起工作的类或方法。

使用泛型是一种增强程序功能的技术，具体表现在以下几个方面：
- 它有助于您最大限度地重用代码、保护类型的安全以及提高性能。
- 您可以创建泛型集合类。`.NET` 框架类库在 `System.Collections.Generic` 命名空间中包含了一些新的泛型集合类。您可以使用这些泛型集合类来替代 `System.Collections` 中的集合类。
- 您可以创建自己的泛型接口、泛型类、泛型方法、泛型事件和泛型委托。
- 您可以对泛型类进行约束以访问特定数据类型的方法。
- 关于泛型数据类型中使用的类型的信息可在运行时通过使用反射获取。

```c#
using System;
using System.Collections.Generic;

namespace GenericApplication
{
    public class MyGenericArray<T>
    {
        private T[] array;
        public MyGenericArray(int size)
        {
            array = new T[size + 1];
        }
        public T getItem(int index)
        {
            return array[index];
        }
        public void setItem(int index, T value)
        {
            array[index] = value;
        }
    }
           
    class Tester
    {
        static void Main(string[] args)
        {
            // 声明一个整型数组
            MyGenericArray<int> intArray = new MyGenericArray<int>(5);
            // 设置值
            for (int c = 0; c < 5; c++)
            {
                intArray.setItem(c, c*5);
            }
            // 获取值
            for (int c = 0; c < 5; c++)
            {
                Console.Write(intArray.getItem(c) + " ");
            }
            Console.WriteLine();
            // 声明一个字符数组
            MyGenericArray<char> charArray = new MyGenericArray<char>(5);
            // 设置值
            for (int c = 0; c < 5; c++)
            {
                charArray.setItem(c, (char)(c+97));
            }
            // 获取值
            for (int c = 0; c < 5; c++)
            {
                Console.Write(charArray.getItem(c) + " ");
            }
            Console.WriteLine();
            Console.ReadKey();
        }
    }
}
```


### C# 不安全代码

当一个代码块使用 `unsafe` 修饰符标记时，C# 允许在函数中使用指针变量。不安全代码或非托管代码是指使用了指针变量的代码块。
如果您使用的是 Visual Studio IDE，那么您需要在项目属性中启用不安全代码。
步骤如下：
- 通过双击资源管理器（Solution Explorer）中的属性（properties）节点，打开项目属性（project properties）。
- 点击 Build 标签页。
- 选择选项 Allow unsafe code 。

#### C# 多线程 Thread
线程生命周期

线程生命周期开始于 `System.Threading.Thread` 类的对象被创建时，结束于线程被终止或完成执行时。

下面列出了线程生命周期中的各种状态：
- 未启动状态：当线程实例被创建但 Start 方法未被调用时的状况。
- 就绪状态：当线程准备好运行并等待 CPU 周期时的状况。
- 不可运行状态：下面的几种情况下线程是不可运行的：
- 已经调用 `Sleep` 方法
- 已经调用 `Wait` 方法
- 通过 `I/O` 操作阻塞
- 死亡状态：当线程已完成执行或已中止时的状况。

一个进程包含多个线程，进程会包含一个进入此入口的线程，我们称之为主线程Main。
对于单个CPU而言，在一个单位时间内，只能执行一个线程。当一个线程的时间片用完时，系统会将该线程挂起，下一个时间内再执行另一个线程。多线程其实是一个假象，它在单位时间内进行多个线程的切换，切换频密而且单位时间非常短暂，所以多线程可被视为同时运行。

前台线程与后台线程：
前台线程能阻止应用程序的终止，既直到所有前台线程终止后才会彻底关闭应用程序。而对后台线程而言，当所有前台线程终止时，后台线程会被自动终止，不论后台线程是否正在执行任务。默认情况下通过Thread.Start()方法创建的线程都自动为前台线程，把线程的属性IsBackground设为true时就将线程转为后台线程。

I/O 类				| 描述
---					| ---
CurrentContext		| 获取线程正在其中执行的当前上下文。
CurrentThread		| 获取当前正在运行的线程。
ExecutionContext	| 获取一个 ExecutionContext 对象，该对象包含有关当前线程的各种上下文的信息。
IsAlive				| 获取一个值，该值指示当前线程的执行状态。
IsBackground		| 获取或设置一个值，该值指示某个线程是否为后台线程。
IsThreadPoolThread	| 获取一个值，该值指示线程是否属于托管线程池。
ManagedThreadId		| 获取当前托管线程的唯一标识符。
Name				| 获取或设置线程的名称。
Priority			| 获取或设置一个值，该值指示线程的调度优先级。
ThreadState			| 获取一个值，该值包含当前线程的状态。Unstarted, Sleeping, Running
Abort()				| 终止本线程。
GetDomain()			| 返回当前线程正在其中运行的当前域。
GetDomainId()		| 返回当前线程正在其中运行的当前域Id。
Interrupt()			| 中断处于 WaitSleepJoin 线程状态的线程。
Join()				| 已重载。 阻塞调用线程，直到某个线程终止时为止。
Resume()			| 继续运行已挂起的线程。
Start()				| 执行本线程。
Suspend()			| 挂起当前线程，如果当前线程已属于挂起状态则此不起作用
Sleep()				| 把正在运行的线程挂起一段时间。

线程优先级别:

Lowest BelowNormal Normal AboveNormal Highest