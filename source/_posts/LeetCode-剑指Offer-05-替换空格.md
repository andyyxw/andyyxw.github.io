---
title: LeetCode-剑指Offer-05.替换空格
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
abbrlink: '56e6'
date: 2022-10-04 20:32:43
updated: 2022-10-04 20:32:43
---

## [题目](https://leetcode.cn/problems/ti-huan-kong-ge-lcof/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/剑指Offer05.替换空格.html)

### 思路

- 遍历一遍字符串，然后拼接

### 看完[代码随想录](https://programmercarl.com/剑指Offer05.替换空格.html)之后的想法

- 可以数组填充法（预先给数组扩容带填充后的大小，然后在从后向前进行操作），原地修改
  - 注意要从后向前填充，因为原数组会被膨胀（从前向后填充就是O(n^2)的算法了，因为每次添加元素都要将添加元素之后的所有元素向后移动）
  - 类似于[27.移除元素](/archives/64f.html)，我们是从前向后覆盖原数组，因为原数组是在做删除操作会被收缩

### 实现过程中遇到的困难

- 注意要从后往前填充

### 代码

```ts TypeScript
function replaceSpace(s: string): string {
  const res = s.split('')
  const spaceNum = res.reduce((acc, cur) => cur === ' ' ? acc + 1 : acc, 0)
  let left = s.length - 1,
    right = left + spaceNum * 2
  while (left >= 0) {
    if (res[left] === ' ') {
      res[right--] = '0'
      res[right--] = '2'
      res[right--] = '%'
    } else {
      res[right--] = res[left]
    }
    left--
  }
  return res.join('')
}
```

时间复杂度：O(n)
空间复杂度：O(1)

## 收获

- 将字符串转化为数组便于操作
