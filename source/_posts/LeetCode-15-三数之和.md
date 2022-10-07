---
title: LeetCode-15.三数之和
tags:
  - LeetCode
  - 代码随想录
  - 双指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 4d32
date: 2022-10-04 15:03:50
updated: 2022-10-04 15:03:50
---

## [题目](https://leetcode.cn/problems/3sum/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0015.三数之和.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=941244988&bvid=BV1GW4y127qo&cid=780823635&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

之前做过的忘了。。。

### 看完[代码随想录](https://programmercarl.com/0015.三数之和.html)之后的想法

- 巧用双指针，看完视频后对去重细节理解了，自己写就一遍过了

### 实现过程中遇到的困难

- 对第一个数去重
- 对后两个数去重

### 代码

```ts TypeScript
function threeSum(nums: number[]): number[][] {
  const len = nums.length;
  if (len < 3) return []
  const res: number[][] = []
  nums.sort((a, b) => a - b)
  for (let i = 0; i < len - 2; i++) {
    if (nums[i] > 0) break // 剪枝
    if (i > 0 && nums[i] === nums[i - 1]) continue // 去重
    let left = i + 1,
      right = len - 1
    while (left < right) {
      const sum = nums[i] + nums[left] + nums[right]
      if (sum < 0) left++
      else if (sum > 0) right--
      else {
        res.push([nums[i], nums[left++], nums[right--]])
        while (left < right && nums[left] === nums[left - 1]) left++ // 去重
        while (left < right && nums[right] === nums[right + 1]) right-- // 去重
      }
    }
  }
  return res
}
```

时间复杂度：O(n^2)
空间复杂度：O(n)

## 收获
