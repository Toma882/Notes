# Unity 2D 层级关系

Unity 根据优先级顺序对渲染器进行排序，而优先级顺序取决于渲染器的类型和用途。可以通过 渲染队列 (Render Queue) 指定渲染器的渲染顺序。通常有两个主要队列：不透明队列 (the Opaque queue) 和 透明队列 (the Transparent queue)。

2D 渲染器主要位于 透明队列(the Transparent queue) 中，包括 精灵渲染器 (Sprite Renderer)、 瓦片地图渲染器 (Tilemap Renderer) 和 精灵形状渲染器 (Sprite Shape Renderer) 类型。

## 透明队列 (the Transparent queue) 按优先级排序

透明队列 (the Transparent queue) 中的 2D 渲染器通常遵循以下优先级顺序：

1. Camera
2. Sorting Layer and Order in Layer
3. Specify Render Queue
4. Distance to Camera
   1. Perspective/Orthographic
   2. Custom Axis sort mode
   3. Sprite Sort Point
5. Sorting Group
6. Material/Shader
7. A Tiebreaker occurs when multiple Renderers have the same sorting priorities.

#### Camera
当 Canvas 的 `Render Mode` 使用 `Screen Space - Camera` 或者 `World Space`，若不同的 Canvas 的 `Render Camera` 对应不同的 Camera，那么就要看其对应的 Camera 的 `Depth` 属性， `Depth` 越大那么越在前面。

#### Sorting Layer and Order in Layer

`Sorting Layer` 可以自定义添加，默认有个 `Default`。
两个对象，首先看 `Sorting Layer`，再看 `Order in Layer`，数字越大，越在前面。

#### Specify Render Queue

> You can specify the Render Queue type of the Renderer in its Material settings or in the Shader settings of its Material. This is useful for grouping and sorting Renderers which are using different Materials. Refer to documentation on ShaderLab: SubShader Tags for more details.

可以在 渲染器材质设置(the Material settings) 中或 渲染器材质的着色器设置(the Shader settings of its Material) 中指定渲染器的 渲染队列(the Render Queue) 类型。这对于使用不同材质的渲染器的分组和排序很有用。参阅关于 `ShaderLab：SubShader` 。


#### Distance to Camera

Camera 组件根据其 Projection 设置对渲染器进行排序。

* Perspective: 根据 Sprite 的中心和 Camera 的 3D 直线距离 
* Orthographic: 根据 Camera 方向上， Sprite 和 Camera 的距离。
* Custom Axis sort mode

    选择此模式可根据 `Project Settings`（主菜单：`Edit > Projecting Settings > Graphics > Transparency Sort Axis`）中设置的渲染器在自定义轴上的距离对渲染器进行排序。此模式通常用于具有等距 瓦片地图(Isometric Tilemaps) 的项目中，以便在 瓦片地图(Tilemap) 上正确排序和 渲染瓦片精灵(Tile Sprites)。
* Sprite Sort Point

    默认情况下，精灵的 Sort Point（排序点）设置为其 Center，因此 Unity 会测量摄像机的变换位置与精灵的中心之间的距离，以确定它们在排序过程中的渲染顺序。另一种选项是将精灵的 Sort Point 设置为世界空间中的 Pivot 位置。为此，请在精灵的 Sprite Renderer 属性设置中选择 Pivot 选项，然后在 Sprite Editor 中编辑精灵的 Pivot 位置。

#### Sorting Group

排序组 (Sorting Group) 是一个组件，它将具有共同根的渲染器分组到一起以进行排序。同一排序组中的所有渲染器具有相同的排序图层 (Sorting Layer)、图层中的顺序 (Order in Layer) 和与摄像机的距离 (Distance to Camera)。请参阅有关排序组 (Sorting Group) 组件及其相关设置的文档以了解更多详细信息。

#### Material/Shader

Unity 将具有相同材质设置的渲染器排序到一起，以获得更高效的渲染性能，例如在进行动态批处理时。

#### A Tiebreaker occurs when multiple Renderers have the same sorting priorities.

当多个渲染器具有相同的排序优先级时，由仲裁程序决定 Unity 将渲染器放置在渲染队列中的顺序。因为这是您无法控制的内部过程，所以您应该使用排序选项（例如 Sorting Layers 和 Sorting Groups）确保所有渲染器具有不同的排序优先级。


## Particle System & 3D
Particle 在 Renderer 中可以设置 `Sorting Layer ID` & `Order in Layer` ，但是 **又** 同时拥有 3D 物体的情况下，会发现 3D 上会有例子穿透的现象，那是因为还需要同时还要调整 Z 轴。

## Shader 的 RenderQueue

Unity提供给我们一些默认的渲染队列，每一个对应一个唯一的值，来指导Unity绘制对象到屏幕上。这些内置的渲染队列被称为 `Background, Geometry, AlphaTest, Transparent, Overlay`。这些队列不是随便创建的，它们是为了让我们更容易地编写Shader并处理实时渲染的。

`Tags{ "RenderType" = "Geometry" }`

当 RenderQueue 填 `-1` 是使用 shader 自定义的值，否则使用手动填的值。
2500 是关键值，它是透明跟不透明的分界点。
知识点:
`RenderQueue > 2500` 的物体绝对会在 `RenderQueue <= 2500` 的物体前面，即渲染时 RenderQueue 大的会挡住 RenderQueue 小的，不论它的 Sorting Layer 和 Order in Layer 怎么设置都是不起作用的。

Properties | Value | 渲染队列描述 | 备注
--- | --- | ---  | ---
Background | 1000 | This render queue is rendered before any others. | 这个队列通常被最先渲染（比如 天空盒）。
Geometry | 2000 | Opaque geometry uses this queue. | 这是默认的渲染队列。它被用于绝大多数对象。不透明几何体使用该队列。
AlphaTest | 2450 | Alpha tested geometry uses this queue. | 需要开启透明度测试的物体。Unity5以后从Geometry队列中拆出来,因为在所有不透明物体渲染完之后再渲染会比较高效。
GeometryLast | 2500 | Last render queue that is considered “opaque” | 所有Geometry和AlphaTest队列的物体渲染完后
Transparent | 3000 | This render queue is rendered after Geometry and AlphaTest, in back-to-front order. | 所有Geometry和AlphaTest队列的物体渲染完后，再按照从后往前的顺序进行渲染,任何使用了透明度混合的物体都应该使用该队列（例如玻璃和粒子效果）
Overlay | 4000 | This render queue is meant for overlay effects. | 该队列用于实现一些叠加效果，适合最后渲染的物体（如镜头光晕）。


## 参考

* [Unity中SortingLayer、Order in Layer和RenderQueue的讲解](https://linxinfa.blog.csdn.net/article/details/105361396)
* [Unity SortingLayer和Layer区别、相机、渲染顺序和射线检测](https://juejin.cn/post/6844904121753927693)
* [Unity Doc | 2D Sorting](https://docs.unity3d.com/2018.4/Documentation/Manual/2DSorting.html)