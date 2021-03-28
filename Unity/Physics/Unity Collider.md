## Unity Collider 碰撞体

碰撞体 (Collider) 组件定义 对象的形状 以便用于 物理碰撞。碰撞体 (Collider) 是不可见的，其形状不需要与对象的网格完全相同，事实上，粗略近似方法通常更有效，在游戏运行过程中难以察觉。

* BoxCollider
* SphereCollider
* CapsuleCollider
* MeshCollider

## Compound Colliders 复合碰撞体
最简单（并且也是处理器开销最低）的碰撞体是所谓的 primitive 碰撞体类型。在 3D 中，这些碰撞体为 `Box Collider`, `Sphere Collider` and `Capsule Collider`。在 2D 中，可以使用 `Box Collider 2D` and `Circle Collider 2D`。可以将任意数量的上述碰撞体添加到单个 GameObject 以创建 复合碰撞体(compound colliders)。

复合碰撞体通常可以充分模拟对象的形状，同时保持较低的处理器开销。  
> Compound colliders approximate the shape of a GameObject while keeping a low processor overhead.

通过在子对象上设置额外的碰撞体可以获得额外的灵活性（例如，盒体可以相对于父对象的局部轴进行旋转）。  
> To get further flexibility, you can add additional colliders on child GameObjects. For instance, you can rotate boxes relative to the local axes of the parent GameObject. 

在创建像这样的复合碰撞体时，层级视图中的根对象上应该只放置一个刚体组件。  
> When you create a compound collider like this, you should only use one Rigidbody
 component, placed on the root GameObject in the hierarchy.

原始碰撞体无法正常处理剪切变换。，如果在变换层级视图中组合使用旋转和不统一的比例，从而使产生的形状不再与原始形状匹配，则原始碰撞体无法正确表现。  
> Primitive colliders do not work correctly with shear transforms. If you use a combination of rotations and non-uniform scales in the Transform hierarchy so that the resulting shape is no longer a primitive shape, the primitive collider cannot represent it correctly.

## Mesh Colliders 网格碰撞体

在某些情况下，即使 复合碰撞体(Compound Colliders) 也不够准确。
在 3D 中，可以使用 网格碰撞体(Mesh Colliders) 精确匹配对象网格的形状。
在 2D 中，2D 多边形碰撞体(Polygon Collider 2D) 通常不能完美匹配精灵图形的形状，但您可以将形状细化到所需的任何细节级别。

但是，这些碰撞体比 原始类型(Primitive Types) 具有更高的处理器开销，因此请谨慎使用以保持良好的性能。

#### Convex 凸面碰撞体
网格碰撞体(Mesh Colliders) 通常无法与另一个 网格碰撞体(Mesh Colliders) 碰撞（即，当它们进行接触时不会发生任何事情）。在某些情况下，可以通过在 Inspector 中将 网格碰撞体(Mesh Colliders) 标记为 `Convex` 来解决此问题。此设置将产生 “凸面外壳”(convex hull) 形式的碰撞体形状，类似于原始网格，但填充了底切。这样做的好处是，凸面网格碰撞体_可_与其他网格碰撞体碰撞，因此，当有一个包含合适形状的移动角色时，便可以使用此功能。但是，一条通用规则是将网格碰撞体用于场景几何体，并使用复合原始碰撞体近似得出移动对象的形状。
> A mesh collider cannot collide with another mesh collider (i.e., nothing happens when they make contact). You can get around this in some cases by marking the mesh collider as Convex in the Inspector. This generates the collider shape as a “convex hull” which is like the original mesh but with any undercuts filled in. The benefit of this is that a convex mesh collider can collide with other mesh colliders so you can use this feature when you have a moving character with a suitable shape. However, a good rule is to use mesh colliders for scene geometry and approximate the shape of moving GameObjects using compound primitive colliders.

## Physics Materials 物理材质

当 碰撞体(Colliders) 相互作用时，它们的表面需要模拟所应代表的材质的属性。例如，一块冰将是光滑的，而橡胶球将提供大量摩擦力并且弹性很好。虽然碰撞时 碰撞体(Colliders) 的形状不会变形，但可以使用 Physics Materials（物理材质） 配置 碰撞体(Colliders) 的 摩擦力(friction) 和 弹力(bounce) 。可能需要进行多次试验和纠错后才能获得正确参数，比如冰材质将具有零（或非常低的） 摩擦力(friction)，而橡胶材质则具有高 摩擦力(friction) 和近乎完美的 弹性(bounciness)。

有关可用参数的更多详细信息，请参阅物理材质和 2D 物理材质的参考页面。请注意，由于历史原因，3D 资源实际上称为` Physic Material`（物理材质）（不带 s），而等效的 2D 资源则称为 `Physics Material 2D`（2D 物理材质）（带 s）。


> When colliders interact, their surfaces need to simulate the properties of the material they are supposed to represent. For example, a sheet of ice will be slippery while a rubber ball will offer a lot of friction and be very bouncy. Although the shape of colliders is not deformed during collisions, their friction and bounce can be configured using Physics Materials. Getting the parameters just right can involve a bit of trial and error but an ice material, for example will have zero (or very low) friction and a rubber material with have high friction and near-perfect bounciness. See the reference pages for Physic Material and Physics Material 2D for further details on the available parameters. Note that for historical reasons, the 3D asset is actually called Physic Material (without the S) but the 2D equivalent is called Physics Material 2D (with the S).

## OnCollisionXXX

* `OnCollisionEnter` 当该碰撞体/刚体已开始接触另一个刚体/碰撞体时。
* `OnCollisionExit` 当该碰撞体/刚体已停止接触另一个刚体/碰撞体时。
* `OnCollisionStay` 对应正在接触刚体/碰撞体的每一个碰撞体/刚体。


`OnCollisionXXX` 被传入 `Collision` 类，而不是 `Collider` 。 `Collision` 类包含有关接触点(contact points)、冲击速度(impact velocity)等的信息。 

如果在该函数中没有使用 `collisionInfo` ，则不考虑 `collisionInfo` 参数，这样可避免不必要的计算。

注意：如果其中一个 碰撞体(Colliders) 还附加了 非运动学刚体(A Non-Kinematic Rigidbody)，也就是开启了物理引擎控制，则仅发送 Collision 事件。Collision 事件将发送到已禁用的 MonoBehaviours，以便允许启用 Behaviours，从而响应碰撞。对于 休眠刚体(Sleeping Rigidbodies)，不发送 Collision stay 事件。

> In contrast to OnTriggerStay, OnCollisionStay is passed the Collision class and not a Collider. The Collision class contains information about contact points, impact velocity etc. If you don't use collisionInfo in the function, leave out the collisionInfo parameter as this avoids unneccessary calculations. Notes: Collision events are only sent if one of the colliders also has a non-kinematic rigidbody attached. Collision events will be sent to disabled MonoBehaviours, to allow enabling Behaviours in response to collisions. Collision stay events are not sent for sleeping Rigidbodies.



## Trigger 触发器

Trigger 触发器 的特点是**允许其他碰撞体穿过，不会 产生 碰撞(Collision)**。

脚本系统可以使用 `OnCollisionEnter` 函数检测何时发生碰撞并启动操作。但是，也可以直接使用物理引擎检测 碰撞体(Colliders) 何时进入另一个对象的空间而 **不会 产生 碰撞(Collision)**。配置为 触发器(Tigger) （使用 Is Trigger 属性）的碰撞体不会表现为实体对象，**会允许其他碰撞体穿过**。当碰撞体进入其空间时，触发器将在触发器对象的脚本上调用 `OnTriggerEnter` 函数。

> The scripting system can detect when collisions occur and initiate actions using the OnCollisionEnter function. However, you can also use the physics engine simply to detect when one collider enters the space of another without creating a collision. A collider configured as a Trigger (using the Is Trigger property) does not behave as a solid object and will simply allow other colliders to pass through. When a collider enters its space, a trigger will call the OnTriggerEnter function on the trigger object’s scripts.


当一个 GameObject 与另一个 GameObject 碰撞时，Unity 会调用 `OnTriggerEnter` 。
> When a GameObject collides with another GameObject, Unity calls OnTriggerEnter.

当两个 GameObjects 发生碰撞时， `OnTriggerEnter` 会在 `FixedUpdate` 函数后发生。 涉及的 碰撞体(Colliders) 并不总是处于初始接触点。因此并不完全准确。
> OnTriggerEnter happens on the FixedUpdate function when two GameObjects collide. The Colliders involved are not always at the point of initial contact.

## Collision & Trigger
#### 事件函数的执行顺序  
`FixedUpdate -> OnTriggerXXX -> OnCollisionXXX`

#### 发送 `OnCollisionXXX` 的条件
两个 GameObjects 其中一个必须拥有 刚体(Rigidbody) 组件，且必须关闭 `Is Kinematic`。
> With normal, non-trigger collisions, there is an additional detail that at least one of the objects involved must have a non-kinematic Rigidbody (ie, Is Kinematic must be switched off).



注意：从技术上讲， `OnTriggerEnter` 不是 `Collision` 的一部分。这是一个 MonoBehaviour 函数。



#### 发送 `OnTriggerXXX` 的条件

* 一个 GameObject 的 刚体(Rigidbody) 组件无论是否 Kinematic，若其 碰撞体(Collider)组件 开启 触发(Trigger)，与任一个 碰撞体(Collider) 无论是否 触发(Trigger)，都会发送 `OnTriggerXXX` 事件
* todo 其他情况待总结。




## Static Colliders 静态碰撞体

**没有 刚体(Rigidbody)** 的对象上的 碰撞体(Colliders)，称为 **静态碰撞体(Static Colliders)**。从而创建如场景的地板、墙壁和其他静止元素。

**具有 刚体(Rigidbody)** 的对象上的 碰撞体(Colliders) 称  **动态碰撞体(Dynamic Colliders)**。

通常情况下，不应通过更改变换位置来重新定位静态碰撞体，因为这会极大地影响物理引擎的性能。静态碰撞体(Static Colliders) 可与 动态碰撞体(Dynamic Colliders) 相互作用，但由于没有刚体，因此不会通过移动来响应碰撞。

todo: 相互作用指的是什么？
 
> You can add colliders to a GameObject without a Rigidbody component to create floors, walls and other motionless elements of a Scene. These are referred to as static colliders. At the opposite, colliders on a GameObject that has a Rigidbody are known as dynamic colliders. Static colliders can interact with dynamic colliders but since they don’t have a Rigidbody, they don’t move in response to collisions.



## Rigidbody 刚体
**如果在游戏过程中需要移动具有 Collider 的对象，还应将 Rigidbody 组件附加到该对象。如果不想使该对象与其他对象进行物理交互，可将 Rigidbody 设置为 kinematic运动学 刚体。**