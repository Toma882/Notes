# Unity Animator

Unity3D动画系统分为
1. 旧版动画系统 Animation
2. 新版动画 Mecanim 系统 Animator

## 什么是根运动 (Root Motion)
动画用于在特定层级视图中移动和旋转所有游戏对象。这些移动和旋转大多数都是相对于其父项完成的，但是层级视图的父游戏对象没有父项，因此它们的移动不是相对的。此父游戏对象也可以称为根 (Root)，因此其移动称为根运动 (Root Motion)。

**重要注意事项！** 在 JohnLemon 预制件的层级视图中称为根的游戏对象指的是其骨架的根，而不是实际的根游戏对象。根游戏对象是 Animator 组件所在的任何游戏对象，在本例中，该游戏对象称为 JohnLemon。

在 Animator 组件上启用了 Apply Root Motion，因此根在动画中的任何移动都将应用于每一帧。由于 Animator 正在播放 Idle 动画，没有移动，因此 Animator 不会施加任何动作。那么，为什么 JohnLemon 游戏对象会移动呢？这是因为 Animator 的**更新模式 (Update Mode)**。

## `Apply Root Motion` & `Bake into Pose`

还未理解透彻

|  Apply Root Motion   | Bake into Pose | 说明  | 说明  |
|  ----  | ----   | ----  | ----  |
| √  | √  | Body Transform  | 动画结束后，开始新的动画之前，变换会应用到模型。（模型的position在新的动画开始之前会发生变化，新的动画开始时候，模型处于动画结束时的位置） |
| x  | √  | Body Transform  | 动画依然会在场景中体现，人物会按照动画的路径行走（但是如果我们观察Inspector中模型的position参数，值一直不变）。但是因为没有勾选Apply Root Motion，所以动画结束后，变换不会应用到模型，所以如果这时候开始一个新的动画的话，模型会瞬间回到起始位置（新的动画开始时候，模型处于行走动画开始时的位置）。 |
| √  | x  | Root Transform  | 变换会应用到模型（模型的position跟着动画不停的变化），自然，新的动画开始时候，模型处于动画结束时的位置 |
| x  | x  | Root Transform  | 因为没有勾选 Apply Root Motion，所以变换将不被应用，所以模型将一直在本地不动，自然，新的动画开始时候，模型处于行走动画开始时的位置 |


## 参考
* [Mecanim动画系统](https://www.jianshu.com/p/167595bfc868)
* [Unity之动画文件的设置与Apply Root Motion](https://gameinstitute.qq.com/community/detail/122661)
* [[专栏精选]Unity动画系统的RootMotion](https://zhuanlan.zhihu.com/p/44714595)
* [教程玩家角色](https://learn.unity.com/tutorial/wan-jia-jiao-se-di-1-bu-fen?uv=2019.4&projectId=5dfa9a5dedbc2a26d1077ca8#5e391a73edbc2a0259f1f632)