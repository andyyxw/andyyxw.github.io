---
title: LeetCode-151.反转字符串中的单词
tags:
  - LeetCode
  - 代码随想录
  - 字符串
  - 双指针
  - 快慢指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: '9090'
date: 2022-10-04 20:47:04
updated: 2022-10-04 20:47:04
---

## [题目](https://leetcode.cn/problems/reverse-words-in-a-string/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0151.翻转字符串里的单词.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=471513250&bvid=BV1uT41177fX&cid=790645275&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

### 看完[代码随想录](https://programmercarl.com/0151.翻转字符串里的单词.html)之后的想法

- 要保持最优空间复杂度，只能原地修改字符串（js中字符串是不可变数据类型，只能先转为数组，后续操作的算法思想是正确的）

### 实现过程中遇到的困难

- 移除多余空格时的边界条件处理

### 代码

```ts TypeScript
function reverseWords(s: string): string {
  const strArr = s.split('')
  removeExtraSpaces(strArr)
  const len = strArr.length
  // 先整体反转
  reverse(strArr, 0, len - 1)
  // 再把每个单词反转回来
  let start = 0
  for (let i = 0; i <= len; i++) {
    if (strArr[i] === ' ' || i === len) {
      reverse(strArr, start, i - 1)
      start = i + 1
    }
  }
  return strArr.join('')
}

/** 删除多余空格 */
function removeExtraSpaces(strArr: string[]) {
  let slow = 0,
    fast = 0
  while (fast < strArr.length) {
    // 移除开始位置和重复的空格
    if (strArr[fast] === ' ' && (fast === 0 || strArr[fast - 1] === ' ')){
      fast++
    } else {
      strArr[slow++] = strArr[fast++]
    }
  }
  strArr.length = strArr[slow - 1] === ' ' ? slow - 1 : slow
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

## 收获
