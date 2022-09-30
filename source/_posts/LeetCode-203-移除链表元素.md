---
title: LeetCode-203.移除链表元素
tags:
  - LeetCode
  - 代码随想录
  - 链表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: da77
date: 2022-09-30 16:19:28
updated: 2022-09-30 16:19:28
---

## [题目](https://leetcode.cn/problems/remove-linked-list-elements/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0203.移除链表元素.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=600158049&bvid=BV18B4y1s7R9&cid=753794207&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

1. 生成一个*虚拟头节点*`dummyHead`指向`head`
2. 然后从`dummyHead`开始完整的遍历链表：判断当前节点的后一个节点val是否是否是目标值，如果是则将当前节点的next指向下下个节点（即跳过目标节点，从而达到删除效果）

### 看完[代码随想录](https://programmercarl.com/0203.移除链表元素.html)之后的想法

- 与我想法一致

### 实现过程中遇到的困难

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

  function removeElements(head: ListNode | null, val: number): ListNode | null {
    let dummyHead = new ListNode()
    dummyHead.next = head
    let cur = dummyHead
    while (cur.next) {
      if (cur.next.val === val) cur.next = cur.next.next
      else cur = cur.next
    }
    return dummyHead.next
  }
  ```

  时间复杂度：O(n)
  空间复杂度：O(1)

## 收获

- [链表](/tags/链表/)进行增删操作时通常可以使用*虚拟头节点*，就不需要单独处理头节点了，使得处理方法统一，代码更清爽。
