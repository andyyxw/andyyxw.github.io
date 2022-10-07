---
title: LeetCode-18.四数之和
tags:
  - LeetCode
  - 代码随想录
  - 双指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 98c7
date: 2022-10-04 15:52:12
updated: 2022-10-04 15:52:12
---

## [题目](https://leetcode.cn/problems/4sum/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0018.四数之和.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=728760817&bvid=BV1DS4y147US&cid=783669679&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 与[15.三数之和](/archives/4d32.html)思路一样，外面多了一层循环

### 看完[代码随想录](https://programmercarl.com/0018.四数之和.html)之后的想法

- 彻底理解了双指针解法，与Carl思路一致

### 实现过程中遇到的困难

- 去重
- 剪枝

### 代码

```ts TypeScript
function fourSum(nums: number[], target: number): number[][] {
  const len = nums.length
  if (len < 4) return []
  nums.sort((a, b) => a - b)
  const res: number[][] = []
  for (let i = 0; i < len - 3; i++) {
    if (nums[i] > target && nums[i] > 0 && target > 0) break // 剪枝
    if (i > 0 && nums[i] === nums[i - 1]) continue // 去重
    for (let j = i + 1; j < len - 2; j++) {
      if (nums[i] + nums[j] > target && nums[i] + nums[j] > 0 && target > 0) break // 剪枝
      if (j > i + 1 && nums[j] === nums[j - 1]) continue // 去重
      let left = j + 1,
        right = len - 1
      while (left < right) {
        const sum = nums[i] + nums[j] + nums[left] + nums[right]
        if (sum < target) left++
        else if (sum > target) right--
        else {
          res.push([nums[i], nums[j], nums[left++], nums[right--]])
          while (left < right && nums[left] === nums[left - 1]) left++ // 去重
          while (left < right && nums[right] === nums[right + 1]) right-- // 去重
        }
      }
    }
  }
  return res
}
```

时间复杂度：O(n^3)
空间复杂度：O(n)

## 收获
