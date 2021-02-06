# Git 假定未变更 Assume Unchanged
一般自己的本地工程都有一些配置文件，为了方便调试，需要与远程的代码库不一样，但是又不能上传，防止覆盖掉其他同学的配置文件。

## 添加 假定未变更
在修改好相应的配置文件进行 Commit ，弹出对话框之后，可以右键选择文件，选择 `Assume Unchanged`，中文为 `假定未变更`，那么本地的 Git 就会`假定未变更`，不会进行对比。

## 取消 假定未变更
可以在工程目录里右键选择 Git 的 `Check For Modifications`，中文为 `检查已修改`，在出现的对话框选择 `Show ignore local changes flagged fils`，中文为`显示已标记的忽略本地变更的文件`，就会出现前面 `Assume Unchanged` `假定未变更` 忽略的本地文件。右键选择相应的文件，选择 `Unflag as skip-worktree and assume-unchanged`，中文为`取消 skip-worktree 和 assume-unchanged 标记`，那么就有可以正常的对比和进行后续的文件操作了。