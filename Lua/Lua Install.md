## Lua Install

### homebrew
```sh
brew install lua
```

### Windows
[luaforwindows](https://github.com/rjpcomputing/luaforwindows/)



### 源码安装
* 先在 [Lua.org](http://www.lua.org/ftp/ )  下载最新的Lua版本
* 解压缩
* CD 到相应的目录
* make macosx 编译Lua源代码
* make test 对上一步make进行检查，确保error为0
* sudo make install 安装Lua
* lua -v 查看lua版本号


## 相关设置
### SublimeText3 安装Lua
Tool->Build System -> New Build System

```
{
	"cmd":["/usr/local/bin/lua", "$file"],
	"file_regex":"^(...*?):([0-9]*):?([0-9]*)",
	"selector":"source.lua"
}
```

在SublimeText3的Package下建立 Lua 文件夹，然后文件另存为 Lua.sublime-build