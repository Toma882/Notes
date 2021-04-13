# Lua class

## Lua Class By 云风

#### class 代码 
```lua
-- _class用来保存所有类模板
local _class = {}

-- 此方法用于定义类，super为基类
function class(super)
	-- class_type 可以理解为类模板
	local class_type = {}
	-- ctor为构造函数
	class_type.ctor = false
	-- 赋值基类
	class_type.super = super
	-- 定义new成员方法
	class_type.new = function(...) 
			local obj = {}
			do
			    -- create 用于实现嵌套调用，目的是调用基类的ctor函数，即基类的构造函数
				local create
				create = function(c,...)
					if c.super then
					   -- 如果有基类，优先调用基类的ctor函数
						create(c.super, ...)
					end
					if c.ctor then
						-- 调用构造函数
						c.ctor(obj, ...)
					end
				end
 
				create(class_type, ...)
			end
			-- obj继承_class[class_type]，其实就是下面的vtbl，obj就是类对象
			setmetatable(obj, { __index = _class[class_type] })
			-- new方法返回obj对象
			return obj
		end
		
	-- vtbl可以理解为类容器
	local vtbl = {}
	_class[class_type] = vtbl
	
    -- class_type 新增成员的时候，存到vtbl中
	setmetatable(class_type, { __newindex=
		function(t, k, v)
			vtbl[k] = v
		end
	})
 
	if super then
	    -- 如果有基类，取某个成员的时候，先从_class中找到基类容器，然后从基类容器中取成员赋值给vtbl
	    -- 意思就是，如果子类有成员，则直接调用，否则从基类中找成员调用
		setmetatable(vtbl, { __index = 
			function(t, k)
				local ret = _class[super][k]
				vtbl[k] = ret
				return ret
			end
		})
	end
 
    -- 返回类模板，可以添加ctor函数，可以添加成员函数，这些都会被加到vtbl中，
    -- 当执行new方法的时候，就会执行vtbl的ctor函数，返回obj
    -- 执行成员方法的时候，就会执行obj的成员方法，因为obj继承了vtbl，所以会执行vtbl的成员方法
    -- 如果vtbl没有成员方法，则从其基类中查找
	return class_type
end
```

#### 测试用例

```lua
base_type = class()		-- 定义一个基类 base_type
 
function base_type:ctor(x)	-- 定义 base_type 的构造函数
	print("base_type ctor")
	self.x=x
end
 
function base_type:print_x()	-- 定义一个成员函数 base_type:print_x
	print(self.x)
end
 
function base_type:hello()	-- 定义另一个成员函数 base_type:hello
	print("hello base_type")
end

child=class(base_type)	-- 定义一个类 child 继承于 base_type
 
function child:ctor()	-- 定义 child 的构造函数
	print("test ctor")
end
 
function child:hello()	-- 重载 base_type:hello 为 child:hello
	print("hello test")
end

grandChild=class(child)
grandChild.name = "Mike"
function grandChild:sayHello()
	print("hello test2")
end


c = child.new(1)	-- 输出两行，base_type ctor 和 test ctor 。这个对象被正确的构造了。
c:print_x()	-- 输出 1 ，这个是基类 base_type 中的成员函数。
c:hello()	-- 输出 hello test ，这个函数被重载了。

g = grandChild.new(1)
g:sayHello()
print(g.name)
g.name = "Kobe"
print(g.name)

g2 = grandChild.new(2)
print(g2.name)
```

#### 特点
 lua 侧 OK，与 C#, C++ 不能结合
