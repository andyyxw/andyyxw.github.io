---
title: LeetCode-541.反转字符串II
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
abbrlink: c80d
date: 2022-10-04 16:48:32
updated: 2022-10-04 16:48:32
---

## [题目](https://leetcode.cn/problems/reverse-string-ii/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0541.反转字符串II.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=471495028&bvid=BV1dT411j7NN&cid=787669511&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 模拟字符串遍历，分段拼接字符串

### 看完[代码随想录](https://programmercarl.com/0541.反转字符串II.html)之后的想法

- 可以将字符串先转化成数组，便于原地进行字符反转(同[344.反转字符串](/archives/f3c.html))，最后再转回字符串

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function reverseStr(s: string, k: number): string {
  const res = s.split('')
  for (let i = 0, len = res.length; i < len; i += k * 2) {
    let left = i,
      right = Math.min(i + k - 1, len - 1)
    while(left < right) {
      [res[left], res[right]] = [res[right], res[left]]
      left++
      right--
    }
  }
  return res.join('')
}

```

时间复杂度：O(n)
空间复杂度：O(n)

## 收获

- js中字符串是基本类型，不能直接修改，可转化为数组便于操作
