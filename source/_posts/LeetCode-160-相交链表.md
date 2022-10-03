---
title: LeetCode-160.相交链表
tags:
  - LeetCode
  - 代码随想录
  - 链表
  - 双指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 71ca
date: 2022-10-03 17:59:40
updated: 2022-10-03 17:59:40
---

## [题目](https://leetcode.cn/problems/intersection-of-two-linked-lists/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/面试题02.07.链表相交.html)

### 思路

1. 使用双指针分别从两个链表起点开始跑，一个链表跑完后再指向另一个链表
2. 如果两个链表相交 一定会相遇，如果不相交 最终一定会同时指向null

### 看完[代码随想录](https://programmercarl.com/面试题02.07.链表相交.html)之后的想法

### 实现过程中遇到的困难

- 在链表要跑完时下一个节点的指向要注意，不能直接指向下一个链表(无缝衔接)，而是要先指向null下一轮再指向另一个链表。
  - 如果两个链表不存在相交，会有死循环；
  - 如果两个链表存在相交，在最终同时指向null之前一定会相遇

### 代码

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

/**
 * Algorithm: Double Pointer
 * Time Complexity: O(m + n)
 * Space Complexity: O(1)
 */
function getIntersectionNode(headA: ListNode | null, headB: ListNode | null): ListNode | null {
  if (!headA || !headB) return null
  let pA = headA,
    pB = headB
  // 判断p而不是p.next的原因是：如果是判断p.next，那就是直接从一个链表过度到另一个链表，如果两个链表不相交，会存在死循环
  // 如果两个链表相交，在最终同时指向null之前一定会相遇
  while (pA !== pB) {
    pA = pA ? pA.next : headB
    pB = pB ? pB.next : headA
  }
  return pA
}
```

时间复杂度：O(n)
空间复杂度：O(1)

## 收获
