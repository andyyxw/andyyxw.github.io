---
title: LeetCode-剑指Offer-58-II.左旋转字符串
tags:
  - LeetCode
  - 代码随想录
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 8a8
date: 2022-10-04 21:40:39
updated: 2022-10-04 21:40:39
---

## [题目](https://leetcode.cn/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/剑指Offer58-II.左旋转字符串.html)

### 思路

1. 便历一遍，前面部分动态填充到数组尾部
2. 后面部分原地修改数组
3. 截取长度

### 看完[代码随想录](https://programmercarl.com/剑指Offer58-II.左旋转字符串.html)之后的想法

- 学习到了`局部反转+整体反转`的解法

### 实现过程中遇到的困难

### 代码

- 局部反转+整体反转
  ```ts TypeScript
  function reverseLeftWords(s: string, n: number): string {
    const strArr = s.split(''),
      len = s.length
    reverse(strArr, 0, n - 1)
    reverse(strArr, n, len - 1)
    reverse(strArr, 0, len - 1)
    return strArr.join('')
  }

  /** 反转数组元素 */
  function reverse(strArr: string[], start: number, end: number) {
    while (start < end) {
      [strArr[start], strArr[end]] = [strArr[end], strArr[start]]
      start++
      end--
    }
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(n)
- 填充
  ```ts TypeScript
  function reverseLeftWords(s: string, n: number): string {
    const strArr = s.split(''),
      len = s.length
    let slow = 0,
      fast = 0
    while (fast < len + n) {
      if (fast < n) strArr.push(strArr[fast++])
      else strArr[slow++] = strArr[fast++]
    }
    strArr.length = len
    return strArr.join('')
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(n)

## 收获

- 字符串反转有时候 局部反转、整体反转 能更巧妙的解决问题
