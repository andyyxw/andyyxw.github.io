---
title: LeetCode-454.四数相加II
tags:
  - LeetCode
  - 代码随想录
  - 哈希表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 4a6c
date: 2022-10-04 11:33:34
updated: 2022-10-04 11:33:34
---

## [题目](https://leetcode.cn/problems/4sum-ii/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0454.四数相加II.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=386006485&bvid=BV1Md4y1Q7Yh&cid=778751921&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

### 看完[代码随想录](https://programmercarl.com/0454.四数相加II.html)之后的想法

- 将数组分为两部分的思路很好，之前没想到

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function fourSumCount(nums1: number[], nums2: number[], nums3: number[], nums4: number[]): number {
  let res = 0
  const hash = new Map<number, number>()
  for (const v1 of nums1) {
    for (const v2 of nums2) {
      const v = v1 + v2
      hash.set(v, (hash.get(v) || 0) + 1)
    }
  }
  for (const v1 of nums3) {
    for (const v2 of nums4) {
      res += (hash.get(0 - (v1 + v2)) || 0)
    }
  }
  return res
}
```

时间复杂度：O($n^2$)
空间复杂度：O(n)

## 收获

- 哈希法的经典题目
