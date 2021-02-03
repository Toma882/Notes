# Unity RectTransform

> Center  
> `Center` 是 Unity 根据模型 mesh 计算得出的中心位置，与模型的大小和形状有关系。

https://www.cnblogs.com/Fflyqaq/p/12714387.html
https://zhuanlan.zhihu.com/p/139252379


`RectTransforms` 用于 GUI，不过也可以用于其他情况。 它用于存储和操作矩形的位置、大小和锚定，并支持各种形式的缩放（基于父 `RectTransform` ）。

## `Anchors`
取值范围`[0-1]`，

`Anchors` 有4片小三角组成，合并在一起的时候像极了花瓣。

`Anchors` 默认合并在一起，值为 `Min(0.5, 0.5) Max(0.5, 0.5)`，显示的是`PoxX PoxY PoxZ`

`Anchors` 若分开，可以把它看成一个矩形，左下角为 Min 的值，右上角为 Max 的值，有可能显示的是 `Left Rigth Top Bottom`


关于父节点  
如果没有父节点没有 `RectTransform` ，那么 `RectTransform` 属性面板上的 `Anchor Presets` 将不可设置，但 `Anchors` 仍可设置。

// 重写  
`Anchors` 锚点的(0, 0)点，可以理解为自己在父对象的(0, 0)点的位置
所谓的 `Anchors` 锚点，指的是自己（也就是子节点）的 `Pivot` 在 Parent 父节点上的相对位置，对应了 `anchoredPosition3D(PosX，PosY，PosZ)`，或 `anchoredPosition(PosX，PosY)`



## `anchoredPosition`
此 `RectTransform` 的轴心相对于 锚点`Pivot` 参考点的位置。

## `anchoredPosition3D`
此 `RectTransform` 的轴心相对于 锚点`Pivot` 参考点的 3D 位置。

## `localPosition`
相对于父对象中心点的偏移坐标

## `anchorMax`
父 `RectTransform` 中右上角锚定到的标准化位置。
## `anchorMin`
父 `RectTransform` 中左下角锚定到的标准化位置。
## `offsetMax`
矩形右上角相对于右上锚点的偏移。
## `offsetMin`
矩形左下角相对于左下锚点的偏移。
## `pivot`
此 `RectTransform` 中围绕其旋转的标准化位置。
## `rect`
`Transform` 的本地空间中计算的矩形。
Rect(x, y, width, height)

`rect.x，rect.y` 是以 `Pivot` 为原点 到 UI左下角 的坐标。  
`rect.width，rect.height`是 UI的宽度和高度。


## `sizeDelta`
此 `RectTransform` 相对于锚点之间距离的大小。几何定义可以理解为 `RectTransform` 的区域 与 `Anchors` 区域的差值

`sizeDelta = offsetMax - offsetMin`