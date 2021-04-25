# FGUI
版本 FairyGUI-Editor_2021.1.0

FairyGUI的项目在文件系统的结构为：

* `assets` 包内容放置目录。
  * `package1` 每个包一个目录。目录名就是包名。
* `assets_xx` 分支内容放置目录，xx是分支名称。多个分支则存在多个类似名称的目录。
* `settings` 配置文件放置目录。
* `.objs` 内部数据目录。**注意：不要加入版本管理，因为这里的内容是不需要共享的。**
* `test.fair`y 项目标识文件。文件名就是项目名称，可以随便修改。


## 目录
- [FGUI](#fgui)
  - [目录](#目录)
  - [注意点](#注意点)
  - [优点](#优点)
    - [项目类型](#项目类型)
    - [一般不再使用 TexturePacker](#一般不再使用-texturepacker)
    - [设计图功能](#设计图功能)
    - [对齐和排列](#对齐和排列)
    - [测试界面](#测试界面)
    - [支持表情显示和直接输入](#支持表情显示和直接输入)
    - [虚拟列表](#虚拟列表)
    - [支持从右向左的阿拉伯语言文字显示](#支持从右向左的阿拉伯语言文字显示)
    - [发布时自动清空](#发布时自动清空)
  - [缺点](#缺点)
    - [打包多一份 FGUI SDK](#打包多一份-fgui-sdk)
    - [需要熟悉 FGUI API](#需要熟悉-fgui-api)
    - [FGUI 不是 UGUI](#fgui-不是-ugui)
    - [特效的支持](#特效的支持)
    - [FGUI 不处理包依赖，需要开发者手动调用](#fgui-不处理包依赖需要开发者手动调用)
  - [其它](#其它)
    - [`FairyGUI_GenCode_Lua`](#fairygui_gencode_lua)
    - [Transform vs UI Transform](#transform-vs-ui-transform)
    - [关于适配](#关于适配)
    - [字体](#字体)
    - [GRoot & Window](#groot--window)
    - [资源URL地址](#资源url地址)
    - [XXXBinder](#xxxbinder)


## 注意点

* 请不要使用带中文的路径。
* 设置为导出  
  包内的每个资源都有一个是否导出的属性，已导出的资源的图标右下角有一个小红点。**一个包只能使用其他包设置为已导出的资源**，而设置为不导出的资源是不可访问的。同时，只有**设置为导出的组件才可以使用代码动态创建**。
* FairyGUI 坐标原点为屏幕的左上角

* fnt 图片字体直接复制即可使用
* 资源URL地址
* 划分包的原则：避免A包使用B包的资源，B包使用C包的资源这类情况
* Generate Mip Maps 默认勾选，应该 unchecked

## 优点

### 项目类型

UI项目类型，即UI实际运行的平台。不同的平台在显示效果、发布结果上有一定的差别。不过不需要担心这里选择错了项目类型，在项目创建后可以随时调整UI项目类型，操作位置在菜单“文件->项目设置”里。

### 一般不再使用 TexturePacker

一开始都是碎图，导出后自动生成合图。

### 设计图功能

可以设定一个组件的设计图。设计图将显示在舞台上，可以设置显示在组件内容的底层或者上层。使用设计图可以使拼接UI更加快速和精准。**设计图不会发布到最终的资源中。**



###  对齐和排列

对齐功能：

* 左对齐
* 右对齐
* 上对齐
* 下对齐
* 上下居中对齐
* 左右居中对齐
* 相同高度
* 相同宽度

排列：

* 均匀行距
* 均匀列距
* 表格

### 测试界面

除了基本的 UI 测试功能之外，还可以进行各种机型的 适配测试。

### 支持表情显示和直接输入

### 虚拟列表

### 支持从右向左的阿拉伯语言文字显示

### 发布时自动清空

## 缺点


### 打包多一份 FGUI SDK
### 需要熟悉 FGUI API

### FGUI 不是 UGUI

不再使用 RectTransform

### 特效的支持

简单的特效可以直接支持，丰富的特效还是需要导出 Unity 物件再跟 FairyGUI 结合


### FGUI 不处理包依赖，需要开发者手动调用

```c#
UIPackage pkg;
var dependencies = pkg.dependencies;
foreach(var kv in dependencies)
{
    Debug.Log(kv["id"]); //依赖包的id
    Debug.Log(kv["name"]); //依赖包的名称
}
```

## 其它

发布路径支持使用变量，变量用中括号包围，例如：`/home/zhansan/{publish_file_name}`。支持的变量名：

* `publish_file_name` 表示发布的文件名。
* `branch_name` 表示发布的分支名。
* “项目设置-自定义属性”里定义的属性。假设自定义属性里有 `var1` ，那么路径里可以使用 `{var1}`。


### `FairyGUI_GenCode_Lua`

1. 本项目理论上适用使用 Lua 作为UI逻辑的游戏引擎，但只在 Unity 引擎下进行了测试。
2. 使用本插件前，需要先熟悉编辑器发布代码的功能，并开启发布代码。
3. 使用 编辑器—项目设置—自定义属性 为插件功能赋值。

```
local customPropKeys = {
    key_gen_lua = { name = "key_gen_lua", default_value = "true" },
    key_lua_file_extension_name = { name = "key_lua_file_extension_name", default_value = "lua" },
    key_lua_path_root = { name = "key_lua_path_root", default_value = "UIGenCode/" },
    key_wrapper_namespace = { name = "key_wrapper_namespace", default_value = "" },
}
```

* key_gen_lua 是否生成Lua代码，默认为值 true
* key_lua_file_extension_name Lua文件的扩展名，默认值为 lua
* key_lua_path_root 生成文件相对于Lua执行根路径的相对路径，默认值为 UIGenCode/
* key_wrapper_namespace 框架层 FairyGUI 导出代码的命名空间，默认值为 CS.FairyGUI
4. 生成文件是根据模板文件 component_template.txt 和 binder_template.txt 生成，以 $XXX 作为占位符，可以在此基础上继续自定义扩展。
5. 使用生成文件示例:

```
require("UIGenCode.init");
UI_DemoComponent:CreateInstance();
  GRoot.inst:AddChild(UI_DemoComponent.__ui);
UI_DemoComponent.m_btn_login.onClick:Add(function()
      print("btn clicked");
  end);
```
* 绑定类是自动调用绑定方法的，只需要引入一次 init.lua 文件即可。
* 为了使用方便，生成的组件类都是全局名称，这一点需要注意。如果不需要生成全局名称，则修改插件源码。
* 组件实例默认赋值为 __ui 对象，为了防止被组件子级覆盖，使用了双下划线命名。
* 不要手动修改生成文件，以免被下一次生成覆盖，更好的办法是修改插件源码和模板文件。

### Transform vs UI Transform

* 当 Render Mode 是 Screen Space 时，建议使用 UI Transform 设置UI的位置。
* 当 Render Mode 是 World Space 时，建议使用 Transform 设置UI的位置。

### 关于适配
FairyGUI 推荐的是在 FairyGUI 编辑器中整体设计，而不是在 Unity 里摆放小元件。例如如果需要不同的 UI 在屏幕上的各个位置布局，你应该在 FairyGUI 编辑器中创建一个全屏大小的组件，然后在里面放置各个子组件，再用关联控制布局；最后将这个全屏组件放置到 Unity，将 Fit Screen 设置为 Fit Size 即可。错误的做法是把各个子组件放置到Unity里再布局。

### 字体

使用 TTF 字体时，需要把字体复制到 `C:\Windows\Fonts` 下面，然后再项目设置里面选择相应的字体 或者 将字体文件拖入编辑器，成为字体资源，支持文件名称后缀为 `ttf/ttc/otf` 的文件。可以将字体资源拖入下图中的输入框，也可以在项目字体列表中选择。

**无论字体是否设置为导出，它都不会被发布**。UI包发布后，引用此字体资源的文本元件的字体名称是该字体的资源名字。例如，一个文本元件，它的字体设置为Basics包的afont资源，那么发布后，它的字体属性是 `afont` ，而不是` ui://Basics/afont` 。


```c#
//假设afont.ttf是放在Resources目录下
FontManager.RegisterFont(new DynamicFont("afont"));
```

全局字体

```c#
//Droid Sans Fallback是安卓上支持中文的默认字体
UIConfig.defaultFont = 'Droid Sans Fallback'; 
```

### GRoot & Window

`GRoot` 是 2D UI 的**根容器**。当我们通过 `UIPackage.CreateObject` 创建出顶级UI界面后，将它添加到 `GRoot` 下。例如游戏的登录界面、主界面等，这类界面的特点是在游戏的底层，且比较固定。

`Window` 的本质也是通过 `UIPackage.CreateObject` 动态创建的顶级UI界面，但它提供了常用的窗口特性，比如自动排序，显示/隐藏流程，模式窗口等。适用于游戏的对话框界面，例如人物状态、背包、商城之类。这类界面的特点是在游戏的上层，且切换频繁。

窗口自动排序

默认情况下， `Window` 是具有点击自动排序功能的，也就是说，你点击一个窗口，系统会自动把窗口提到所有窗口的最前面，这也是所有窗口系统的规范。但你可以关闭这个功能：

```c#
UIConfig.bringWindowToFrontOnClick = false;
```

### 资源URL地址

在FairyGUI中，每一个资源都有一个URL地址。选中一个资源，右键菜单，选择“复制URL”，就可以得到资源的URL地址。无论在编辑器中还是在代码里，都可以通过这个URL引用资源。例如设置一个按钮的图标，你可以直接从库中拖入，也可以手工粘贴这个URL地址。这个URL是一串编码，并不可读，在开发中使用会造成阅读困难，所以我们通常使用另外一种格式：ui://包名/资源名。两种URL格式是通用的，一种不可读，但不受包或资源重命名的影响；另一种则可读性较高。

**注意：`ui://包名/资源名`这个格式的地址是不包含文件夹的，只需要用到包名和资源名。**

运行时要获得指定对象的URL地址，可以使用如下方法：

```c#
//对象的URL地址
Debug.Log(aObject.resourceURL);

//对象在资源库中的名称
Debug.Log(aObject.packageItem.name);

//对象所在包的名称
Debug.Log(aObject.packageItem.owner.name);

//根据URL获得资源名称
Debug.Log(UIPackage.GetItemByURL(resourceURL).name);
```


### XXXBinder

发布出来的代码包含一个 XXXBinder 文件和多个类文件。注意：

在使用绑定类之前，一定要调用XXXBinder.BindAll，并且在创建任何UI之前调用。
使用绑定类创建UI的API是CreateInstance，不能直接new。
举例：
```c#
    //首先要调用BindAll。发布出来的代码有个名字为XXXBinder的文件
    //注意：一定要在启动时调用。
    XXXBinder.BindAll();

    //创建UI界面。注意：不是直接new XXX。
    XXX view = XXX.CreateInstance();
    view.m_n10.text = ...;
```

Lua 扩展部分 

https://www.fairygui.com/docs/unity/lua#%E8%87%AA%E5%AE%9A%E4%B9%89%E6%89%A9%E5%B1%95