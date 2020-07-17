# Node.js Install

> nvm [Node Version Manager](https://github.com/creationix/nvm) #Homebrew installation is not supported
> 
> nmp [[package manager for JavaScript](https://www.npmjs.com/)]
>
> cnpm[ [Company npm](https://cnpmjs.org/) ]For developers in China, please visit the [China mirror](https://npm.taobao.org/)

## 准备


### 卸载

卸载已安装到全局的 node/npm

如果之前是在官网下载的 node 安装包，运行后会自动安装在全局目录，其中

node 命令在 `/usr/local/bin/node` ，npm 命令在全局 `node_modules` 目录中，具体路径为 `/usr/local/lib/node_modules/npm`

安装 nvm 之后最好先删除下已安装的 node 和全局 node 模块：

```sh
npm ls -g --depth=0 #查看已经安装在全局的模块，以便删除这些全局模块后再按照不同的 node 版本重新进行全局安装

sudo rm -rf /usr/local/lib/node_modules #删除全局 node_modules 目录
sudo rm /usr/local/bin/node #删除 node
cd  /usr/local/bin && ls -l | grep "../lib/node_modules/" | awk '{print $9}'| xargs rm #删除全局 node 模块注册的软链`
```


### 安装
先安装 `XCode` 或者 `Command Line Tools`

[How to Install Command Line Tools in OS X Mavericks & Yosemite (Without Xcode)](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/)





## nvm

### 安装

#### 1.使用脚本

To install or update nvm, you can use the install script using 

cURL:

```sh
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
```

or Wget:

```sh
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
```

The script clones the nvm repository to `~/.nvm` and adds the source line to your profile (`~/.bash_profile`, `~/.zshrc`, `~/.profile`, or `~/.bashrc`).

You can customize the install source, directory and profile using the `NVM_SOURCE, NVM_DIR`, and `PROFILE` variables. Eg: `curl ... | NVM_DIR="path/to/nvm" bash`

NB. The installer can use git, curl, or wget to download nvm, whatever is available.

Note: On OSX, if you get `nvm: command not found` after running the install script, your system may not have a [.bash_profile file] where the command is set up. Simple create one with `touch ~/.bash_profile` and run the install script again.

#### 2.使用 git 本地安装

```sh
$ cd ~/git
$ git clone https://github.com/creationix/nvm.git
```

配置终端启动时自动执行:
`~/.bashrc, ~/.bash_profile, ~/.profile, 或者 ~/.zshrc` 文件添加以下命令:

```sh
source ~/git/nvm/nvm.sh
```

重新打开你的终端, 输入 `nvm`


### 验证安装

```sh
# 出现 'nvm' 说明正确
command -v nvm

# 查看一下你当前已经安装的版本
nvm ls
# 查看远端的
nvm ls-remote
```

### 使用 nvm

```sh
# To download, compile, and install the latest release of node, do this:
nvm install node

# And then in any new shell just use the installed version:
nvm use node
# Or you can just run it:
nvm run node --version
# Or, you can run any arbitrary command in a subshell with the desired version of node:
nvm exec 4.2 node --version

# You can also get the path to the executable to where it was installed:
nvm which 5.0
```

```sh
$ nvm [tab][tab]
alias               deactivate          install
ls                  run                 unload
clear-cache         exec                list
ls-remote           unalias             use
current             help                list-remote
reinstall-packages  uninstall           version
```

### 设置国内镜像

```sh
set "NVMW_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node"
#set "NVMW_NPMJS_COM_MIRROR=https://npm.taobao.org/mirrors/npm"
nvm install 4.3.2

# 设置环境变量
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
source ~/git/nvm/nvm.sh
```


## npm

[npm](./npm.md)

## 参考
* [Node Version Manager](https://github.com/creationix/nvm)
* [使用 nvm 管理不同版本的 node 与 npm](http://www.cnblogs.com/kaiye/p/4937191.html)
