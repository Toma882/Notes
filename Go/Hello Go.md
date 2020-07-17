# Go

## 注意点

### 关键字

```go
break      default       func     interface   select
case       defer         go       map         struct
chan       else          goto     package     switch
const      fallthrough   if       range       type
continue   for           import   return      var
```

### 预定义的名字

```go
内建常量: true false iota nil

内建类型: int int8 int16 int32 int64
          uint uint8 uint16 uint32 uint64 uintptr
          float32 float64 complex128 complex64
          bool byte rune string error

内建函数: make len cap new append copy close delete
          complex real imag
          panic recover
```

###`()`

`for`循环，`if`语句条件两边不加括号

###`{`

函数的左括号`{`必须和`func`函数声明在同一行上, 且位于末尾，不能独占一行

###`gofmt`

代码格式化

###`goimports`

可以根据代码需要, 自动地添加或删除`import`声明
这个工具并没有包含在标准的分发包中，可以用下面的命令安装：`$ go get golang.org/x/tools/cmd/goimports`

###`:=`

短变量声明（short variable declaration）的一部分, 这是定义一个或多个变量并根据它们的初始值为这些变量赋予适当类型的语句

###`i++ i--`

自增语句`i++`给i加1；这和`i += 1`以及`i = i + 1`都是等价的。对应的还有`i--`给i减1。它们是语句，而不像C系的其它语言那样是表达式。所以`j = i++`非法，而且`++`和`--`都只能放在变量名后面，因此`--i`也非法

### 包和文件

包还可以让我们通过控制哪些名字是外部可见的来隐藏内部实现信息。

在Go语言中，一个简单的规则是：如果一个名字是大写字母开头的，那么该名字是导出的（译注：因为汉字不区分大小写，因此汉字开头的名字是没有导出的）。

## Hello, World

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello, 世界")
}

```

Go是一门编译型语言，Go语言的工具链将源代码及其依赖转换成计算机的机器指令（译注：静态编译）。Go语言提供的工具都通过一个单独的命令go调用，go命令有一系列子命令。最简单的一个子命令就是`run`。这个命令编译一个或多个以`.go`结尾的源文件，链接库文件，并运行最终生成的可执行文件。

`run`

```go
$ go run helloworld.go
Hello, 世界
```

`build`

生成一个名为helloworld的可执行的二进制文件（译注：Windows系统下生成的可执行文件是`helloworld.exe`，增加了`.exe`后缀名）

```go
$ go build helloworld.go
```

## 命令行参数
### `os`

`os.Args`变量是一个字符串（`string`）的切片（`slice`）（译注：`slice`和Python语言中的切片类似，是一个简版的动态数组）。

`os.Args`的第一个元素，`os.Args[0]`, 是命令本身的名字
现在先把切片s当作数组元素序列, 序列的长度动态变化, 用`s[i]`访问单个元素，用`s[m:n]`获取子序列(译注：和python里的语法差不多)。序列的元素数目为`len(s)`。和大多数编程语言类似，区间索引时，Go言里也采用左闭右开形式, 即，区间包括第一个索引元素，不包括最后一个, 因为这样可以简化逻辑。（译注：比如`a = [1, 2, 3, 4, 5], a[0:3] = [1, 2, 3]`，不包含最后一个元素）。比如`s[m:n]`这个切片，`0 ≤ m ≤ n ≤ len(s)`，包含`n-m`个元素。

### `flag`

[参考](https://shifei.me/gopl-zh/ch2/ch2-03.html)

```go
package main

import (
    "flag"
    "fmt"
    "strings"
)

var n = flag.Bool("n", false, "omit trailing newline")
var sep = flag.String("s", " ", "separator")

func main() {
    flag.Parse()
    fmt.Print(strings.Join(flag.Args(), *sep))
    if !*n {
        fmt.Println()
    }
}
```

调用`flag.Bool`函数会创建一个新的对应布尔型标志参数的变量。它有三个属性：第一个是的命令行标志参数的名字`“n”`，然后是该标志参数的默认值（这里是`false`），最后是该标志参数对应的描述信息。如果用户在命令行输入了一个无效的标志参数，或者输入`-h`或`-help`参数，那么将打印所有标志参数的名字、默认值和描述信息。类似的，调用`flag.String`函数将于创建一个对应字符串类型的标志参数变量，同样包含命令行标志参数对应的参数名、默认值、和描述信息。程序中的`sep`和`n`变量分别是指向对应命令行标志参数变量的指针，因此必须用`*sep`和`*n`形式的指针语法间接引用它们。

当程序运行时，必须在使用标志参数对应的变量之前先调用`flag.Parse`函数，用于更新每个标志参数对应变量的值（之前是默认值）。对于非标志参数的普通命令行参数可以通过调用`flag.Args()`函数来访问，返回值对应对应一个字符串类型的`slice`。如果在`flag.Parse`函数解析命令行参数时遇到错误，默认将打印相关的提示信息，然后调用`os.Exit(2)`终止程序。

让我们运行一些echo测试用例：


```sh
$ go build gopl.io/ch2/echo4
$ ./echo4 a bc def
a bc def
$ ./echo4 -s / a bc def
a/bc/def
$ ./echo4 -n a bc def
a bc def$
$ ./echo4 -help
Usage of ./echo4:
  -n    omit trailing newline
  -s string
        separator (default " ")
```


## 声明

### 变量 var

`var 变量名字 类型 = 表达式`

其中`类型`或`= 表达式`两个部分可以省略其中的一个

零值初始化机制让Go语言中不存在未初始化的变量

* 数值类型变量对应的零值是0
* 布尔类型变量对应的零值是false
* 字符串类型对应的零值是空字符串
* 接口或引用类型（包括slice、指针、map、chan和函数）变量对应的零值是nil


```go
s := ""
var s string
var s = ""
var s string = ""
```

#### 简短变量声明

简短变量声明被广泛用于大部分的局部变量的声明和初始化。`var`形式的声明语句往往是用于需要显式指定变量类型地方，或者因为变量稍后会被重新赋值而初始值无关紧要的地方。

`名字 := 表达式`

```go
anim := gif.GIF{LoopCount: nframes}
freq := rand.Float64() * 3.0
t := 0.0
```

#### new 函数

另一个创建变量的方法是调用用内建的`new`函数。表达式`new(T)`将创建一个`T`类型的匿名变量，初始化为`T`类型的零值，然后返回变量地址，返回的**指针类型**为`*T`

```go
p := new(int)   // p, *int 类型, 指向匿名的 int 变量
fmt.Println(*p) // "0"
*p = 2          // 设置 int 匿名变量的值为 2
fmt.Println(*p) // "2"
```

下面的两个newInt函数有着相同的行为：

```go
func newInt() *int {
    return new(int)
}

func newInt() *int {
    var dummy int
    return &dummy
}
```

### 常量 const

常量声明的值必须是一个数字值、字符串或者一个固定的boolean值

```go
const (
        cycles  = 5     // number of complete x oscillator revolutions
        res     = 0.001 // angular resolution
        size    = 100   // image canvas covers [-size..+size]
        nframes = 64    // number of animation frames
        delay   = 8     // delay between frames in 10ms units
    )
```

### 类型 type
```go
// Package tempconv performs Celsius and Fahrenheit temperature computations.
package tempconv

import "fmt"

type Celsius float64    // 摄氏温度
type Fahrenheit float64 // 华氏温度

const (
    AbsoluteZeroC Celsius = -273.15 // 绝对零度
    FreezingC     Celsius = 0       // 结冰点温度
    BoilingC      Celsius = 100     // 沸水温度
)

func CToF(c Celsius) Fahrenheit { return Fahrenheit(c*9/5 + 32) }

func FToC(f Fahrenheit) Celsius { return Celsius((f - 32) * 5 / 9) }
```

`Celsius`和`Fahrenheit`分别对应不同的温度单位。它们虽然有着相同的底层类型`float64`，但是它们是不同的数据类型，因此它们不可以被相互比较或混在一个表达式运算

### 函数实体 func
为了说明类型声明，我们将不同温度单位分别定义为不同的类型

```go
// Ftoc prints two Fahrenheit-to-Celsius conversions.
package main

import "fmt"

func main() {
    const freezingF, boilingF = 32.0, 212.0
    fmt.Printf("%g°F = %g°C\n", freezingF, fToC(freezingF)) // "32°F = 0°C"
    fmt.Printf("%g°F = %g°C\n", boilingF, fToC(boilingF))   // "212°F = 100°C"
}

func fToC(f float64) float64 {
    return (f - 32) * 5 / 9
}
```

## 整型

```go
&      位运算 AND
|      位运算 OR
^      位运算 XOR          # 如果某位不同则该位为1, 否则该位为0
&^     位清空 (AND NOT)    # 其中 NOT 运算的定义是把内存中的0和1全部取反
<<     左移               # x<<n左移运算等价于乘以2^n2n
>>     右移               # x>>n右移运算等价于除以2^n2n
```

## 循环

Go语言只有`for`循环这一种循环语句。`for`循环有多种形式，如下所示：

```go
for initialization; condition; post {
    // zero or more statements
}

// "while" loop
for condition {
    // ...
}

// infinite loop
for {
    // ...
}
```
这就变成一个无限循环，尽管如此，还可以用其他方式终止循环, 如一条`break`或`return`语句

### 空标识符（blank identifier），`_`

和变量声明一样，我们可以用下划线空白标识符_来丢弃不需要的值。

```go
_, err = io.Copy(dst, src) // 丢弃字节数
_, ok = x.(T)              // 只检测类型，忽略具体值
```

循环语句中

```go
// Echo2 prints its command-line arguments.
package main

import (
    "fmt"
)

func main() {
    s, sep := "", ""
    for _, arg := range os.Args[1:] {
        s += sep + arg
        sep = " "
    }
    fmt.Println(s)
}
```

每次循环迭代，`range`产生一对值；索引以及在该索引处的元素值。这个例子不需要索引，但`range`的语法要求, 要处理元素, 必须处理索引。一种思路是把索引赋值给一个临时变量, 如`temp`, 然后忽略它的值，但Go语言不允许使用无用的局部变量（local variables），因为这会导致编译错误。

Go语言中这种情况的解决方法是用空标识符（`blank identifier`），即`_`（也就是下划线）。空标识符可用于任何语法需要变量名但程序逻辑不需要的时候, 例如, 在循环里，丢弃不需要的循环索引, 保留元素值。大多数的Go程序员都会像上面这样使用`range`和`_`写`echo`程序，因为隐式地而非显式地索引`os.Args`，容易写对。

## switch

Go语言并不需要显式地在每一个case后写`break`，语言默认执行完case后的逻辑语句会自动退出


```go
switch coinflip() {
case "heads":
    heads++
case "tails":
    tails++
default:
    fmt.Println("landed on edge!")
}

func Signum(x int) int {
    switch {
    case x > 0:
        return +1
    default:
        return 0
    case x < 0:
        return -1
    }
}
```

## 


## goroutine
[goroutine](./Go goroutine.md)



## 参考
[Go语言圣经（中文版）](https://www.gitbook.com/book/yar999/gopl-zh/details)