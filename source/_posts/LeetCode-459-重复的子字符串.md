---
title: LeetCode-459.重复的子字符串
tags:
  - LeetCode
  - 代码随想录
  - 字符串
  - KMP
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: e0bf
date: 2022-10-06 22:23:56
updated: 2022-10-06 22:23:56
---

## [题目](https://leetcode.cn/problems/repeated-substring-pattern/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0459.重复的子字符串.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=514040419&bvid=BV1cg41127fw&cid=792550174&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 想到了用KMP，但是没想明白前缀表的用处

### 看完[代码随想录](https://programmercarl.com/0459.重复的子字符串.html)之后的想法

- get了移动字符串匹配解法
- 利用前缀表 通过数学推导出最小重复子串：除去最大公共前后缀的剩余部分就是最小重复子串

### 实现过程中遇到的困难

- KMP求前缀表
- 前缀表的作用

### 代码

- 移动字符串匹配
  ```ts TypeScript
  function repeatedSubstringPattern(s: string): boolean {
    return (s + s).slice(1, s.length * 2 - 1).includes(s)
  }
  ```
- KMP
  ```ts TypeScript
  function repeatedSubstringPattern(s: string): boolean {
    const prefix = getPrefix(s),
      lastPrefix = prefix[prefix.length - 1]
    return lastPrefix !== 0 && (s.length % (s.length - lastPrefix)) === 0
  }

  function getPrefix(s: string): number[] {
    let j = 0
    const prefix: number[] = [j]
    for (let i = 1; i < s.length; i++) {
      while (j > 0 && s[i] !== s[j]) j = prefix[j - 1]
      if (s[i] === s[j]) j++
      prefix[i] = j
    }
    return prefix
  }
  ```

## 收获

- get了利用KMP求最小重复子串的方法
