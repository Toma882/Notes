# Unity Editor 拓展编辑器

## AssetDatebase

AssetDatebase 是一个静态类，他的作用是管理整个工程的所有文件。比如，你可以增加、删除、修改文件等等。

* CreateAsset 创建文件
* CreateFolder 创建文件夹
* DeleteAsset 删除文件
* GetAssetPath 获取文件相对于Assets所在目录的相对位置，如 `Assets/Images/test.png`
* LoadAssetAtPath 加载文件
* Refresh 刷新整个project窗口
* SaveAssets 保存所有文件

删除选择的文件或者文件夹

```c#
using UnityEditor;
 
public class EditorCase1
{
    [MenuItem("Assets/MyEditor/Delete Asset")]
    public static void CaseMenu()
    {
        var obj = Selection.activeObject;
        var path = AssetDatabase.GetAssetPath(obj);
        AssetDatabase.DeleteAsset(path);
    }
}
```