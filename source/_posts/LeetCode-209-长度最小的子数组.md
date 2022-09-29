---
title: LeetCode-209.长度最小的子数组
tags:
  - LeetCode
  - 代码随想录
  - 数组
  - 双指针
  - 滑动窗口
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 6abf
date: 2022-09-27 19:19:09
updated: 2022-09-27 19:19:09
---

## <center>[LeetCode-209.长度最小的子数组](https://leetcode.cn/problems/minimum-size-subarray-sum/)</center>

### 题目详解

- 相关链接：[文章](https://programmercarl.com/0209.%E9%95%BF%E5%BA%A6%E6%9C%80%E5%B0%8F%E7%9A%84%E5%AD%90%E6%95%B0%E7%BB%84.html)、[视频](https://www.bilibili.com/video/BV1tZ4y1q7XE/?spm_id_from=333.788&vd_source=71d285511d98d6f3acb381e2ee160233)
- 思路：
  1. 滑动窗口，先滑右边界，直至 `sum >= target`，再收缩左边界直至不符合 `sum >= target`
  2. 重复循环上面的过程，直至窗口滑到右边界，且不符合 `sum >= target` 时结束
- 看完 [代码随想录](https://programmercarl.com/0209.%E9%95%BF%E5%BA%A6%E6%9C%80%E5%B0%8F%E7%9A%84%E5%AD%90%E6%95%B0%E7%BB%84.html) 之后的想法：
  - 主要确定如下三点：
    - 窗口内是什么？窗口就是 满足其和 ≥ s 的长度最小的 连续 子数组。
    - 如何移动窗口的起始位置？如果当前窗口的值大于s了，窗口就要向前移动了（也就是该缩小了）
    - 如何移动窗口的结束位置？窗口的结束位置就是遍历数组的指针，也就是for循环里的索引。
- 实现过程中遇到的困难：
  - 边界条件、窗口滑动的时机、统计子数组长度 这些点都需要注意，容易出错
- 代码：
  ```ts
  function minSubArrayLen(target: number, nums: number[]): number {
    const len = nums.length
    let res = len + 1,
      left = 0,
      right = 0,
      sum = 0
    while (right < len) {
      sum += nums[right++]
      while (sum >= target) {
        res = Math.min(res, right - left)
        sum -= nums[left++]
      }
    }
    return res > len ? 0: res
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(1)

### 收获

- 学会了滑动窗口的通用解题思路：外层循环移动窗口终止位置，内层循环移动窗口起始位置
