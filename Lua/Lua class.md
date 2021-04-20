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

## Lua Class By Cocos

```lua
--[[--

创建一个类

~~~ lua

-- 定义名为 Shape 的基础类
local Shape = class("Shape")

-- ctor() 是类的构造函数，在调用 Shape.new() 创建 Shape 对象实例时会自动执行
function Shape:ctor(shapeName)
    self.shapeName = shapeName
    printf("Shape:ctor(%s)", self.shapeName)
end

-- 为 Shape 定义个名为 draw() 的方法
function Shape:draw()
    printf("draw %s", self.shapeName)
end

--

-- Circle 是 Shape 的继承类
local Circle = class("Circle", Shape)

function Circle:ctor()
    -- 如果继承类覆盖了 ctor() 构造函数，那么必须手动调用父类构造函数
    -- 类名.super 可以访问指定类的父类
    Circle.super.ctor(self, "circle")
    self.radius = 100
end

function Circle:setRadius(radius)
    self.radius = radius
end

-- 覆盖父类的同名方法
function Circle:draw()
    printf("draw %s, raidus = %0.2f", self.shapeName, self.raidus)
end

--

local Rectangle = class("Rectangle", Shape)

function Rectangle:ctor()
    Rectangle.super.ctor(self, "rectangle")
end

--

local circle = Circle.new()             -- 输出: Shape:ctor(circle)
circle:setRaidus(200)
circle:draw()                           -- 输出: draw circle, radius = 200.00

local rectangle = Rectangle.new()       -- 输出: Shape:ctor(rectangle)
rectangle:draw()                        -- 输出: draw rectangle

~~~

### 高级用法

class() 除了定义纯 Lua 类之外，还可以从 C++ 对象继承类。

比如需要创建一个工具栏，并在添加按钮时自动排列已有的按钮，那么我们可以使用如下的代码：

~~~ lua

-- 从 cc.Node 对象派生 Toolbar 类，该类具有 cc.Node 的所有属性和行为
local Toolbar = class("Toolbar", function()
    return display.newNode() -- 返回一个 cc.Node 对象
end)

-- 构造函数
function Toolbar:ctor()
    self.buttons = {} -- 用一个 table 来记录所有的按钮
end

-- 添加一个按钮，并且自动设置按钮位置
function Toolbar:addButton(button)
    -- 将按钮对象加入 table
    self.buttons[#self.buttons + 1] = button

    -- 添加按钮对象到 cc.Node 中，以便显示该按钮
    -- 因为 Toolbar 是从 cc.Node 继承的，所以可以使用 addChild() 方法
    self:addChild(button)

    -- 按照按钮数量，调整所有按钮的位置
    local x = 0
    for _, button in ipairs(self.buttons) do
        button:setPosition(x, 0)
        -- 依次排列按钮，每个按钮之间间隔 10 点
        x = x + button:getContentSize().width + 10
    end
end

~~~

class() 的这种用法让我们可以在 C++ 对象基础上任意扩展行为。

既然是继承，自然就可以覆盖 C++ 对象的方法：

~~~ lua

function Toolbar:setPosition(x, y)
    -- 由于在 Toolbar 继承类中覆盖了 cc.Node 对象的 setPosition() 方法
    -- 所以我们要用以下形式才能调用到 cc.Node 原本的 setPosition() 方法
    getmetatable(self).setPosition(self, x, y)

    printf("x = %0.2f, y = %0.2f", x, y)
end

~~~

**注意:** Lua 继承类覆盖的方法并不能从 C++ 调用到。也就是说通过 C++ 代码调用这个 cc.Node 对象的 setPosition() 方法时，并不会执行我们在 Lua 中定义的 Toolbar:setPosition() 方法。

@param string classname 类名
@param [mixed super] 父类或者创建对象实例的函数

@return table

]]
function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
            cls.ctor = function() end
        end

        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.new(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls
end
```


## Lua Class Patch for Unity C# Monobehavior

```lua
function inserMetaIndex(tbl, indexTbl)
    local new_meta = {}
    local origin_meta = getmetatable(tbl)

    new_meta.__index = function (table, key)
        if indexTbl[key] then
            return indexTbl[key]
        elseif type(origin_meta.__index) == "function" then
            return origin_meta.__index(table, key)
        elseif type(origin_meta.__index) == "table" then
            return origin_meta.__index[key]
        end
    end

    setmetatable(tbl, new_meta)
end
```

使用方式：

```lua
local CLASSNAME = "Obj"
local CurObj = class(CLASSNAME)

function CurObj:ctor(CurObjName, csharpObj)
	inserMetaIndex(self, csharpObj)
	self.m_uCSharpObj = csharpObj
	self.m_curObjName = CurObjName
	self.m_uCSharpObj:SetLuaObj(self)
end
```

xLua 侧 LuaBehavior 的 lua 代码
```lua
local curObj
function Awake()
   curObj = CurObj.new(CurObj.__cname, self)
   curObj:Awake()
end
function Start()
   curObj:Start()
end
function Update()
   curObj:Update()
end
function OnDestroy()
   curObj:OnDestroy()
end
function OnEnable()
   curObj:OnEnable()
end
function OnDisable()
   curObj:OnDisable()
end
```