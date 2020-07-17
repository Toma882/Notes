## 数据相关包

### 数据

**Numpy**

来存储和处理大型矩阵，比Python自身的嵌套列表（nested list structure)结构要高效的多，本身是由C语言开发。这个是很基础的扩展，其余的扩展都是以此为基础。数据结构为ndarray,一般有三种方式来创建。

* Python对象的转换
* 通过类似工厂函数numpy内置函数生成：np.arange,np.linspace.....
* 从硬盘读取，loadtxt快速入门：Quickstart tutorial


* axis=-1 默认，按照数组中最后一个轴来排序
* axis=None 扁平化，一个向量进行排序
* axis=0 代表跨行（实际上就是按列）
* axis=1 代表跨列（实际上就是按行）

```
a = np.array([[4,3,2],[2,4,1]])
print np.sort(a)
print np.sort(a, axis=None)
print np.sort(a, axis=0)  
print np.sort(a, axis=1)  

[[2 3 4]
 [1 2 4]]
[1 2 2 3 4 4]
[[2 3 1]
 [4 4 2]]
[[2 3 4]
 [1 2 4]]

```

快速入门：[Quickstart tutorial](https://docs.scipy.org/doc/numpy-dev/user/quickstart.html)

**Pandas** ★★★

基于 NumPy 的一种工具，该工具是为了解决数据分析任务而创建的。Pandas 纳入了大量库和一些标准的数据模型，提供了高效地操作大型数据集所需的工具。最具有统计意味的工具包，某些方面优于R软件。数据结构有一维的Series，二维的DataFrame(类似于Excel或者SQL中的表，如果深入学习，会发现Pandas和SQL相似的地方很多，例如merge函数)，三维的Panel（Pan（el) + da(ta) + s，知道名字的由来了吧）。学习Pandas你要掌握的是：

* 汇总和计算描述统计，处理缺失数据 ，层次化索引
* 清理、转换、合并、重塑、GroupBy技术
* 日期和时间数据类型及工具（日期处理方便地飞起）

快速入门：[10 Minutes to pandas](https://pandas.pydata.org/pandas-docs/stable/10min.html)

**Scipy**

方便、易于使用、专为科学和工程设计的Python工具包.它包括统计,优化,整合,线性代数模块,傅里叶变换,信号和图像处理,常微分方程求解器等等。

基本可以代替Matlab，但是使用的话和数据处理的关系不大，数学系，或者工程系相对用的多一些。（略）近期发现有个statsmodel可以补充scipy.stats，时间序列支持完美



### 图形
**Matplotlib**

Python中最著名的绘图系统，很多其他的绘图例如seaborn（针对pandas绘图而来）也是由其封装而成。创世人John Hunter于2012年离世。这个绘图系统操作起来很复杂，和R的ggplot,lattice绘图相比显得望而却步，这也是为什么我个人不丢弃R的原因，虽然调用

`plt.style.use("ggplot")`

绘制的图形可以大致按照ggplot的颜色显示，但是还是感觉很鸡肋。但是matplotlib的复杂给其带来了很强的定制性。其具有面向对象的方式及Pyplot的经典高层封装。

需要掌握的是：

* 散点图，折线图，条形图，直方图，饼状图，箱形图的绘制。
* 绘图的三大系统：pyplot，pylab(不推荐)，面向对象
* 坐标轴的调整，添加文字注释，区域填充，及特殊图形patches的使用
* 金融的同学注意的是：可以直接调用Yahoo财经数据绘图（真。。。）

Pyplot快速入门：[Pyplot tutorial](https://matplotlib.org/users/pyplot_tutorial.html)

**Seaborn**

Seaborn 与 Matplotlib 的关系，类似于 Pandas 与 Numpy 的关系

### 机器学习

**Scikit-learn**

关注机器学习的同学可以关注一下，很火的开源机器学习工具，这个方面很多例如去年年末Google开源的TensorFlow，或者Theano，caffe(贾扬清)，Keras等等，这是另外方面的问题。

主页：[An introduction to machine learning with scikit-learn](https://scikit-learn.org/stable/tutorial/basic/tutorial.html)


## 数据集成
* 数据清洗
* 数据抽取
* 数据集成
* 数据变换

**ETL**

* 抽取 Extract
* 转化 Transform
* 加载 Load

典型的 ETL 工具有: 

* 商业软件：Informatica PowerCenter、IBM InfoSphere DataStage、Oracle DataIntegrator、Microsoft SQL Servever Integration Services 等
* 开源软件：Kettle、Talend、Apatar、Scriptella、DataX、Sqoop 等

## 数据规范化

* Min-Max 规范化  
  Min-Max 规范化是将原来数据转化到[0,1]的空间
  新数值 = (原数值 - 极小值) / (极大值 - 极小值)
  
  ```
  # coding:utf-8
  from sklearn import preprocessing
  import numpy as np
  # 初始化数据，每一行表示一个样本，每一列表示一个特征
  x = np.array([[ 0., -3.,  1.],
                [ 3.,  1.,  2.],
                [ 0.,  1., -1.]])
  # 将数据进行 [0,1] 规范化
  min_max_scaler = preprocessing.MinMaxScaler()
  minmax_x = min_max_scaler.fit_transform(x)
  print minmax_x
  [[0.         0.         0.66666667]
   [1.         1.         1.        ]
   [0.         1.         0.        ]]
  ```


* Z-Score 规范化  
  新数值 = (原始值 - 均值) / 标准差
  
  ```
  from sklearn import preprocessing
  import numpy as np
  # 初始化数据
  x = np.array([[ 0., -3.,  1.],
                [ 3.,  1.,  2.],
                [ 0.,  1., -1.]])
  # 将数据进行 Z-Score 规范化
  scaled_x = preprocessing.scale(x)
  print scaled_x
  [[-0.70710678 -1.41421356  0.26726124]
   [ 1.41421356  0.70710678  1.06904497]
   [-0.70710678  0.70710678 -1.33630621]]
  ```


* 小数定标规范化  
  新数值 = 原数值 / 1000  
  取决于最大绝对值来移动多少位小数点
  
  ```
  # coding:utf-8
  from sklearn import preprocessing
  import numpy as np
  # 初始化数据
  x = np.array([[ 0., -3.,  1.],
                [ 3.,  1.,  2.],
                [ 0.,  1., -1.]])
  # 小数定标规范化
  j = np.ceil(np.log10(np.max(abs(x))))
  scaled_x = x/(10**j)
  print scaled_x
  [[ 0.  -0.3  0.1]
   [ 0.3  0.1  0.2]
   [ 0.   0.1 -0.1]]
  ```


## 数据可视化

**商业智能分析**

* Tableau 适合BI工程师，数据工程师
* PowerBI 微软出品，与Excel无缝对接
* FineBI 中国帆软出品，倾向于企业级应用BI

**可视化大屏类**

* DataV 阿里巴巴出品，天猫双十一使用
* FineReport 中国帆软出品，纯JAVA编写，商业报表软件


**前端可视化工具**  

* Canvas 2D 适合位图  
* SVG 2D 适合矢量图  
* WebGL 3D Three.js

**推荐项目**

* [ECharts](https://echarts.baidu.com/) 百度开源项目  
* [D3.js](https://d3js.org/) (Data-Driven Documents)
* [Three.js ](https://threejs.org/) WebGL 框架 ，封装大量 WebGL 接口
* [AntV](http://antv.alipay.com) 蚂蚁金服出品
* Python 的 Matplotlib, Seaborn


## 日志采集第三方工具

* 友盟
* Google Analysis
* Talkingdata

## 参考
