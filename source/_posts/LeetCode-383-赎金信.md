---
title: LeetCode-383.赎金信
tags:
  - LeetCode
  - 代码随想录
  - 哈希表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: '9001'
date: 2022-10-04 11:58:50
updated: 2022-10-04 11:58:50
---

## [题目](https://leetcode.cn/problems/ransom-note/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0383.赎金信.html)

### 思路

- 哈希表记录每个字符串出现的次数

### 看完[代码随想录](https://programmercarl.com/0383.赎金信.html)之后的想法

- 思路一致

### 实现过程中遇到的困难

### 代码

- Hash Array
  ```ts TypeScript
  function canConstruct(ransomNote: string, magazine: string): boolean {
    const hash = Array(26).fill(0)
    const base = 'a'.codePointAt(0)
    for (let i = 0; i < magazine.length; i++) hash[magazine.codePointAt(i) - base]++
    for (let i = 0; i < ransomNote.length; i++) {
      const index = ransomNote.codePointAt(i) - base
      hash[index]--
      if (hash[index] < 0) return false
    }
    return true
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(n)
- Hash Map
  ```ts TypeScript
  function canConstruct(ransomNote: string, magazine: string): boolean {
    const hash = new Map<string, number>()
    for (const c of magazine) hash.set(c, (hash.get(c) || 0) + 1)
    for (const c of ransomNote) {
      const count = hash.get(c)
      if (count > 0) hash.set(c, count - 1)
      else return false
    }
    return true
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(n)

## 收获

- 已经轻车熟路了，与[242.有效的字母异位词](/archives/6aa1.html)解法一致
