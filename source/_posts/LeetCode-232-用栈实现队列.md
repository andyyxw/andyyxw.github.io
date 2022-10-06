---
title: LeetCode-232.用栈实现队列
tags:
  - LeetCode
  - 代码随想录
  - 栈
  - 队列
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 5c9c
date: 2022-10-06 23:03:13
updated: 2022-10-06 23:03:13
---

## [题目](https://leetcode.cn/problems/implement-queue-using-stacks/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0232.用栈实现队列.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=644140871&bvid=BV1nY4y1w7VC&cid=794448489&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 利用两个栈来模拟

### 看完[代码随想录](https://programmercarl.com/0232.用栈实现队列.html)之后的想法

- 重点是利用第二个栈来模拟出队列行为

### 实现过程中遇到的困难

- 注意`popStack`中已有元素时，不能再向其中push了，否则就乱了（因为`popStack`的栈顶元素实际是模拟队列顶：即将要出队列的元素）

### 代码

```ts TypeScript
/**
 * Your MyQueue object will be instantiated and called as such:
 * var obj = new MyQueue()
 * obj.push(x)
 * var param_2 = obj.pop()
 * var param_3 = obj.peek()
 * var param_4 = obj.empty()
 */

class MyQueue {
  pushStack: number[]
  popStack: number[]
  constructor() {
    this.pushStack = []
    this.popStack = []
  }

  transfer() {
    if (this.popStack.length) return
    while (this.pushStack.length) this.popStack.push(this.pushStack.pop())
  }

  push(x: number): void {
    this.pushStack.push(x)
  }

  pop(): number {
    this.transfer()
    return this.popStack.pop()
  }

  peek(): number {
    this.transfer()
    return this.popStack[this.popStack.length - 1]
  }

  empty(): boolean {
    return !(this.pushStack.length || this.popStack.length)
  }
}
```

## 收获

- **一定要懂得复用，功能相近的函数要抽象出来，不要大量的复制粘贴，很容易出问题！（踩过坑的人自然懂）**
