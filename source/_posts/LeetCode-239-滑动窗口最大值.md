---
title: LeetCode-239.滑动窗口最大值
tags:
  - LeetCode
  - 代码随想录
  - 队列
  - 单调队列
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: '6798'
date: 2022-10-07 16:12:13
updated: 2022-10-07 16:12:13
---

## [题目](https://leetcode.cn/problems/sliding-window-maximum/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0239.滑动窗口最大值.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=729559279&bvid=BV1XS4y1p7qj&cid=806301877&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 暴力解法时间复杂度是 O(n^2)，而用单调队列只有 O(n)
  - 使用双端队列实现单调递减队列，队顶始终是最大值
  - 每次滑动窗口时，均有元素入队和出对，然后队顶元素就是当前窗口的最大值

### 看完[代码随想录](https://programmercarl.com/0239.滑动窗口最大值.html)之后的想法

- 将单调队列的代码抽离封装好，主流程十分简单已读

### 实现过程中遇到的困难

- 实现单调队列时入队逻辑

### 代码

```ts TypeScript
function maxSlidingWindow(nums: number[], k: number): number[] {
  const res: number[] = [],
    queue = new MonoQueue<number>()
  for (let i = 0; i < nums.length; i++) {
    queue.enqueue(nums[i])
    if (i >= k) queue.dequeue(nums[i - k])
    if (i >= k - 1) res.push(queue.top())
  }
  return res
}

/** 单调递减队列 */
class MonoQueue<T> {
  queue: T[]
  constructor() {
    this.queue = []
  }

  enqueue(value: T): void {
    // 比value小的都剔除
    while (this.queue.length && value > this.queue[this.queue.length - 1]) this.queue.pop()
    this.queue.push(value)
  }

  dequeue(value: T): void {
    // value可能在前面元素push的时候已经被剔除了
    if (value === this.top()) this.queue.shift()
  }

  top(): T {
    return this.queue[0]
  }
}
```

时间复杂度：O(n)
空间复杂度：O(n)

## 收获

- 学习了单调队列
