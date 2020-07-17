# Cocos Creator

## 事件相关

* [监听和发射事件](https://docs.cocos.com/creator/manual/zh/scripting/events.html)
* [系统内置事件/节点系统事件/cc.Node.EventType.X](https://docs.cocos.com/creator/manual/zh/scripting/internal-events.html)
* [玩家输入事件/全局系统事件/cc.systemEvent.EventType.X](https://docs.cocos.com/creator/manual/zh/scripting/internal-events.html)

## 资源

* [获取和加载资源](https://docs.cocos.com/creator/manual/zh/scripting/load-assets.html)


## 动作 Action & Tween

`cc.Action`：
```
this.node.runAction(
    cc.sequence(
        cc.spawn(
            cc.moveTo(1, 100, 100),
            cc.rotateTo(1, 360),
        ),
        cc.scale(1, 2)
    )
)
```

`cc.tween`：
```
cc.tween(this.node)
    .to(1, { position: cc.v2(100, 100), rotation: 360 })
    .to(1, { scale: 2 })
    .start()
```

* [动作系统/Actions](https://docs.cocos.com/creator/manual/zh/scripting/actions.html)
* [动作列表](https://docs.cocos.com/creator/manual/zh/scripting/action-list.html)
* [缓动系统/Tween(Cocos Creator v2.0.9)](https://docs.cocos.com/creator/manual/zh/scripting/tween.html)


## 分包加载

* [分包加载](https://docs.cocos.com/creator/manual/zh/scripting/subpackage.html)

## SpriteFrame & Texture

`Texture`是一张图片保存在GPU缓冲中的一张纹理

`SpriteFrame` 是 `Texture + Rect`，根据一张纹理材质来剪切获得。

导入图像资源后生成的 `SpriteFrame` 会进行自动剪裁，去除原始图片周围的透明像素区域。这样我们在使用 `SpriteFrame` 渲染 `Sprite` 时，将会获得有效图像更精确的大小。

## 插件脚本

由于插件脚本都保证了会在普通脚本之前加载，一般为第三方插件，或者底层插件或全局变量。如果插件包含了多个脚本，则需要把插件用到的所有脚本合并为单个的 js 文件。

脚本加载顺序如下：

1. Cocos2d 引擎
2. 插件脚本（有多个的话按项目中的路径**字母顺序**依次加载）
3. 普通脚本（打包后只有一个文件，内部按 **require 的依赖顺序**依次初始化）
