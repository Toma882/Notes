## Unity Lua GC

```lua
Transform child = transform.find("children1")
transform.position = new Vector3(0,1,0);
transform.name = "1234";
```

#### 避免字符串频繁传递

C# 的 `tostring` 函数

```c#
public static string lua_tostring(IntPtr L, int index)
{
    IntPtr strlen;

    IntPtr str = lua_tolstring(L, index, out strlen);
    if (str != IntPtr.Zero)
	{
        // 这里new了一个字符串
        string ret = Marshal.PtrToStringAnsi(str, strlen.ToInt32());
        if (ret == null)
        {
            int len = strlen.ToInt32();
            // 这里new 了一个byte数组
            byte[] buffer = new byte[len];
            Marshal.Copy(str, buffer, 0, len);
            // 这里new 了一个字符串
            return Encoding.UTF8.GetString(buffer);
        }
        return ret;
    }
    else
	{
        return null;
	}
} 
```

所以，一定要避免字符串频繁传递，尤其是 UI 打开的时候获取一些控件，千万别用字符串来。应该在C#那边组织好(比如在 prefab 中维护一个 `public List<UnityEngine.Object>`，然后直接把对应的对象拽进去)，然后通过 LuaTable 注册给 UI 操作 table。

#### 避免在 Lua 这边使用 Vector3 计算位移

Lua 会把 `Vector3` 当成 `table` 或者 `userdata` 处理，C# 那边是个栈对象，Lua 这边是个堆对象，会导致 Lua 的频繁GC，替换做法可以通过 3 个 number 进行传递，然后在 C# 那边封装好数值计算函数

XLua 的 `push_struct` 方法

```c#
LUA_API void *xlua_pushstruct(lua_State *L, unsigned int size, int meta_ref) {
    // 在Lua这边new了一个 userdata
    CSharpStruct *css = (CSharpStruct *)lua_newuserdata(L, size + sizeof(int) + sizeof(unsigned int));
    css->fake_id = -1; 
    css->len = size;
    lua_rawgeti(L, LUA_REGISTRYINDEX, meta_ref);
    lua_setmetatable(L, -2);
    return css;
}
```


#### 尽量的减少 `__index` 元运算

`transform.gameObject` 在 C# 那边仅仅只是个地址偏移效率估计就是一次加法和取地址运算，但是在 Lua 这边却有着非常严重的虚拟机交互过程。所以要尽量的减少 `__index` 元运算，多用缓存把一些 C# 对象保存起来，比如 UIManager.GetInstance() 这种在 C# 那边效率影响不大，Lua 这边就最好搞个全局变量保存一下。


## 参考
[用Unity+Lua开发游戏，有什么好的办法进行性能检测？](https://www.zhihu.com/question/307064711)