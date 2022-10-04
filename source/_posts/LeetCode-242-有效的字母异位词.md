---
title: LeetCode-242.有效的字母异位词
tags:
  - LeetCode
  - 代码随想录
  - 哈希表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 6aa1
date: 2022-10-03 22:23:09
updated: 2022-10-03 22:23:09
---

## [题目](https://leetcode.cn/problems/valid-anagram/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0242.有效的字母异位词.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=428486350&bvid=BV1YG411p7BA&cid=772001165&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 使用hash表记录每个字符出现的次数再比较

### 看完[代码随想录](https://programmercarl.com/0242.有效的字母异位词.html)之后的想法

- 原本我用的是hashMap，后来发现不需要，用数组即可
- 只创建一个hash数组即可，并且两个字符串只需要分别遍历一遍，一遍累加一遍累减即可

### 实现过程中遇到的困难

### 代码

- Hash Array
  ```ts TypeScript
  function isAnagram(s: string, t: string): boolean {
    if (s.length !== t.length) return false
    const hash: number[] = Array(26).fill(0)
    const base = 'a'.codePointAt(0)
    for (let i = 0; i < s.length; i++) hash[s.codePointAt(i) - base]++
    for (let i = 0; i < t.length; i++) {
      hash[t.codePointAt(i) - base]--
      if (hash[t.codePointAt(i) - base] < 0) return false
    }
    return true
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(n)
- Hash Map
  ```ts TypeScript
  function isAnagram(s: string, t: string): boolean {
    if (s.length !== t.length) return false
    const hash = new Map<string, number>()
    for (const c of s) hash.set(c, (hash.get(c) || 0) + 1)
    for (const c of t) {
      const count = hash.get(c)
      if (count > 0) hash.set(c, count  - 1)
      else return false
    }
    return true
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(n)

## 收获
