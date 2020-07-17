# 配置 Git 处理行结束符

## LF CRLF

`CRLF` `LF` 是用来表示文本换行的方式。

`CR (Car­riage Re­turn)` 代表回车，对应字符 `\r`，`LF (Line Feed)` 代表换行，对应字符 `\n`。

Win­dows 系统使用的是 `CRLF`, Unix 系统 (包括 Linux、Ma­cOS 近些年的版本) 使用的是 `LF`。

## Git 配置

### `core.autocrlf`
`git config --global  [true | input | false]`

* `true` 提交时转换为`LF`，检出时转换为`CRLF`
* `input` 提交时转换为`LF`，检出时不转换，如果自己的话那还是`LF`，如果有其他人有可能为`CRLF`，因此也要关注其他人的设置情况
* `false` **默认配置**，提交与检出的代码都保持文件原有的换行符不变（不转换）


Windows，请选择 `true`，因为 Windows 上某些应用使用文件时候也是需要 `CRLF` 结尾才能正确识别。

Mac & Linux，请选择 `input`，同上的原因，某些软件 `LF` 结尾才能正确识别。

如果大家都使用相同的系统，默认选择 `false` 是最好的选择。

### `core.safecrlf`
由于可能同时单个文件同时存在 `CRLF` 和 `LF` 的情况，Git 为了防止这种情况的发生，在提交时，可以做出相应的设置

`git config --global core.safecrlf [true | false | warn]`

* `true` 禁止提交混合换行符的文本文件(`git add` 的时候会被拦截，提示异常)
* `warn` 提交混合换行符的文本文件的时候发出警告，但是不会阻止 `git add` 操作
* `false` **默认配置**，不禁止提交混合换行符的文本文件

## 总结

`git config --global core.safecrlf true`

* Windows  
    `git config --global core.autocrlf true`
* Mac Or Linux  
    `git config --global core.autocrlf input`

## 参考

[配置 Git 处理行结束符](https://help.github.com/cn/github/using-git/configuring-git-to-handle-line-endings#per-repository-settings)