---
title: LeetCode-347.前K个高频元素
tags:
  - LeetCode
  - 代码随想录
  - 优先队列
  - 堆
  - 小顶堆
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: df8f
date: 2022-10-07 18:10:56
updated: 2022-10-07 18:10:56
---

## [题目](https://leetcode.cn/problems/top-k-frequent-elements/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0347.前K个高频元素.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=514643371&bvid=BV1Xg41167Lz&cid=808260290&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 先统计每个元素出现次数，再使用优先队列，最后输出

### 看完[代码随想录](https://programmercarl.com/0347.前K个高频元素.html)之后的想法

- 为什么使用优先队列呢？因为直接排序时间复杂度一般是 O(n log n)

### 实现过程中遇到的困难

- 使用小顶堆而不是大顶堆，因为：
  - 如果用大顶堆，时间复杂度是 O(n log n)（高频元素在栈顶，那么堆就需要维护所有节点，最大是n）
  - 如果用小顶堆，时间复杂度是 O(n log k)（低频元素在栈顶被出栈，栈只需要维护k个节点，最终留下的k个元素就是前k个高频元素），明显时间复杂度要优一些

### 代码

```ts TypeScript
function topKFrequent(nums: number[], k: number): number[] {
  const statistic: { [k: number]: number } = nums.reduce((acc, cur) => (acc[cur] = (acc[cur] || 0) + 1, acc), {})
  const queue = new MinPriorityQueue({ priority: (item: [number, number]) => item[1] })
  for (const item of Object.entries(statistic)) {
    queue.enqueue(item)
    if (queue.size() > k) queue.dequeue()
  }
  const res: number[] = []
  while (queue.size()) res.push(queue.dequeue().element[0])
  return res
}
```

时间复杂度：O(n log k)
空间复杂度：O(k)

## 收获
