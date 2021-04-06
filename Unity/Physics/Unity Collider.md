## Unity Collider 碰撞体

Collider(碰撞体) 组件定义 对象的形状 以便用于 物理碰撞。Collider(碰撞体) 是不可见的，其形状不需要与对象的网格完全相同，事实上，粗略近似方法通常更有效，在游戏运行过程中难以察觉。

* BoxCollider
* SphereCollider
* CapsuleCollider
* MeshCollider

## Compound Colliders 复合碰撞体
最简单（并且也是处理器开销最低）的碰撞体是所谓的 primitive 碰撞体类型。在 3D 中，这些碰撞体为 `Box Collider`, `Sphere Collider` and `Capsule Collider`。在 2D 中，可以使用 `Box Collider 2D` and `Circle Collider 2D`。可以将任意数量的上述碰撞体添加到单个 GameObject 以创建 Compound Colliders (复合碰撞体)。

Compound Colliders(复合碰撞体) 通常可以充分模拟对象的形状，同时保持较低的处理器开销。  
> Compound colliders approximate the shape of a GameObject while keeping a low processor overhead.

通过在子对象上设置额外的碰撞体可以获得额外的灵活性（例如，盒体可以相对于父对象的局部轴进行旋转）。  
> To get further flexibility, you can add additional colliders on child GameObjects. For instance, you can rotate boxes relative to the local axes of the parent GameObject. 

在创建像这样的复合碰撞体时，层级视图中的根对象上应该只放置一个刚体组件。  
> When you create a compound collider like this, you should only use one Rigidbody
 component, placed on the root GameObject in the hierarchy.

原始碰撞体无法正常处理剪切变换。，如果在变换层级视图中组合使用旋转和不统一的比例，从而使产生的形状不再与原始形状匹配，则原始碰撞体无法正确表现。  
> Primitive colliders do not work correctly with shear transforms. If you use a combination of rotations and non-uniform scales in the Transform hierarchy so that the resulting shape is no longer a primitive shape, the primitive collider cannot represent it correctly.

注意：使用 Collision碰撞 回调时，Compound Colliders(复合碰撞体) 会为每个碰撞体碰撞返回单独的回调。
> Note: Compound colliders return individual callbacks for each collider collision pair when using Collision Callbacks.


## Mesh Colliders 网格碰撞体

在某些情况下，即使 Compound Colliders (复合碰撞体) 也不够准确。
在 3D 中，可以使用 Mesh Colliders(网格碰撞体) 精确匹配对象网格的形状。
在 2D 中，Polygon Collider 2D(2D 多边形碰撞体) 通常不能完美匹配精灵图形的形状，但您可以将形状细化到所需的任何细节级别。

但是，这些碰撞体比 Primitive Types(原始类型) 具有更高的处理器开销，因此请谨慎使用以保持良好的性能。

**典型的解决方案是对所有移动的对象使用 Primitive Colliders(原始碰撞体)，而对静态背景对象使用 Mesh Colliders(网格碰撞体)。**

#### Convex 凸面碰撞体
Mesh Colliders(网格碰撞体) 通常无法与另一个 Mesh Colliders(网格碰撞体) 碰撞（即，当它们进行接触时不会发生任何事情）。在某些情况下，可以通过在 Inspector 中将 Mesh Colliders(网格碰撞体) 标记为 `Convex` 来解决此问题。此设置将产生 convex hull(凸面外壳) 形式的碰撞体形状，类似于原始网格，但填充了底切。这样做的好处是，Convex Mesh Collider(凸面网格碰撞体) 可 与其他 Mesh Colliders(网格碰撞体) 碰撞，因此，当有一个包含合适形状的移动角色时，便可以使用此功能。但是，一条通用规则是将 Mesh Colliders(网格碰撞体) 用于场景几何体，并使用 Compound Primitive Colliders(复合原始碰撞体) 近似得出移动对象的形状。
> A mesh collider cannot collide with another mesh collider (i.e., nothing happens when they make contact). You can get around this in some cases by marking the mesh collider as Convex in the Inspector. This generates the collider shape as a “convex hull” which is like the original mesh but with any undercuts filled in. The benefit of this is that a convex mesh collider can collide with other mesh colliders so you can use this feature when you have a moving character with a suitable shape. However, a good rule is to use mesh colliders for scene geometry and approximate the shape of moving GameObjects using compound primitive colliders.

## Static Colliders 静态碰撞体

* **没有 Rigidbody(刚体)** 的对象上的 Colliders(碰撞体) 称为 **Static Colliders(静态碰撞体)**，如创建如场景的地板、墙壁和其他静止元素。通常情况下，不应通过更改变换位置来重新定位 Static Colliders(静态碰撞体)，因为这会极大地影响 **物理引擎** 的性能。
* **具有 Rigidbody(刚体)** 的对象上的 Colliders(碰撞体) 称为 **Dynamic Colliders(动态碰撞体)**。


> You can add colliders to a GameObject without a Rigidbody component to create floors, walls and other motionless elements of a Scene. These are referred to as static colliders. At the opposite, colliders on a GameObject that has a Rigidbody are known as dynamic colliders. Static colliders can interact with dynamic colliders but since they don’t have a Rigidbody, they don’t move in response to collisions.


## Physics Materials 物理材质

当 Colliders(碰撞体) 相互作用时，它们的表面需要模拟所应代表的材质的属性。例如，一块冰将是光滑的，而橡胶球将提供大量摩擦力并且弹性很好。虽然碰撞时 Colliders(碰撞体) 的形状不会变形，但可以使用 Physics Materials（物理材质） 配置 Colliders(碰撞体) 的 friction(摩擦力) 和 bounce(弹力) 。可能需要进行多次试验和纠错后才能获得正确参数，比如冰材质将具有零（或非常低的） friction(摩擦力)，而橡胶材质则具有高 friction(摩擦力) 和近乎完美的 bounciness(弹性)。

有关可用参数的更多详细信息，请参阅物理材质和 2D 物理材质的参考页面。请注意，由于历史原因，3D 资源实际上称为` Physic Material`（物理材质）（不带 s），而等效的 2D 资源则称为 `Physics Material 2D`（2D 物理材质）（带 s）。


> When colliders interact, their surfaces need to simulate the properties of the material they are supposed to represent. For example, a sheet of ice will be slippery while a rubber ball will offer a lot of friction and be very bouncy. Although the shape of colliders is not deformed during collisions, their friction and bounce can be configured using Physics Materials. Getting the parameters just right can involve a bit of trial and error but an ice material, for example will have zero (or very low) friction and a rubber material with have high friction and near-perfect bounciness. See the reference pages for Physic Material and Physics Material 2D for further details on the available parameters. Note that for historical reasons, the 3D asset is actually called Physic Material (without the S) but the 2D equivalent is called Physics Material 2D (with the S).





## Trigger 触发器

Trigger 触发器 的特点是**允许其他碰撞体穿过，不会 产生 Collision(碰撞)**。

脚本系统可以使用 `OnCollisionEnter` 函数检测何时发生碰撞并启动操作。但是，也可以直接使用物理引擎检测 Colliders(碰撞体) 何时进入另一个对象的空间而 **不会 产生 Collision(碰撞)**。配置为 Tigger(触发器) （使用 `Is Trigger` 属性）的 Colliders(碰撞体) 不会表现为实体对象，**会允许其他碰撞体穿过**。当碰撞体进入其空间时，触发器将在触发器对象的脚本上调用 `OnTriggerEnter` 函数。

> The scripting system can detect when collisions occur and initiate actions using the OnCollisionEnter function. However, you can also use the physics engine simply to detect when one collider enters the space of another without creating a collision. A collider configured as a Trigger (using the Is Trigger property) does not behave as a solid object and will simply allow other colliders to pass through. When a collider enters its space, a trigger will call the OnTriggerEnter function on the trigger object’s scripts.

当一个 GameObject 与另一个 GameObject 碰撞时，Unity 会调用 `OnTriggerEnter` 。
> When a GameObject collides with another GameObject, Unity calls OnTriggerEnter.

当两个 GameObjects 发生碰撞时， `OnTriggerEnter` 会在 `FixedUpdate` 函数后发生。 涉及的 Colliders(碰撞体) 并不总是处于初始接触点。因此并不完全准确。
> OnTriggerEnter happens on the FixedUpdate function when two GameObjects collide. The Colliders involved are not always at the point of initial contact.


## 碰撞体相互作用 Collider interactions

碰撞体彼此之间的相互作用根据刚体组件的配置不同而不同。三个重要的配置分别是
* **Static Collider/Without Rigidbody Collider 静态碰撞体: 没有 Rigidbody(刚体)**  
  物理引擎假定静态碰撞体永远不会移动或改变，并且可以基于此假设进行有用的优化。因此，在游戏运行过程中不应禁用/启用、移动或缩放静态碰撞体。如果更改静态碰撞体，则会导致物理引擎进行额外的内部重新计算，从而导致性能大幅下降。更糟糕的是，这些更改有时会使碰撞体处于不明的状态，从而产生错误的物理计算。例如，针对已更改的静态碰撞体的射线投射可能无法检测到静态碰撞体，或在空间中的随机位置检测到静态碰撞体。此外，移动的静态碰撞体碰到的刚体不一定会“被唤醒”，静态碰撞体也不会施加任何摩擦力。由于这些原因，只应更改刚体碰撞体。如果希望碰撞体对象不受靠近的刚体影响，但仍然可以通过脚本来移动该对象，则应为其附加一个_运动_刚体组件附加，而非不附加任何刚体。
* **Rigidbody Collider 刚体碰撞体: 有 Rigidbody(刚体) & Kinematic 为 disable**  
  刚体碰撞体完全由物理引擎模拟，并可响应通过脚本施加的碰撞和力。刚体碰撞体可与其他对象（包括静态碰撞体）碰撞，是使用物理组件的游戏中最常用的碰撞体配置。需要通过力来改变对象位置。
* **Kinematic Rigidbody Collider 运动刚体碰撞体: 有 Rigidbody(刚体) & Kinematic 为 enabled**  
  可以通过 Transform Component 来改变对象位置。  
  运动刚体应该用于符合以下特征的碰撞体：偶尔可能被移动或禁用/启用，除此之外的行为应该像静态碰撞体一样。这方面的一个例子是滑动门，这种门通常用作不可移动的物理障碍物，但必要时可以打开。与静态碰撞体不同，移动的运动刚体会对其他对象施加摩擦力，并在双方接触时“唤醒”其他刚体。  
  即使处于不动状态，运动刚体碰撞体也会对静态碰撞体产生不同的行为。例如，如果将碰撞体设置为触发器，则还需要向其添加刚体以便在脚本中接收触发器事件。如果不希望触发器在重力作用下跌落或在其他方面受物理影响，则可以在其刚体上设置 IsKinematic 属性。  
  可使用 IsKinematic 属性随时让刚体组件在正常和运动行为之间切换。这方面的一个常见例子是“布娃娃”效果；在这种效果中，角色通常在动画下移动，但在爆炸或猛烈碰撞时被真实抛出。角色的四肢可被赋予自己的刚体组件，并在默认情况下启用 IsKinematic。肢体将通过动画正常移动，直到所有这些肢体关闭 IsKinematic 为止，然后它们立即表现为物理对象。此时，碰撞或爆炸力将使角色飞出，使肢体以令人信服的方式被抛出。


## 碰撞操作矩阵 Collision action matrix

#### 发生碰撞检测并在碰撞后发送消息 Collision detection occurs and messages are sent upon collision

  \ | Static Collider | Rigidbody Collider | Kinematic Rigidbody Collider | Static Trigger Collider | Rigidbody Trigger Collider | Rigidbody Kinematic Trigger Collider
--- | --- | --- | --- | --- | --- | --- 
Static Collider                      | - | Y | - | - | - | - 
Rigidbody Collider                   | Y | Y | Y | - | - | - 
Kinematic Rigidbody Collider         | - | Y | - | - | - | -
Static Trigger Collider              | - | - | - | - | - | - 
Rigidbody Trigger Collider           | - | - | - | - | - | - 
Rigidbody Kinematic Trigger Collider | - | - | - | - | - | - 


#### 碰撞后发送触发器消息 Trigger messages are sent upon collision

  \ | Static Collider | Rigidbody Collider | Kinematic Rigidbody Collider | Static Trigger Collider | Rigidbody Trigger Collider | Rigidbody Kinematic Trigger Collider
--- | --- | --- | --- | --- | --- | --- 
Static Collider                      | - | - | - | - | Y | Y 
Rigidbody Collider                   | - | - | - | Y | Y | Y 
Kinematic Rigidbody Collider         | - | - | - | Y | Y | Y
Static Trigger Collider              | - | Y | Y | - | Y | Y 
Rigidbody Trigger Collider           | Y | Y | Y | Y | Y | Y
Rigidbody Kinematic Trigger Collider | Y | Y | Y | Y | Y | Y

## Collision & Trigger 小结

#### 为什么对于需要移动的对象，需要加上 Rigidbody(刚体) 组件？
Rigidbody(刚体) 的作用本身在于实现游戏对象的**物理**行为的主要组件。  
目前对于 Staitc Collider(静态碰撞体) ，不建议在游戏运行过程中禁用/启用、移动或缩放 Staitc Collider(静态碰撞体)。如果更改 Staitc Collider(静态碰撞体)，则会导致物理引擎进行额外的内部重新计算，从而导致性能大幅下降。  
因此如果在游戏过程中需要移动具有 Collider 的对象，还应将 Rigidbody 组件附加到该对象。如果不想使该对象与其他对象进行物理交互，可将 Rigidbody 设置为 kinematic 运动学 刚体。


#### 事件函数的执行顺序  
`FixedUpdate -> OnTriggerXXX -> OnCollisionXXX`

#### 发送 `OnCollisionXXX` 的条件
两个 GameObjects 其中一个必须拥有 Rigidbody(刚体) 组件，且必须关闭 `Is Kinematic`。
> With normal, non-trigger collisions, there is an additional detail that at least one of the objects involved must have a non-kinematic Rigidbody (ie, Is Kinematic must be switched off).



注意：从技术上讲， `OnTriggerEnter` 不是 `Collision` 的一部分。这是一个 MonoBehaviour 函数。

#### 发送 `OnTriggerXXX` 的条件

* 一个拥有 Rigidbody(刚体) 和 Collider(碰撞体) 的 GameObject， 若其 Collider(碰撞体)组件 开启 Trigger(触发)， Rigidbody(刚体) 组件无论是否 Kinematic，都会发送 `OnTriggerXXX` 事件
* 一个 Static Trigger Collider(静态触发碰撞体)，也就是 **没有 Rigidbody(刚体)** 的对象，并且 开启 Trigger(触发) 的 Colliders(碰撞体)， 那么它只对 拥有 Rigidbody(刚体)，无论其是否会 Kinematic or Trigger，都会发送 `OnTriggerXXX` 事件；反之，它对任何  静态碰撞体(Static  Collider)，无论其是否 Trigger(触发)，都不会发送；也就是说 静态碰撞体 之间不会有 `OnTriggerXXX` 事件


#### OnCollisionXXX

* `OnCollisionEnter` 当该碰撞体/刚体已开始接触另一个刚体/碰撞体时。
* `OnCollisionExit` 当该碰撞体/刚体已停止接触另一个刚体/碰撞体时。
* `OnCollisionStay` 对应正在接触刚体/碰撞体的每一个碰撞体/刚体。


`OnCollisionXXX` 被传入 `Collision` 类，而不是 `Collider` 。 `Collision` 类包含有关接触点(contact points)、冲击速度(impact velocity)等的信息。 

如果在该函数中没有使用 `collisionInfo` ，则不考虑 `collisionInfo` 参数，这样可避免不必要的计算。    

注意：如果其中一个 Colliders(碰撞体) 还附加了 非运动学刚体(A Non-Kinematic Rigidbody)，也就是开启了物理引擎控制，则**仅发送 Collision 事件**。Collision 事件将发送到已禁用的 MonoBehaviours，以便允许启用 Behaviours，从而响应碰撞。对于 Sleeping Rigidbodies(休眠刚体)，不发送 Collision stay 事件。

> In contrast to OnTriggerStay, OnCollisionStay is passed the Collision class and not a Collider. The Collision class contains information about contact points, impact velocity etc. If you don't use collisionInfo in the function, leave out the collisionInfo parameter as this avoids unneccessary calculations. Notes: Collision events are only sent if one of the colliders also has a non-kinematic rigidbody attached. Collision events will be sent to disabled MonoBehaviours, to allow enabling Behaviours in response to collisions. Collision stay events are not sent for sleeping Rigidbodies.


## 参考
* [CollidersOverview](https://docs.unity3d.com/2018.4/Documentation/Manual/CollidersOverview.html)
* [物理系统概述 | 碰撞体](https://docs.unity.cn/cn/current/Manual/CollidersOverview.html)