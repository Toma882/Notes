# Unity Analysis
```
Window -> Analysis -> Profile
Window -> Analysis -> FrameDebugger
```
## Draw Call
引擎向图形API(OpenGL / Direct3D)发出绘制调用，就是 DrawCall。

### Base
#### 为什么会成为瓶颈？  
在每次调用Draw Call之前，CPU需要向GPU发送很多内容，包括数据，状态，命令等。在这一阶段，CPU都要执行完整的贴图绑定，Shader切换，渲染状态设置等准备工作。

#### 优化  
  将多个对象的模型做完全的合并，一次DrawPrimitive完全画出，但是这样做也有副作用，因为多个对象合并后裁剪的粒度变粗了，常常会传给GPU更多的顶点，增大GPU负担，所以合并到什么程度要根据实际情况做决定。

### For Untiy
#### 静态批处理
将 相同材质 并且 静态（共不移动） 且不会在游戏中移动、旋转或缩放的游戏对象组合成大网格，并以较快的速度渲染它们。

在内部，静态批处理的工作原理是将静态游戏对象转换到世界空间并为它们构建一个共享的顶点和索引缓冲区。如果已启用 Optimized Mesh Data（在 Player 设置中），则 Unity 会在构建顶点缓冲区时删除任何着色器变体未使用的任何顶点元素。为了执行此操作，系统会进行一些特殊的关键字检查；例如，如果 Unity 未检测到 LIGHTMAP_ON 关键字，则会从批处理中删除光照贴图 UV。然后，针对同一批次中的可见游戏对象，Unity 会执行一系列简单的绘制调用，每次调用之间几乎没有状态变化。在技术上，Unity 不会减少 API 绘制调用，而是减少它们之间的状态变化（这正是消耗大量资源的部分）。在大多数平台上，批处理限制为 64k 个顶点和 64k 个索引（OpenGLES 上为 48k 个索引，在 macOS 上为 32k 个索引）。

缺点：  
使用静态批处理需要额外的内存来存储组合的几何体。如果多个游戏对象在静态批处理之前共享相同几何体，则会在 Editor 中或运行时为每个游戏对象创建几何体的副本。这可能并非总是好办法；有时您必须避免为某些游戏对象进行静态批处理，这样会牺牲渲染性能，但可保持较小的内存占用量。例如，在茂密森林关卡中，将树标记为静态可能会产生严重的内存影响。

#### 动态批处理（网格）
如果移动的游戏对象共享相同材质并满足其他条件，则 Unity 可自动在同一绘制调用中批处理这些游戏对象。动态批处理是自动完成的，无需您进行任何额外工作。

* 批处理动态游戏对象在每个顶点都有一定开销，因此批处理仅会应用于总共包含不超过 900 个顶点属性且不超过 300 个顶点的网格。
  * 如果着色器使用顶点位置、法线和单个 UV，最多可以批处理 300 个顶点，而如果着色器使用顶点位置、法线、UV0、UV1 和切线，则只能批处理 180 个顶点。
* 如果游戏对象在变换中包含镜像，则不会对这些对象进行批处理（例如，具有 +1 缩放的游戏对象 A 和具有 –1 缩放的游戏对象 B 无法一起接受批处理）。
* 即使游戏对象基本相同，使用不同的材质实例也会导致游戏对象不能一起接受批处理。例外情况是阴影投射物渲染。如(1,1,1)改为(1,-1,1)。
* 带有光照贴图的游戏对象具有其他渲染器参数：光照贴图索引和光照贴图偏移/缩放。通常，动态光照贴图的游戏对象应指向要批处理的完全相同的光照贴图位置。
* 多 pass 着色器会中断批处理。
  * 几乎所有的 Unity 着色器都支持前向渲染中的多个光照，有效地为它们执行额外 pass。“其他每像素光照”的绘制调用不进行批处理。
  * 旧版延迟（光照 pre-pass）渲染路径会禁用动态批处理，因为它必须绘制两次游戏对象。

因为动态批处理的工作原理是将所有游戏对象顶点转换到 CPU 上的世界空间，所以仅在该工作小于进行绘制调用的情况下，才有优势。绘制调用的资源需求取决于许多因素，主要是使用的图形 API。例如，对于游戏主机或诸如 Apple Metal 之类的现代 API，绘制调用的开销通常低得多，通常动态批处理根本没有优势。

#### 动态批处理（粒子系统、线渲染器、轨迹渲染器）
动态批处理在用于具有 Unity 动态生成的几何体的组件时，其工作方式与用于网格时不同。

* 对于每个兼容的渲染器类型，Unity 将所有可批处理的内容构建为 1 个大型顶点缓冲区。
* 渲染器设置材质状态以用于批处理。
* Unity 将顶点缓冲区绑定到图形设备。
* 对于批处理中的每个渲染器，Unity 将偏移更新到顶点缓冲区中，然后提交新的绘制调用。


在衡量图形设备调用的成本时，渲染组件时的最慢部分是材质状态的设置。相比之下，将不同偏移处的绘制调用提交到共享顶点缓冲区中的速度非常快。

这种方法与 Unity 在使用静态批处理时提交绘制调用的方式非常相似。

## Unity's 1 drawcall

新建一个场景，只保留 Main Camera，修改 Camera 组件的 ClearFlags 为 SolidColor

1. 起始情况下，Tris为2，Verts为4，表示摄像机背景由2个三角面组成，占4个顶点
2. 创建一个Cube，如下。推算得到一个Cube占12个三角面，24个顶点，因为一个Cube有6个面，每个面由2个三角面4个顶点组成

## Batches & Saved by batching

Batches：批处理个数  
Saved by batching：被合并的批处理个数，即优化后减少的批处理个数

1. 起始情况下，Batches为1，Saved by batching为0，表示摄像机背景占一个batch
1. 1个Cube时，Batches为2，Saved by batching为0，表示这个Cube占一个batch
1. 2个Cube时，Batches为2，Saved by batching为1，表示这2个Cube占一个batch，减少了1个batch
1. 3个Cube时，Batches为2，Saved by batching为2，表示这3个Cube占一个batch，减少了2个batch
......

综上，使用相同材质可以减少批处理个数


## Set Pass
现代引擎通过良好的排序，将渲染状态一样的对象连续绘制，这样 CPU 可以仅做一次准备工作就把一组对象连续画出来，虽然调用的同样次数的DrawPrimitive，但开销大大减少。在Unity中这个被叫做一次Set Pass。

## overdraw 

`Scene -> miscellaneous -> Overdraw`

表示单位像素的重新绘制次数

1. slide 九宫格图片，取消 fill center，中心镂空
2. mask 尽量不用，可以用 rect mask2D 代替
3. 不用 UI/Effect，包括 Shadow，Outline，Position As UV1
4. 不用 Image 的 Tiled 类型
5. 不用 Pixel Perfect
6. 动静分离，动态的在父物体上加个Canvas
7. 尽量 active，不要 destroy，也不要设置 Alpha=0 这样还是会渲染
8. 不用 BestFit(代价高，Unity会为该元素用到的所有字号生成图元保存在Altlas中，增加额外生成时间，还会使得字体对应的atlas变大)
9. 特效粒子

## 关闭VSync垂直同步来提高帧率
> 具体步骤是edit->project settings->Quality，在Inspector面板中，V Sync count选择don’t Sync.

垂直和水平是CRT显示器中两个基本的同步信号，水平同步信号决定了CRT画出一条横越屏幕线的时间，垂直同步信号决定了CRT从屏幕顶部画到底部，再返回原始位置的时间，而垂直同步代表着CRT显示器的刷新率水准。  
在游戏项目中，如果我们选择等待垂直同步信号也就是打开垂直同步，在游戏中或许性能较强的显卡会迅速的绘制完一屏的图像，但是没有垂直同步信号的到达，显卡无法绘制下一屏，只有等85单位的信号到达，才可以绘制。这样FPS自然要受到刷新率运行值的制约。  
而如果我们选择不等待垂直同步信号，那么游戏中绘制完一屏画面，显卡和显示器无需等待垂直同步信号就可以开始下一屏图像的绘制，自然可以完全发挥显卡的实力。


## 数据观察

### CPU:
1. GC Allow: 任何一次性内存分配大于2KB的选项。
每帧都具有20B以上内存分配的选项 。
1. Time ms:
注意占用5ms以上的选项

### 内存
1. Texture: 检查是否有重复资源和超大内存是否需要压缩等.。
2. AnimationClip: 重点检查是否有重复资源.。
3. Mesh： 重点检查是否有重复资源。

## 官方教程
* [Unity性能优化（1）-官方教程The Profiler window翻译](http://www.cnblogs.com/alan777/p/6115505.html)
* [Unity性能优化（2）-官方教程Diagnosing performance problems using the Profiler window翻译](http://www.cnblogs.com/alan777/p/6135703.html)
* [Unity性能优化（3）-官方教程Optimizing garbage collection in Unity games翻译](http://www.cnblogs.com/alan777/p/6155501.html)
* [Unity性能优化（4）-官方教程Optimizing graphics rendering in Unity games翻译](https://www.cnblogs.com/alan777/p/6204759.html)


## 参考
* [Unity性能优化](https://zhuanlan.zhihu.com/p/38671064)
* [Unity3D性能优化——工具篇](https://zhuanlan.zhihu.com/p/39529241)
* [Unity3D性能优化——CPU篇](https://zhuanlan.zhihu.com/p/39998137)
* [Unity3D性能优化——渲染篇](https://zhuanlan.zhihu.com/p/40900056)
* [Unity3D - 图形性能优化：帧调试器](https://blog.csdn.net/ynnmnm/article/details/44673143)
* [Unity问答-性能调优](https://my.oschina.net/u/4406918/blog/4722305)
