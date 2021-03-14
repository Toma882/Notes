## Transform

`eulers 欧拉角`

欧拉角会造成 死锁 问题

`Quaternion`

四元数用于表示旋转。
它们结构紧凑，不受万向锁影响，可以轻松插值。 Unity 内部使用四元数来表示所有旋转。
它们基于复数，不容易理解。 您几乎不会有机会访问或修改单个四元数分量（x、y、z、w）； 大多数情况下，您只需要获取现有旋转（例如，来自 Transform），然后使用它们构造新的旋转 （例如，在两个旋转之间平滑插值）。 您绝大多数时间使用的四元数函数为： 
```
Quaternion.LookRotation
Quaternion.Angle
Quaternion.Euler
Quaternion.Slerp
Quaternion.FromToRotation
Quaternion.identity
```
（其他函数仅用于一些十分奇特的用例。）
您可以使用 `Quaternion.operator` 对旋转进行旋转，或对向量进行旋转。
注意，Unity 使用的是标准化的四元数。


## Transform.parent & Transform.SetParent

`public Transform parent`

更改父级将修改相对于父级的位置、缩放和旋转，但保持世界空间位置、旋转和缩放不变。

`Transform.SetParent`
```
public void SetParent (Transform p);
public void SetParent (Transform parent, bool worldPositionStays);
```
默认该方法与 parent 属性相同，可通过将 `worldPositionStays` 参数设置为 false 来实现，但它可以使 Transform 保持其本地方向而不是其全局方向。


## `Transform.Rotate`
```
public void Rotate (Vector3 eulers, Space relativeTo= Space.Self);
public void Rotate (float xAngle, float yAngle, float zAngle, Space relativeTo= Space.Self);
public void Rotate (Vector3 axis, float angle, Space relativeTo= Space.Self);
```

## `public Quaternion Transform.rotation`

一个四元数，用于存储变换在世界空间中的旋转。
Transform.rotation 存储四元数。您可以使用 rotation 来旋转游戏对象或提供当前旋转。请勿尝试编辑/修改 rotation。Transform.rotation 小于 180 度。
Transform.rotation 没有万向锁。
要旋转 Transform，请使用 Transform.Rotate，它将使用欧拉角。


## `Transform.eulerAngles`

以欧拉角表示的旋转（以度为单位）。
x、y 和 z 角表示一个围绕 Z 轴旋转 z 度、围绕 X 轴旋转 x 度、围绕 Y 轴旋转 y 度的旋转。
仅使用该变量读取角度和将角度设置为绝对值。不要增大角度，因为当角度超过 360 度时，操作将失败。 请改用 Transform.Rotate。
不要单独设置某个 eulerAngles 轴（例如，eulerAngles.x = 10;），这会导致偏差和不希望的旋转。 在将它们设置为新值时，请一次性设置所有 eulerAngles 轴，如上所示。 Unity 在角度与存储在 Transform.rotation 中的旋转之间进行转换。

## Transform.localRotation
相对于父级变换旋转的变换旋转。
Unity 在内部将旋转存储为四元数。要旋转对象，请使用 Transform.Rotate。 要将旋转修改为欧拉角，请使用 Transform.localEulerAngles。