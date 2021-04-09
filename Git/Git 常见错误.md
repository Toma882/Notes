# Git 常见错误

## 工程太大引起拉取失败

错误内容：

```
fatal: The remote end hung up unexpectedly
fatal: early EOF
fatal: index-pack failed
```

解决方案：

```
git clone --depth 1 <repo_URI>
git fetch --unshallow
git remote set-branches origin '*'
git fetch -v
```

---
