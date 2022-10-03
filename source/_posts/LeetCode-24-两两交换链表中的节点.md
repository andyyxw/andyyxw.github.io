---
title: LeetCode-24.两两交换链表中的节点
tags:
  - LeetCode
  - 代码随想录
  - 链表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 6ba3
date: 2022-10-03 08:18:13
updated: 2022-10-03 08:18:13
---

## [题目](https://leetcode.cn/problems/swap-nodes-in-pairs/)详解

### 相关链接

- [代码随想录](https://leetcode.cn/problems/swap-nodes-in-pairs/)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=470747611&bvid=BV1YT411g7br&cid=765323235&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 使用虚拟头节点，交换头结点的后两个节点

### 看完[代码随想录](https://leetcode.cn/problems/swap-nodes-in-pairs/)之后的想法

- 为什么第一时间想到使用虚拟头结点呢，因为如果想要交换两个节点，`cur`必须指向这两个节点的前一个节点
- 只需要操作`cur`一个指针就够了

### 实现过程中遇到的困难

- 循环的终止条件容易出错

### 代码

- 迭代

  我原本的写法：

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

  function swapPairs(head: ListNode | null): ListNode | null {
    let dummyHead = new ListNode()
    dummyHead.next = head
    let cur = dummyHead
    while (head && head.next) {
      let next = head.next
      head.next = next.next
      next.next = head
      cur.next = next
      cur = head
      head = head.next
    }
    return dummyHead.next
  }
  ```

  优化后的写法：

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

  function swapPairs(head: ListNode | null): ListNode | null {
    let dummyHead = new ListNode()
    dummyHead.next = head
    let cur = dummyHead
    while (cur.next && cur.next.next) {
      let next1 = cur.next,
        next2 = next1.next.next
      cur.next = next1.next
      next1.next.next = next1
      next1.next = next2
      cur = next1
    }
    return dummyHead.next
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

  function swapPairs(head: ListNode | null): ListNode | null {
    if (!head || !head.next) return head
    let next = head.next
    head.next = swapPairs(next.next)
    next.next = head
    return next
  }
  ```
  时间复杂度：O(n)
  空间复杂度：O(1)

## 收获

- 链表操作要谨慎，熟练使用虚拟头节点和`temp`，避免断链
