---
title: LeetCode-35.搜索插入位置
tags:
  - LeetCode
  - 代码随想录
  - 数组
  - 二分法
  - 双指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: b702
date: 2022-09-24 19:07:46
updated: 2022-09-24 19:07:46
---

## [题目](https://leetcode.cn/problems/search-insert-position/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0035.搜索插入位置.html)

### 思路

- 经典的双指针二分法

### 看完[代码随想录](https://programmercarl.com/0035.搜索插入位置.html)之后的想法

- 之前在 [LeetCode-704.二分查找](/archives/4f45.html) 已经掌握了Carl教的二分法使用开闭区间判断边界条件的精髓，做完题后检查了一遍与Carl的题解一致！

### 实现过程中遇到的困难

### 代码

- 二分法（左闭右闭）
    ```ts TypeScript
    function searchInsert(nums: number[], target: number): number {
      let left = 0,
        right = nums.length - 1
      while (left <= right) {
        const mid = left + ((right - left) >>> 1)
        if (nums[mid] === target) return mid
        else if (nums[mid] < target) left = mid + 1
        else right = mid - 1
      }
      return left
    }
    ```
    时间复杂度：O(log n)
    空间复杂度：O(1)
- 二分法（左闭右开）
    ```ts TypeScript
    function searchInsert(nums: number[], target: number): number {
      let left = 0,
        right = nums.length
      while (left < right) {
        const mid = left + ((right - left) >>> 1)
        if (nums[mid] === target) return mid
        else if (nums[mid] < target) left = mid + 1
        else right = mid
      }
      return left
    }
    ```
    时间复杂度：O(log n)
    空间复杂度：O(1)

## 收获

- 二分法玩明白了
