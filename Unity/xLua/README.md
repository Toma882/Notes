# xLua
https://github.com/Tencent/xLua

## 热补丁操作指南
1、打开该特性

添加HOTFIX_ENABLE宏，（在Unity3D的File->Build Setting->Scripting Define Symbols下添加）。编辑器、各手机平台这个宏要分别设置！如果是自动化打包，要注意在代码里头用API设置的宏是不生效的，需要在编辑器设置。

（建议平时开发业务代码不打开HOTFIX_ENABLE，只在build手机版本或者要在编译器下开发补丁时打开HOTFIX_ENABLE）

2、执行XLua/Generate Code菜单。

3、注入，构建手机包这个步骤会在构建时自动进行，编辑器下开发补丁需要手动执行"XLua/Hotfix Inject In Editor"菜单。打印“hotfix inject finish!”或者“had injected!”才算成功，否则会打印错误信息。

如果已经打印了“hotfix inject finish!”或者“had injected!”，执行xlua.hotfix仍然报类似“xlua.access, no field __Hitfix0_Update”的错误，要么是该类没配置到Hotfix列表，要么是注入成功后，又触发了编译，覆盖了注入结果。

## 常见出错

* `error CS0246: The type or namespace name 'ILGenerator' could not be found (are you missing a using directive or an assembly reference?)`  
  
    可以查阅xLua的FAQ文档的 **Unity 2018及以上版本兼容性问题解决** 
https://github.com/Tencent/xLua/blob/master/Assets/XLua/Doc/faq.md

    解决办法（三选一）：  
    1. 把 `Scripting Backend` 设置为 `3.5`
    2. 把 `Api Compatibility Level` 设置为 `.Net 4.x`
    3. 更新 xLua 到2019年1月8号后面的版本，可以解决编译问题，但由于没有emit的支持，编辑器下要生成代码才能跑了，建议执行 `XLua/Generate Minimize Code` ，这个少生成些代码。

    在这我选择了第二种把 `Api Compatibility Level` 设置为 `.Net 4.x`，来暂时解决这个问题

