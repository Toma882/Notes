# Unity 目录

在比较老的版本中，Unity 创建空工程之后，就只有一个空的 Assets。现在，在 Assets 里默认有了一个 Scenes 目录，然后里面有一个 SampleScene 的默认空白场景。

## Packages 目录
这个目录是2018新增的，Unity 自动生成的，是一个只读目录。Unity 提供的一个 Package Manager 窗口进行管理。

## Assets 目录
这是是 Unity 的主工作目录，这么多年一直都没变的，是 Unity 工作的基石。任何资源只有放在这个目录下才能被 Unity 识别和管理，不管你是纹理、模型、地形、声音、特效、代码、文本等等。

## Unity 的其他特殊目录


### Editor
可以有很多个，可以在任意的子目录下面。

主要作用就是可以编译Unity编辑器模式下提供的脚本和接口，用于辅助研发，创建各种资源检查，生成工具，以及自定义Unity的工具栏，窗口栏等等。

### Editor Default Resources

只能放在Assets的根目录下。

一个扩展面板或者工具光秃秃的也不好看，配上一些美化资源之后会让你的插件或者工具格局更高。


### Plugins

引入的第三方代码，SDK 接入的各种 `.jar` 包，`.a`文件，`.so` 文件,`.framework`文件等等，这些库文件会在Unity编译的时候链接到你的 DLL 里。

### Resources
可以有很多个，可以在任意的子目录下面。

所有 `Resources` 目录下的文件都会直接打进一个特殊的 `Bundles` 中，并且在游戏启动时，会生成一个序列化映射表，并加载进内存里。

### Gizmos

可以辅助你在 Unity 的 `Scene` 视窗里显示一些辅助标线，图标或者其它的标识，用来辅助开发定位资源。

按钮在 Scene 窗口的最右上角。要注意的是，因为是 Scene 视窗的，所以 Game 视窗和发布之后都不会看到。

### StreamingAssets

Unity 发布程序或者游戏，资源随包出去的时候，只有2个地方，一个就是 `Resources` 目录，另外一个就是 `StreamingAssets` 。这个目录的资源，文件或者任何东西，都会原封不动的复制到最终的 Apk 或者 iOS 的包内。

## Resources 详解

先看一下 Unity 官方对于 Resources 使用的最佳实践：
不！要！使！用！它！

出于几点原因，Unity并不希望大家过度使用 Resources ，是因为：

* Resources 内的资源会增加应用程序的启动时间和构建时长。  
  官方的实际测试数据，一个拥有10000个Assets的Resources目录，在低端移动设备上的初始化需要5-10秒甚至更长。但其实，这些Assets并不会在一开始就全部用到。
* Resources 内的资源无法增量更新，这是现在手机游戏开发的致命点。

所以官方建议，使用 `AssetBundles` 。

它还是有它的一些使用场景的，比如：

* 某些资源是项目整个生命周期都必须要用的。
* 有些很重要，但是却不怎么占内存的。
* 不怎么需要变化，并且不需要进行平台差异化处理的。
* 用于系统启动时候最小引导的。

## 参考目录1
```
Assets
    AddressableAssetsData
    Arts
        // 这个目录里存放的是美术的原件资源，也就是美术最基本的素材。
        // 比如UI的切图，Icon的资源，模型Fbx文件，场景贴图，材质球等。
        // 并且根据不同的类型存放在不同的目录下面。
        Bank
        Building
        Effect
        Icons
        PostEffect
        Role
        Scenes
        TimelineRes
        UGUI
        UGUI_Anim
        WorldMap
    AstarPathfindingProject
    Cinemachine
    CompilingMacro
    Data
        // 策划编辑的表格数据，以及Lua脚本和一些散列的配置项。
        Excel
        Lua
        wordrelease
    Demigiant
    Editor
    Fonts
    Gizmos
    GPUSkinning
    LogsViewer
    Plugins
    PoolManager
    Prefabs
        // 这个目录是真正项目要用到的各种预制体文件，比如一个士兵，
        // 拿到Fbx之后，由工具生成特定的Prefab到指定目录，这里包含了各种资源，也是通过子目录来划分类别。
        // 这部分由客户端和各种工具共同维护。
        Building
        Effect
        Icons
        Path
        Role
        Scenes
        Shader
        Test
        TimelineRes
        UGUI
        WorldMap
    Resources
    Scenens
    Scripts
        // 这个是客户端内部的代码文件，这里要注意的是ECSBattle和ECSBattleView两个目录。
        // 之前也有提到，我们的战斗是逻辑和表现分离的方式，所有的逻辑层可以在脱离表现层的情况下独立工作。
        // ECSBattle就是逻辑层的必须代码，ECSBattleView是跟表现相关的部分。
        // 这里我们其实希望能从设计上将单局和外围的部分隔离出来，这样就可以防止改动外围的时候会动到核心。
        ECSBattle
        ECSBattleView
        EditorTools
        PackageTools
        PostEffect
        Surface
    Shaders
    StreamingAssets
    SuperTile2Unity
    TextMesh Pro
    XLua
```
## 参考
* [Unity手游实战：从0开始SLG——Unity目录分布（Asset权限规划）](https://zhuanlan.zhihu.com/p/77058380)