---
title: LeetCode-150.逆波兰表达式求值
tags:
  - LeetCode
  - 代码随想录
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: f533
date: 2022-10-07 15:26:57
updated: 2022-10-07 15:26:57
---

## [题目](https://leetcode.cn/problems/evaluate-reverse-polish-notation/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0150.逆波兰表达式求值.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=387057277&bvid=BV1kd4y1o7on&cid=804365306&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 遍历tokens：
  - 如果遇到数字入栈
  - 如果遇到运算符，连续出栈两个数字进行运算，再将运算结果入栈用于后续计算

### 看完[代码随想录](https://programmercarl.com/0150.逆波兰表达式求值.html)之后的想法

- get了二进制取整小tip

### 实现过程中遇到的困难

- 出栈两次得到的两个数字顺序与运算顺序时相反的
- 除法取整时需要处理一下

### 代码

```ts TypeScript
function evalRPN(tokens: string[]): number {
  const stack: number[] = []
  // 注意调用时传入的两个数字是依次出栈得到的，顺序是反的
  const map = {
    '+': (a: number, b: number) => b + a,
    '-': (a: number, b: number) => b - a,
    '*': (a: number, b: number) => b * a,
    '/': (a: number, b: number) => (b / a) | 0,
  }
  for (const c of tokens) {
    if (c in map) stack.push(map[c](stack.pop(), stack.pop()))
    else stack.push(+c)
  }
  return stack[0]
}
```

时间复杂度：O(n)
空间复杂度：O(n)

## 收获
