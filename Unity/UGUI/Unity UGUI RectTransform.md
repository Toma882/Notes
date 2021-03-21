# Unity RectTransform

> Center  
> `Center` 是 Unity 根据模型 mesh 计算得出的中心位置，与模型的大小和形状有关系。
>
> Pivot  
> Pivot 是 用户根据图形设定的中心位置


`RectTransforms` 用于 GUI，不过也可以用于其他情况。 它用于存储和操作矩形的位置、大小和锚定，并支持各种形式的缩放（基于父 `RectTransform` ）。

## `Anchors`

`Anchors` 指的是 `Anchor Min & Anchor Max`，取值范围`[0-1]`，有4片小三角组成，合并在一起的时候像极了花瓣。

`Anchors` 根据位置特点分为 **锚点合并** 和 **锚点分开** 两种情况，下面的内容也根据此进行描述。

**锚点合并**  
`Anchors` 默认合并，值为 `Min(0.5, 0.5) Max(0.5, 0.5)`，显示的是`PoxX PoxY PoxZ`。此时锚点代表的是自己作为子节点在父节点上的 `(0, 0)` 点的位置， `PoxX PoxY PoxZ` 是相当于锚点位置的偏移量。

**锚点分开**  
`Anchors` 分开时，可以把4片三角形的位置看成一个矩形，我们可以称之为锚点矩形（可压缩成一条线）。四个顶点中，左下角坐标为 `Min 的 (X, Y)` 值，右上角为` Max 的 (X, Y)` 值，那么左上角可以理解为 `(Min_X, Max_Y)`，右下角可以理解为 `(Max_X, Min_Y)`，根据实际情况，对应的 `PoxX PoxY PoxZ` 有可能由 `Left Rigth Top Bottom` 来代替表示。此时锚点代表的是根据父节点的图形大小，由`Left Rigth Top Bottom`算出来的矩形范围。


**关于父节点**  
如果没有父节点没有 `RectTransform` ，那么 `RectTransform` 属性面板上的 `Anchor Presets` 将不可设置，但 `Anchors` 仍可设置。


## `AnchoredPosition`

**锚点合并**   
对象 Anchors 到 对象 Pivot 的偏移坐标。

**锚点分开**  
对象 Anchors 锚点矩形的中心点 到子对象 Pivot 的偏移坐标。

## `AnchoredPosition3D`
同 `AnchoredPosition` 概念


## `localPosition`
子对象 Pivot 相对于 父对象Pivot 的偏移坐标

在 `Screen Space——Overlay` 的模式下，由于 Canvas 的世界尺寸与其像素尺寸在数值上相等，因此其 `rectTransform` 的 `position` 与其在屏幕空间的坐标在数值上也相等。这种模式下，要获取某个 `RectTransform` 的屏幕坐标，直接使用 `position` 就可以。

在 `Screen Space——Camera` 的模式和 `World Space` 下， `RectTransform` 的渲染与摄像机有关，在获取其屏幕坐标时，需要利用 `canvas.worldCamera` ，或者 `transform.TransformPoint` 等坐标转换函数进行坐标转换。


## `offsetMax` `offsetMin`
**锚点合并** & **锚点分开**  
`offsetMax` 即为 对象矩形 右上角 相对于 Anchors锚点 的偏移坐标   
`offsetMin` 即为 对象矩形 左下角 相对于 Anchors锚点 的偏移坐标

## `rect`
`Transform` 的本地空间中计算的矩形。
Rect(x, y, width, height)

`rect.x，rect.y` 是 对象矩形左下角 相对于 `Pivot` 的偏移坐标。  
`rect.width，rect.height`是 UI的宽度和高度。


## `sizeDelta`
此 `RectTransform` 相对于锚点之间距离的大小。  
几何定义可以理解为 `RectTransform` 的区域 与 `Anchors` 区域的差值。差值有可能为负数。

```
sizeDelta.x = offsetMax.x - offsetMin.x
sizeDelta.y = offsetMax.y - offsetMin.y
```

## `GetLocalCorners (Vector3[] fourCornersArray)`

`public void GetLocalCorners (Vector3[] fourCornersArray);`

获取计算的矩形在其 Transform 的本地空间中的各个角。  
每个角都提供其本地空间值。4 个顶点的 返回数组是顺时针的。它从左下开始，旋转到左上， 然后到右上，最后到右下。请注意，左下（举例 而言）是一个 (x, y, z) 矢量，其中 x 是左，y 是下。  
注意：如果 RectTransform 在 Z 中旋转，则 GetWorldCorners 的尺寸 不会更改。

```c#
    RectTransform rt;
    void Start()
    {
        rt = GetComponent<RectTransform>();
        DisplayLocalCorners();
    }
    void DisplayLocalCorners()
    {
        Vector3[] v = new Vector3[4];

        rt.rotation = Quaternion.AngleAxis(45, Vector3.forward);
        rt.GetLocalCorners(v);

        Debug.Log("Local Corners");
        for (var i = 0; i < 4; i++)
        {
            Debug.Log("Local Corner " + i + " : " + v[i]);
        }
    }
```

## `GetWorldCorners (Vector3[] fourCornersArray);`

`public void GetWorldCorners (Vector3[] fourCornersArray);`

获取计算的矩形在世界空间中的各个角。  
每个角都提供其世界空间值。4 个顶点的 返回数组是顺时针的。它从左下开始，旋转到左上， 然后到右上，最后到右下。请注意，左下（举例 而言）是一个 (x, y, z) 矢量，其中 x 是左，y 是下。  
注意：如果 RectTransform 在 Z 中旋转，则 GetWorldCorners 的尺寸 会更改。

```c#
    RectTransform rt;
    void Start()
    {
        rt = GetComponent<RectTransform>();
        DisplayWorldCorners();
    }
    void DisplayWorldCorners()
    {
        Vector3[] v = new Vector3[4];
        rt.GetWorldCorners(v);

        Debug.Log("World Corners");
        for (var i = 0; i < 4; i++)
        {
            Debug.Log("World Corner " + i + " : " + v[i]);
        }
    }
```

## 改变宽高
RectTransform
```c#
public void SetSizeWithCurrentAnchors (Animations.Axis axis, float size);

// edge	要相对于其进行内嵌的父矩形边缘。
// inset	内嵌距离。
// size	矩形在内嵌相同方向上的大小。
public void SetInsetAndSizeFromParentEdge (Experimental.UIElements.GraphView.Edge edge, float inset, float size);
```

RectTransformUtility
```c#
// 翻转 RectTransform 大小和对齐方式的水平和垂直轴，可以选择同时翻转其子级。
public static void FlipLayoutAxes (RectTransform rect, bool keepPositioning, bool recursive);
// 沿水平或垂直轴翻转 RectTransform 的对齐方式，可以选择同时翻转其子级。
public static void FlipLayoutOnAxis (RectTransform rect, int axis, bool keepPositioning, bool recursive);
// 将屏幕空间中的给定点转换为像素校正点。
public static Vector2 PixelAdjustPoint (Vector2 point, Transform elementTransform, Canvas canvas);
// 根据给定的一个矩形变换，返回像素精确坐标中的角点。
public static Rect PixelAdjustRect (RectTransform rectTransform, Canvas canvas);
// 此 RectTransform 是否包含从给定摄像机观察到的屏幕点
public static bool RectangleContainsScreenPoint (RectTransform rect, Vector2 screenPoint, Camera cam);
// 将一个屏幕空间点转换为 RectTransform 的本地空间中位于其矩形平面上的一个位置。
public static bool ScreenPointToLocalPointInRectangle (RectTransform rect, Vector2 screenPoint, Camera cam, out Vector2 localPoint);
// 将一个屏幕空间点转换为世界空间中位于给定 RectTransform 平面上的一个位置。
public static bool ScreenPointToWorldPointInRectangle (RectTransform rect, Vector2 screenPoint, Camera cam, out Vector3 worldPoint);
```

**锚点合并**  
设置 `sizeDelta`

**锚点分开**  
```c#
// rect width
rectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, 200);
// rect height
rectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, 200);
```

`SetInsetAndSizeFromParentEdge(edge, inset, size)`
可以根据父类的某个边，设置大小和间距（注意此方法会改变Anchors的位置）：

```c#
// edge：是父类的边，Left，Right，Top，Bottom
// inset：子类边到父类边的间距
// size：在边方向上的大小，如：Left和Right对应Width，Top和Bottom对应Height
// 以下两个方法
// 可以将子类（Top，Left）边，定位到距离父类（Top，Left）边各100像素的地方
// 并且设置子类大小为（400，400）
SetInsetAndSizeFromParentEdge(RectTransform.Edge.Top,  100, 400);
SetInsetAndSizeFromParentEdge(RectTransform.Edge.Left, 100, 400);
```

## 参考

* [UGUI---RectTransform、锚点、轴心点详解](https://www.cnblogs.com/Fflyqaq/p/12714387.html)
* [Unity3D RectTransform使用详解：布局、属性、方法](https://zhuanlan.zhihu.com/p/139252379)
