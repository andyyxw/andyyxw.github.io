---
title: LeetCode-28.找出字符串中第一个匹配项的下标
tags:
  - LeetCode
  - 代码随想录
  - 字符串
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: c765
date: 2022-10-06 21:03:58
updated: 2022-10-06 21:03:58
---

## [题目](https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0028.实现strStr.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=712030093&bvid=BV1PD4y1o7nd&cid=493095580&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=457239548&bvid=BV1M5411j7Xx&cid=496522111&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 解决字符串匹配的经带宁解法：KMP算法

### 看完[代码随想录](https://programmercarl.com/0028.实现strStr.html)之后的想法

### 实现过程中遇到的困难

- 学习理解KMP算法
  - 理解KMP算法的原理，它是如何加速字符串匹配的
  - 生成前缀表
  - 利用前缀表写出匹配过程

### 代码

```ts TypeScript
function strStr(haystack: string, needle: string): number {
  const prefix = getPrefix(needle)
  let j = 0
  for (let i = 0; i < haystack.length; i++) {
    while (j > 0 && haystack[i] !== needle[j]) j = prefix[j - 1]
    if (haystack[i] === needle[j]) {
      if (j === needle.length - 1) return i - j
      j++
    }
  }
  return -1
}

/** 求KMP最长公共前后缀 */
function getPrefix(str: string): number[] {
  let j = 0
  const prefix: number[] = [j]
  for (let i = 1; i < str.length; i++) {
    while (j > 0 && str[i] !== str[j]) j = prefix[j - 1]
    if (str[i] === str[j]) j++
    prefix[i] = j
  }
  return prefix
}
```

时间复杂度：O(m+n)
空间复杂度：O(n)

## 收获

- 系统学习了KMP算法
