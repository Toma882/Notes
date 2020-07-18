# Unity 资源

## Asset & Object
无论是纹理、音乐还是预制体等 `Asset` ，在进入 Unity 的世界后，都变成了各种 `Object` 对象 供我们使用。

`Objects` 这里我们指的是从 `UnityEngine.Object` 继承的对象，例如纹理转变为 `Texture2D` 或 `Sprite` ，音效文件转变为 `AudioClip` ，预制体 变成了 `GameObject` 等等，代表任何 Unity 引擎所支持的类型，比如： `Mesh、Sprite、AudioClip or AnimationClip` 等等。

这个由 `Asset` 资源文件 转变为 `Object` 对象，从磁盘进入内存的过程，就是实例化。


大多数的 `Objects` 都是 Unity 内置支持的，但有两种除外：

* `ScriptableObject`  
  用来提供给开发者进行自定义数据格式的类型。从该类继承的格式，都可以像 Unity 的原生类型一样进行序列和反序列化，并且可以从 Unity 的 Inspector 窗口进行操作。
* `MonoBehaviour`  
  提供了一个指向 MonoScript 的转换器。MonoScript 是一个 Unity 内部的数据类型，它不是可执行代码，但是会在特定的命名空间和程序集下，保持对某个或者特殊脚本的引用。

## 常见文件类型
在 Unity3d 中一般存在这么几种文件：

* 资源文件  
  如 `FBX` 文件、贴图文件、音频文件、视频文件和动画文件，像这类文件，Unity 中都会在导入时进行转化。每一个类型都对应一个 `AssetImporter` ，比如 `AudioImporter、TextureImporter、ModelImport` 等等。
* 代码文件  
  代码文件包括所有的代码文件、代码库文件、Shader文件等。在导入时，Unity会进行一次编译。
* 序列化文件（数据文件）  
  序列化文件通常是指 Unity 能够序列化的文件，一般是 Unity 自身的一些类型，比如 `Prefab`(预制体)、`Unity3d`(场景)文件、`Asset`(`ScriptableObject`)文件、`Mat`文件(材质球)，这些文件能够在运行时直接反序列化为对应类的一个实例。
* 文本文档  
  文本文档比较特殊，它不是序列化文件，但是 Unity 可以识别为 `TextAsset` 。很像资源文件，但是又不需要资源文件那样进行设置和转化，比如`txt xml`文件等等。
* 非序列化文件  
  非序列文件是Unity无法识别的文件，比如一个文件夹也会被认为是一个文件，但是无法识别。
* Meta文件  
  定义在它同目录下，同名文件或文件夹的唯一ID：`GUID` ；存储资源文件的 `ImportSetting` 数据，在上文中资源文件是有 `ImportSetting` 数据的，这个数据正数存储在 `Meta` 文件中。 `ImportSetting` 中专门有存储 `Assetbundle` 相关的数据。这些数据帮助编辑器去搜集所有需要打包的文件并分门别类。所以每一次修改配置都会修改 `Meta` 文件。



## GUID LocalID InstanceID

### GUID
Unity 会为每一个加入到 `Assets` 文件夹中的文件或者文件夹，创建一个同级同名的 `.meta` 文件，它们都包含一个用来标记文件身份的 `GUID`。

通过 `GUID` 就可以找到工程中的这个文件，无论它在项目的什么位置。在编辑器中使用 `AssetDatabase.GUIDToAssetPath` 和 `AssetDatabase.AssetPathToGUID` 进行互转。

### LocalID
如果说 `GUID` 表示为文件和文件之间的关系，那么 `LocalID` 表示的就是文件内部各对象之间的关系，通过文本编辑器，打开 `*.mat`，`*.unity`，`*.Prefab` 等后缀名文件可以看到 `--- !u!21 &2100000` 类似这样的内容

一个 `Object` 对象通常是由一个或多个 `Object` 对象构成，每个记录在 `&` 符号后面的数字都是一个 `LocalID`，每一个 `LocalID` 也表示这它将来也会被实例化成一个 `Object` 对象。也就是说，当一个 `prefab` 文件要实例化成一个 `GameObject` 时，它会自动尝试获取其内部 `LocalID` 所指的那个对象。如果这个所指的对象当前还没有被实例化出来，那么 Unity 会自动实例化这个对象，如此递归，直到所有涉及的对象都被实例化。


### Instance ID

每当 Unity 读入一个 `GUID` 和 `LocalID` 时，就会自动将其转换成一个 `Instance ID` ，方便其在内存中快速查找相应的资源。 `Instance ID` 很简单，就是一个递增的整数，每当有新对象需要在缓存里注册的时候，简单的递增就行。

`PersistentManager` 会维护 `Instance ID` 和 `GUID` 、 `LocalID` 的映射关系，只要系统解析到一个 `Instance ID` ，就能快速找到代表这个 `Instance ID` 的已加载的对象。如果 `Object` 没有被加载， `GUID` 和 `LocalID` 也可以快速地定位到指定的 `Asset` 资源从而即时进行资源加载。

### 总结：

Unity 会在项目启动后，创建并一直维护一张 映射表 ，这张 映射表 记录的就是 `GUID`，`LocalID` 以及由它们转换而成的 `InstanceID` 之间的关系，这样下次在请求资源时就可以快速获取资源。

[AssetBundle](./Unity%20AssetBundle.md)

## 参考
* [Unity Doc AssetBundle](https://docs.unity3d.com/cn/current/Manual/AssetBundlesIntro.html)
* [程序丨入门必看：Unity资源加载及管理](https://mp.weixin.qq.com/s/0XFQt8LmqoTxxst_kKDMjw)
* [Unity文件、文件引用、meta详解](https://www.cnblogs.com/CodeGize/p/8697227.html)