# Unity RectTransform

> Center  
> `Center` 是 Unity 根据模型 mesh 计算得出的中心位置，与模型的大小和形状有关系。
>
> Pivot  
> Pivot 是 用户根据图形设定的中心位置

https://www.cnblogs.com/Fflyqaq/p/12714387.html
https://zhuanlan.zhihu.com/p/139252379


`RectTransforms` 用于 GUI，不过也可以用于其他情况。 它用于存储和操作矩形的位置、大小和锚定，并支持各种形式的缩放（基于父 `RectTransform` ）。

## `Anchors`

`Anchors` 取值范围`[0-1]`，有4片小三角组成，合并在一起的时候像极了花瓣。

`Anchors` 根据位置特点分为 **锚点合并** 和 **锚点分开** 两种情况，下面的内容也根据此进行描述。

**锚点合并**  
`Anchors` 默认合并，值为 `Min(0.5, 0.5) Max(0.5, 0.5)`，显示的是`PoxX PoxY PoxZ`。此时锚点代表的是自己作为子节点在父节点上的 `(0, 0)` 点的位置， `PoxX PoxY PoxZ` 是相当于锚点位置的偏移量。

**锚点分开**  
`Anchors` 分开时，可以把4片三角形的位置看成一个矩形，我们可以称之为锚点矩形（可压缩成一条线）。四个顶点中，左下角坐标为 `Min 的 (X, Y)` 值，右上角为` Max 的 (X, Y)` 值，那么左上角可以理解为 `(Min_X, Max_Y)`，右下角可以理解为 `(Max_X, Min_Y)`，根据实际情况，对应的 `PoxX PoxY PoxZ` 有可能由 `Left Rigth Top Bottom` 来代替表示。此时锚点代表的是根据父节点的图形大小，由`Left Rigth Top Bottom`算出来的矩形范围。


**关于父节点**  
如果没有父节点没有 `RectTransform` ，那么 `RectTransform` 属性面板上的 `Anchor Presets` 将不可设置，但 `Anchors` 仍可设置。



## `AnchoredPosition`
`AnchoredPosition` 取值范围是正常的。

**锚点合并**   
锚点 到 Pivot 中心点的向量值


**锚点分开**  
锚点矩形的中心点 到 Pivot 中心点的向量值


## `AnchoredPosition3D`
`AnchoredPosition` 取值范围是正常的。

**锚点合并**   
锚点 到 Pivot 中心点的向量值


**锚点分开**  
锚点矩形的中心点 到 Pivot 中心点的向量值

## `localPosition`
相对于父对象中心点的偏移坐标

在 `Screen Space——Overlay` 的模式下，由于 Canvas 的世界尺寸与其像素尺寸在数值上相等，因此其 `rectTransform` 的 `position` 与其在屏幕空间的坐标在数值上也相等。这种模式下，要获取某个 `RectTransform` 的屏幕坐标，直接使用 `position` 就可以。

在 `Screen Space——Camera` 的模式和 `World Space` 下， `RectTransform` 的渲染与摄像机有关，在获取其屏幕坐标时，需要利用 `canvas.worldCamera` ，或者 `transform.TransformPoint` 等坐标转换函数进行坐标转换。

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