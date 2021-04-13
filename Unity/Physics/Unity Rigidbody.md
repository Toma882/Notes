## Unity Rigidbody 刚体

Rigidbody(刚体) 是实现游戏对象的**物理行为**的主要组件，通过物理模拟控制对象的位置。向对象添加 Rigidbody(刚体) 组件后，其运动将受到 Unity 物理引擎的控制。

刚开始使用 Rigidbody 时，新手常常会遇到游戏物理效果似乎以“慢动作”运行的问题。这实际上是您的模型使用了不适当的缩放导致的。默认的重力设置假定 一个世界单位 对应于 一米 的距离。对于非物理游戏，如果您的模型长度都为 100 个单位，则不会有太大的差别；但在使用物理引擎时，它们将被视为非常大的对象。如果为本应较小的对象使用较大的缩放，它们下落时的视觉速度就会相当缓慢 - 物理引擎认为它们是非常大的物体，正在很远的距离处下落。因此，请确保您的对象缩放后与现实世界的对象差不多（例如，汽车的长度应为 4 个单位 = 4 米左右）。


#### FixedUpdate
在脚本中，建议使用 `FixedUpdate` 函数来 `apply forces and change Rigidbody settings`。
The physics updates are carried out in measured time steps that don't coincide with the frame update. FixedUpdate 在每次进行物理更新前调用，因此在该函数中做出的任何更改都将直接处理。

#### Gravity 重力
即使不添加任何代码，Rigidbody 对象也受到向下的重力，可以通过 `useGravity` 控制重力是否影响该刚体，默认为开启。**Kinematic 也会让 Gravity(重力) 失效，无视其 Gravity(重力) 属性。**

#### position, rotation, apply forces
若想更改 position rotation ，不应该直接更改 Transform 属性进行更改，而应该 apply forces 施加力，让物理引擎计算结果。

由于刚体组件会接管附加到的游戏对象的运动，因此不应试图借助脚本通过更改变换属性（如位置和旋转）来移动游戏对象。相反，应该施加__力__来推动游戏对象并让物理引擎计算结果。

#### Kinematic 运动学
在某些情况下，希望物体暂时摆脱物理引擎的控制，直接从脚本代码控制角色，但仍允许 `Triggers` 进行检测，这种通过脚本进行的 非物理 运动，称为 **运动学**。 **Kinematic 也会让 Gravity(重力) 失效。**

`Rigidbody` 可以通过 `isKinematic` 进行开启和关闭 物理引擎，但这会产生性能开销，应谨慎使用。

#### Sleeping 睡眠
当刚体移动速度低于 `a defined minimum linear or rotational speed`，物理引擎会认为 Rigidbody 刚体 已经停止。发生这种情况时，游戏对象在受到 `a collision or force` 之前不会再次移动，因此将其设置为 `sleeping` 模式。这种优化意味着，在 Rigidbody 刚体 下一次被 `awoken` （即再次进入运动状态）之前，不会花费处理器时间来更新刚体。

在大多数情况下，Rigidbody 刚体组件的 睡眠 和 唤醒 是透明发生的。但是，如果通过修改 Transform position 将 `Static Collider` 静态碰撞体（即，没有刚体的碰撞体）移入游戏对象 或 远离游戏对象，则可能无法唤醒游戏对象。这种情况下可能会导致问题，例如，已经从Rigidbody 刚体游戏对象下面移走地板(`Static Collider` 静态碰撞体)时，Rigidbody 刚体游戏对象会悬在空中。在这种情况下，可以使用 `WakeUp` 函数显式唤醒游戏对象。


#### Mass 质量 drag 阻力
发生碰撞时，mass 质量 较大的对象对 mass 质量 较小的对象的推力要更大一些。您可以想象一下大卡车与小汽车相撞的场景。

drag 阻力可用于减慢对象。 阻力越大，对象越慢。

一个常见的错误是假设重物的下落速度比较轻的物体快。 事实并非如此，下落速度实际上取决于重力和阻力。

#### AngularDrag 对象的角阻力

angularDrag 角阻力 可用于减慢对象的旋转。 阻力越大，旋转越慢。


#### Interpolation 插值
interpolation 插值 可以 smooth平滑 消除 a fixed frame rate固定帧率 运行物理导致的现象。

By default interpolation is turned off. Commonly rigidbody interpolation is used on the player's character. Physics is running at discrete timesteps, while graphics is renderered at variable frame rates. This can lead to jittery looking objects, because physics and graphics are not completely in sync. The effect is subtle but often visible on the player character, especially if a camera follows the main character. It is recommended to turn on interpolation for the main character but disable it for everything else.

默认情况下，插值是关闭的。通常对玩家的角色使用刚体插值。 

Physics is running at discrete timesteps, while graphics is renderered at variable frame rates.  
物理以离散时间步长运行，而图形以可变帧率渲染。 

This can lead to jittery looking objects, because physics and graphics are not completely in sync.  
由于物理和图形并不完全同步，这可能导致对象出现视觉抖动。

The effect is subtle but often visible on the player character, especially if a camera follows the main character.  
这种效果很细微，但通常能够在玩家角色上看到，对于有摄像机跟随的主要角色或车辆，建议 使用插值。对于任意其他刚体，不建议使用插值。 建议对主角打开插值，对于其他所有内容，则禁用它。


* None 不使用插值。
* Interpolate 插值将始终滞后一点，但比外推更流畅。
* Extrapolate 外推将根据当前速度预测刚体的位置。

#### Collision Detection Mode 碰撞检测模式

用于设置 Rigidbody刚体 以进行连续碰撞检测，可避免快速移动的对象在未检测到碰撞的情况下穿过其他对象。连续碰撞检测仅支持带有 Sphere球体, Capusle胶囊体 or BoxColliders盒形碰撞体 的刚体。 

* 如果快速对象的碰撞没有任何问题，请保留默认设置， 即 `CollisionDetectionMode.Discrete`。 
* 可以使用 `CollisionDetectionMode.Continuous Speculative`， 其通常成本更低，并且也可以用于运动对象。推断性 Continuous Collision Detection (CCD)，推测性 CCD 可能会导致幽灵碰撞；还可能导致发生穿隧，因为只会在碰撞检测阶段计算推测性触点。
  
下两个选项对物理性能有很大影响。
* 为获得最佳效果，对于快速移动的对象，设置为 `CollisionDetectionMode.Continuous Dynamic`； 
* 对于需要与之碰撞的其他对象，设置为 `CollisionDetectionMode.Continuous`。 


#### Constraints 模拟自由度

默认情况下，该属性设置为 `RigidbodyConstraints.None` 允许沿所有轴旋转和移动。 在某些情况下，您可能需要限制 Rigidbody 只能沿某些轴移动或旋转， 例如在开发 2D 游戏时。可以使用按位 OR 运算符组合多个 约束。

注意，**位置约束应用于世界空间，旋转约束应用于本地空间**。