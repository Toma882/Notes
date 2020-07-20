# Unity AssetBundle

学习之前先了解下列知识 
* [Unity 资源](./Unity%20资源.md)



## AssetBundle 结构
AssetBundle 是一个存档文件，针对不同的平台会需要进行不同的打包，它包含可在运行时加载的特定于平台的资源（模型、纹理、预制件、音频剪辑甚至整个场景）。

AssetBundle 就像传统的压缩包一样，由两个部分组成：包头和数据段。

包头包含有关 AssetBundle 的信息，比如标识符、压缩类型和内容清单。清单是一个 以Objects name 为键的查找表。每个条目都提供一个字节索引，用来指示该 Objects 在 AssetBundle 数据段的位置。在大多数平台上，这个查找表是用平衡搜索树实现的。具体来说，Windows 和 OSX 派生平台（包括 iOS ）都采用了红黑树。因此，构建清单所需的时间会随着 AssetBundle 中 Assets 的数量增加而线性增加。

数据段包含通过序列化 AssetBundle 中的 Assets 而生成的原始数据。如果指定 LZMA 为压缩方案，则对所有序列化 Assets 后的完整字节数组进行压缩。如果指定了 LZ4，则单独压缩单独 Assets 的字节。如果不使用压缩，数据段将保持为原始字节流。


## 生成 AssetBundle

AssetBundle 需要针对不同的平台生成不同的 AssetBundle，因此目前推荐的方式是有多个工程目录，文件的同步性可以通过 [Link Sheel Extension](https://schinagl.priv.at/nt/hardlinkshellext/linkshellextension.html) 来解决。

### AssetBundles 的压缩方式

* LZMA  
  默认。优点是被压缩的非常小，缺点是每次使用都需解压，可能会带来卡顿。在项目中不建议使用。
* None BuildAssetBundleOptions.UncompressedAssetBundle  
  优点是加载速度非常快，缺点是构建出来的 AssetBundle 比较大。可以将不压缩的 AssetBundle 构建出来，用第三方压缩算法压缩它。下载后再用第三方解压算法将它写在硬盘上。
* LZ4 BuildAssetBundleOptions.ChunkBasedCompression  
  折中方案，建议在项目中使用。
* None

### AssetBundles 的构建

每一次调用 `BuildPipleLine.BuildAssetBundles` 时，将会生成一批 `AssetBundle` 文件，具体数量根据传递 `AssetBundleBuild` 数组决定，每一个 `AssetBundleBuild` 对象将对应一个 `AssetBundle` 及一个同名 `.manifest` 后缀文件。其中 `AssetBundle` 文件的后缀用户自行设置，比如 `.unity3d` ， `.ab` 等等；而 `.manifest` 文件是给人看的，里面有这个 `AssetBundle` 的基本信息以及非常关键的资源列表。

### AssetBundles 依赖的相关信息构建

此 `Asset` 将存储在与构建 `AssetBundles` 的父目录同名的 `AssetBundle中` 。如果一个项目将其 `AssetBundles` 构建到位于 `(Projectroot)/Build/Client/` 的文件夹中，那么包含清单的 `AssetBundle` 将被保存为 `(Projectroot)/build/client/Client.manifest` 。

包含 `Manifest` 的 `AssetBundle` 可以像任何其它 `AssetBundle` 一样加载、缓存和卸载。

`AssetBundleManifest` 对象本身提供 `GetAllAssetBundles` API 来列出与清单同时构建的所有 `AssetBundles` ，以及查询特定 `AssetBundle` 的依赖项的两个方法：

* `AssetBundleManifest.GetAllDependencies`  
  返回 `AssetBundle` 的所有层次依赖项，其中包括 `AssetBundle` 的直接子级、其子级的依赖项等。
* `AssetBundleManifest.GetDirectDependations`  
  只返回 `AssetBundle` 的直接子级

请注意，这两个API分配的都是字符串数组。因此，最好是在性能要求不敏感的时候使用

### AssetBundles.manifest 文件示例

`StreamingAssets.manifest` 示例

```
ManifestFileVersion: 0
CRC: 53709537
AssetBundleManifest:
  AssetBundleInfos:
    Info_0:
      Name: new material.unity3d
      Dependencies: {}
    Info_1:
      Name: cube.unity3d
      Dependencies:
        Dependency_0: new material.unity3d
```

`cube.unity3d.manifest` 示例
```
ManifestFileVersion: 0
CRC: 391681970
Hashes:
  AssetFileHash:
    serializedVersion: 2
    Hash: f0d503ef1f2738f948916f9a65920294
  TypeTreeHash:
    serializedVersion: 2
    Hash: f49f05f36a566d50434f7d9f3fb347da
HashAppended: 0
ClassTypes:
- Class: 1
  Script: {instanceID: 0}
- Class: 4
  Script: {instanceID: 0}
- Class: 21
  Script: {instanceID: 0}
- Class: 23
  Script: {instanceID: 0}
- Class: 33
  Script: {instanceID: 0}
- Class: 43
  Script: {instanceID: 0}
- Class: 65
  Script: {instanceID: 0}
Assets:
- Assets/Cube.prefab
- Assets/Cube 2.prefab
Dependencies:
- "/Users/senumatsu/\u7B2C\u4E8C\u7248\u5728\u8DEF\u4E0A/\u7B2C\u5341\u4E00\u7AE0/CodeList_11_14/Assets/StreamingAssets/new
  material.unity3d"
```

`new material.unity3d.manifest` 示例
```
ManifestFileVersion: 0
CRC: 3230917786
Hashes:
  AssetFileHash:
    serializedVersion: 2
    Hash: 0907c51f4759c8f91b1d3672add7af1f
  TypeTreeHash:
    serializedVersion: 2
    Hash: 6f165f44e4778b6c9d85e7a145a54cb1
HashAppended: 0
ClassTypes:
- Class: 21
  Script: {instanceID: 0}
- Class: 28
  Script: {instanceID: 0}
- Class: 48
  Script: {instanceID: 0}
Assets:
- Assets/New Material.mat
Dependencies: []
```

## AssetBundle 的加载

将 `AssetBundle` 的加载拆分理解为： `Bundle` 加载和 `Asset` 加载两部分。

 * 记录文件标记、压缩信息、文件列表的 `Header` 部分；
 * 记录资源实际内容的 `Data` 部分。

使用 `AssetBundle.LoadFromFile` 或 `AssetBundle.LoadFromFileAsync` 时， ，Unity 仅会为我们读取 `AssetBundle` 的 `header` 部分，并不会将 `data` 部分整个读入内存。

当调用上一步生成的 `AssetBundle` 对象读取具体资源时 `LoadAsset LoadAssetAsync LoadAllAssets`，Unity 会参考已经缓存的文件列表，找到目标资源在 `data` 部分的位置并读入到内存中。如果一个资源引用到了其他资源，则必须要先读入被引用资源的 `AssetBundle` 文件，否则就会发生引用 `Miss` 。

### Dependencies
Unity 不会尝试在加载 父 `AssetBundle` 时自动加载任何 子 `AssetBundle` 。为了避免上面 `Miss` 的情况，在加载资源时，首先需要将该资源的依赖项全部加载完毕，不过仅需加载依赖资源的 `AssetBundle` 文件。也就是说，我们只要将该依赖 `AssetBundle` 的 `Header` 部分加载 `AssetBundle.LoadFromFile` 或 `AssetBundle.LoadFromFileAsync` 就可以，这样在真正读取 `Asset` 时，Unity 会自动处理好真实依赖的 `Asset` ，我们不用操心。

```c#
AssetBundle assetbundle = AssetBundle.LoadFromFile (Path.Combine (Application.streamingAssetsPath, "StreamingAssets"));
if(assetbundle)
{
    AssetBundleManifest manifest = assetbundle.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
    string[] assets = manifest.GetAllAssetBundles();
    foreach(var item in assets)
    {
        // 获取AB资源的直接依赖资源 A->B->C，则返回{B}
        string[] dependencies = manifest.GetDirectDependencies(item);
        // 获取AB资源的全部依赖资源 A->B->C，则返回{B,C}，不推荐使用?
        //string[] dependencies = manifest.GetAllDependencies(item);
    }
}
```

### AssetBundle 4个加载方式

* AssetBundle.LoadFromMemory(Async optional)  
Unity的建议是不要使用这个API。
*  AssetBundle.LoadFromFile(Async optional)  
  `LoadFromFile` 是一种高效的 API，用于从本地存储（如硬盘或SD卡）加载未压缩或LZ4压缩格式的AssetBundle。
  在桌面独立平台、控制台和移动平台上，API 将只加载 `AssetBundle` 的头部，并将剩余的数据留在磁盘上。
  `AssetBundle` 的 `Objects` 会按需加载，比如：加载方法（例如：`AssetBundle.Load`）被调用或其 `InstanceID` 被间接引用的时候。在这种情况下，不会消耗过多的内存。
  **但在 Editor 环境下，API 还是会把整个 `AssetBundle` 加载到内存中**，就像读取磁盘上的字节和使用 `AssetBundle.LoadFromMemoryAsync` 一样。如果在 Editor 中对项目进行了分析，此API可能会导致在 AssetBundle 加载期间出现内存尖峰。但这不应影响设备上的性能，在做优化之前，这些尖峰应该在设备上重新再测试一遍。
* UnityWebRequest's DownloadHandlerAssetBundle  
  值得进一步关注。
  `UnityWebRequest` API 允许开发人员精确地指定Unity应如何处理下载的数据，并允许开发人员消除不必要的内存使用。使用 `UnityWebRequest` 下载 `AssetBundle` 的最简单方法是调用 `UnityWebRequest.GetAssetBundle`。
*  WWW.LoadFromCacheOrDownload (on Unity 5.6 or older)  
  从Unity 2017.1开始，就只是简单地包装了UnityWebRequest。Unity已经放弃了对改接口的维护，并可能在未来的某个版本中移除。

### 加载方式建议
1. 一般来说，只要有可能，就应该使用 `AssetBundle.LoadFromFile`。这个API在速度、磁盘使用和运行时内存使用方面是最有效的。
2. 对于必须下载或热更新 `AssetBundles` 的项目，强烈建议对使用Unity 5.3或更高版本的项目使用 `UnityWebRequest` ，对于使用Unity 5.2或更老版本的项目使用`WWW.LoadFromCacheOrDownload`。
3. 当使用 `UnityWebRequest` 或 `WWW.LoadFromCacheOrDownload` 时，要确保下载程序代码在加载 `AssetBundle` 后正确地调用 `Dispose` 。另外，`C#` 的 `using` 语句是确保 `WWW` 或 `UnityWebReques` t被安全处理的最方便的方法。
4. 对于需要独特的、特定的缓存或下载需求的大项目，可以考虑使用自定义的下载器。编写自定义下载程序是一项重要并且复杂的任务，任何自定义的下载程序都应该与 `AssetBundle.LoadFromFile` 保持兼容。


### 从 AssetBundles 中加载 Assets

Unity 提供了三个不同的 API 从 `AssetBundles` 加载 `UnityEngine.Objects` ，这些API都绑定到AssetBundle对象上。

```c#
LoadAsset (LoadAssetAsync)
LoadAllAssets (LoadAllAssetsAsync)
LoadAssetWithSubAssets (LoadAssetWithSubAssetsAsync)
```

这些 API 的 同步版本 总是比 异步版本 快至少一个帧（其实是因为异步版本为了确保异步，都至少延迟了1帧），异步加载每帧会加载多个对象，直到它们的时间切片切出。

`LoadAllAsset` 比对 `LoadAsset` 的多个单独调用略快一些。因此，如果要加载的 `Asset` 数量很大，但如果需要一次性加载不到三分之二的 `AssetBundle` ，则要考虑将 `AssetBundle` 拆分为多个较小的包，再使用 `LoadAllAsset` 。

加载包含多个嵌入式对象的复合 `Asset` 时，应使用 `LoadAssetWithSubAsset` ，例如嵌入动画的FBX模型或嵌入多个精灵的 `sprite` 图集。也就是说，如果需要加载的对象都来自同一 `Asset` ，但与许多其它无关对象一起存储在 `AssetBundle` 中，则使用此API。

**任何其它情况**，请使用 `LoadAsset` 或 `LoadAssetAsync` 。

### 其他加载细节

`AssetBundle` 之间的加载没有先后，但是 `Asset` 的加载有。加载 `AssetBundle` 和 从 `AssetBundles` 中加载 `Assets` 是两件事情。

`Object` 加载是在 主线程 上执行，但 数据 从 工作线程上 的存储中读取。任何不触碰 Unity 系统中线程敏感部分（脚本、图形）的工作都将在工作线程上转换。例如，VBO将从网格创建，纹理将被解压等等。

从Unity 5.3开始， Object 加载就被并行化了。在 工作线程 上反序列化、处理和集成多个Object。当一个Object完成加载时，它的 Awake 回调将被调用，该对象的其余部分将在 下一个帧 中对 UnityEngine 可用。

同步 `AssetBundle.Load` 方法将暂停 主线程，直到 Object 加载完成。但它们也会加载时间切片的 Object ，以便 Object 集成不会占用太多的毫秒帧时间。应用程序属性设置毫秒数的属性为 `Application.backgroundLoadingPriority`。
* ThreadPriority.High：每帧最多50毫秒
* ThreadPriority.Normal：每帧最多10毫秒
* ThreadPriority.BelowNormal：每帧最多4毫秒
* ThreadPriority.Low：每帧最多2毫秒


## AssetBundle 的卸载

```
public void Unload(bool unloadAllLoadedObjects);
```

调用 `Unload` 都可以 `Destroy` 当前 `AssetBundle` 对象，释放之前从 `AssetBundle` 文件中的 `Header` 部分所获取的信息。当然，被释放的 `AssetBundle` 对象无法再使用诸如 `LoadAsset LoadAllAssets` 等函数加载资源。

### `unloadAllLoadedObjects == true`

不仅 `Destroy` 了 `AssetBundle` 这个对象 和 包含的所有对象，而且实例化的也统统释放掉。释放掉之后就算重新加载，因为重新加载重新生成 InstanceID 的不同，而不会重新建立引用关系。

不会有重复资源问题的情况发生，每次都处理的干干净净。

### `unloadAllLoadedObjects == false`

仅仅 `Destroy` 了 `AssetBundle` 这个对象，但是并没有释放这个 `AssetBundle` 下的任何 `Asset` ，因此如果有对象引用了这些 `Asset` ，也不会有问题。
它的风险是，下次再 `Load` 这个 `AssetBundle` ，并且通过这个 `AssetBundle` 重新读取了这个 `Asset` ，会在内存中重新创建一份，这样如果之前的 `Asset` 没有被释放，那么现在内存中就有两份 `Asset` 了。
**适用于读取一次，使用一次之后，再也不使用?的情况。**

## 参考
* [Unity Doc AssetBundle](https://docs.unity3d.com/cn/current/Manual/AssetBundlesIntro.html)
* [程序丨入门必看：Unity资源加载及管理](https://mp.weixin.qq.com/s/0XFQt8LmqoTxxst_kKDMjw)
* [Unity文件、文件引用、meta详解](https://www.cnblogs.com/CodeGize/p/8697227.html)
* [AssetBundle的原理及最佳实践](https://blog.uwa4d.com/archives/USparkle_Addressable3.html)