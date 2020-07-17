# Unity多平台切换


Unity 在针对不同的平台进行打包时，平台之间的转化变得很慢，因此我们可以把不同的平台复制多个工程，在打包时把 Assets、Packages 和 ProjectSettings 文件夹放入其他平台的文件夹中进行编译即可。

那如何进行修改一个地方，其他地方也可以修改完成呢？
可以使用 [Link Sheel Extension](https://schinagl.priv.at/nt/hardlinkshellext/linkshellextension.html)