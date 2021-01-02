# toLua

## tolua LuaFramework_UGUI Unity2019 错误修复

LuaLoader.cs  
`CreateFromMemoryImmediate -> LoadFromMemory`

Packager.cs  
`BuildTarget.iPhone -> BuildTarget.iOS`

CustomSettings.cs 对下面3个进行注释  
```
//_GT(typeof(Light)),
//_GT(typeof(ParticleSystem)),
//_GT(typeof(QualitySettings)),
```

ToLuaExport.cs memberFilter 里添加下面内容  
```
"MeshRenderer.stitchLightmapSeams",
"MeshRenderer.receiveGI",
"MeshRenderer.scaleInLightmap",
```

## 参考
* [uLua](http://www.ulua.org/index.html)
* [LuaFramework_UGUI_V2](https://github.com/jarjin/LuaFramework_UGUI_V2)
* [LuaFramework_UGUI](https://github.com/jarjin/LuaFramework_UGUI)
* [Unity3D热更新实战演练](https://zhuanlan.zhihu.com/p/43632619)