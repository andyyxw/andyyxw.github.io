---
title: LeetCode-27.移除元素
tags:
  - LeetCode
  - 代码随想录
  - 双指针
  - 快慢指针
  - 数组
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 64f
date: 2022-09-23 04:52:00
updated: 2022-09-23 04:52:00
---

## <center>[LeetCode-27.移除元素](https://leetcode.cn/problems/remove-element/)</center>

### 题目详解

- 相关链接：[文章](https://programmercarl.com/0027.%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0.html#_27-%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0)、[视频](https://www.bilibili.com/video/BV12A4y1Z7LP)
- 思路：
  - 先排序，使用双指针去遍历找到需要移除的那段区间移除掉
- 看完 [代码随想录](https://programmercarl.com/0027.%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0.html#_27-%E7%A7%BB%E9%99%A4%E5%85%83%E7%B4%A0) 之后的想法：
  - 原来不需要排序，只遍历一遍就可以，原地修改数组
- 代码：
  ```ts
    function removeElement(nums: number[], val: number): number {
      let slow = 0, // 慢指针指向新数组的元素
        fast = 0 // 快指针指向原数组的元素
      while (fast < nums.length) {
        if (nums[fast] !== val) nums[slow++] = nums[fast]
        fast++
      }
      return slow
    }
  ```
  时间复杂度：O(n)
  空间复杂度：O(1)

### 收获
