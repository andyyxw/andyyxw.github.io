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
  - 模拟旋转路线，每一圈有4个边，就是4个遍历
- 看完 [代码随想录](https://programmercarl.com/0059.%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5II.html#_59-%E8%9E%BA%E6%97%8B%E7%9F%A9%E9%98%B5ii) 之后的想法：
  - 循环不变量规则：对每条边的处理规则要统一。每条边边的遍历都是左闭右开
  - 遍历n/2圈，如果n是奇数，需要中心点再赋值
- 实现过程中遇到的困难：
- 代码：
  - 二分法
    ```ts
      function generateMatrix(n: number): number[][] {
        const res: number[][] = Array.from(Array(n), () => Array(n)),
          mid = n >>> 1
        let offset = 0,
          count = 1
        for (let k = 0; k < mid; k++) {
          for (let i = offset; i < n - offset - 1; i++) res[offset][i] = count++
          for (let i = offset; i < n - offset - 1; i++) res[i][n - offset - 1] = count++
          for (let i = n - offset - 1; i > offset; i--) res[n - offset - 1][i] = count++
          for (let i = n - offset - 1; i > offset; i--) res[i][offset] = count++
        }
        if (n & 1) res[mid][mid] = count
        return res
      }
    ```
    时间复杂度：O($\log n$)
    空间复杂度：O(1)

### 收获
