---
title: LeetCode-704.二分查找
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
abbrlink: 4f45
date: 2022-09-22 23:29:30
updated: 2022-09-22 23:29:30
---

## [题目](https://leetcode.cn/problems/binary-search/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0704.二分查找.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=896855273&bvid=BV1fA4y1o715&cid=783305542&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

使用双指针二分法，确定左右区间分别为数组的起点和终点，每次取中间元素`mid`跟`target`对比：

- 如果`mid`较小，收缩左区间到`mid`；
- 如果`mid`较大，收缩有区间到`mid`。
- 直到左右区间相遇

### 看完[代码随想录](https://programmercarl.com/0704.二分查找.html)之后的想法

- 使用开闭区间来辅助判断循环的终止条件和区间迭代变化，写起来更轻松流畅

### 实现过程中遇到的困难

- 对边界条件判断模糊

### 代码

- 二分法（左闭右闭）
    ```ts TypeScript
    function search(nums: number[], target: number): number {
      let mid: number,
        left = 0,
        right = nums.length - 1
      while (left <= right) {
        mid = left + ((right - left) >> 1)
        if (nums[mid] === target) return mid
        if (nums[mid] < target) left = mid + 1
        else right = mid - 1
      }
      return -1
    }
    ```
    时间复杂度：O($\log n$)
    空间复杂度：O(1)
- 二分法（左闭右开）
    ```ts TypeScript
    function search(nums: number[], target: number): number {
      let mid: number, 
        left = 0,
        right = nums.length
      while (left < right) {
        mid = left + ((right - left) >> 1)
        if (nums[mid] === target) return mid
        if (nums[mid] < target) left = mid + 1
        else right = mid
      }
      return -1
    }
    ```
    时间复杂度：O($\log n$)
    空间复杂度：O(1)

## 收获

- 对双指针理解更深刻了，可以两端收缩，可以是快慢指针
- 对二分法的边界条件判断更清晰了，用开闭区间的方法辅助判断（一般用`左闭右闭`/`左闭右开`）
