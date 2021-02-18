## 工作环境
* Rider
* xLua
* EmmyLua

### Rider 识别 `*.lua.txt`

Rider -> Setting -> Editor -> File Types -> Lua Language

### xLua 调试

使用xlua，需要在 `luaEnv.DoString()` 时 `chunkName` 参数传入 `lua` 脚本的全路径，调试器才能正确定位到断点。

修改文件位置内容参考私有配置

### EmmyLua 调试

在 Rider 的 EmmyLua 的 Lua additional sources root 中添加我们的 lua 脚本目录。


### C# EmmyLua 同时调试方法

Rider 先 Attach To Unity Editor 进行 Debug，然后切换到 Emmy Debugger 进行 Debug ，就能一起调试了

### EmmyLua 中对 UnityEngine 代码进行提示

把 `UnityLuaAPI.zip` 解压到工程目录

```lua
function start()
    ---@type UnityEngine.GameObject
    local go = xxx
    go:SetActive(true)
end
```