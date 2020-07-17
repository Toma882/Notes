# Unity 资源

## Asset & Object
无论是纹理、音乐还是预制体，在进入 Unity 的世界后，都变成了各种对象供我们使用，例如纹理转变为 `Texture2D` 或 `Sprite` ，音效文件转变为 `AudioClip` ，预制体变成了 `GameObject` 等等。这个由 `Asset` (资源文件)转变为 `Object` (对象)，从磁盘进入内存的过程，就是实例化。而对资源进行的管理，本质上是对 `Object` 的管理。

## Asset
Unity 会为每一个加入到 `Assets` 文件夹中的文件，创建一个同级同名的 `.meta` 文件，虽然文件类型的不同会影响这个 `.meta` 的具体内容，但它们都包含一个用来标记文件身份的 `File GUID`。