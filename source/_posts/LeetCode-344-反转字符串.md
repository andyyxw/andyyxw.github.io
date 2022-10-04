---
title: LeetCode-344.反转字符串
tags:
  - LeetCode
  - 代码随想录
  - 字符串
  - 双指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: f3c
date: 2022-10-04 16:29:00
updated: 2022-10-04 16:29:00
---

## [题目](https://leetcode.cn/problems/reverse-string/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0344.反转字符串.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=856322054&bvid=BV1fV4y17748&cid=785729810&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 双指针收缩，每次交换两个指针的元素值

### 看完[代码随想录](https://programmercarl.com/0344.反转字符串.html)之后的想法

- 思路一致

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function reverseString(s: string[]): void {
  let left = 0,
    right = s.length - 1
  while (left < right) {
    [s[left], s[right]] = [s[right], s[left]]
    left++
    right--
  }
}
```

时间复杂度：O(n)
空间复杂度：O(1)

## 收获

- 在算法的解题思路上，字符串和数组是差不多的，只不过在不同编程语言中有着不同的操作
