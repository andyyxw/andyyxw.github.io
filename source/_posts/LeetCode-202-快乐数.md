---
title: LeetCode-202.快乐数
tags:
  - LeetCode
  - 代码随想录
  - 哈希表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 971d
date: 2022-10-04 10:29:03
updated: 2022-10-04 10:29:03
---

## [题目](https://leetcode.cn/problems/happy-number/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0202.快乐数.html)

### 思路

- 题目中说了如果不是快乐数就会出现无限循环，那么用哈希表记录n的每次迭代值：
  - 出现1则为快乐数
  - 出现重复值则不是

### 看完[代码随想录](https://programmercarl.com/0202.快乐数.html)之后的想法

- 思路一致

### 实现过程中遇到的困难

- 计算迭代值时要细心点

### 代码

- 哈希表
  ```ts TypeScript
  function isHappy(n: number): boolean {
    const hash = new Set<number>()
    while (n !== 1) {
      if (hash.has(n)) return false
      hash.add(n)
      n = getNext(n)
    }
    return true
  }

  function getNext(n: number): number {
    let sum = 0
    while (n) {
      sum += (n % 10) ** 2
      n = Math.floor(n / 10)
    }
    return sum
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(n)

- 快慢指针（空间复杂度较好）
  ```ts TypeScript
  function isHappy(n: number): boolean {
    let slow = n,
      fast = n
    // 环形链表的思想，如果有环，快慢指针一定会在环内相遇
    while (true) {
      slow = getNext(slow)
      fast = getNext(getNext(fast))
      if (slow === fast) return slow === 1
    }
  }

  function getNext(n: number): number {
    let sum = 0
    while (n) {
      sum += (n % 10) ** 2
      n = Math.floor(n / 10)
    }
    return sum
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(1)

## 收获

- 要透过现象发现本质。本题看上去像是数学问题，其实不是。
