---
title: LeetCode-27.移除元素
tags:
  - LeetCode
  - 代码随想录
  - 数组
  - 双指针
  - 快慢指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 64f
date: 2022-09-23 04:52:00
updated: 2022-09-23 04:52:00
---

## [题目](https://leetcode.cn/problems/remove-element/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0027.移除元素.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=896973525&bvid=BV12A4y1Z7LP&cid=731188361&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 先排序，再使用双指针去遍历找到需要移除的那段区间移除掉

### 看完[代码随想录](https://programmercarl.com/0027.移除元素.html)之后的想法

- 原来不需要排序，只遍历一遍就可以，原地修改数组

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function removeElement(nums: number[], val: number): number {
  let slow = 0, // 慢指针指向新数组的元素
    fast = 0 // 快指针指向原数组的元素
  while (fast < nums.length) {
    if (nums[fast] !== val) nums[slow++] = nums[fast]
    fast++
  }
  return slow
}
```

时间复杂度：O(n)
空间复杂度：O(1)

## 收获
