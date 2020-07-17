## Py2exe

[py2exe](www.py2exe.org)

```
# Python3
pip install py2exe
# Python2
pip install py2exe-py2
```

* 若主文件名为 main.py 的 python 脚本，新建 2exe.py 文件，代码如下

    ```py
    from distutils.core import setup
    import py2exe
    setup(windows=["main.py"])
    #setup(console=["main.py"]) 保留命令行窗口
    ```
* 然后在控制台执行

    ```py
    python 2exe.py py2exe
    ```

* 执行后将产生一个名为dist的子目录  

  其中`myscript.exe, python24.dll, library.zip`这些文件，如果你的`main.py`脚本中用了已编译的`C`扩展模块，那么这些模块也会被拷贝在个子目录中，同样，所有的`dll`文件在运行时都是需要的，除了系统的`dll`文件。


## PyInstaller

[PyInstaller](http://www.pyinstaller.org/)

```
pip install PyInstaller
```

相应位置执行命令如下：

```
# -w 去除命令行调试窗口
pyinstaller -w main.py
```