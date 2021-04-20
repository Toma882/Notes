## lua 5.1
### 全局变量

`_G`

可以通过 `value = _G["varname"]` 或者 `value = _G.varname` 来获得动态名字的全局变量。

```lua
> a=1
> b= "b"
> print(_G[a])
nil
> print(_G["a"])
1
> print(_G["b"])
b
> print(_G.a)
1
> print(_G.b)
b
```

### 改变环境 `setfenv`

Lua5.1 允许每个函数拥有一个子集的环境来查找全局变量，可以通过 `setfenv` 来改变一个函数的环境，
第一个参数若是 1 则表示当前函数，2 则表示调用当前函数的函数（依次类推），第二个参数是一个新的环境 table 。

比如下面，修改了函数的环境， `print` 不存在了，再访问就会出错。

```lua
va = 1  
setfenv(1, {})  
print(va) -- 会报错，print是一个nil。这是因为一旦改变环境，所有的全局访问都会使用新的table  
```

为了避免上述问题，

* 可以使用 `setfenv(1, {_G = _G})` 将原来的环境保存起来。
* 另一种组装新环境的方法是使用继承
	```lua
	a = 1  
	print(a) --1
	print(b) --nil
	local newTable = {b=2}
	setmetatable(newTable, {__index = _G})
	setfenv(1, newTable)  
	print(a) --1
	print(b) --2

	local freshTable = {c=2}
	setmetatable(freshTable, {__index = _G})
	setfenv(1, freshTable)  
	print(a) --1
	print(b) --nil
	print(c) --2
	```

## Lua 5.2

引入了 `_ENV` 叫做 环境，`_ENV` 是一个 `upvalue`(非局部变量)，里面的变量叫做 环境变量，因此现在有  三个概念。

* 全局变量 `_G`
* 环境变量 `_ENV`
* 局部变量 `local`

`_ENV['_G'] = _ENV` 是为了兼容前面的之前的版本代码

```lua
--_ENV['_G'] = _ENV
a = 1 --_ENV['a'] = 1
print(a)              -- 1
print(_G.a)           -- 1
print(_ENV['a'])      -- 1
print(_ENV['_G']['a'])-- 1
_G.a = 2 -- _ENV['_G']['a']
print(a)              -- 2
print(_G.a)           -- 2
print(_ENV['a'])      -- 2
print(_ENV['_G']['a'])-- 3
_ENV.a = 3 -- _ENV['_G']['a']
print(a)              -- 3
print(_G.a)           -- 3
print(_ENV['a'])      -- 3
print(_ENV['_G']['a'])-- 3
```


### 改变环境 `_ENV`

