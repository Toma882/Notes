# Cocos Creator 生命周期

`cc.Component` 是所有组件的基类

## 常见属性

### `this.node` 
该组件所属的节点实例

### `this.enabled` 
是否每帧执行该组件的 `update` 方法，同时也用来控制渲染组件**是否显示**


### `this.node.active` 激活/关闭节点

```js
this.node.active = true;
this.node.active = false;
```


判断是否可被激活：

我们可以通过节点上的只读属性 `activeInHierarchy` 来判断它当前是否已经激活。
`active` 表示的其实是该节点 **自身的** 激活状态，而这个节点 **当前** 是否可被激活则取决于它的 **父节点**。







## 生命周期回调函数：


### `onLoad` 

组件脚本的初始化阶段，我们提供了 `onLoad` `回调函数。onLoad` 回调会在节点首次激活时触发，比如所在的场景被载入，或者所在节点被激活的情况下。在 `onLoad` 阶段，保证了你可以获取到场景中的其他节点，以及节点关联的资源数据。`onLoad` 总是会在任何 `start` 方法调用前执行，这能用于安排脚本的初始化顺序。通常我们会在 `onLoad` 阶段去做一些初始化相关的操作。

### `start` 

会在该组件第一次 `update` 之前执行，通常用于需要在所有组件的 `onLoad` 初始化完毕后执行的逻辑

### `update` 

作为组件的成员方法，在组件的 `enabled` 属性为 `true` 时，其中的代码会每帧执行渲染前更新物体的行为，状态和方位。

### `lateUpdate`


### `onDestroy` 


### `onEnable` 

当组件的 `enabled` 属性从 `false` 变为 `true` 时，或者所在节点的 `active` 属性从 `false` 变为 `true` 时，会激活 `onEnable` 回调。倘若节点第一次被创建且 `enabled` 为 `true`，则会在 `onLoad` 之后，`start` 之前被调用。

### `onDisable` 

当组件的 `enabled` 属性从 `true` 变为 `false` 时，或者所在节点的 `active` 属性从 `true` 变为 `false` 时，会激活 `onDisable` 回调。


## enabled 为 true 的生命周期
```
onload
onEnable
start
update
lastUpdate
```