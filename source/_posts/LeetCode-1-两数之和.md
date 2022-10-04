---
title: LeetCode-1.两数之和
tags:
  - LeetCode
  - 代码随想录
  - 哈希表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: ce53
date: 2022-10-04 10:45:34
updated: 2022-10-04 10:45:34
---

## [题目](https://leetcode.cn/problems/two-sum/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0001.两数之和.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=471096893&bvid=BV1aT41177mK&cid=776815010&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 我们需要记录每个元素出现的位置，所以用`hash map`即可

### 看完[代码随想录](https://programmercarl.com/0001.两数之和.html)之后的想法

- 思路一致

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function twoSum(nums: number[], target: number): number[] {
  const hash = new Map<number, number>()
  for (let i = 0; i < nums.length; i++) {
    const num = nums[i],
      s = target - num
    if (hash.has(s)) return [hash.get(s), i]
    else hash.set(num, i)
  }
  return []
}
```

时间复杂度：O(n)
空间复杂度：O(n)

## 收获

- `hash map`的经典应用
