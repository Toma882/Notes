#Golang

## Mac

### Install

安装 

```sh
brew install go
```

查看环境变量

```sh
go env

# result:
GOARCH="amd64"
GOBIN=""
GOEXE=""
GOHOSTARCH="amd64"
GOHOSTOS="darwin"
GOOS="darwin"
GOPATH=""
GORACE=""
GOROOT="/usr/local/Cellar/go/1.7.4_2/libexec"
GOTOOLDIR="/usr/local/Cellar/go/1.7.4_2/libexec/pkg/tool/darwin_amd64"
CC="clang"
GOGCCFLAGS="-fPIC -m64 -pthread -fno-caret-diagnostics -Qunused-arguments -fmessage-length=0 -fdebug-prefix-map=/var/folders/1x/s344ps794nzb3cd8tn2v1hmw0000gn/T/go-build932119579=/tmp/go-build -gno-record-gcc-switches -fno-common"
CXX="clang++"
CGO_ENABLED="1"
```

设置环境变量`GOPATH`

```sh
vim ~/.bash_profile
```

添加

```sh
export GOPATH=/usr/local/Cellar/go/1.7.4_2
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
```

```sh
source .bash_profile
```

### IDE

Pycharm + Plugin Go

`File->Settings->Plugins`
点击"Browse repositories"，输入go查询

安装 `Plugin GO` 后重启

`File->Settings->Languages & Frameworks` 寻找 `Go` 菜单

`Go->Go SDK` 设置go的sdk路径（go的lib安装目录）

如前面为 `/usr/local/Cellar/go/1.7.4_2`


