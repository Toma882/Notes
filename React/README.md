# React

> ReactJS官网地址：http://facebook.github.io/react/
> 
> Github地址：https://github.com/facebook/react
> 

## 参考
https://github.com/bailicangdu/react-pxq

seo:https://isux.tencent.com/seo-for-single-page-applications.html

## React的背景和原理

在Web开发中，我们总需要将变化的数据实时反应到UI上，这时就需要对DOM进行操作。而**复杂或频繁的DOM操作通常是性能瓶颈产生的原因**（如何进行高性能的复杂DOM操作通常是衡量一个前端开发人员技能的重要指标）。

React为此引入了**虚拟DOM（Virtual DOM）**的机制：在浏览器端用Javascript实现了一套DOM API。基于React进行开发时所有的DOM构造都是通过虚拟DOM进行，每当数据变化时，React都会重新构建整个DOM树，然后React将当前整个DOM树和上一次的DOM树进行对比，得到DOM结构的区别，然后仅仅将需要变化的部分进行实际的浏览器DOM更新。而且React能够批处理虚拟DOM的刷新，在一个事件循环（Event Loop）内的两次数据变化会被合并，例如你连续的先将节点内容从A变成B，然后又从B变成A，React会认为UI不发生任何变化，而如果通过手动控制，这种逻辑通常是极其复杂的。尽管每一次都需要构造完整的虚拟DOM树，但是因为虚拟DOM是内存数据，性能是极高的，而对实际DOM进行操作的仅仅是**Diff**部分，因而能达到提高性能的目的。这样，在保证性能的同时，开发者将不再需要关注某个数据的变化如何更新到一个或多个具体的DOM元素，而只需要关心在任意一个数据状态下，整个界面是如何Render的。

## Hello, React!

通过 `http://facebook.github.io/react/downloads.html` 下载完成后，我么看到的是一个压缩包。解压后，我们新建一个html文件，引用react.js和JSXTransformer.js这两个js文件。html模板如下(js路径改成自己的):

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="build/react.js"></script>
    <script src="build/JSXTransformer.js"></script>
</head>
<body>
    <div id="container"></div>
    <script type="text/jsx">
        // ** Our code goes here! **
    </script>
</body>
</html>
```

script的type是`text/jsx`,这是因为 React 独有的 JSX 语法，跟 JavaScript 不兼容。凡是使用 JSX 的地方，都要加上 `type="text/jsx"` 。 其次，React 提供两个库： `react.js` 和 `JSXTransformer.js` ，它们必须首先加载。其中，`JSXTransformer.js` 的作用是将 JSX 语法转为 JavaScript 语法。这一步很消耗时间，实际上线的时候，应该将它放到服务器完成。

`React.render` 是 React 的最基本方法，用于将模板转为 HTML 语言，并插入指定的 DOM 节点

```js
React.render(
<h1>Hello, React!</h1>,
document.getElementById('container')
);
```
react并不依赖jQuery，当然我们可以使用jQuery，但是render里面第二个参数必须使用JavaScript原生的getElementByID方法，不能使用jQuery来选取DOM节点

## Jsx语法
HTML 语言直接写在 JavaScript 语言之中，不加任何引号，这就是 JSX 的语法，它允许 HTML 与 JavaScript 的混写

JSX 允许直接在模板插入 JavaScript 变量。如果这个变量是一个数组，则会展开这个数组的所有成员

* 获取属性的值用的是this.props.属性名
* 创建的组件名称首字母必须大写。
* 为组件添加外部css样式时，类名应该写成`className`而不是`class`;添加内部样式时，应该是`style={{opacity: this.state.opacity}}`而不是`style="opacity:{this.state.opacity};"`。
* 组件的style属性的设置方式也值得注意，要写成style={{width: this.state.witdh}}。
* 变量名用{}包裹，且不能加双引号

## 组件的生命周期

三个状态：

* Mounting：已插入真实 DOM
* Updating：正在被重新渲染
* Unmounting：已移出真实 DOM

处理函数:

* componentWillMount()
* componentDidMount()
* componentWillUpdate(object nextProps, object nextState)
* componentDidUpdate(object prevProps, object prevState)
* componentWillUnmount()

特殊状态的处理函数:

* componentWillReceiveProps(object nextProps)：已加载组件收到新的参数时调用
* shouldComponentUpdate(object nextProps, object nextState)：组件判断是否重新渲染时调用

## jQuery vs React

jQuery插件方式，开发者首先需要考虑控件第一次Render出来时的DOM构建；其次，需要知道如何切换UI上的选中状态

```html
<!DOCTYPE html>
<html>
  <head>
    <script src="js/jquery.min.js"></script>
    <link rel="stylesheet" tpe="text/css" href="style.css"/>
  </head>
  <body>
    <div id="container"></div>
    <script type="text/javascript">
      var data = [
        {name: 'Red', value: 'red'},
        {name: 'Blue', value: 'blue'},
        {name: 'Yellow', value: 'yellow'},
        {name: 'Green', value: 'green'},
        {name: 'White', value: 'White'}
      ];
      $.fn.TabSelector = function (options) {
        var arr = ['<div class="tab-selector">'];
        arr.push('<label>', options.label, '</label>');
        arr.push('<ul>');
        options.data.forEach(function (item) {
          arr.push('<li data-value="', item.value, '">');
          arr.push(item.name);
          arr.push('</li>');
        });
        arr.push('</ul></div>');
        this.html(arr.join(''));
        var lastSelected = null;
        this.on('click', 'li', function () {
          var $this = $(this);
          if (lastSelected) {
            lastSelected.removeClass('selected');
          }
          $this.addClass('selected');
          lastSelected = $this;
        });
        return this;
      }
      $('#container').TabSelector({data: data, selected: null, label: 'Color'});
    </script>
  </body>
</html>
```

React的方式，开发者仅仅需要考虑整体界面的DOM构建，不再需要关心局部更新，每次在一个React的Component上调用setState方法，都会触发render来重建整个界面。从开发思想的角度看，你可以认为每次数据的更新都会做整体的完全刷新。逻辑简单而直接

```html
<!DOCTYPE html>
<html>
  <head>
    <script src="js/react.js"></script>
    <script src="js/JSXTransformer.js"></script>
    <link rel="stylesheet" tpe="text/css" href="style.css"/>
  </head>
  <body>
    <div id="container"></div>
    <script type="text/jsx">
      var data = [
        {name: 'Red', value: 'red'},
        {name: 'Blue', value: 'blue'},
        {name: 'Yellow', value: 'yellow'},
        {name: 'Green', value: 'green'},
        {name: 'White', value: 'White'}
      ];

      var TabSelector = React.createClass({
        getInitialState: function() {
          return {selected: this.props.selected};
        },

        handleOnClick: function (evt) {
          this.setState({'selected': evt.target.getAttribute('data-value')})
        },

        render: function() {
          var tabs = this.props.data.map(function (item) {
            var selected = item.value == this.state.selected ? 'selected' : '';
            return <li data-value={item.value}
                className={selected}
                onClick={this.handleOnClick}
              >{item.name}</li>
            ;
          }, this);

          return <div className="tab-selector">
            <label>{this.props.label}</label>
            <ul>
              {tabs}
            </ul>
          </div>
          ;
        }
      });

      React.render(
        TabSelector({label: 'Color', data: data, selected: null}),
        document.getElementById('container')
      );
    </script>
  </body>
</html>
```


如果我们再多考虑一步，控件的值不只在初始化和点击时可以设置，而且还可以通过程序动态的去设置。那么对于jQuery的方案而言，我们需要额外的方法和入口去做对应的UI更新。而对于React方式，则无需做任何改变，外部只需调用setState方法改变它的状态即可。这就是简化UI逻辑带来的好处。

