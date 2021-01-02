## 公共源镜像关停服务解决方案
```
YumRepo Error: All mirror URLs are not using ftp, http[s] or file.
```

1. 确认在`/etc/yum.repos.d/`目录没有除了`CentOS-Base.repo`之外其他以`repo`结尾的文件，对其他文件进行备份

2. 获取对应版本的CentOS-Base.repo 到/etc/yum.repos.d/目录

    ### 腾讯云
    各版本源配置列表
    * CentOS5  
    `wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos5_base.repo`
    * CentOS6  
    `wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos6_base.repo`
    * CentOS7  
    `wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos7_base.repo`
    * CentOS8  
    `wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos8_base.repo`


3. 更新缓存

    ```
    yum clean all
    yum makecache
    ```