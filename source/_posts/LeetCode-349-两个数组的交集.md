---
title: LeetCode.349.两个数组的交集
tags:
  - LeetCode
  - 代码随想录
  - 哈希表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 4dd2
date: 2022-10-03 23:22:08
updated: 2022-10-03 23:22:08
---

## [题目](https://leetcode.cn/problems/intersection-of-two-arrays/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0349.两个数组的交集.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=258484486&bvid=BV1ba411S7wu&cid=774679429&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

1. 选择一个合适的数据结构：本题需要判断一个元素在集合中是否出现过，典型的哈希表的使用场景，又不需要记录出现次数 那就用`hash set`即可

### 看完[代码随想录](https://programmercarl.com/0349.两个数组的交集.html)之后的想法

- 思路一致

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function intersection(nums1: number[], nums2: number[]): number[] {
  const hash = new Set(nums1)
  return Array.from(
    nums2.reduce(
      (acc, cur) => (hash.has(cur) && acc.add(cur), acc),
      new Set<number>()
    )
  )
}
```

时间复杂度：O(n)
空间复杂度：O(1)

## 收获
