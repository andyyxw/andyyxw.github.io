---
title: 精读《Function VS Class 组件》
tags:
  - React
  - React组件
  - React Hooks
categories: 
    - 前端
    - React
description: 为什么要了解 Function 写法的组件呢？因为它正在变得越来越重要。
abbrlink: ecb7
date: 2019-09-04 21:08:02
---


> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 https://zhuanlan.zhihu.com/p/59558396

1. 引言
-----

为什么要了解 Function 写法的组件呢？因为它正在变得越来越重要。

那么 React 中 **Function Component 与 Class Component 有何不同？**

[how-are-function-components-different-from-classes](https://overreacted.io/how-are-function-components-different-from-classes/) 这篇文章带来了一个独特的视角。

> 顺带一提，以后会用 Function Component 代替 Stateless Component 的说法，原因是：自从 Hooks 出现，函数式组件功能在不断丰富，函数式组件不再需要强调其无状态特性，因此叫 Function Component 更为恰当。

2. 概述
-----

原文事先申明：并没有对 Function 与 Classes 进行优劣对比，而仅仅进行特性对比，所以不接受任何吐槽。

> 这两种写法没有好坏之分，性能差距也几乎可以忽略，而且 React 会长期支持这两种写法。

Capture props
-------------

对比下面两段代码。

**Class Component:**

```
class ProfilePage extends React.Component {
  showMessage = () => {
    alert("Followed " + this.props.user);
  };

  handleClick = () => {
    setTimeout(this.showMessage, 3000);
  };

  render() {
    return <button onClick={this.handleClick}>Follow</button>;
  }
}

```

**Function Component:**

```
function ProfilePage(props) {
  const showMessage = () => {
    alert("Followed " + props.user);
  };

  const handleClick = () => {
    setTimeout(showMessage, 3000);
  };

  return <button onClick={handleClick}>Follow</button>;
}

```

（[在线 Demo](https://codesandbox.io/s/pjqnl16lm7)）

这两个组件都描述了同一个逻辑：点击按钮 3 秒后 `alert` 父级传入的用户名。

如下父级组件的调用方式：

```
<ProfilePageFunction user={this.state.user} />
<ProfilePageClass user={this.state.user} />

```

那么当点击按钮后的 3 秒内，父级修改了 `this.state.user`，弹出的用户名是修改前的还是修改后的呢？

**Class Component 展示的是修改后的值：**

<img src="[https://pic4.zhimg.com/v2-9d9d77bb138395301509792d9ae9acbf_b.gif](https://pic4.zhimg.com/v2-9d9d77bb138395301509792d9ae9acbf_b.gif)" data-caption=""data-size="normal"data-rawwidth="950"data-rawheight="351"data-thumbnail="[https://pic4.zhimg.com/v2-9d9d77bb138395301509792d9ae9acbf_b.jpg](https://pic4.zhimg.com/v2-9d9d77bb138395301509792d9ae9acbf_b.jpg)"width="950"data-original="[https://pic4.zhimg.com/v2-9d9d77bb138395301509792d9ae9acbf_r.jpg](https://pic4.zhimg.com/v2-9d9d77bb138395301509792d9ae9acbf_r.jpg)"/>![](https://pic4.zhimg.com/v2-9d9d77bb138395301509792d9ae9acbf_b.jpg)

**Function Component 展示的是修改前的值：**

<img src="[https://pic3.zhimg.com/v2-84396c4b3982827bead96912a947904e_b.gif](https://pic3.zhimg.com/v2-84396c4b3982827bead96912a947904e_b.gif)" data-caption=""data-size="normal"data-rawwidth="901"data-rawheight="293"data-thumbnail="[https://pic3.zhimg.com/v2-84396c4b3982827bead96912a947904e_b.jpg](https://pic3.zhimg.com/v2-84396c4b3982827bead96912a947904e_b.jpg)"width="901"data-original="[https://pic3.zhimg.com/v2-84396c4b3982827bead96912a947904e_r.jpg](https://pic3.zhimg.com/v2-84396c4b3982827bead96912a947904e_r.jpg)"/>![](https://pic3.zhimg.com/v2-84396c4b3982827bead96912a947904e_b.jpg)

那么 React 文档中描述的 `props` 不是不可变（Immutable） 数据吗？为啥在运行时还会发生变化呢？

原因在于，虽然 `props` 不可变，是 `this` 在 Class Component 中是可变的，因此 `this.props` 的调用会导致每次都访问最新的 `props`。

而 Function Component 不存在 `this.props` 的语法，因此 `props` 总是不可变的。

为了便于理解，笔者补充一些代码注解：

**Function Component:**

```
function ProfilePage(props) {
  setTimeout(() => {
    // 就算父组件 reRender，这里拿到的 props 也是初始的
    console.log(props);
  }, 3000);
}

```

**Class Component:**

```
class ProfilePage extends React.Component {
  render() {
    setTimeout(() => {
      // 如果父组件 reRender，this.props 拿到的永远是最新的。
      // 并不是 props 变了，而是 this.props 指向了新的 props，旧的 props 找不到了
      console.log(this.props);
    }, 3000);
  }
}

```

如果希望在 Class Component 捕获瞬时 Props，可以： `const props = this.props;`，但这样的代码很蹩脚，所以如果希望拿到稳定的 `props`，使用 Function Component 是更好的选择。

Hooks 也具有 capture value 特性
--------------------------

看下面的代码：

```
function MessageThread() {
  const [message, setMessage] = useState("");

  const showMessage = () => {
    alert("You said: " + message);
  };

  const handleSendClick = () => {
    setTimeout(showMessage, 3000);
  };

  const handleMessageChange = e => {
    setMessage(e.target.value);
  };

  return (
    <>
      <input value={message} onChange={handleMessageChange} />
      <button onClick={handleSendClick}>Send</button>
    </>
  );
}

```

（[在线 Demo](https://codesandbox.io/s/93m5mz9w24)）

在点击 `Send` 按钮后，再次修改输入框的值，3 秒后的输出依然是 **点击前输入框的值**。这说明 Hooks 同样具有 capture value 的特性。

利用 `useRef` 可以规避 capture value 特性：

```
function MessageThread() {
  const latestMessage = useRef("");

  const showMessage = () => {
    alert("You said: " + latestMessage.current);
  };

  const handleSendClick = () => {
    setTimeout(showMessage, 3000);
  };

  const handleMessageChange = e => {
    latestMessage.current = e.target.value;
  };
}

```

只要将赋值与取值的对象变成 `useRef`，而不是 `useState`，就可以躲过 capture value 特性，在 3 秒后得到最新的值。

这说明了利用 Function Component + Hooks 可以实现 Class Component 做不到的 capture props、capture value，而且 React 官方也推荐 [新的代码使用 Hooks 编写](https://reactjs.org/docs/hooks-faq.html#do-i-need-to-rewrite-all-my-class-components)。

3. 精读
-----

原文 [how-are-function-components-different-from-classes](https://overreacted.io/how-are-function-components-different-from-classes/) 从一个侧面讲述了 Function Component 与 Class Component 的不同点，之所以将 Function Component 与 Class Component 相提并论，几乎都要归功于 Hooks API 的出现，有了 Hooks，Function Component 的能力才得以向 Class Component 看齐。

关于 React Hooks，之前的两篇精读分别有过介绍：

*   [精读《React Hooks》](https://github.com/dt-fe/weekly/blob/master/79.%E7%B2%BE%E8%AF%BB%E3%80%8AReact%20Hooks%E3%80%8B.md)
*   [精读《怎么用 React Hooks 造轮子》](https://github.com/dt-fe/weekly/blob/master/80.%E7%B2%BE%E8%AF%BB%E3%80%8A%E6%80%8E%E4%B9%88%E7%94%A8%20React%20Hooks%20%E9%80%A0%E8%BD%AE%E5%AD%90%E3%80%8B.md)

但是，虽然 Hook 已经发布了稳定版本，但周边生态跟进还需要时间（比如 `useRouter`）、最佳实践整理还需要时间，因此不建议重构老代码。

为了更好的使用 Function Component，建议时常与 Class Component 的功能做对比，方便理解和记忆。

下面整理一些常见的 Function Component 问题：

> 非常建议完整阅读 [React Hooks FAQ](https://reactjs.org/docs/hooks-faq.html#do-i-need-to-rewrite-all-my-class-components)。

怎么替代 shouldComponentUpdate
--------------------------

说实话，Function Component 替代 `shouldComponentUpdate` 的方案并没有 Class Component 优雅，代码是这样的：

```
const Button = React.memo(props => {
  // your component
});

```

或者在父级就直接生成一个自带 `memo` 的子元素：

```
function Parent({ a, b }) {
  // Only re-rendered if `a` changes:
  const child1 = useMemo(() => <Child1 a={a} />, [a]);
  // Only re-rendered if `b` changes:
  const child2 = useMemo(() => <Child2 b={b} />, [b]);
  return (
    <>
      {child1}
      {child2}
    </>
  );
}

```

相比之下，Class Component 的写法通常是：

```
class Button extends React.PureComponent {}

```

这样就自带了 `shallowEqual` 的 `shouldComponentUpdate`。

怎么替代 componentDidUpdate
-----------------------

由于 `useEffect` 每次 Render 都会执行，因此需要模拟一个 `useUpdate` 函数：

```
const mounting = useRef(true);
useEffect(() => {
  if (mounting.current) {
    mounting.current = false;
  } else {
    fn();
  }
});

```

更多可以查看 [精读《怎么用 React Hooks 造轮子》](https://github.com/dt-fe/weekly/blob/master/80.%E7%B2%BE%E8%AF%BB%E3%80%8A%E6%80%8E%E4%B9%88%E7%94%A8%20React%20Hooks%20%E9%80%A0%E8%BD%AE%E5%AD%90%E3%80%8B.md#componentdidupdate)

怎么替代 forceUpdate
----------------

React 官方文档提供了一种方案：

```
const [ignored, forceUpdate] = useReducer(x => x + 1, 0);

function handleClick() {
  forceUpdate();
}

```

每次执行 `dispatch` 时，只要 `state` 变化就会触发组件更新。当然 `useState` 也同样可以模拟：

```
const useUpdate = () => useState(0)[1];

```

我们知道 `useState` 下标为 1 的项是用来更新数据的，而且就算数据没有变化，调用了也会刷新组件，所以我们可以把返回一个没有修改数值的 `setValue`，这样它的功能就仅剩下刷新组件了。

更多可以查看 [精读《怎么用 React Hooks 造轮子》](https://github.com/dt-fe/weekly/blob/master/80.%E7%B2%BE%E8%AF%BB%E3%80%8A%E6%80%8E%E4%B9%88%E7%94%A8%20React%20Hooks%20%E9%80%A0%E8%BD%AE%E5%AD%90%E3%80%8B.md#force-update)

state 拆分过多
----------

`useState` 目前的一种实践，是将变量名打平，而非像 Class Component 一样写在一个 State 对象里：

```
class ClassComponent extends React.PureComponent {
  state = {
    left: 0,
    top: 0,
    width: 100,
    height: 100
  };
}

// VS

function FunctionComponent {
  const [left,setLeft] = useState(0)
  const [top,setTop] = useState(0)
  const [width,setWidth] = useState(100)
  const [height,setHeight] = useState(100)
}

```

实际上在 Function Component 中也可以聚合管理 State：

```
function FunctionComponent() {
  const [state, setState] = useState({
    left: 0,
    top: 0,
    width: 100,
    height: 100
  });
}

```

只是更新的时候，不再会自动 merge，而需要使用 `...state` 语法：

```
setState(state => ({ ...state, left: e.pageX, top: e.pageY }));

```

可以看到，更少的黑魔法，更可预期的结果。

获取上一个 props
-----------

虽然不怎么常用，但是毕竟 Class Component 可以通过 `componentWillReceiveProps` 拿到 `previousProps` 与 `nextProps`，对于 Function Component，最好通过自定义 Hooks 方式拿到上一个状态：

```
function Counter() {
  const [count, setCount] = useState(0);
  const prevCount = usePrevious(count);
  return (
    <h1>
      Now: {count}, before: {prevCount}
    </h1>
  );
}

function usePrevious(value) {
  const ref = useRef();
  useEffect(() => {
    ref.current = value;
  });
  return ref.current;
}

```

通过 `useEffect` 在组件渲染完毕后再执行的特性，再利用 `useRef` 的可变特性，让 `usePrevious` 的返回值是 “上一次” Render 时的。

可见，合理运用 `useEffect` `useRef`，可以做许多事情，而且封装成 CustomHook 后使用起来仍然很方便。

> 未来 `usePrevious` 可能成为官方 Hooks 之一。

性能注意事项
------

`useState` 函数的参数虽然是初始值，但由于整个函数都是 Render，因此每次初始化都会被调用，如果初始值计算非常消耗时间，建议使用函数传入，这样只会执行一次：

```
function FunctionComponent(props) {
  const [rows, setRows] = useState(() => createRows(props.count));
}

```

> `useRef` 不支持这种特性，需要[写一些冗余的函判定是否进行过初始化](https://reactjs.org/docs/hooks-faq.html#how-to-create-expensive-objects-lazily)。

掌握了这些，Function Component 使用起来与 Class Component 就几乎没有差别了！

4. 总结
-----

Function Component 功能已经可以与 Class Component 媲美了，但目前最佳实践比较零散，官方文档推荐的一些解决思路甚至不比社区第三方库的更好，可以预料到，Class Component 的功能会被五花八门的实现出来，那些没有被收纳进官方的 Hooks 乍看上去可能会眼花缭乱。

总之选择了 Function Component 就同时选择了函数式的好与坏。**好处是功能强大，几乎可以模拟出任何想要的功能**，**坏处是由于可以灵活组合，如果自定义 Hooks 命名和实现不够标准，函数与函数之间对接的沟通成本会更大。**

> 讨论地址是：[精读《Stateless VS Class 组件》 · Issue #137 · dt-fe/weekly](https://github.com/dt-fe/weekly/issues/137)

**如果你想参与讨论，请** **[点击这里](https://github.com/dt-fe/weekly)，每周都有新的主题，周末或周一发布。前端精读 - 帮你筛选靠谱的内容。**

> 关注 **前端精读微信公众号**

<img src="[https://pic3.zhimg.com/v2-d817340c54185469ec4df17c0938742e_b.jpg](https://pic3.zhimg.com/v2-d817340c54185469ec4df17c0938742e_b.jpg)" data-caption=""data-size="normal"data-rawwidth="258"data-rawheight="258"width="258"/>![](https://pic3.zhimg.com/80/v2-d817340c54185469ec4df17c0938742e_hd.jpg)

**special Sponsors**

*   [DevOps 全流程平台](https://e.coding.net/?utm_source=weekly)

> 版权声明：自由转载 - 非商用 - 非衍生 - 保持署名（[创意共享 3.0 许可证](https://creativecommons.org/licenses/by-nc-nd/3.0/deed.zh)）

写下你的评论...  

在线 Demo 挂了~

修复了

class 的这个 bug Dan 好像提过 用 const {XXX} = this.props 可以解决

你在文中好像提了 我没仔细看 不好意思

![](https://pic1.zhimg.com/v2-12562ad40366818a1ea39bcecb2599a0_r.gif)

那么问题来了，为什么要用 hooks...

生命在于不息

我觉得那段 props immutable 解释的是不是有点歧义。。比如，instance 的 this 是可变的，this 在完整的组件声明周期里并不会修改啊，只是 this 上的 props 可能会修改指向。然后。下文用 setTimeout 这段表达的其实是闭包针对变量的捕获吧，这个和是不是 immutable 关系并不大吧 （我觉得这里完全就是闭包的问题）？