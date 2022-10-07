---
title: LeetCode-1047.删除字符串中的所有相邻重复项
tags:
  - LeetCode
  - 代码随想录
  - 栈
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: e442
date: 2022-10-07 15:10:49
updated: 2022-10-07 15:10:49
---

## [题目](https://leetcode.cn/problems/remove-all-adjacent-duplicates-in-string/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/1047.删除字符串中的所有相邻重复项.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=216931465&bvid=BV12a411P7mw&cid=801359937&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 遍历字符串：
  - 如果当前元素与栈顶元素相同，则进行出栈
  - 如果不相同，则入栈
- 最后栈里的所有元素就是结果

### 看完[代码随想录](https://programmercarl.com/1047.删除字符串中的所有相邻重复项.html)之后的想法

- 思路一致

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function removeDuplicates(s: string): string {
  const stack: string[] = []
  for (const c of s) {
    if (stack.length && stack[stack.length - 1] === c) stack.pop()
    else stack.push(c)
  }
  return stack.join('')
}
```

时间复杂度：O(n)
空间复杂度：O(n)

## 收获
