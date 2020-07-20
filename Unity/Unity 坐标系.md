# Unity 坐标系

Unity 是左手坐标系

Unity 下的几种坐标系

* 世界 坐标系
  物体在世界的三维坐标，可以通过 `transform.position` 获得; `transfrom.localPosition` 可以获得与父节点的相对坐标。
* 屏幕 坐标系
  左下角为 `(0, 0)` 点，右上角为 `(Screen.width, Sceen.height)`  
  `Input.mousePosition` `Input.GetTouch(0).position` 可以获得屏幕坐标
* GUI 坐标系
  左上角为 `(0, 0)` 点，右下角为 `(Screen.width, Sceen.height)`  
* Viewport 坐标系
  相对于相机。相机的左下角为 `(0, 0)` 点，右上角为 `(1, 1)`，Z 的位置是以相机的世界单位来衡量。

`CoordinateUtil`