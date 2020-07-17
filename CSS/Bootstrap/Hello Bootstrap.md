# Bootstrap

* [Bootstrap](http://getbootstrap.com/)
* [Bootstrap中文网](http://www.bootcss.com/)
* [GitHub Bootstrap](https://github.com/twbs/bootstrap)

Bootstrap 的文档还在完善，具体看👆为主。

## 目录结构

```
bootstrap/
├── css/
│   ├── bootstrap.css
│   ├── bootstrap.css.map
│   ├── bootstrap.min.css
│   └── bootstrap.min.css.map
└── js/
    ├── bootstrap.js
    └── bootstrap.min.js
```

* bootstrap.min.css 是 Bootstrap 的主要组成部分，包含了大量要用到的 CSS 类；
* bootstrap-theme.min.css 包含了可选的 Bootstrap 主题；
* bootstrap.min.js 提供了一些 JavaScript 方法，需要注意的是 Bootstrap 依赖于 jQuery，因此使用 bootstrap.min.js 前必须引入 jQuery
* css.map 请关注 [source maps](https://developers.google.com/web/tools/chrome-devtools/debug/readability/source-maps)

## 基础模板

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Bootstrap 101 Template</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <h1>Hello, world!</h1>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
```

国内

```html
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>Bootstrap 101 Template</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
    <h1>你好，世界！</h1>

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
  </body>
</html>
```

## Install
### CDN
国外

```
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
```

国内

```
<!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- 可选的 Bootstrap 主题文件（一般不用引入） -->
<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
```

其他

```sh
# bower
$ bower install bootstrap
# npm
$ npm install bootstrap@3
# composer
$ composer require twbs/bootstrap
```

## 容器
Bootstrap 需要为页面内容 content 和栅格系统 grid 包裹一个容器 container。我们提供了两个作此用处的类。注意，由于 padding 等属性的原因，这两种 容器类不能互相嵌套。

`.container` 类用于固定宽度并支持响应式布局的容器。

```html
<div class="container">
  ...
</div>
```
`.container-fluid` 类用于 100% 宽度，占据全部视口（viewport）的容器。

```html
<div class="container-fluid">
  ...
</div>
```

**栅格参数**

<table class="table table-bordered table-striped table-responsive">
  <thead>
    <tr>
      <th></th>
      <th class="text-center">
        超小屏幕 <small>手机</small><br> <small>(<768px)</small>
      </th>
      <th class="text-center">
        小屏幕 <small>平板</small><br> <small>(≥768px)</small>
      </th>
      <th class="text-center">
        中等屏幕 <small>桌面显示器</small><br> <small>(≥992px)</small>
      </th>
      <th class="text-center">
        大屏幕 <small>大桌面显示器 </small><br> <small>(≥1200px)</small>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th class="text-nowrap" scope="row">栅格系统行为</th>
      <td>总是水平排列</td>
      <td colspan="3">开始是堆叠在一起的，当大于这些阈值时将变为水平排列C</td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row"><code>.container</code> 最大宽度</th>
      <td>None (auto)</td>
      <td>750px</td>
      <td>970px</td>
      <td>1170px</td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row">类前缀</th>
      <td><code>.col-xs</code></td>
      <td><code>.col-sm-</code></td>
      <td><code>.col-md-</code></td>
      <td><code>.col-lg-</code></td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row">列（column）数</th>
      <td colspan="5">12</td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row">最大列（column）宽</th>
      <td>自动</td>
      <td>~62px</td>
      <td>~81px</td>
      <td>~97px</td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row">槽（gutter）宽</th>
      <td colspan="5">30px (15px on each side of a column)</td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row">可嵌套</th>
      <td colspan="5">Yes</td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row">偏移（Offsets）</th>
      <td colspan="5">Yes</td>
    </tr>
    <tr>
      <th class="text-nowrap" scope="row">列排序</th>
      <td colspan="5">Yes</td>
    </tr>
  </tbody>
</table>

怎么理解上面这个表格呢？假如在电脑上浏览页面，需要将页面分为三列，分别占行宽的 1/4、2/4、1/4，则可编写代码如下：

一行分三列

```html
<div class="row">
<div class="col-md-3">.col-md-3</div>
<div class="col-md-6">.col-md-6</div>
<div class="col-md-3">.col-md-3</div>
</div>
```
打开浏览器，可以看到它们各自占据了 12 列中的 3、6、3 列，加起来恰好是 12 列。如果我们缩小浏览器窗口，直到其小于 970px，此时会发现变成了三行，堆在一起显示。除过`.col-xs-`，其他 CSS 类的行为都一样，在屏幕尺寸小于其临界点时，会堆起来显示，只有在屏幕尺寸大于其临界点时，才按列显示，而`.col-xs-` 在任何情况下都按列显示。

对应不同屏幕尺寸的 CSS 类可以混合使用，比如我想让一个页面在电脑上显示 3 列，在手机上显示成 2 列，则可编写代码如下，在手机上，第三列会换行到下一行显示，并且占据行宽的一半：

在电脑和手机上显示不同数量的列

```html
<div class="row">
<div class="col-xs-6 col-md-3">.col-md-3</div>
<div class="col-xs-6 col-md-6">.col-md-6</div>
<div class="col-xs-6 col-md-3">.col-md-3</div>
</div>
```

如果希望在所有设备上显示相同的列，只需要定义最小尺寸的.col-xs- 即可，布局会自动扩展到更大尺寸，反之则不成立：

所有设备上显示同数量的列

```html
<div class="row">
<div class="col-xs-6">.col-xs-6</div>
<div class="col-xs-6">.col-xs-6</div>
</div>
```
还可以给列一定的偏移量，比如第一列占行宽的 1/4，我们希望第二列向右偏移 6 列，占用行末的 3 列：

列偏移

```html
<div class="row">
<div class="col-md-3">.col-md-3</div>
<div class="col-md-3 col-md-offset-6">.col-md-3</div>
</div>
```

列的顺序也可以通过`.col-md-push-*` 和 `.col-md-pull-*` 调整，它们的含义是将某元素向后推或向前拉若干列，开发者可使用该特性，将重要内容在手机显示时，拉到前面：

推拉列

```html
<div class="row">
<div class="col-md-9 col-md-push-3">.col-md-9 .col-md-push-3</div>
<div class="col-md-3 col-md-pull-9">.col-md-3 .col-md-pull-9</div>
</div>
```

更让人兴奋的是，这种网格系统还可以嵌套，这样就能进行各种各样复杂的布局了:

嵌套

```html
<div class="row">
<div class="col-sm-9">
Level 1: .col-sm-9
<div class="row">
<div class="col-xs-8 col-sm-6">
Level 2: .col-xs-8 .col-sm-6
</div>
<div class="col-xs-4 col-sm-6">
Level 2: .col-xs-4 .col-sm-6
</div>
</div>
<div class="col-sm-3">
Level 1: .col-sm-3
</div>
</div>
</div>
```

上面的代码总体上分成两列，其中第一列又嵌套了两列。

具体移步 [Example/Grid](http://v3.bootcss.com/examples/grid/) 使用 Chrome Developer Tools 进行参考

[更多实例精选](http://v3.bootcss.com/getting-started/#examples)

## 参考
* [使用 Bootstrap 构建响应式页面](https://www.ibm.com/developerworks/cn/web/1508_wangqf_bootstrap/)