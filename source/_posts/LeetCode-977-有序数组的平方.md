---
title: LeetCode-977.有序数组的平方
tags:
  - LeetCode
  - 代码随想录
  - 数组
  - 双指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: bc1e
date: 2022-09-23 05:02:43
---

## [题目](https://leetcode.cn/problems/squares-of-a-sorted-array/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0977.有序数组的平方.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=597240875&bvid=BV1QB4y1D7ep&cid=737799572&page=1&high_quality=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

1. 题目要求了时间复杂度O(n)，那就不应该有排序过程
2. 我们知道一个可能有负数的非递减顺序，最大绝对值一定在两端
3. 所以用双指针收缩区间，每次对比两端的值就能拿到剩余的最大值，再从后往前的放置在新数组中即可

### 看完[代码随想录](https://programmercarl.com/0977.有序数组的平方.html)之后的想法

与我的思路一致

### 实现过程中遇到的困难

- 每次迭代只能往新数组里放一个，因为第二个端值可能不是最大的（可能比另一端的倒数第二个值小）

### 代码

```ts TypeScript
function sortedSquares(nums: number[]): number[] {
  const ans: number[] = Array(nums.length)
  let left = 0,
    right = nums.length - 1,
    i = nums.length - 1
  while (left <= right) {
    const dLeft = Math.pow(nums[left], 2),
      dRight = Math.pow(nums[right], 2)
    if (dLeft > dRight) {
      ans[i--] = dLeft
      left++
    } else {
      ans[i--] = dRight
      right--
    }
  }
  return ans
}
```

时间复杂度：O(n)
空间复杂度：O(n)

## 收获
