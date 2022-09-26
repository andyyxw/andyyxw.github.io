---
title: LeetCode-704.二分查找
tags:
  - LeetCode
  - 代码随想录
  - 二分法
  - 双指针
  - 数组
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 4f45
date: 2022-09-22 23:29:30
updated: 2022-09-22 23:29:30
---

## <center>[LeetCode-704.二分查找](https://leetcode.cn/problems/binary-search/)</center>

### 题目详解

- 相关链接：[文章](https://programmercarl.com/0704.%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE.html#_704-%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE)、[视频](https://www.bilibili.com/video/BV1fA4y1o715)
- 思路：
  - 使用双指针二分法，确定左右区间分别为数组的起点和终点，每次取中间元素`mid`跟`target`对比：
    - 如果`mid`较小，收缩左区间到`mid`；
    - 如果`mid`较大，收缩有区间到`mid`。
    - 直到左右区间相遇
- 看完 [代码随想录](https://programmercarl.com/0704.%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE.html#_704-%E4%BA%8C%E5%88%86%E6%9F%A5%E6%89%BE) 之后的想法：
  - 使用开闭区间来辅助判断循环的终止条件和区间迭代变化，写起来更轻松流畅
- 实现过程中遇到的困难：
  - 对边界判断模糊
- 代码：
  - 二分法（左闭右闭）
    ```ts
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
    ```ts
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

### 收获

- 对双指针理解更深刻了，可以两端收缩，可以是快慢指针
- 对二分法的边界条件判断更清晰了，用开闭区间的方法辅助判断（一般用`左闭右闭`/`左闭右开`）
