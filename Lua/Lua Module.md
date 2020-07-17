#Lua Module


>模块类似于一个封装库，从 Lua 5.1 开始，`Lua` 加入了标准的模块管理机制，可以把一些公用的代码放在一个文件里，以 `API` 接口的形式在其他地方调用，有利于代码的重用和降低代码耦合度。

`Lua` 的模块是由变量、函数等已知元素组成的 `table`，因此创建一个模块很简单，就是创建一个 `table`，然后把需要导出的常量、函数放入其中，最后返回这个 `table` 就行。

以下为创建自定义模块 `module.lua`，文件代码格式如下：

```lua
-- 文件名为 module.lua
-- 定义一个名为 module 的模块
module = {}
 
-- 定义一个常量
module.constant = "这是一个常量"
 
-- 定义一个函数
function module.func1()
    io.write("这是一个公有函数！\n")
end
 
local function func2()
    print("这是一个私有函数！")
end
 
function module.func3()
    func2()
end
 
return module
```

```lua
-- test_module.php 文件
-- module 模块为上文提到到 module.lua
require("module")
print(module.constant)
module.func3()

local m = require("module")
print(m.constant)
m.func3()
```

## require 函数

```lua
require("<模块名>")"
```

`Lua`提供了一个名为`require`的函数用来加载模块。要加载一个模块，只需要简单地调用`require "<模块名>”`就可以了。这个调用会返回一个由模块函数组成的`table`，并且还会定义一个包含该`table`的全局变量。但是，这些行为都是由模块完成的，而非`require`。
    
**加载机制**

`require` 采用的路径是一连串的模式，其中每项都是一种将模块名转换为文件名的方式。`require`会用模块名来替换每个`"？"`，然后根据替换的结果来检查是否存在这样一个文件，如果不存在，就会尝试下一项。路径中的每一项都是以分号隔开，比如路径为以下字符串：

```lua
?;?.lua;c:\windows\?;/usr/local/lua/?/?.lua
```

那么，当我们`require "mod”`时，就会尝试着打开以下文件：

```lua
mod
mod.lua
c:\windows\mod
/usr/local/lua/mod/mod.lua
```

可以看到，`require`函数只处理了分号和问好，其它的都是由路径自己定义的。在实际编程中，`require`用于搜索的`Lua`文件的路径存放在变量`package.path`中，在我的电脑上，`print(package.path)`会输出以下内容：

```lua
;.\?.lua;D:\Lua\5.1\lua\?.lua;D:\Lua\5.1\lua\?\init.lua;D:\Lua\5.1\?.lua;D:\Lua\5.1\?\init.lua;D:\Lua\5.1\lua\?.luac
```

如果require无法找到与模块名相符的Lua文件，那Lua就会开始找C程序库；这个的搜索地址为package.cpath对应的地址，在我的电脑上，print(package.cpath)会输出以下值：

```lua
.\?.dll;.\?51.dll;D:\Lua\5.1\?.dll;D:\Lua\5.1\?51.dll;D:\Lua\5.1\clibs\?.dll;D:\Lua\5.1\clibs\?51.dll;D:\Lua\5.1\loadall.dll;D:\Lua\5.1\clibs\loadall.dll
```

当找到了这个文件以后，如果这个文件是一个Lua文件，它就通过`loadfile`来加载该文件；如果找到的是一个`C`程序库，就通过`loadlib`来加载。`loadfile`和`loadlib`都只是加载了代码，并没有运行它们，为了运行代码，`require`会以模块名作为参数来调用这些代码。

## 第一个模块

在Lua中创建一个模块最简单的方法是：创建一个`table`，并将所有需要导出的函数放入其中，最后返回这个`table`就可以了。相当于将导出的函数作为`table`的一个字段，在Lua中函数是第一类值，提供了天然的优势。

```lua
complex = {}    -- 全局的变量，模块名称
 
function complex.new(r, i) return {r = r, i = i} end
 
-- 定义一个常量i
complex.i = complex.new(0, 1)
 
function complex.add(c1, c2)
    return complex.new(c1.r + c2.r, c1.i + c2.i)
end
 
function complex.sub(c1, c2)
    return complex.new(c1.r - c2.r, c1.i - c2.i)
end
 
return complex  -- 返回模块的table
```

在模块中定义一个局部的`table`类型的变量

```lua
local moduleName = ...
 
-- 打印参数
for i = 1, select('#', ...) do
     print(select(i, ...))
end
 
local M = {}    -- 局部的变量
_G[moduleName] = M     -- 将这个局部变量最终赋值给模块名
complex = M
 
function M.new(r, i) return {r = r, i = i} end
 
-- 定义一个常量i
M.i = M.new(0, 1)
 
function M.add(c1, c2)
    return M.new(c1.r + c2.r, c1.i + c2.i)
end
 
function M.sub(c1, c2)
    return M.new(c1.r - c2.r, c1.i - c2.i)
end
 
return complex  -- 返回模块的table
```

**消除`return`语句**

将模块`table`直接赋值给`package.loaded`

```lua
local moduleName = ...
 
local M = {}    -- 局部的变量
_G[moduleName] = M     -- 将这个局部变量最终赋值给模块名
 
package.loaded[moduleName] = M
```

## package.loaded

`package.loaded`这个`table`中保存了已经加载的所有模块

1. 先判断package.loaded这个table中有没有对应模块的信息；
2. 如果有，就直接返回对应的模块，不再进行第二次加载；
3. 如果没有，就加载，返回加载后的模块。

## 参考
* [Lua.org](http://www.lua.org/)
* [Lua中的模块(module)和包(package)详解](http://www.jb51.net/article/55818.htm)