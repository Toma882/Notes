## Unity Monobehaviour Flowchart


## 什么是更新循环？
游戏的工作方式与电影和电视类似：一幅图像显示在屏幕上，该图像每秒变化多次，给人以运动的感觉。我们称这些图像为帧；将这些帧绘制到屏幕上的过程称为渲染。对于电影和电视，通常会预先定义要在屏幕上显示的下一幅图像，但是在游戏中，下一幅图像可能会发生巨大变化，因为用户会对接下来发生的事情产生影响。每幅图像都需要根据用户输入进行计算 — 由于这种变化可能在转瞬间发生，因此计算显示内容的程序要以同样快的速度进行运算。这称为**更新循环**。

每次显示帧时，都会依序发生许多事情。您现在只需要知道，自定义组件的 Update 方法被调用后，会在屏幕上渲染新图像。这些更新的长度会有所不同，具体取决于计算和渲染的复杂程度。但是，还有另一个单独的循环可以运行所有物理操作。此循环不会改变更新的频率，因此称为 **FixedUpdate**。

Animator 组件可以更改其执行更新的时间。默认情况下根据渲染执行此更新。这意味着 Animator 在 Update 中移动角色，而 Rigidbody 同时在 Fixed Update 中移动角色。这就是造成您的问题的原因，很容易解决！


## FlowChart

![](https://docs.unity3d.com/uploads/Main/monobehaviour_flowchart.svg)


## 参考
[monobehaviour_flowchart 源地址](https://docs.unity3d.com/uploads/Main/monobehaviour_flowchart.svg)
* [教程玩家角色](https://learn.unity.com/tutorial/wan-jia-jiao-se-di-1-bu-fen?uv=2019.4&projectId=5dfa9a5dedbc2a26d1077ca8#5e391a73edbc2a0259f1f632)