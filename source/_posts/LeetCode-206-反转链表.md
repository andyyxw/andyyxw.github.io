---
title: LeetCode-206.反转链表
tags:
  - LeetCode
  - 代码随想录
  - 链表
  - 双指针
  - 迭代
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 7a3f
date: 2022-09-30 20:52:51
updated: 2022-09-30 20:52:51
---

## [题目](https://leetcode.cn/problems/reverse-linked-list/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0206.翻转链表.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=598107226&bvid=BV1nB4y1i7eL&cid=763421475&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 遍历一遍链表，利用双指针将每个节点的指向反转

### 看完[代码随想录](https://programmercarl.com/0206.翻转链表.html)之后的想法

- 学会了递归写法

### 实现过程中遇到的困难

- `while`循环的终止条件，最终返回值需要注意 容易出错

### 代码

- 双指针迭代

```ts TypeScript
/**
 * Definition for singly-linked list.
 * class ListNode {
 *     val: number
 *     next: ListNode | null
 *     constructor(val?: number, next?: ListNode | null) {
 *         this.val = (val===undefined ? 0 : val)
 *         this.next = (next===undefined ? null : next)
 *     }
 * }
 */

function reverseList(head: ListNode | null): ListNode | null {
  let prev = null,
    cur = head
  while (cur) [cur.next, prev, cur] = [prev, cur, cur.next]
  return prev
}
```

时间复杂度：O(n)
空间复杂度：O(1)

- 递归

```ts TypeScript
/**
 * Definition for singly-linked list.
 * class ListNode {
 *     val: number
 *     next: ListNode | null
 *     constructor(val?: number, next?: ListNode | null) {
 *         this.val = (val===undefined ? 0 : val)
 *         this.next = (next===undefined ? null : next)
 *     }
 * }
 */

function reverseList(head: ListNode | null): ListNode | null {
  return reverse(head, null)
}

function reverse(cur: ListNode | null, prev: ListNode | null): ListNode | null {
  if (!cur) return prev
  const tmp = cur.next
  cur.next = prev
  return reverse(tmp, cur)
}
```

时间复杂度：O(n)
空间复杂度：O(1)

## 收获

- 链表的操作顺序一定要理清楚 不能乱，否则很容易断链
