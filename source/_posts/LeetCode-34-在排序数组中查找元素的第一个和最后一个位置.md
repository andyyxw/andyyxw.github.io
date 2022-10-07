---
title: LeetCode-34.在排序数组中查找元素的第一个和最后一个位置
tags:
  - LeetCode
  - 代码随想录
  - 数组
  - 二分法
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: a130
date: 2022-09-24 19:36:54
updated: 2022-09-24 19:36:54
---

## [题目](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0034.在排序数组中查找元素的第一个和最后一个位置.html)

### 思路

- 用双指针二分法

### 看完[代码随想录](https://programmercarl.com/0034.在排序数组中查找元素的第一个和最后一个位置.html)之后的想法

- 我的解法只用了一次二分，找到目标值后再向两边延伸：
    ```ts TypeScript
    function searchRange(nums: number[], target: number): number[] {
      let left = 0,
        right = nums.length - 1
      while (left <= right) {
        const mid = left + ((right - left) >>> 1)
        if (nums[mid] === target) {
          left = right = mid
          break
        }
        if(nums[mid] < target) left = mid + 1
        else right = mid - 1
      }
      if (left > right) return [-1, -1]
      while (nums[--left] === target) {}
      while (nums[++right] === target) {}
      return [++left, --right]
    }
    ```
    虽然ac了，但是因为最后的遍历寻找边界导致时间复杂度实际是O(n)，不符合题目要求的O(log n)

### 实现过程中遇到的困难

- 边界不好判断

### 代码

- 两遍二分法分别寻找左边界和右边界：
    ```ts TypeScript
    function searchRange(nums: number[], target: number): number[] {
      if (!nums.length) return [-1, -1]
      const leftBorder = getLeftBorder(nums, target)
      const rightBorder = getRightBorder(nums, target)
      if (leftBorder === nums.length || rightBorder === 0) return [-1, -1] // target在nums区间两侧
      if (rightBorder - leftBorder <= 1) return [-1, -1] // target不存在nums中
      return [leftBorder + 1, rightBorder - 1]
    }

    function getLeftBorder(nums: number[], target: number): number {
      let left = 0,
        right = nums.length - 1
      while (left <= right) {
        const mid = left + ((right - left) >>> 1)
        if (nums[mid] < target) left = mid + 1
        else right = mid - 1
      }
      return right
    }
    function getRightBorder(nums: number[], target: number): number {
      let left = 0,
        right = nums.length - 1
      while (left <= right) {
        const mid = left + ((right - left) >>> 1)
        if (nums[mid] > target) right = mid - 1
        else left = mid + 1
      }
      return left
    }
    ```
    时间复杂度：O(logn)
    空间复杂度：O(1)

### 收获

- 二分法的灵活运用
