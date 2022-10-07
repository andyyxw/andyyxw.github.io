---
title: LeetCode-20.有效的括号
tags:
  - LeetCode
  - 代码随想录
  - 栈
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: c7da
date: 2022-10-07 14:00:25
updated: 2022-10-07 14:00:25
---

## [题目](https://leetcode.cn/problems/valid-parentheses/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0020.有效的括号.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=301823875&bvid=BV1AF411w78g&cid=799270643&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 遍历字符串
  - 遇到左括号->入栈;
  - 遇到右括号->出栈 并判断出栈元素是否与当前的遍历到的右括号成对，不成对则终止

### 看完[代码随想录](https://programmercarl.com/0020.有效的括号.html)之后的想法

- 使用字典来简化判断逻辑

### 实现过程中遇到的困难

### 代码

```ts TypeScript
function isValid(s: string): boolean {
  if (s.length % 2 !== 0) return false
  const stack: string[] = []
  const map = {
    '(': ')',
    '[': ']',
    '{': '}'
  }
  for (const c of s) {
    if (c in map) stack.push(c)
    else if (map[stack.pop()] !== c) return false
  }
  return !stack.length
}
```

时间复杂度：O(n)
空间复杂度：O(n)

## 收获

- **数据结构与算法的应用往往隐藏在我们看不到的地方**
