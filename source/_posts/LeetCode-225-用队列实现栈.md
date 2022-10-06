---
title: LeetCode-225.用队列实现栈
tags:
  - LeetCode
  - 代码随想录
  - 队列
  - 栈
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: fd25
date: 2022-10-06 23:23:15
updated: 2022-10-06 23:23:15
---

## [题目](https://leetcode.cn/problems/implement-stack-using-queues/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0225.用队列实现栈.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=344329109&bvid=BV1Fd4y1K7sm&cid=797278452&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 两个队列互相倒腾：
  - pop时将队列1中的元素队列并入队到队列2，剩最后一个即pop的目标元素
  - 如果pop时队列为空，则将队列2与队列1内容互换

### 看完[代码随想录](https://programmercarl.com/0225.用队列实现栈.html)之后的想法

- 学会了只用一个队列也能实现栈

### 实现过程中遇到的困难

### 代码

- 一个队列实现栈
  ```ts TypeScript
  /**
  * Your MyStack object will be instantiated and called as such:
  * var obj = new MyStack()
  * obj.push(x)
  * var param_2 = obj.pop()
  * var param_3 = obj.top()
  * var param_4 = obj.empty()
  */

  class MyStack {
    queue: number[]
    constructor() {
      this.queue = []
    }

    push(x: number): void {
      this.queue.push(x)
    }

    pop(): number {
      let len = this.queue.length
      while (--len) this.queue.push(this.queue.shift())
      return this.queue.shift()
    }

    top(): number {
      const top = this.pop()
      this.queue.push(top)
      return top
    }

    empty(): boolean {
      return !this.queue.length
    }
  }
  ```
- 两个队列实现栈
  ```ts TypeScript
  /**
  * Your MyStack object will be instantiated and called as such:
  * var obj = new MyStack()
  * obj.push(x)
  * var param_2 = obj.pop()
  * var param_3 = obj.top()
  * var param_4 = obj.empty()
  */

  class MyStack {
    queue1: number[]
    queue2: number[]
    constructor() {
      this.queue1 = []
      this.queue2 = []
    }

    push(x: number): void {
      this.queue1.push(x)
    }

    pop(): number {
      if (!this.queue1.length) [this.queue1, this.queue2] = [this.queue2, this.queue1]
      while (this.queue1.length > 1) this.queue2.push(this.queue1.shift())
      return this.queue1.shift()
    }

    top(): number {
      const top = this.pop()
      this.queue1.push(top)
      return top
    }

    empty(): boolean {
      return !this.queue1.length && !this.queue2.length
    }
  }
  ```

## 收获

- 学会了极致的的代码复用。本题中`top`函数就完全复用了`pop`函数逻辑
