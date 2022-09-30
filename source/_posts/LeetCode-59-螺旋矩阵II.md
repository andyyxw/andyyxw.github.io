---
title: LeetCode-59.螺旋矩阵II
tags:
  - LeetCode
  - 代码随想录
  - 数组
  - 矩阵
  - 模拟
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 631e
date: 2022-09-29 17:07:26
updated: 2022-09-29 17:07:26
---

## <center>[LeetCode-59.螺旋矩阵II](https://leetcode.cn/problems/spiral-matrix-ii/)</center>

### 题目详解

- 相关链接：[文章](https://programmercarl.com/0059.%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5II.html#_59-%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5ii)、[视频](https://www.bilibili.com/video/BV1SL4y1N7mV/?spm_id_from=pageDriver&vd_source=71d285511d98d6f3acb381e2ee160233)
- 思路：
  - 模拟顺时针旋转路线，每一圈有4个边，实际就是每圈包含4次遍历
- 看完 [代码随想录](https://programmercarl.com/0059.%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5II.html#_59-%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5ii) 之后的想法：
  - 遵循*循环不变量规则*：对每条边的处理规则要统一。每条边的遍历都是左闭右开
  - 需要转`Math.floor(n/2)`圈，如果`n`是奇数，跑完圈还剩下中心点再赋值一下
- 实现过程中遇到的困难：
  - 模拟旋转时循环的边界条件太多，很难处理
- 代码：
  ```ts
  function generateMatrix(n: number): number[][] {
    const res: number[][] = Array.from(Array(n), () => Array(n)),
      loop = n >>> 1 // 需要的旋转圈数
    let offset = 0, // 当前已旋转圈数
      count = 1
    // 循环不变量规则：每条边遍历时均使用左开右闭区间
    while (offset < loop) {
      let row = offset,
        col = offset
      while (col < n - offset - 1) res[row][col++] = count++
      while (row < n - offset - 1) res[row++][col] = count++
      while (col > offset) res[row][col--] = count++
      while (row > offset) res[row--][col] = count++
      offset++
    }
    // 如果n是奇数，一定剩下中心点没有赋值
    if (n & 1) res[loop][loop] = count
    return res
  }
  ```
  时间复杂度：O($n^2$)
  空间复杂度：O($n^2$)

### 收获

- 理解了*循环不变量规则*，尤其是在 [模拟](/tags/模拟/) 类型的题中很有用
