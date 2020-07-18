# Unity 资源



## AssetBundle

AssetBundle 是一个存档文件，针对不同的平台会需要进行不同的打包，它包含可在运行时加载的特定于平台的资源（模型、纹理、预制件、音频剪辑甚至整个场景）。


### 生成 AssetBundle

每一次调用 `BuildPipleLine.BuildAssetBundles` 时，将会生成一批 `AssetBundle` 文件，具体数量根据传递 `AssetBundleBuild` 数组决定，每一个 `AssetBundleBuild` 对象将对应一个 `AssetBundle` 及一个同名 `.manifest` 后缀文件。其中 `AssetBundle` 文件的后缀用户自行设置，比如 `.unity3d` ， `.ab` 等等；而 `.manifest` 文件是给人看的，里面有这个 `AssetBundle` 的基本信息以及非常关键的资源列表。

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

### AssetBundle的加载

将 `AssetBundle` 的加载拆分理解为： `Bundle` 加载和 `Asset` 加载两部分。

 * 记录文件标记、压缩信息、文件列表的 `Header` 部分；
 * 记录资源实际内容的 `Data` 部分。

使用 `AssetBundle.LoadFromFile` 或 `AssetBundle.LoadFromFileAsync` 时， ，Unity 仅会为我们读取 `AssetBundle` 的 `header` 部分，并不会将 `data` 部分整个读入内存。

当调用上一步生成的 `AssetBundle` 对象读取具体资源时 `LoadAsset LoadAssetAsync LoadAllAssets`，Unity 会参考已经缓存的文件列表，找到目标资源在 `data` 部分的位置并读入到内存中。如果一个资源引用到了其他资源，则必须要先读入被引用资源的 `AssetBundle` 文件，否则就会发生引用 `Miss` 。

为了避免上面 `Miss` 的情况，在加载资源时，首先需要将该资源的依赖项全部加载完毕，不过仅需加载依赖资源的 `AssetBundle` 文件。也就是说，我们只要将该依赖 `AssetBundle` 的 `Header` 部分加载 `AssetBundle.LoadFromFile` 或 `AssetBundle.LoadFromFileAsync` 就可以，这样在真正读取 `Asset` 时，Unity 会自动处理好真实依赖的 `Asset` ，我们不用操心。

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


### AssetBundle 的卸载

```
public void Unload(bool unloadAllLoadedObjects);
```

调用 `Unload` 都可以 `Destroy` 当前 `AssetBundle` 对象，释放之前从 `AssetBundle` 文件中的 `Header` 部分所获取的信息。当然，被释放的 `AssetBundle` 对象无法再使用诸如 `LoadAsset LoadAllAssets` 等函数加载资源。

`unloadAllLoadedObjects == true`

不仅 `Destroy` 了 `AssetBundle` 这个对象 和 包含的所有对象，而且实例化的也统统释放掉。释放掉之后就算重新加载，因为重新加载重新生成 InstanceID 的不同，而不会重新建立引用关系。

不会有重复资源问题的情况发生，每次都处理的干干净净。

`unloadAllLoadedObjects == false`

仅仅 `Destroy` 了 `AssetBundle` 这个对象，但是并没有释放这个 `AssetBundle` 下的任何 `Asset` ，因此如果有对象引用了这些 `Asset` ，也不会有问题。
它的风险是，下次再 `Load` 这个 `AssetBundle` ，并且通过这个 `AssetBundle` 重新读取了这个 `Asset` ，会在内存中重新创建一份，这样如果之前的 `Asset` 没有被释放，那么现在内存中就有两份 `Asset` 了。
适用于读取一次，使用一次之后，再也不适用的情况。

## 参考
* [Unity Doc AssetBundle](https://docs.unity3d.com/cn/current/Manual/AssetBundlesIntro.html)
* [程序丨入门必看：Unity资源加载及管理](https://mp.weixin.qq.com/s/0XFQt8LmqoTxxst_kKDMjw)
* [Unity文件、文件引用、meta详解](https://www.cnblogs.com/CodeGize/p/8697227.html)