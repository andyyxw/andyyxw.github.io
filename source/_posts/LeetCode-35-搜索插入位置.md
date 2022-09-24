---
title: LeetCode-35.搜索插入位置
tags:
  - LeetCode
  - 代码随想录
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

## 题目详解

### [LeetCode-35.搜索插入位置](https://leetcode.cn/problems/search-insert-position/)

- 相关链接：[文章](https://programmercarl.com/0035.%E6%90%9C%E7%B4%A2%E6%8F%92%E5%85%A5%E4%BD%8D%E7%BD%AE.html)
- 思路:
  - 经典的双指针二分法
- 看完 [代码随想录](https://programmercarl.com/0035.%E6%90%9C%E7%B4%A2%E6%8F%92%E5%85%A5%E4%BD%8D%E7%BD%AE.html) 之后的想法：
  - 之前在 [LeetCode-704.二分查找](https://andy.city/archives/4f45.html) 已经掌握了卡尔教的二分法使用开闭区间判断边界条件的精髓，做完题后检查了一遍与卡尔的题解一致！
- 实现过程中遇到的困难：无
- 代码：
  - 二分法（左闭右闭）
    ```ts
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
    时间复杂度：O($\log n$)
    空间复杂度：O(1)
  - 二分法（左闭右开）
    ```ts
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
    时间复杂度：O($\log n$)
    空间复杂度：O(1)

## 收获

- 二分法玩明白了
